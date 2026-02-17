abstract class DatabaseService {
  Future<void> addData(
      {required String path,
      required Map<String, dynamic> data,
      String? documentId});
  Future<dynamic> getData({
    required String path,
    String? documentId, // Corrected spelling from docuementId
    Map<String, dynamic>? query,
  });
  Stream<dynamic> streamData({
    required String path,
    Map<String, dynamic>? query,
  });
  Future<void> updateData(
      {required String path,
      required Map<String, dynamic> data,
      String? documentId});
  Future<bool> checkIfDataExists(
      {required String path, required String documentId}); // Corrected spelling
}
