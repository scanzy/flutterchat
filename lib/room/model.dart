import 'package:pocketbase/pocketbase.dart';

import 'package:flutterchat/utils/model.dart';
import 'package:flutterchat/utils/pb_service.dart';


// room mixin to allow to use shared code for:
// - real rooms, with dynamic data loaded from server
// - fake rooms, with hardcoded data
mixin RoomBase {

  // room data
  late String name;
  late String? type;
  late int? iconCode;

  // extra data getters
  int? get unreadMessages;
  DateTime? get lastUpdate;
  String? get lastMsgPreview;
}



// model for rooms
class Room extends Model with RoomBase {

  // TODO: extra data getters for real rooms
  @override int?    get unreadMessages => null;
  @override DateTime?   get lastUpdate => null;
  @override String? get lastMsgPreview => null;

  late String? description;


  // updater from raw data
  @override
  void updateFromRecord(RecordModel record) {

    // loads main room data
    name = record.get<String>("name");
    type = record.get<String>("type");

    // TODO: load other data

    // loads extra data from json
    final data  = record.getJson("data");
    iconCode    = data.get<int?>("iconCode", null);
    description = data.get<String?>("description", null);
  }


  // deletes room
  Future<void> delete() async {
    await collection(Room).delete(id);
  }
}


// creates room models
class RoomFactory extends ModelFactory<Room> {

  @override
  Room createModel() => Room();


  // creates a room
  Future<Room> create(String name) async {
    final record = await collection(Room).create(body: {"name": name});
    return fromRecord(record);
  }
}
