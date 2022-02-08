import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hyrbidsol/models/categor_model.dart';
import 'package:get/state_manager.dart';

class CategoryControoler extends GetxController {
  Future<List<Category>> getNews() async {
    var client = http.Client();
    var catModel;

    var response = await client
        .get(Uri.parse("http://fattafatt.com.pk:19000/api/v1/category"));
    if (response.statusCode == 200) {
      var jsonString = response.body;
      var jsonMap = json.decode(jsonString);

      print(jsonMap);
      // print(jsonMap['_id']);
    }
    // } catch (Exception) {
    //   return catModel;
    // }

    return categoryFromJson(response.body);
  }
}
