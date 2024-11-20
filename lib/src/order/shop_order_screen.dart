import 'package:flutter/material.dart';
import 'package:wash_wow/src/order/shop_booking_screen.dart';
import 'package:wash_wow/src/service/services_screen.dart';
import 'package:wash_wow/src/utility/fetch_service.dart';

class ShopOrderScreen extends StatefulWidget {
  const ShopOrderScreen({super.key});

  @override
  State<ShopOrderScreen> createState() => _ShopOrderScreenState();
}

class _ShopOrderScreenState extends State<ShopOrderScreen> {
  String? selectedShopId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Column(
        children: [
          buildShopCard(1, 40),
        ],
      ),
    );
  }

  PreferredSizeWidget buildAppBar() {
    return PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: AppBar(
          title: Text(
            "Cửa hàng",
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
          shape: ServicesScreen.roundedRectangleBorder,
          iconTheme: IconThemeData(color: Colors.white),
        ));
  }

  Widget buildShopCard(int pageNo, int pageSize) {
    return FutureBuilder<List<dynamic>>(
      future: fetchLandryShopByOwnerID(pageNo, pageSize),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          List<dynamic> shops = snapshot.data!;

          return Expanded(
            child: ListView.builder(
              itemCount: shops.length,
              itemBuilder: (context, index) {
                var shop = shops[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 5, // Adds shadow
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        10), // Optional: make the card's edges rounded
                  ),
                  child: ListTile(
                    title: Text(shop['name'],
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    subtitle: Text('Address: ${shop['address']}'),
                    trailing: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedShopId = shop['id'];
                        });

                        nextScreen(selectedShopId);
                      },
                      child: const Text('Select'),
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return const Center(child: Text('No services found'));
        }
      },
    );
  }

  void nextScreen(String? shopID) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ShopBookingsScreen(shopID: shopID)),
    );
  }
}
