import 'package:intl/intl.dart';

class Helpers {

  String baseUrl = "http://127.0.0.1:8080";

  String formatDate(date) {
    final DateFormat formatter = DateFormat("yyyy-MM-dd HH:mm:ss");
    return formatter.format(date);
  }

 

}