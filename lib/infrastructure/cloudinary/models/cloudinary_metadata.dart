class CloudinaryMetadata {
    CloudinaryMetadata({
        required this.coordLat,
        required this.coordLng,
        required this.descripcion
    });

    String coordLat;
    String coordLng;
    String descripcion;

    factory CloudinaryMetadata.fromJson(Map<String, dynamic> json) => CloudinaryMetadata(
        coordLat: json["coord_lat"],
        coordLng: json["coord_lng"],
        descripcion: json["desc"]
    );

    Map<String, dynamic> toJson() => {
        "coord_lat": coordLat,
        "coord_lng": coordLng,
        "descripcion": descripcion
    };
}