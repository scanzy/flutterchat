import 'package:pocketbase/pocketbase.dart';
import 'package:shared_preferences/shared_preferences.dart';


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


  // logs user out, deleting stored auth token
  Future<void> logout() async {
    _pb.authStore.clear();
    await _pb.collection('users').authRefresh();
  }


  // loads previous messages
  Future<List<RecordModel>> loadMessages() async {
    return await _pb.collection('messages')
        .getFullList(sort: '+created', expand: 'user');
  }

  // sends message
  Future<void> sendMessage(String message) async {
    await _pb.collection('messages').create(body: {
      'user': userId,
      'message': message,
    });
  }


  // updates existing message
  Future<void> updateMessage(String messageId, String newContent) async {
    await _pb.collection('messages').update(
      messageId,
      body: {'message': newContent},
    );
  }


  // deletes existing message
  Future<void> deleteMessage(String messageId) async {
    await _pb.collection('messages').delete(messageId);
  }
}
