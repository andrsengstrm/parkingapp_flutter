import 'package:server/server_config.dart';
import 'package:shared/models/parking_space.dart';
import 'package:shared/objectbox.g.dart';
import 'package:shared/repositories/repository_interface.dart';

class ParkingSpaceRepository implements RepositoryInterface<ParkingSpace> {

  Box itemBox = ServerConfig().store.box<ParkingSpace>();

  @override
  Future<ParkingSpace?> add(ParkingSpace item) async {
    itemBox.put(item, mode: PutMode.insert);
    return item;
  }

  @override
  Future<ParkingSpace?> getById(int id) async {
    return itemBox.get(id);
  }

  @override
  Future<List<ParkingSpace>?> getAll() async {
    var itemList = itemBox.getAll().cast<ParkingSpace>();
    return itemList;
  }

  @override
  Future<ParkingSpace?> update(int id, ParkingSpace item) async {
    itemBox.put(item, mode: PutMode.update);
    return item;
  }

  @override
  Future<ParkingSpace?> delete(int id) async {
    var itemToDelete = itemBox.get(id);
    if(itemToDelete != null) {
      itemBox.remove(id);
    }
    return itemToDelete;
  }

}
