import 'dart:convert';

import 'package:saig_app/infrastructure/cloudinary/models/cloudinary_resource.dart';


CloudinarySearchResponse searchResponseFromJson(String str) => CloudinarySearchResponse.fromJson(json.decode(str));

class CloudinarySearchResponse {

    int totalCount;
    int time;
    List<CloudinaryResource> resources;

    CloudinarySearchResponse({
        required this.totalCount,
        required this.time,
        required this.resources,
    });

    factory CloudinarySearchResponse.fromJson(Map<String, dynamic> json) => CloudinarySearchResponse(
        totalCount: json["total_count"],
        time: json["time"],
        resources: List<CloudinaryResource>.from(json["resources"].map((x) => CloudinaryResource.fromJson(x))),
    );
}
