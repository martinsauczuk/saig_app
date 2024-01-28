
import 'package:saig_app/infrastructure/datasources/cloudinary/models/cloudinary_metadata.dart';

class CloudinaryResource {
  
    CloudinaryResource({
        required this.assetId,
        required this.publicId,
        required this.folder,
        required this.filename,
        required this.format,
        required this.version,
        // required this.resourceType,
        // required this.type,
        required this.createdAt,
        required this.uploadedAt,
        required this.bytes,
        required this.backupBytes,
        required this.width,
        required this.height,
        required this.aspectRatio,
        required this.pixels,
        // required this.duration,
        // required this.pages,
        required this.url,
        required this.secureUrl,
        // required this.status,
        // required this.accessMode,
        required this.accessControl,
        required this.etag,
        required this.metadata,
        // required this.createdBy,
        // required this.uploadedBy,
    });

    String assetId;
    String publicId;
    String folder;
    String filename;
    String format;
    int version;
    // ResourceType resourceType;
    // Type type;
    DateTime createdAt;
    DateTime uploadedAt;
    int bytes;
    int backupBytes;
    int width;
    int height;
    double aspectRatio;
    int pixels;
    // double duration;
    // int pages;
    String url;
    String secureUrl;
    // Status status;
    // AccessMode accessMode;
    dynamic accessControl;
    String etag;
    CloudinaryMetadata metadata;
    dynamic createdBy;
    dynamic uploadedBy;


    // String getUrlThumb() {
    //   return 'https://res.cloudinary.com/dmhk3tifm/image/upload/c_thumb,w_200,g_face/$publicId.$format';
    // }


    factory CloudinaryResource.fromJson(Map<String, dynamic> json) => CloudinaryResource(
        assetId: json["asset_id"],
        publicId: json["public_id"],
        folder: json["folder"],
        filename: json["filename"],
        format: json["format"],
        version: json["version"],
        // resourceType: resourceTypeValues.map[json["resource_type"]],
        // type: typeValues.map[json["type"]],
        createdAt: DateTime.parse(json["created_at"]),
        uploadedAt: DateTime.parse(json["uploaded_at"]),
        bytes: json["bytes"],
        backupBytes: json["backup_bytes"],
        width: json["width"],
        height: json["height"],
        aspectRatio: json["aspect_ratio"].toDouble(),
        pixels: json["pixels"],
        url: json["url"],
        secureUrl: json["secure_url"],
        // status: statusValues.map[json["status"]],
        // accessMode: accessModeValues.map[json["access_mode"]],
        accessControl: json["access_control"],
        etag: json["etag"],
        metadata: CloudinaryMetadata.fromJson(json["metadata"]),
        // createdBy: json["created_by"],
        // uploadedBy: json["uploaded_by"], type: null,
    );

}