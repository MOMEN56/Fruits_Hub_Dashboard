import 'data_service.dart';

class FireStoreService implements DatabaseService {
  @override
  Future<void> addData(
      {required String path,
      required Map<String, dynamic> data,
      String? documentId}) {
    // TODO: implement addData
    throw UnimplementedError();
  }

  @override
  Future<bool> checkIfDataExists(
      {required String path, required String docuementId}) {
    // TODO: implement checkIfDataExists
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> getData(
      {required String path, required String docuementId}) {
    // TODO: implement getData
    throw UnimplementedError();
  }
}
