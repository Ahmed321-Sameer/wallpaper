// details page
import 'dart:io' show Platform;
import 'dart:ui';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:hyrbidsol/controller/images_api.dart';
import 'package:hyrbidsol/controller/internetcon.dart';
import 'package:hyrbidsol/models/icons_data.dart';
import 'package:hyrbidsol/utils/circular_button.dart';
import '../models/config.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:wallpaper/wallpaper.dart';
import 'package:permission_handler/permission_handler.dart';

class DetailsPage extends StatefulWidget {
  final String? tag;
  final String? imageUrl;
  final String? catagory;
  // final String? timestamp;

  DetailsPage({
    Key? key,
    required this.tag,
    this.imageUrl,
    this.catagory,
    // this.timestamp
  }) : super(key: key);

  @override
  _DetailsPageState createState() =>
      _DetailsPageState(this.tag, this.imageUrl, this.catagory
          // this.timestamp
          );
}

class _DetailsPageState extends State<DetailsPage> {
  String? tag;
  String? imageUrl;
  String? catagory;
  // String? timestamp;
  _DetailsPageState(
    this.tag,
    this.imageUrl,
    this.catagory,
    //this.timestamp
  );

  // final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String progress = 'Set as Wallpaper or Download';
  bool downloading = false;
  late Stream<String> progressString;
  Icon dropIcon = const Icon(Icons.arrow_upward);
  Icon upIcon = const Icon(Icons.arrow_upward);
  Icon downIcon = const Icon(Icons.arrow_downward);
  PanelController pc = PanelController();
  PermissionStatus? status;

