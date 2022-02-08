import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:hyrbidsol/controller/singncontrooler.dart';
import 'package:hyrbidsol/pages/home.dart';

class SigninPage extends StatefulWidget {
  @override
  _SigninPageState createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  bool _obscureText = true;
  IconData _iconVisible = Icons.visibility_off;

  final Color _color1 = Color(0xFF304FFE);
  final Color _color2 = Color(0xFF8C9EFF);
  final Color _color3 = Color(0xFF90CAF9);
  final controller = Get.put((LoginControoler()));
  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
      if (_obscureText == true) {
        _iconVisible = Icons.visibility_off;
      } else {
        _iconVisible = Icons.visibility;
      }
    });
  }

  double getSmallDiameter(BuildContext context) {
    return MediaQuery.of(context).size.width * 2 / 3;
  }

  double getBigDiameter(BuildContext context) {
    return MediaQuery.of(context).size.width * 7 / 8;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: Platform.isIOS
              ? SystemUiOverlayStyle.light
              : SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light),
          child: Stack(
            children: [
              const Positioned(
                  bottom: 20,
                  left: 100,
                  child: Text(
                    "",
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 20,
                    ),
                  )),
              Positioned(
                top: -getSmallDiameter(context) / 3,
                right: -getSmallDiameter(context) / 3,
                child: Container(
                  width: getSmallDiameter(context),
                  height: getSmallDiameter(context),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                          colors: [_color1, _color3],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter)),
                ),
              ),
              Positioned(
                top: -getBigDiameter(context) / 4,
                left: -getBigDiameter(context) / 4,
                child: Container(
                  child: Center(
                    child: Container(
                      alignment: const Alignment(0.2, 0.2),
                      // child: Image.asset('assets/images/logo_dark.png',
                      //     height: 120)
                    ),
                  ),
                  width: getBigDiameter(context),
                  height: getBigDiameter(context),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                          colors: [_color1, _color2],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter)),
                ),
              ),
              Positioned(
                bottom: -getBigDiameter(context) / 2,
                right: -getBigDiameter(context) / 2,
                child: Container(
                  width: getBigDiameter(context),
                  height: getBigDiameter(context),
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Color(0xFFF3E9EE)),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: ListView(
                  padding: const EdgeInsets.only(bottom: 24),
                  children: <Widget>[
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      margin: const EdgeInsets.fromLTRB(24, 300, 24, 10),
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Text(
                            "Hybrid Walls",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(
                            height: 14,
                          ),
                          Text(
                            "Explore thousand of free wallapapers for your phone and set them as your LockScreen or HomeScreen any time you want",
                            style: TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 20,
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(24, 0, 24, 30),
                      child: TextButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) => Colors.transparent,
                            ),
                            overlayColor:
                                MaterialStateProperty.all(Colors.transparent),
                          ),
                          onPressed: () async {
                            await controller.login();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Home()));
                          },
                          child: Ink(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: <Color>[_color1, _color2],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                            ),
                            child: Container(
                              constraints: const BoxConstraints(
                                  maxWidth: 200,
                                  minHeight:
                                      60), // min sizes for Material buttons
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  const Text(
                                    "Sign In With",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Image.asset(
                                    "assets/google3.png",
                                    height: 22,
                                  )
                                ],
                              ),
                            ),
                          )),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
