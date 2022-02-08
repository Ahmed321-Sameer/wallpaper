import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:hyrbidsol/controller/category.dart';
import 'package:hyrbidsol/models/categor_model.dart';
import 'package:hyrbidsol/pages/category_item.dart';

class CatagoryPage extends StatefulWidget {
  CatagoryPage({Key? key}) : super(key: key);

  @override
  _CatagoryPageState createState() => _CatagoryPageState();
}

class _CatagoryPageState extends State<CatagoryPage> {
  final sb = Get.put((CategoryControoler()));
  Future<List<Category>>? _catModel;

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      _catModel = sb.getNews();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final db = context.watch<DataBloc>();
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Categories',
            style: TextStyle(
              color: Colors.black,
            )),
      ),
      body: FutureBuilder<List<Category>>(
        future: _catModel,
        builder: (context, snapshot) {
          return ListView.separated(
            padding: const EdgeInsets.all(15),
            itemCount: snapshot.data!.length,
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(
                height: 10,
              );
            },
            itemBuilder: (BuildContext context, int index) {
              var catModel = snapshot.data![index];
              // ignore: unrelated_type_equality_checks
              if (snapshot.data![index] == Null) {
                return Container();
              } else {
                return InkWell(
                  child: Container(
                    height: 140,
                    width: w,
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                            image: CachedNetworkImageProvider(
                                catModel.imagename ?? ""),
                            fit: BoxFit.cover)),
                    child: Align(
                      child: Text(catModel.name ?? "",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CatagoryItem(
                          title: catModel.name ?? "",
                          selectedCatagory: catModel.id ?? "",
                        ),
                      ),
                    );
                  },
                );
              }
            },
          );
        },
      ),
    );
  }
}

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_instance/src/extension_instance.dart';
// import 'package:hyrbidsol/controller/category.dart';
// import 'package:hyrbidsol/models/categor_model.dart';
// import 'package:hyrbidsol/pages/category_item.dart';

// class CatagoryPage extends StatefulWidget {
//   CatagoryPage({Key? key}) : super(key: key);

//   @override
//   _CatagoryPageState createState() => _CatagoryPageState();
// }

// class _CatagoryPageState extends State<CatagoryPage> {
//   final sb = Get.put((CategoryControoler()));
//   Future<List<Category>>? _catModel;
//   List category = [];
//   @override
//   void initState() {
//     setState(() {
//       sb.getNews().then(
//             (value) => category = value,
//           );
//     });
//     // TODO: implement initState

//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // final db = context.watch<DataBloc>();
//     double w = MediaQuery.of(context).size.width;
//     return Scaffold(
//         backgroundColor: Colors.white,
//         appBar: AppBar(
//           centerTitle: false,
//           title: const Text('Categories',
//               style: TextStyle(
//                 color: Colors.black,
//               )),
//         ),
//         body: category.isNotEmpty
//             ? ListView.separated(
//                 padding: const EdgeInsets.all(15),
//                 itemCount: category.length,
//                 separatorBuilder: (BuildContext context, int index) {
//                   return const SizedBox(
//                     height: 10,
//                   );
//                 },
//                 itemBuilder: (BuildContext context, int index) {
//                   return InkWell(
//                     child: Container(
//                       height: 140,
//                       width: w,
//                       decoration: BoxDecoration(
//                           color: Colors.grey[300],
//                           borderRadius: BorderRadius.circular(10),
//                           image: DecorationImage(
//                               image: CachedNetworkImageProvider(
//                                   category[index].imagename),
//                               fit: BoxFit.cover)),
//                       child: Align(
//                         child: Text(category[index].name,
//                             style: const TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 22,
//                                 fontWeight: FontWeight.w600)),
//                       ),
//                     ),
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => CatagoryItem(
//                             title: category[index].name,
//                             selectedCatagory: category[index].id,
//                           ),
//                         ),
//                       );
//                     },
//                   );
//                 },
//               )
//             : const Center(
//                 child: CircularProgressIndicator(),
//               ));
//   }
// }
