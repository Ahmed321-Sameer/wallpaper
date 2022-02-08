import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:hyrbidsol/controller/images_api.dart';
import 'package:hyrbidsol/models/images.dart';
import '../models/config.dart';
import '../widgets/cached_image.dart';
import 'detail.dart';

class CatagoryItem extends StatefulWidget {
  final String? title;
  final String? selectedCatagory;
  CatagoryItem({Key? key, required this.title, this.selectedCatagory})
      : super(key: key);

  @override
  _CatagoryItemState createState() =>
      _CatagoryItemState(this.title, this.selectedCatagory);
}

class _CatagoryItemState extends State<CatagoryItem> {
  String? title;
  String? selectedCatagory;
  _CatagoryItemState(this.title, this.selectedCatagory);
  List categories = [];
  List<ImagesModel> filtercategories = [];

  @override
  void initState() {
    sb.getImages().then((data) {
      setState(() {
        categories = data;
        filtercategories = data
            .where((element) => element.category!.id == selectedCatagory)
            .toList();
      });
    });
    // controller = ScrollController()..addListener(_scrollListener);
    _isLoading = true;
    super.initState();
  }

  getfiltercat() {
    print(filtercategories);
    print(selectedCatagory);

    print("yes");
  }

  // @override
  // void dispose() {
  //   controller!.removeListener(_scrollListener);
  //   super.dispose();
  // }

  ScrollController? controller;
  late bool _isLoading;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // void _scrollListener() {
  //   if (!_isLoading) {
  //     if (controller!.position.pixels == controller!.position.maxScrollExtent) {
  //       setState(() => _isLoading = true);
  //     }
  //   }
  // }

  final sb = Get.put((ImagesControoler()));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: scaffoldKey,
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          title!,
          style: const TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          Expanded(
              child: filtercategories.isNotEmpty
                  ? StaggeredGridView.countBuilder(
                      crossAxisCount: 4,
                      // controller: controller,
                      itemCount: filtercategories.length,
                      itemBuilder: (BuildContext context, int index) {
                        // if (index < snapshot.data!.length) {
                        //   var imagesData = snapshot.data![index];

                        return InkWell(
                          child: Stack(
                            children: [
                              Hero(
                                  tag: 'category$index',
                                  child: cachedImage(
                                      filtercategories[index].image)),
                              Positioned(
                                bottom: 30,
                                left: 10,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      Config().hashTag,
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 14),
                                    ),
                                    Text(
                                      categories[index].title.toString(),
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    )
                                  ],
                                ),
                              ),
                              Positioned(
                                right: 10,
                                top: 20,
                                child: Row(
                                  children: [
                                    Icon(Icons.favorite,
                                        color: Colors.white.withOpacity(0.5),
                                        size: 25),
                                    // Text(
                                    //   ('loves').toString(),
                                    //   style: TextStyle(
                                    //       color: Colors.white.withOpacity(0.7),
                                    //       fontSize: 16,
                                    //       fontWeight: FontWeight.w600),
                                    // ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DetailsPage(
                                        tag: 'category$index',
                                        imageUrl: filtercategories[index].image,
                                        catagory: filtercategories[index]
                                            .category
                                            .toString())));
                          },
                        );
                        // }
                        // return Center(
                        //   child: Opacity(
                        //     opacity: _isLoading ? 1.0 : 0.0,
                        //     child: const SizedBox(
                        //         width: 32.0,
                        //         height: 32.0,
                        //         child: CupertinoActivityIndicator()),
                        //   ),
                        // );
                      },
                      staggeredTileBuilder: (int index) =>
                          StaggeredTile.count(2, index.isEven ? 4 : 3),
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      padding: const EdgeInsets.all(15),
                    )
                  : const Center(child: CircularProgressIndicator())
              // },
              // ),
              ),
          ElevatedButton(
              onPressed: () {
                getfiltercat();
              },
              child: Text("fff")),
        ],
      ),
    );
  }
}
