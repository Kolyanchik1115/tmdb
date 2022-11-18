import 'package:tmdb/config/configuration.dart';

class ImageDownloader{
    static String imageUrl(String path) => Configuration.imageUrl + path;
}