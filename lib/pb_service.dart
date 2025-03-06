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
  factory PocketBaseService() => _instance;
  PocketBaseService._setup();

  // public properties
  PocketBase    get client      => _pb;
  bool          get isLoggedIn  => _pb.authStore.isValid;
  RecordModel?  get currentUser => _pb.authStore.record;
  String?       get userId      => _pb.authStore.record?.id;
  

  // initializes the store, reading from SharedPrefs
  Future<void> setup() async {
    final prefs = await SharedPreferences.getInstance();
    final store = AsyncAuthStore(
      save:    (String data) async => prefs.setString('pb_auth', data),
      initial: prefs.getString('pb_auth'),
    );
    _pb = PocketBase(pocketbaseURL, authStore: store);
    _pb.authStore.onChange.listen(_handleAuthChange);
  }

  // NOTE: delete this if not needed
  void _handleAuthChange(AuthStoreEvent event) {
    // Handle auth changes (e.g., token refresh)
  }


  Future<void> logout() async {
    _pb.authStore.clear();
    await _pb.collection('users').authRefresh();
  }
}
