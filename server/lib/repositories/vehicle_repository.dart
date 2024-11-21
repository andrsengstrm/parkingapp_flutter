import 'package:server/server_config.dart';
import 'package:shared/models/vehicle.dart';
import 'package:shared/objectbox.g.dart';
import 'package:shared/repositories/repository_interface.dart';

class VehicleRepository implements RepositoryInterface<Vehicle> {

  Box itemBox = ServerConfig().store.box<Vehicle>();

  @override
  Future<Vehicle?> add(Vehicle item) async {
    itemBox.put(item, mode: PutMode.insert);
    return item;
  }

  @override
  Future<Vehicle?> getById(int id) async {
    return itemBox.get(id);
  }


  @override
  Future<List<Vehicle>?> getAll() async {
    var itemList = itemBox.getAll().cast<Vehicle>();
    return itemList;
  }


  @override
  Future<Vehicle?> update(int id, Vehicle item) async {
    itemBox.put(item, mode: PutMode.update);
    return item;
  }

  @override
  Future<Vehicle?> delete(int id) async {
    var itemToDelete = itemBox.get(id);
    if(itemToDelete != null) {
      itemBox.remove(id);
    }
    return itemToDelete;
  }

}
