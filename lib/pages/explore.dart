import 'package:flutter/material.dart';
import 'package:hyrbidsol/widgets/new_item.dart';
import 'package:hyrbidsol/widgets/popular_item.dart';

class ExplorePage extends StatefulWidget {
  ExplorePage({Key? key}) : super(key: key);

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage>
    with TickerProviderStateMixin {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  TabController? tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          child: SafeArea(
            child: TabBar(
              controller: tabController,
              labelStyle: const TextStyle(
                  fontSize: 15,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500),
              tabs: const [
                Tab(
                  child: Text('Popular Walfies'),
                ),
                Tab(
                  child: Text(
                    'New Walfies',
                  ),
                )
              ],
              labelColor: Colors.black,
              indicatorColor: Colors.grey[900],
              unselectedLabelColor: Colors.grey,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                PopularItems(scaffoldKey: scaffoldKey),
                NewItems(
                  scaffoldKey: scaffoldKey,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
