import 'package:server/server_config.dart';
import 'package:shared/models/person.dart';
import 'package:shared/objectbox.g.dart';
import 'package:shared/repositories/repository_interface.dart';

class PersonRepository implements RepositoryInterface<Person> {

  Box itemBox = ServerConfig().store.box<Person>();

  @override
  Future<Person?> add(Person item) async {
    itemBox.put(item, mode: PutMode.insert);
    return item;
  }

  @override
  Future<Person?> getById(int id) async {
    return itemBox.get(id);
  }


  @override
  Future<List<Person>?> getAll() async {
    var itemList = itemBox.getAll().cast<Person>();
    return itemList;
  }


  @override
  Future<Person?> update(int id, Person item) async {
    itemBox.put(item, mode: PutMode.update);
    return item;
  }

  @override
  Future<Person?> delete(int id) async {
    var itemToDelete = itemBox.get(id);
    if(itemToDelete != null) {
      itemBox.remove(id);
    }
    return itemToDelete;
  }

}
