import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:hyrbidsol/controller/category.dart';
import 'package:hyrbidsol/controller/internetcon.dart';
import 'package:hyrbidsol/controller/singncontrooler.dart';
import 'package:hyrbidsol/models/config.dart';
import 'package:hyrbidsol/pages/categories.dart';
import 'package:hyrbidsol/pages/drawer.dart';
import 'package:hyrbidsol/pages/explore.dart';
import 'package:hyrbidsol/pages/internet.dart';
import 'package:hyrbidsol/widgets/loading_animation.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

int listIndex = 0;
var _scaffoldKey = GlobalKey<ScaffoldState>();

class _HomeState extends State<Home> {
  showUserInfo(context, name, email, imageUrl) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding:
                const EdgeInsets.only(left: 0, right: 0, top: 40, bottom: 0),
            content: Container(
                height: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[300],
                          image: DecorationImage(
                              image: CachedNetworkImageProvider(imageUrl))),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      'You have alredy signed in with\n$email',
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey),
                    ),
                    const Spacer(),
                    InkWell(
                      child: Container(
                        height: 50,
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.blueAccent,
                        child: const Text(
                          'Ok, Got It',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                )),
          );
        });
  }

  final ib = Get.put((CheckInternetController()));
  final sb = Get.put((LoginControoler()));
  final dt = Get.put((CategoryControoler()));

  @override
  void initState() {
    dt.getNews();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return ib.hasInternet == false
        ? const NoInternetPage()
        : Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.white,
            endDrawer: DrawerWidget(),
            body: SafeArea(
              child: Column(
                children: <Widget>[
                  Container(
                      padding: const EdgeInsets.only(
                        left: 30,
                        right: 10,
                      ),
                      alignment: Alignment.centerLeft,
                      height: 70,
                      child: Row(
                        children: <Widget>[
                          Text(
                            Config().appName,
                            style: const TextStyle(
                                fontSize: 27,
                                color: Colors.black,
                                fontWeight: FontWeight.w800),
                          ),
                          const Spacer(),
                          InkWell(
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey[300],
                                image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                      sb.acountdeatil.value?.photoUrl ?? ""),
                                ),
                              ),
                            ),
                            onTap: () {
                              showUserInfo(
                                  context,
                                  sb.acountdeatil.value?.displayName,
                                  sb.acountdeatil.value?.email,
                                  sb.acountdeatil.value?.photoUrl);
                            },
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          IconButton(
                            icon: const Icon(
                              FontAwesomeIcons.stream,
                              size: 20,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              _scaffoldKey.currentState!.openEndDrawer();
                            },
                          )
                        ],
                      )),
                  Stack(
                    children: <Widget>[
                      CarouselSlider(
                        options: CarouselOptions(
                            enlargeStrategy: CenterPageEnlargeStrategy.height,
                            initialPage: 0,
                            viewportFraction: 0.90,
                            enlargeCenterPage: true,
                            enableInfiniteScroll: false,
                            height: h * 0.70,
                            onPageChanged: (int index, reason) {
                              setState(() => listIndex = index);
                            }),
                        items: [1, 2, 3, 4, 5].map((i) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                                  decoration:
                                      BoxDecoration(color: Colors.amber),
                                  child: Text(
                                    'text $i',
                                    style: TextStyle(fontSize: 16.0),
                                  ));
                            },
                          );
                        }).toList(),
                        //  sb.alldata.length! == 0
                        //     ? [0, 1]
                        //         .take(1)
                        //         .map((f) => LoadingWidget())

                        // : db.alldata.map((i) {
                        //     return Builder(
                        //       builder: (BuildContext context) {
                        //         return Container(
                        //             width:
                        //                 MediaQuery.of(context).size.width,
                        //             margin:
                        //                 const EdgeInsets.symmetric(horizontal: 0),
                        //             child: InkWell(
                        //               child: CachedNetworkImage(
                        //                 imageUrl: i['image url'],
                        //                 imageBuilder:
                        //                     (context, imageProvider) =>
                        //                         Hero(
                        //                   tag: i['timestamp'],
                        //                   child: Container(
                        //                     margin: const EdgeInsets.only(
                        //                         left: 10,
                        //                         right: 10,
                        //                         top: 10,
                        //                         bottom: 50),
                        //                     decoration: BoxDecoration(
                        //                         color: Colors.grey[200],
                        //                         borderRadius:
                        //                             BorderRadius.circular(
                        //                                 20),
                        //                         boxShadow: <BoxShadow>[
                        //                           BoxShadow(
                        //                               color:
                        //                                   Colors.grey[300]!,
                        //                               blurRadius: 30,
                        //                               offset: const Offset(5, 20))
                        //                         ],
                        //                         image: DecorationImage(
                        //                             image: imageProvider,
                        //                             fit: BoxFit.cover)),
                        //                     child: Padding(
                        //                         padding:
                        //                             const EdgeInsets.only(
                        //                                 left: 30,
                        //                                 bottom: 40),
                        //                         child: Row(
                        //                           crossAxisAlignment:
                        //                               CrossAxisAlignment
                        //                                   .end,
                        //                           children: <Widget>[
                        //                             Column(
                        //                               mainAxisAlignment:
                        //                                   MainAxisAlignment
                        //                                       .end,
                        //                               crossAxisAlignment:
                        //                                   CrossAxisAlignment
                        //                                       .start,
                        //                               children: <Widget>[
                        //                                 Text(
                        //                                   Config().hashTag,
                        //                                   style: const TextStyle(
                        //                                       decoration:
                        //                                           TextDecoration
                        //                                               .none,
                        //                                       color: Colors
                        //                                           .white,
                        //                                       fontSize: 14),
                        //                                 ),
                        //                                 Text(
                        //                                   i['category'],
                        //                                   style: const TextStyle(
                        //                                       decoration:
                        //                                           TextDecoration
                        //                                               .none,
                        //                                       color: Colors
                        //                                           .white,
                        //                                       fontSize: 25),
                        //                                 )
                        //                               ],
                        //                             ),
                        //                            const Spacer(),
                        //                             Icon(
                        //                               Icons.favorite,
                        //                               size: 25,
                        //                               color: Colors.white
                        //                                   .withOpacity(0.5),
                        //                             ),
                        //                             const SizedBox(width: 2),
                        //                             Text(
                        //                               i['loves'].toString(),
                        //                               style: TextStyle(
                        //                                   decoration:
                        //                                       TextDecoration
                        //                                           .none,
                        //                                   color: Colors
                        //                                       .white
                        //                                       .withOpacity(
                        //                                           0.7),
                        //                                   fontSize: 18,
                        //                                   fontWeight:
                        //                                       FontWeight
                        //                                           .w600),
                        //                             ),
                        //                             const SizedBox(
                        //                               width: 15,
                        //                             )
                        //                           ],
                        //                         )),
                        //                   ),
                        //                 ),
                        //                 placeholder: (context, url) =>
                        //                     LoadingWidget(),
                        //                 errorWidget:
                        //                     (context, url, error) => const Icon(
                        //                   Icons.error,
                        //                   size: 40,
                        //                 ),
                        //               ),
                        //               onTap: () {
                        //                 Navigator.push(
                        //                     context,
                        //                     MaterialPageRoute(
                        //                         builder: (context) =>
                        //                             // DetailsPage(
                        //                             //     tag: i['timestamp'],
                        //                             //     imageUrl:
                        //                             //         i['image url'],
                        //                             //     catagory:
                        //                             //         i['category'],
                        //                             //     timestamp: i[
                        //                             //         'timestamp']),
                        //                                     ),
                        //                                     );
                        //               },
                        //             ));
                        //       },
                        //     );
                        //   }).toList(),
                      ),
                      Positioned(
                        top: 40,
                        left: w * 0.23,
                        child: const Text(
                          'WALL OF THE DAY',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Positioned(
                        bottom: 5,
                        left: w * 0.34,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          child: DotsIndicator(
                            dotsCount: 5,
                            position: listIndex.toDouble(),
                            decorator: DotsDecorator(
                              activeColor: Colors.black,
                              color: Colors.black,
                              spacing: const EdgeInsets.all(3),
                              size: const Size.square(8.0),
                              activeSize: const Size(40.0, 6.0),
                              activeShape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  const Spacer(),
                  Container(
                    height: 50,
                    width: w * 0.80,
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(30)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(FontAwesomeIcons.dashcube,
                              color: Colors.grey[600], size: 20),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CatagoryPage()));
                          },
                        ),
                        IconButton(
                          icon: Icon(FontAwesomeIcons.solidCompass,
                              color: Colors.grey[600], size: 20),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ExplorePage()));
                          },
                        ),
                        IconButton(
                          icon: Icon(FontAwesomeIcons.solidHeart,
                              color: Colors.grey[600], size: 20),
                          onPressed: () {
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => FavouritePage(
                            //             userUID:
                            //                 context.read<SignInBloc>().uid)));
                          },
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          );
  }
}
