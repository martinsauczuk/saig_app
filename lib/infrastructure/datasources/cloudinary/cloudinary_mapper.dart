import 'package:saig_app/domain/entities/gallery_item.dart';
import 'package:saig_app/infrastructure/datasources/cloudinary/models/cloudinary_resource.dart';

class CloudinaryMapper {
  static GalleryItem resourceToEntity( CloudinaryResource resource ) {
    
    return GalleryItem(
        coordLat: double.tryParse(resource.metadata.coordLat) ?? 0.0,
        coordLng: double.tryParse(resource.metadata.coordLng) ?? 0.0,
        description: resource.publicId,
        thumbUrl: resource.url, //TODO: Fix size
        filename: resource.filename,
    );
  }
}
