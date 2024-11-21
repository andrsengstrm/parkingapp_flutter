abstract interface class RepositoryInterface<T> {

  Future<T?> add(T item);
  Future<List<T>?> getAll();
  Future<T?> getById(int id);
  Future<T?> update(int id, T item);
  Future<T?> delete(int id);

}