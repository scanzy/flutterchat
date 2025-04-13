import 'package:pocketbase/pocketbase.dart';
import 'package:flutterchat/utils/pb_service.dart';


// This file contains code to handle data objects, synced to database

// For every object in your data model, create two classes:
// - `MyObject extends Model`
// - `MyObjectFactory extends ModelFactory<MyObject>`

// In MyObject class, make sure to:
// - override `updateFromRecord` method to load data from pocketbase
// - add a method to delete the record in pocketbase
// - add methods to update the record in pocketbase

// In MyObjectFactory, make sure to:
// - override the `createModel` method, with simple default constructor `MyObject()`
// - override `expand` and `sort` getters, if needed
// - add a `create` method to create a new record in pocketbase


// base class for object stored in pocketbase
abstract class Model {

  // pocketbase record id
  late String id;


  // models object cache
  // ensures that no duplicates objects are created for the same record
  static final Map<Type, Map<String, Model>> cachedItems =
    {for (var type in collectionNames.keys) type: {}};


  // applies raw data to model
  // subclasses must override this method
  void updateFromRecord(RecordModel record);
}


// creates model from id or record data
abstract class ModelFactory<M extends Model> {

  // model constructor
  // dart does not support instantiating classes from type objects
  // subclasses must override this method providing default model constructor
  M createModel();


  // strings for pocketbase operations
  // subclasses may override this getters
  String? get expand => null;
  String? get sort   => null;


  // cache accessor for this model type
  Map<String, M> get cachedItems => Model.cachedItems[M]!.cast<String, M>();


  // model constructor from raw pocketbase data
  M fromRecord(RecordModel record) {

    // creates object, storing it in cache
    final model = createModel();
    Model.cachedItems[M]![record.id] = model;

    // sets id and data
    model.id = record.id;
    model.updateFromRecord(record);

    return model;
  }


  // gets one model, using cache if possible
  Future<M> fromId(String id) async {

    // tries cache
    final model = cachedItems[id];
    if (model != null) return model;

    // downloads data from pocketbase
    final record = await collection(M).getOne(id, expand: expand);

    // and builds object
    return fromRecord(record);
  }


  // gets all models
  Future<List<M>> all() async {

    // loads data from pocketbase
    final records = await collection(M).getFullList(sort: sort, expand: expand);

    // builds objects, using cache if possible
    return records.map((record) =>
       cachedItems[record.id] ?? fromRecord(record)
    ).toList();
  }
}
