import 'dart:async';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:wash_wow/src/utility/auth_service.dart';
import 'package:wash_wow/src/utility/fetch_service.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen>
    with SingleTickerProviderStateMixin {
  final AuthService authService = AuthService('https://washwowbe.onrender.com');
  Timer? _paymentStatusTimer;
  String? paymentStatus; // Track the current payment status
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

// Function to check the payment status every 5 seconds
  void checkPaymentStatus(String bookingId, int paymentId) async {
    try {
      final paymentResponse = await fetchPayOS(paymentId.toString());

      if (paymentResponse['status'] == "PAID") {
        setState(() {
          paymentStatus = "PAID";
        });

        _paymentStatusTimer?.cancel();

        // Call changePaymentStatus to update the backend
        bool updateSuccess =
            await authService.changePaymentStatus(paymentId, bookingId, 0);

        if (updateSuccess) {
          // Close the dialog when payment status is updated successfully
          if (context.mounted) {
            Navigator.of(context).pop();
          }

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text("Thanh Toán Thành Công!")),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed to update payment status.")),
          );
        }
      }
    } catch (error) {
      print('Error checking payment status: $error');
    }
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
                buildShopCard(),
                Center(child: Text("Rate")),
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
          "Orders",
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
        Tab(text: "History"),
        Tab(text: "Review"),
      ],
    );
  }

  Widget buildShopCard() {
    return FutureBuilder<List<dynamic>>(
      future: fetchBookingHistoryById(),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Lỗi: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          List<dynamic> bookings = snapshot.data!;

          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              var booking = bookings[index];
              bool isConfirmed = booking['status'] == 'CONFIRMED';
              return InkWell(
                onTap: isConfirmed
                    ? () async {
                        String bookingId = booking['bookingId'];
                        int paymentId = booking['paymentId'];
                        print("Payment ID: $paymentId");

                        try {
                          final paymentResponse =
                              await authService.pay(bookingId, paymentId);

                          if (paymentResponse != null &&
                              paymentResponse['qrCode'] != null) {
                            final String qrCodeData = paymentResponse['qrCode'];

                            // Show QR code dialog and start status check
                            showDialog(
                              context: context,
                              builder: (context) {
                                return StatefulBuilder(
                                  builder: (context, setState) {
                                    return AlertDialog(
                                      title: const Text(
                                          "Scan the QR for payment"),
                                      content: Container(
                                        width: 200.0,
                                        height: 200.0,
                                        child: paymentStatus == "PAID"
                                            ? const Text(
                                                "Payment successfully!",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold))
                                            : QrImageView(
                                                data: qrCodeData,
                                                version: QrVersions.auto,
                                                size: 200.0,
                                              ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            _paymentStatusTimer?.cancel();
                                          },
                                          child: const Text("Close"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            );

                            // Start a timer to check the payment status every 5 seconds
                            _paymentStatusTimer = Timer.periodic(
                              const Duration(seconds: 5),
                              (timer) =>
                                  checkPaymentStatus(bookingId, paymentId),
                            );
                          }
                        } catch (error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Payment error: $error')),
                          );
                        }
                      }
                    : null,
                child: Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ID: ${booking['bookingId']}',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text('Date created: ${booking['createdAt']}'),
                        Text('Status: ${booking['status']}'),
                        Text('Price: ${booking['totalPrice']} VND'),
                        Text('Weight: ${booking['totalWeight']} kg'),
                        const SizedBox(height: 8),
                        Text('Service:',
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        ...booking['bookingItems'].map<Widget>((item) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Service name: ${item['serviceName']}'),
                                Text('Price per kg: ${item['pricePerKg']} VND'),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return const Center(child: Text('No order found'));
        }
      },
    );
  }
}
