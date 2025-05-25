import 'package:pocketbase/pocketbase.dart';

import 'package:flutterchat/chat/msg.dart';
import 'package:flutterchat/utils/model.dart';
import 'package:flutterchat/utils/pb_service.dart';


// room mixin to allow to use shared code for:
// - real rooms, with dynamic data loaded from server
// - fake rooms, with hardcoded data
mixin RoomBase {

  // room data
  late String name;
  late String type;
  int? iconCode;
  int? unreadMessages;
  String? lastMsgPreview;
  DateTime? lastUpdate;
}



// model for rooms
class Room extends Model with RoomBase {

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


  // loads all rooms, with linked unread messages
  @override
  Future<List<Room>> all() async {
    final rooms = await super.all();
    for (var room in rooms) {

      // gets unread messages
      final msgs = await collection(Message).getList(
        filter: 'room = "${room.id}"', sort: "-created", expand: "user",
        perPage: 1, // gets only last message. TODO: get all unread messages
      );

      // builds message preview
      final lastMsg = Message(msgs.items[0]);
      room.lastMsgPreview = "${lastMsg.username}: ${lastMsg.text}";

      // shows last message date/time
      room.lastUpdate = lastMsg.editedUTC ?? lastMsg.createdUTC;
    }

    // sorts rooms by last message
    rooms.sort((room1, room2) => room2.lastUpdate!.compareTo(room1.lastUpdate!));
    return rooms;
  }
}
