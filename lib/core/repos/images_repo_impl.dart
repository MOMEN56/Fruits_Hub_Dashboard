import 'dart:developer';
import 'dart:io';
import 'package:dartz/dartz.dart';
import '../errors/failures.dart';
import '../repos/images_repo.dart';
import '../service/storage_service.dart';
import '../utils/backend_endpoint.dart';

class ImagesRepoImpl implements ImagesRepo {
  final StorageService storageService;

  ImagesRepoImpl(this.storageService);

  @override
  Future<Either<Failure, String>> uploadImage(File image) async {
    try {
      final url = await storageService.uploadFile(
        image,
        BackendEndpoint.images,
      );
      return Right(url);
    } catch (e) {
      log('UPLOAD ERROR: $e');
      return Left(ServerFailure(e.toString()));
    }
  }
}
