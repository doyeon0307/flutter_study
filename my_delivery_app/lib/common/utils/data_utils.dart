import 'package:my_delivery_app/common/const/data.dart';

class DataUtils {
  static pathToUrl(String value) {
    return "http://$ip/$value";
  }
  static listPathsToUrl(List<String> paths) {
    return paths.map((e) => pathToUrl(e)).toList();
  }
}