import 'package:flutter_dotenv/flutter_dotenv.dart';

// TODO: do const where is necessary
class CloudinaryConfig {

  static String basePath = dotenv.env['BASE_PATH']!;
  static String cloudinaryCloudName = dotenv.env['CLOUD_NAME']!;
  static String apiKey = dotenv.env['API_KEY']!;
  static String apiSecret = dotenv.env['API_SECRET']!;
  static String folder = dotenv.env['FOLDER']!;
  static String uploadPreset = dotenv.env['UPLOAD_PRESET']!;

  static int maxResults = 500;

}