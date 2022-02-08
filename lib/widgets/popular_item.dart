import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:hyrbidsol/controller/images_api.dart';
import 'package:hyrbidsol/models/config.dart';
import 'package:hyrbidsol/models/images.dart';
import 'package:hyrbidsol/pages/detail.dart';
import 'package:hyrbidsol/widgets/cached_image.dart';

class PopularItems extends StatefulWidget {
  PopularItems({Key? key, required this.scaffoldKey}) : super(key: key);
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  _PopularItemsState createState() => _PopularItemsState();
}

class _PopularItemsState extends State<PopularItems>
    with AutomaticKeepAliveClientMixin {
  // final FirebaseFirestore firestore = FirebaseFirestore.instance;

  ScrollController? controller;
  // DocumentSnapshot? _lastVisible;
  late bool _isLoading;
  // List<DocumentSnapshot> _data = [];

  @override
  void initState() {
    controller = ScrollController()..addListener(_scrollListener);
    super.initState();
    _isLoading = true;
    sb.getImages();
  }

  @override
  void dispose() {
    controller!.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    if (!_isLoading) {
      if (controller!.position.pixels == controller!.position.maxScrollExtent) {
        setState(() => _isLoading = true);
        sb.getImages();
      }
    }
  }

  final sb = Get.put((ImagesControoler()));

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        Expanded(
          child: FutureBuilder<List<ImagesModel>>(
              future: sb.getImages(),
              builder: (context, snapshot) {
                return StaggeredGridView.countBuilder(
                  controller: controller,
                  crossAxisCount: 4,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (index < snapshot.data!.length) {
                      var d = snapshot.data![index];

                      return InkWell(
                        child: Stack(
                          children: <Widget>[
                            Hero(
                                tag: 'popular$index',
                                child: cachedImage(d.image)),
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
                                    d.title.toString(),
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
                                  Text(
                                    ('loves').toString(),
                                    style: TextStyle(
                                        color: Colors.white.withOpacity(0.7),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
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
                                        tag: 'popular$index',
                                        imageUrl: d.image,
                                        catagory: d.category.toString(),
                                      )));
                        },
                      );
                    }

                    return Center(
                      child: Opacity(
                        opacity: _isLoading ? 1.0 : 0.0,
                        child: const SizedBox(
                            width: 32.0,
                            height: 32.0,
                            child: CupertinoActivityIndicator()),
                      ),
                    );
                  },
                  staggeredTileBuilder: (int index) =>
                      StaggeredTile.count(2, index.isEven ? 4 : 3),
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  padding: const EdgeInsets.all(15),
                );
              }),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
