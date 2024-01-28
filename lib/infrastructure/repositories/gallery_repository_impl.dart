import 'package:saig_app/domain/datasources/gallery_datasource.dart';
import 'package:saig_app/domain/entities/gallery_item.dart';
import 'package:saig_app/domain/repositories/gallery_repository.dart';

class GalleryRepositoryImpl implements GalleryRepository {

  final GalleryDatasource datasource;

  GalleryRepositoryImpl({required this.datasource});

  @override
  Future<List<GalleryItem>> getAllItems() {
    return datasource.getAllItems();
  }


}