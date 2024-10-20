import 'package:flutter/material.dart';
import 'package:wash_wow/src/service/services_screen.dart';
import 'package:wash_wow/src/utility/auth_service.dart';
import 'package:wash_wow/src/utility/fetch_service.dart';

class ShopBookingsScreen extends StatefulWidget {
  final String? shopID;
  const ShopBookingsScreen({super.key, required this.shopID});

  @override
  State<ShopBookingsScreen> createState() => _ShopBookingScreenState();
}

class _ShopBookingScreenState extends State<ShopBookingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final AuthService authService = AuthService('https://10.0.2.2:7276');
  List<dynamic> services = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchServices(); // Fetch services initially
  }

  void fetchServices() async {
    final fetchedServices =
        await fetchLandryShopServices(widget.shopID.toString(), 1, 20);
    setState(() {
      services = fetchedServices; // Update the state with fetched services
    });
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
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: "Dịch vụ"),
              Tab(text: "Đơn hàng"),
            ],
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Theme.of(context).primaryColor,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // First tab for "Dịch vụ"
                buildServiceTab(),
                // Second tab for "Đơn hàng"
                buildShopBookingCard(widget.shopID.toString(), 1, 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(80.0),
      child: AppBar(
        title: const Text(
          "Cửa hàng",
          style: TextStyle(
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        shape: ServicesScreen.roundedRectangleBorder,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
    );
  }

  Widget buildServiceTab() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController priceController = TextEditingController();
    final TextEditingController weightController = TextEditingController();

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: services.length,
            itemBuilder: (context, index) {
              var service = services[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  title: Text(service['name'],
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  subtitle: Text('Price Per Kg: ${service['pricePerKg']}'),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: FloatingActionButton(
            onPressed: () {
              _showAddServiceDialog(context, nameController,
                  descriptionController, priceController, weightController);
            },
            backgroundColor: Theme.of(context).primaryColor,
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }

  void _showAddServiceDialog(
    BuildContext context,
    TextEditingController nameController,
    TextEditingController descriptionController,
    TextEditingController priceController,
    TextEditingController weightController,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 1,
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Add New Service',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Service Name',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color.fromRGBO(4, 90, 208, 1),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      cursorColor: const Color.fromRGBO(4, 90, 208, 1),
                      controller: nameController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter service name',
                        hintStyle: TextStyle(
                          color: const Color.fromRGBO(208, 207, 207, 1),
                        ),
                        contentPadding: const EdgeInsets.all(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Description',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color.fromRGBO(4, 90, 208, 1),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      cursorColor: const Color.fromRGBO(4, 90, 208, 1),
                      controller: descriptionController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter description',
                        hintStyle: TextStyle(
                          color: const Color.fromRGBO(208, 207, 207, 1),
                        ),
                        contentPadding: const EdgeInsets.all(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Price Per Kg',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color.fromRGBO(4, 90, 208, 1),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      cursorColor: const Color.fromRGBO(4, 90, 208, 1),
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter price per Kg',
                        hintStyle: TextStyle(
                          color: const Color.fromRGBO(208, 207, 207, 1),
                        ),
                        contentPadding: const EdgeInsets.all(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Cân nặng tối thiểu',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color.fromRGBO(4, 90, 208, 1),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      cursorColor: const Color.fromRGBO(4, 90, 208, 1),
                      controller: weightController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter price per Kg',
                        hintStyle: TextStyle(
                          color: const Color.fromRGBO(208, 207, 207, 1),
                        ),
                        contentPadding: const EdgeInsets.all(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Adding action buttons at the bottom
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          backgroundColor: const Color.fromRGBO(4, 90, 208, 1),
                          shape: const StadiumBorder(),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          double? price = double.tryParse(priceController.text);
                          int? weight = int.tryParse(weightController.text);

                          bool? isSuccess = await authService.postShopService(
                            nameController.text,
                            descriptionController.text,
                            price,
                            widget.shopID,
                            weight,
                          );
                          if (isSuccess) {
                            // After adding the service, fetch the updated list
                            fetchServices(); // Refresh the service list
                            Navigator.of(context).pop();
                          } else {
                            // Handle error (e.g., show a message)
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          shape: StadiumBorder(),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          backgroundColor: const Color.fromRGBO(4, 90, 208, 1),
                        ),
                        child: const Text(
                          'Add Service',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildShopBookingCard(String shopId, int pageNo, int pageSize) {
    return FutureBuilder<List<dynamic>>(
      future: fetchBookingByShopID(
          shopId, pageNo, pageSize), // Assuming you have this function
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          List<dynamic> bookings = snapshot.data!;

          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              var booking = bookings[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                    title: Text(
                      booking['customerName'],
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Pickup Time: ${booking['shopPickupTime']}'),
                        Row(
                          children: [
                            const Text(
                                'Status: '), // The label text stays unchanged
                            Text(
                              booking['status'],
                              style: TextStyle(
                                color: booking['status'] == 'PENDING'
                                    ? Colors.orange
                                    : booking['status'] == 'COMPLETED'
                                        ? Colors.green
                                        : booking['status'] == 'CANCELED'
                                            ? Colors.red
                                            : booking['status'] == 'CONFIRMED'
                                                ? Theme.of(context).primaryColor
                                                : Colors
                                                    .black, // Default color for other statuses
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    onTap: () {
                      print('Booking clicked: ${booking['id']}');
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(16), // Rounded corners
                            ),
                            elevation:
                                4, // Slight elevation for a shadow effect
                            child: Container(
                              width: 400, // Set a custom width
                              height: 300,
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Close button (X) at the top right
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: IconButton(
                                      icon: const Icon(Icons.close,
                                          color: Colors.black),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ),
                                  Text(
                                    'Booking Details',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text('Customer: ${booking['customerName']}',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black54)),
                                  Text(
                                      'Pickup Time: ${booking['shopPickupTime']}',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black54)),
                                  Text('Status: ${booking['status']}',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black54)),
                                  const SizedBox(height: 24),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors
                                              .green, // Accept button color
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 10),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        onPressed: () async {
                                          // Handle Accept action
                                          String? bookingID = booking['id'];
                                          bool success = await authService
                                              .changeBookingStatus(
                                                  bookingID, "1");
                                          if (success) {
                                            // Handle success (e.g., show a message or update the UI)
                                            print(
                                                'Booking status updated successfully.');
                                            Navigator.of(context).pop();
                                          } else {
                                            // Handle failure (e.g., show an error message)
                                            print(
                                                'Failed to update booking status.');
                                          }
                                        },
                                        child: const Text(
                                          'Accept',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Colors.red, // Reject button color
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 10),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        onPressed: () {
                                          // Handle Reject action
                                          // Implement your reject logic here
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text(
                                          'Reject',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }),
              );
            },
          );
        } else {
          return const Center(child: Text('No bookings found'));
        }
      },
    );
  }
}
