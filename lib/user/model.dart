import 'package:pocketbase/pocketbase.dart';
import 'package:flutterchat/utils/model.dart';


// user data
class User extends Model {
  late String username;
  late String email;
  late bool isAdmin;
  late bool isVerified;
  late String data;


  @override
  void updateFromRecord(RecordModel record) {
    username  = record.get<String>("username");
    email     = record.get<String>("email");
    isAdmin   = record.get<bool>("admin");
    isVerified = record.get<bool>("verified");
    data      = record.get<String?>("data") ?? "{}";
  }
}


class UserFactory extends ModelFactory<User> {

  @override
  User createModel() => User();
}