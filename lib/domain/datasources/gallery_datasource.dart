
import 'package:saig_app/domain/entities/gallery_item.dart';

abstract class GalleryDatasource {

  Future<List<GalleryItem>> getAllItems();

}