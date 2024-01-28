import 'package:flutter_dotenv/flutter_dotenv.dart';

class CloudinaryConfig {

  static String basePath = dotenv.env['BASE_PATH']!;
  static String cloudinaryCloudName = dotenv.env['CLOUD_NAME']!;
  static String apiKey = dotenv.env['API_KEY']!;
  static String apiSecret = dotenv.env['API_SECRET']!;
  static String folder = dotenv.env['FOLDER']!;

  static int maxResults = 500;

}