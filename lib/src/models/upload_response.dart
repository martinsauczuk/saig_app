import 'dart:convert';

UploadResponse uploadResponseFromJson(String str) => UploadResponse.fromJson(json.decode(str));

String uploadResponseToJson(UploadResponse data) => json.encode(data.toJson());

class UploadResponse {
    UploadResponse({
        this.assetId,
        this.publicId,
        this.version,
        this.versionId,
        this.signature,
        this.width,
        this.height,
        this.format,
        this.resourceType,
        this.createdAt,
        this.bytes,
        this.type,
        this.etag,
        this.placeholder,
        this.url,
        this.secureUrl,
        this.context,
        this.metadata,
        this.originalFilename,
    });

    String assetId;
    String publicId;
    int version;
    String versionId;
    String signature;
    int width;
    int height;
    String format;
    String resourceType;
    DateTime createdAt;
    int bytes;
    String type;
    String etag;
    bool placeholder;
    String url;
    String secureUrl;
    Context context;
    Metadata metadata;
    String originalFilename;

    factory UploadResponse.fromJson(Map<String, dynamic> json) => UploadResponse(
        assetId: json["asset_id"],
        publicId: json["public_id"],
        version: json["version"],
        versionId: json["version_id"],
        signature: json["signature"],
        width: json["width"],
        height: json["height"],
        format: json["format"],
        resourceType: json["resource_type"],
        createdAt: DateTime.parse(json["created_at"]),
        bytes: json["bytes"],
        type: json["type"],
        etag: json["etag"],
        placeholder: json["placeholder"],
        url: json["url"],
        secureUrl: json["secure_url"],
        context: Context.fromJson(json["context"]),
        // metadata: Metadata.fromJson(json["metadata"]),
        originalFilename: json["original_filename"],
    );

    Map<String, dynamic> toJson() => {
        "asset_id": assetId,
        "public_id": publicId,
        "version": version,
        "version_id": versionId,
        "signature": signature,
        "width": width,
        "height": height,
        "format": format,
        "resource_type": resourceType,
        "created_at": createdAt.toIso8601String(),
        "bytes": bytes,
        "type": type,
        "etag": etag,
        "placeholder": placeholder,
        "url": url,
        "secure_url": secureUrl,
        "context": context.toJson(),
        // "metadata": metadata.toJson(),
        "original_filename": originalFilename,
    };
}

class Context {
    Context();

    factory Context.fromJson(Map<String, dynamic> json) => Context(
    );

    Map<String, dynamic> toJson() => {
    };
}

class Metadata {
    Metadata({
        this.latitud,
        this.lng,
    });

    String latitud;
    String lng;

    factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
        latitud: json["latitud"],
        lng: json["lng"],
    );

    Map<String, dynamic> toJson() => {
        "latitud": latitud,
        "lng": lng,
    };
}
