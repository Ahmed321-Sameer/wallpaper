import 'package:connectivity/connectivity.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class CheckInternetController extends GetxController {
  bool _hasInternet = true;
  bool get hasInternet => _hasInternet;

  InternetBloc() {
    //checkInternet();
  }

  Future checkInternet() async {
    var result = await (Connectivity().checkConnectivity());
    if (result == ConnectivityResult.none) {
      _hasInternet = false;
    } else {
      _hasInternet = true;
    }
  }
}
