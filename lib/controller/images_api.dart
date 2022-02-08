import 'dart:convert';

import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:hyrbidsol/models/images.dart';
import 'package:http/http.dart' as http;

class ImagesControoler extends GetxController {
  Future<List<ImagesModel>> getImages() async {
    var client = http.Client();
    var catModel;

    var response = await client
        .get(Uri.parse("http://fattafatt.com.pk:19000/api/v1/images"));
    if (response.statusCode == 200) {
      var jsonString = response.body;
      var jsonMap = json.decode(jsonString);

      print(jsonMap);
      // print(jsonMap['_id']);
    }
    // } catch (Exception) {
    //   return catModel;
    // }

    return imagesModelFromJson(response.body);
  }
}


// Future<SimilarProductModel> getSimilarProduct(int id) async {
//     final String apiUrl = "https://homestorepro.pk/api/v2/products/related/$id";
//     // print("Bearer" + " $accessToken");

//     final response = await http.get(Uri.parse(apiUrl), headers: {
//       // "Authorization": "Bearer" + " $accessToken",
//     });

//     if (response.statusCode == 200) {
//       final String responseString = response.body;

//       return similarProductModelFromJson(responseString);
//     } else {
//       print('something went wrong');
//       // ToastMsg(Colors.red,"SOmething went Wrong status code is ",);
//       return null;
//     }
//   }

  