import 'package:flutter/material.dart';
import 'package:mobile_ess/screens/admin/administrator/master%20data/master_data_bingkai_lensa.dart';
import 'package:mobile_ess/screens/admin/administrator/master%20data/master_data_rawat_jalan.dart';
import 'package:mobile_ess/themes/colors.dart';

class Tabs extends StatefulWidget {
  const Tabs({super.key});

  @override
  State<Tabs> createState() => _TabsState();
}

class _TabsState extends State<Tabs> with TickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget content() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            height: 45,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(
                15,
              ),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  15,
                ),
                color: const Color(
                  primaryYellow,
                ),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.white,
              tabs: const [
                Tab(text: 'Rawat Jalan'),
                Tab(text: 'Bingkai & Lensa'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AppBar(
            surfaceTintColor: Colors.white,
            elevation: 0,
            backgroundColor: Colors.white,
            title: const Text('Master Data'),
          ),
          content(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                RawatJalan(),
                BingkaiLensa(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