  void openSetDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('SET AS'),
          contentPadding:
              const EdgeInsets.only(left: 30, top: 40, bottom: 20, right: 40),
          children: <Widget>[
            ListTile(
              contentPadding: const EdgeInsets.all(0),
              leading: circularButton(Icons.format_paint, Colors.blueAccent),
              title: const Text('Set As Lock Screen'),
              onTap: () async {
                await _setLockScreen();
                Navigator.pop(context);
              },
            ),
            ListTile(
              contentPadding: const EdgeInsets.all(0),
              leading: circularButton(Icons.donut_small, Colors.pinkAccent),
              title: const Text('Set As Home Screen'),
              onTap: () async {
                await _setHomeScreen();
                Navigator.pop(context);
              },
            ),
            ListTile(
              contentPadding: const EdgeInsets.all(0),
              leading: circularButton(Icons.compare, Colors.orangeAccent),
              title: const Text('Set As Both'),
              onTap: () async {
                await _setBoth();
                Navigator.pop(context);
              },
            ),
            const SizedBox(
              height: 40,
            ),
            Center(
              child: TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            )
          ],
        );
      },
    );
  }

  //lock screen procedure
  _setLockScreen() {
    progressString = Wallpaper.imageDownloadProgress(imageUrl!);
    progressString.listen((data) {
      setState(() {
        downloading = true;
        progress = 'Setting Your Lock Screen\nProgress: $data';
      });
      print("DataReceived: " + data);
    }, onDone: () async {
      progress = await Wallpaper.lockScreen();
      setState(() {
        downloading = false;
        progress = progress;
      });

      openCompleteDialog();
    }, onError: (error) {
      setState(() {
        downloading = false;
      });
      print("Some Error");
    });
  }

  // home screen procedure
  _setHomeScreen() {
    progressString = Wallpaper.imageDownloadProgress(imageUrl!);
    progressString.listen((data) {
      setState(() {
        //res = data;
        downloading = true;
        progress = 'Setting Your Home Screen\nProgress: $data';
      });
      print("DataReceived: " + data);
    }, onDone: () async {
      progress = await Wallpaper.homeScreen();
      setState(() {
        downloading = false;
        progress = progress;
      });

      openCompleteDialog();
    }, onError: (error) {
      setState(() {
        downloading = false;
      });
      print("Some Error");
    });
  }

  // both lock screen & home screen procedure
  _setBoth() {
    progressString = Wallpaper.imageDownloadProgress(imageUrl!);
    progressString.listen((data) {
      setState(() {
        downloading = true;
        progress = 'Setting your Both Home & Lock Screen\nProgress: $data';
      });
      print("DataReceived: " + data);
    }, onDone: () async {
      progress = await Wallpaper.bothScreen();
      setState(() {
        downloading = false;
        progress = progress;
      });

      openCompleteDialog();
    }, onError: (error) {
      setState(() {
        downloading = false;
      });
      print("Some Error");
    });
  }

  handleStoragePermission() async {
    await Permission.storage.request().then((_) async {
      if (await Permission.storage.status == PermissionStatus.granted) {
        await handleDownload();
      } else if (await Permission.storage.status == PermissionStatus.denied) {
      } else if (await Permission.storage.status ==
          PermissionStatus.permanentlyDenied) {
        askOpenSettingsDialog();
      }
    });
  }

  void openCompleteDialog() async {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.SUCCES,
      title: 'Complete',
      animType: AnimType.SCALE,
      padding: const EdgeInsets.all(30),
      body: Center(
        child: Container(
            alignment: Alignment.center,
            height: 80,
            child: Text(
              progress,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            )),
      ),
      btnOkText: 'Ok',
      dismissOnTouchOutside: true,
      // btnOkOnPress: () {
      //   context
      //       .read<AdsBloc>()
      //       .showInterstitialAdAdmob(); //-------admob--------
      //   //context.read<AdsBloc>().showFbAdd();                        //-------fb--------
      // }
    ).show();
  }

  askOpenSettingsDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Grant Storage Permission to Download'),
            content: const Text(
                'You have to allow storage permission to download any wallpaper fro this app'),
            contentTextStyle:
                const TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
            actions: [
              TextButton(
                child: const Text('Open Settins'),
                onPressed: () async {
                  Navigator.pop(context);
                  await openAppSettings();
                },
              ),
              TextButton(
                child: const Text('Close'),
                onPressed: () async {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  Future handleDownload() async {
    final ib = Get.put((CheckInternetController()));
    await Get.put((CheckInternetController())).checkInternet();
    if (ib.hasInternet == true) {
      var path = await (ExtStorage.getExternalStoragePublicDirectory(
          ExtStorage.DIRECTORY_PICTURES));
      await FlutterDownloader.enqueue(
        url: imageUrl!,
        savedDir: path,
        fileName: '${Config().appName}-$catagory',
        showNotification:
            true, // show download progress in status bar (for Android)
        openFileFromNotification:
            true, // click on notification to open downloaded file (for Android)
      );

      setState(() {
        progress = 'Download Complete!\nCheck Your Status Bar';
      });

      await Future.delayed(const Duration(seconds: 2));
      openCompleteDialog();
    } else {
      setState(() {
        progress = 'Check your internet connection!';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    final db = Get.put((ImagesControoler()));

    return Scaffold(
        key: _scaffoldKey,
        body: SlidingUpPanel(
          controller: pc,
          color: Colors.white.withOpacity(0.9),
          minHeight: 120,
          maxHeight: 450,
          backdropEnabled: false,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          body: panelBodyUI(h, w),
          panel: panelUI(db),
          onPanelClosed: () {
            setState(() {
              dropIcon = upIcon;
            });
          },
          onPanelOpened: () {
            setState(() {
              dropIcon = downIcon;
            });
          },
        ));
  }

  // floating ui
  Widget panelUI(db) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          InkWell(
            child: Container(
              padding: const EdgeInsets.only(top: 10),
              width: double.infinity,
              child: CircleAvatar(
                backgroundColor: Colors.grey[800],
                child: dropIcon,
              ),
            ),
            onTap: () {
              pc.isPanelClosed ? pc.open() : pc.close();
            },
          ),
          const SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      Config().hashTag,
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                    Text(
                      '$catagory Wallpaper',
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    )
                  ],
                ),
                const Spacer(),
                Row(
                  children: const <Widget>[
                    Icon(
                      Icons.favorite,
                      color: Colors.pinkAccent,
                      size: 22,
                    ),
                    // StreamBuilder(
                    //   stream: firestore
                    //       .collection('contents')
                    //       .doc(timestamp)
                    //       .snapshots(),
                    //   builder: (context, AsyncSnapshot snap) {
                    //     if (!snap.hasData) return _buildLoves(0);
                    //     return _buildLoves(snap.data['loves']);
                    //   },
                    // ),
                  ],
                ),
                const SizedBox(
                  width: 20,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    InkWell(
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            shape: BoxShape.circle,
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: Colors.grey[400]!,
                                  blurRadius: 10,
                                  offset: const Offset(2, 2))
                            ]),
                        child: const Icon(
                          Icons.format_paint,
                          color: Colors.white,
                        ),
                      ),
                      onTap: () async {
                        final ib = Get.put((CheckInternetController()));
                        await Get.put((CheckInternetController()))
                            .checkInternet();
                        if (ib.hasInternet == false) {
                          setState(() {
                            progress = 'Check your internet connection!';
                          });
                        } else {
                          openSetDialog();
                        }
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      'Set Wallpaper',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[800],
                          fontWeight: FontWeight.w600),
                    )
                  ],
                ),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  children: <Widget>[
                    InkWell(
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            color: Colors.pinkAccent,
                            shape: BoxShape.circle,
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: Colors.grey[400]!,
                                  blurRadius: 10,
                                  offset: const Offset(2, 2))
                            ]),
                        child: const Icon(
                          Icons.donut_small,
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {
                        handleStoragePermission();
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      'Download',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[800],
                          fontWeight: FontWeight.w600),
                    )
                  ],
                ),
                const SizedBox(
                  width: 20,
                ),
              ],
            ),
          ),
          const Spacer(),
          Padding(
              padding: const EdgeInsets.only(left: 20, right: 10),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 5,
                    height: 30,
                    color: Colors.blueAccent,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      progress,
                      style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              )),
          const SizedBox(
            height: 40,
          )
        ],
      ),
    );
  }

  Widget _buildLoves(loves) {
    return Text(
      loves.toString(),
      style: const TextStyle(color: Colors.black54, fontSize: 16),
    );
  }

  // background ui
  Widget panelBodyUI(h, w) {
    // final SignInBloc sb = Provider.of<SignInBloc>(context, listen: false);
    return Stack(
      children: <Widget>[
        Container(
          height: h,
          width: w,
          color: Colors.grey[200],
          child: Hero(
            tag: tag!,
            child: CachedNetworkImage(
              imageUrl: imageUrl!,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover)),
              ),
              placeholder: (context, url) => const Icon(Icons.image),
              errorWidget: (context, url, error) =>
                  const Center(child: Icon(Icons.error)),
            ),
          ),
        ),
        Positioned(
          top: 60,
          right: 20,
          child: InkWell(
            child: Container(
              height: 40,
              width: 40,
              decoration: const BoxDecoration(
                  color: Colors.white, shape: BoxShape.circle),
              // child: _buildLoveIcon(sb.uid)
            ),
            onTap: () {
              // _loveIconPressed();
            },
          ),
        ),
        Positioned(
          top: 60,
          left: 20,
          child: InkWell(
            child: Container(
              height: 40,
              width: 40,
              decoration: const BoxDecoration(
                  color: Colors.white, shape: BoxShape.circle),
              child: const Icon(
                Icons.close,
                size: 25,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        )
      ],
    );
  }

  // Widget _buildLoveIcon(uid) {
  //   final sb = context.watch<SignInBloc>();
  //   if (sb.guestUser == false) {
  //     return StreamBuilder(
  //       stream: firestore.collection('users').doc(uid).snapshots(),
  //       builder: (context, AsyncSnapshot snap) {
  //         if (!snap.hasData) return LoveIcon().greyIcon;
  //         List d = snap.data['loved items'];

  //         if (d.contains(timestamp)) {
  //           return LoveIcon().pinkIcon;
  //         } else {
  //           return LoveIcon().greyIcon;
  //         }
  //       },
  //     );
  //   } else {
  //     return LoveIcon().greyIcon;
  //   }
  // }

  // _loveIconPressed() async {
  //   final sb = context.read<SignInBloc>();
  //   if (sb.guestUser == false) {
  //     context.read<UserBloc>().handleLoveIconClick(context, timestamp, sb.uid);
  //   } else {
  //     await showGuestUserInfo(context);
  //   }
  // }
}
