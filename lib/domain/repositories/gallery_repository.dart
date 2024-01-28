import 'package:saig_app/domain/entities/gallery_item.dart';

abstract class GalleryRepository {

  Future<List<GalleryItem>> getAllItems();

}