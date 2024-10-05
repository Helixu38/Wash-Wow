import 'package:flutter/material.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Column(
        children: [
          buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                Center(child: Text("Đang xử lý")),
                Center(child: Text("Lịch sử")),
                Center(child: Text("Đánh giá")),
                Center(child: Text("Đơn nháp")),
              ],
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(40.0),
      child: AppBar(
        title: Text(
          "Đơn hàng",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
    );
  }

  Widget buildTabBar() {
    return TabBar(
      controller: _tabController,
      labelColor: Colors.black,
      unselectedLabelColor: Colors.grey,
      indicator: BoxDecoration(
        color: Colors.transparent, 
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).primaryColor, 
            width: 2.0, 
          ),
        ),
      ),
      tabs: const [
        Tab(text: "Đang xử lý"),
        Tab(text: "Lịch sử"),
        Tab(text: "Đánh giá"),
        Tab(text: "Đơn nháp"),
      ],
    );
  }
}
