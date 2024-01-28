import 'package:saig_app/config/cloudinary/cloudinary_config.dart';
import 'package:saig_app/domain/entities/gallery_item.dart';
import 'package:saig_app/infrastructure/datasources/cloudinary/models/cloudinary_resource.dart';

class CloudinaryMapper {


  static GalleryItem resourceToEntity( CloudinaryResource resource ) {
    
    return GalleryItem(
        coordLat: double.tryParse(resource.metadata.coordLat) ?? 0.0,
        coordLng: double.tryParse(resource.metadata.coordLng) ?? 0.0,
        description: resource.publicId,
        thumbUrl: _getThumbUrl(resource),
        filename: resource.filename,
    );
  }

  ///
  /// Arma el string con la URL de la miniatura
  ///
  static String _getThumbUrl(CloudinaryResource resource) {
    return 'https://res.cloudinary.com/${CloudinaryConfig.cloudinaryCloudName}/image/upload/c_thumb,w_200/${resource.publicId}.${resource.format}';
  }

}
