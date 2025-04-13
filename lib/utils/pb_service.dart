import 'package:pocketbase/pocketbase.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutterchat/chat/msg.dart';
import 'package:flutterchat/room/model.dart';


// This file handles authentication using PocketBase

// To use pocketbase:
// 1. just instantiate the object: `var pb = PocketBaseService()`
// 2. access the database: `pb.client.collection("users")` ...
// Note: make sure to call `PocketBaseService().setup()` in main


final pocketbaseURL = 'https://branco.realmen.it';

class PocketBaseService {
  late final PocketBase _pb;

  // singleton pattern
  static final PocketBaseService _instance = PocketBaseService._setup();
  factory PocketBaseService() => _instance; // factory method
  PocketBaseService._setup(); // private constructor

  // public properties
  PocketBase    get client      => _pb;
  bool          get isLoggedIn  => _pb.authStore.isValid;
  RecordModel?  get currentUser => _pb.authStore.record;
  String?       get userId      => _pb.authStore.record?.id;

  // checks if the current user is admin
  bool get isAdmin => _pb.authStore.record?.getBoolValue("admin") ?? false;
  

  // initializes the auth store, reading from SharedPrefs
  Future<void> setup() async {
    final prefs = await SharedPreferences.getInstance();

    _pb = PocketBase(
      pocketbaseURL,
      authStore: AsyncAuthStore(
        save:    (String data) async => prefs.setString('pb_auth', data),
        initial: prefs.getString('pb_auth'),
      ),
    );
  }


  // tries to login using stored auth info
  Future<bool> autoLogin() async {

    // nothing to do if no stored info
    if (!client.authStore.isValid) return false;

    // tries auth with stored credentials
    // what happens if invalid credentials? does it throw exception?
    // TODO: handle invalid credentials and network errors differently
    await client.collection('users').authRefresh();
    return true;
  }


  // logs in using specified credentials
  Future<void> login(String email, String password) async {
    await client.collection('users').authWithPassword(email, password);
  }


  // logs user out, deleting stored auth token
  void logout() => _pb.authStore.clear();


  // loads previous messages
  Future<List<Message>> loadMessages() async {

    // loads data
    final recordModels = await _pb.collection('messages')
        .getFullList(sort: '+created', expand: 'user,replyTo.user');

    // builds message objects
    return recordModels.map((record) => Message(record)).toList();
  }


  // sends message
  Future<void> sendMessage(String message, Message? replyingMessage) async {
    await _pb.collection('messages').create(body: {
      'user': userId,
      'message': message,
      'replyTo': replyingMessage?.id,
    },
    expand: 'replyTo',
    );
  }


  // updates existing message text
  Future<void> updateMessage(String messageId, String newContent) async {
    await _pb.collection('messages').update(
      messageId,
      body: {
        'message': newContent,
        'contentEditedAt': DateTime.now().toUtc().toString(),
      },
    );
  }


  // pins/unpins existing message
  Future<void> pinMessage(String messageId, bool pinned) async {
    await _pb.collection('messages').update(
      messageId, body: {'pinned': pinned},
    );
  }


  // deletes existing message
  Future<void> deleteMessage(String messageId) async {
    await _pb.collection('messages').delete(messageId);
  }
}


// stores names of pocketbase records
const Map<Type, String> collectionNames = {
  Room: "rooms",
  //User: "users",
};


// accesses pocketbase collection from model type
RecordService collection(Type modelType) =>
  PocketBaseService().client.collection(collectionNames[modelType]!);
