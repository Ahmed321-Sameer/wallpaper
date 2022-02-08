import 'package:get/state_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginControoler extends GetxController {
  var sign_in = GoogleSignIn();
  String? _name;
  String? get name => _name;

  String? _email;
  String? get email => _email;

  String? _imageUrl;
  String? get imageUrl => _imageUrl;
  var acountdeatil = Rx<GoogleSignInAccount?>(null);
  login() async {
    acountdeatil.value = await sign_in.signIn();
    _name = acountdeatil.value!.displayName;
    _email = acountdeatil.value!.email;
    _imageUrl = acountdeatil.value!.photoUrl;
  }

  final List _alldata = [];
  List get alldata => _alldata;
}
