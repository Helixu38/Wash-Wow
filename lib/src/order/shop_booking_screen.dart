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
  final AuthService authService = AuthService('https://washwowbe.onrender.com');
  List<dynamic> services = [];
  List<dynamic> bookings = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchServices(); // Fetch services initially
    fetchBookings();
  }

  void fetchServices() async {
    final fetchedServices =
        await fetchLandryShopServices(widget.shopID.toString(), 1, 20);
    setState(() {
      services = fetchedServices; // Update the state with fetched services
    });
  }

  void fetchBookings() async {
    final fetchedBookings =
        await fetchBookingByShopID(widget.shopID.toString(), 1, 30);
    setState(() {
      bookings = fetchedBookings; // Update the state with fetched services
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
                buildShopBookingCard(),
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

  Widget buildShopBookingCard() {
    if (bookings.isEmpty) {
      return const Center(child: Text('No bookings found'));
    }

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
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Thời gian nhận: ${booking['shopPickupTime']}'),
                Row(
                  children: [
                    const Text('Trạng thái: '),
                    Text(
                      booking['status'] == 'PENDING'
                          ? 'Đang chờ'
                          : booking['status'] == 'COMPLETED'
                              ? 'Hoàn thành'
                              : booking['status'] == 'CANCELED'
                                  ? 'Đã hủy'
                                  : booking['status'] == 'CONFIRMED'
                                      ? 'Đã xác nhận'
                                      : booking[
                                          'status'], // Fallback to original status if it doesn't match
                      style: TextStyle(
                        color: booking['status'] == 'PENDING'
                            ? Colors.orange
                            : booking['status'] == 'COMPLETED'
                                ? Colors.green
                                : booking['status'] == 'CANCELED'
                                    ? Colors.red
                                    : booking['status'] == 'CONFIRMED'
                                        ? Theme.of(context).primaryColor
                                        : Colors.black,
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
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    child: Container(
                      width: 500,
                      height: 400,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              icon:
                                  const Icon(Icons.close, color: Colors.black),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                          Text(
                            'Chi tiết', // Booking Details
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Khách hàng: ${booking['customerName']}', // Customer
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Thời gian lấy hàng: ${booking['shopPickupTime']}', // Pickup Time
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              const Text('Trạng thái: '), // Status Label
                              Text(
                                booking['status'] == 'PENDING'
                                    ? 'Đang chờ' // Pending
                                    : booking['status'] == 'COMPLETED'
                                        ? 'Hoàn thành' // Completed
                                        : booking['status'] == 'CANCELED'
                                            ? 'Đã hủy' // Canceled
                                            : booking['status'] == 'CONFIRMED'
                                                ? 'Đã xác nhận' // Confirmed
                                                : booking[
                                                    'status'], // Fallback to original status if it doesn't match
                                style: TextStyle(
                                  color: booking['status'] == 'PENDING'
                                      ? Colors.orange
                                      : booking['status'] == 'COMPLETED'
                                          ? Colors.green
                                          : booking['status'] == 'CANCELED'
                                              ? Colors.red
                                              : booking['status'] == 'CONFIRMED'
                                                  ? Theme.of(context)
                                                      .primaryColor
                                                  : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () async {
                                  String? bookingID = booking['id'];
                                  String currentStatus = booking[
                                      'status']; // Get the current status

                                  // Check if the current status allows changing to "ACCEPTED"
                                  if (currentStatus == 'COMPLETED' ||
                                      currentStatus == 'CANCELED') {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Row(
                                          children: [
                                            Icon(Icons.error_outline,
                                                color: Colors.white),
                                            SizedBox(width: 10),
                                            Text(
                                                "Không thể thay đổi trạng thái từ '$currentStatus' \n sang 'ĐƯỢC CHẤP NHẬN'"), // Cannot change status from 'currentStatus' to 'ACCEPTED'
                                          ],
                                        ),
                                        backgroundColor: Colors.red,
                                        duration: const Duration(
                                            seconds:
                                                2), // Duration of the toast
                                      ),
                                    );
                                    return; // Exit early to prevent further actions
                                  }

                                  bool success = await authService
                                      .changeBookingStatus(bookingID, "1");
                                  if (success) {
                                    print(
                                        'Trạng thái đặt hàng đã được cập nhật thành công.'); // Booking status updated successfully.
                                    Navigator.of(context).pop();
                                    fetchBookings(); // Refresh bookings
                                  } else {
                                    print(
                                        'Cập nhật trạng thái đặt hàng không thành công.'); // Failed to update booking status.
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Row(
                                          children: [
                                            Icon(Icons.error_outline,
                                                color: Colors.white),
                                            SizedBox(width: 10),
                                            Text(
                                                "Cập nhật trạng thái đặt hàng không thành công."), // Failed to update booking status.
                                          ],
                                        ),
                                        backgroundColor: Colors.red,
                                        duration: const Duration(
                                            seconds:
                                                2), // Duration of the toast
                                      ),
                                    );
                                  }
                                },
                                child: const Text(
                                  'Chấp nhận', // Accept
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () async {
                                  String? bookingID = booking['id'];
                                  String currentStatus = booking[
                                      'status']; // Get the current status

                                  // Check if the current status allows changing to "CANCELED"
                                  if (currentStatus == 'COMPLETED' ||
                                      currentStatus == 'CANCELED') {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Row(
                                          children: [
                                            Icon(Icons.error_outline,
                                                color: Colors.white),
                                            SizedBox(width: 10),
                                            Text(
                                                "Không thể thay đổi trạng thái từ '$currentStatus' \n sang 'ĐÃ HỦY'"), // Cannot change status from 'currentStatus' to 'CANCELED'
                                          ],
                                        ),
                                        backgroundColor: Colors.red,
                                        duration: const Duration(
                                            seconds:
                                                2), // Duration of the toast
                                      ),
                                    );
                                    return; // Exit early to prevent further actions
                                  }

                                  bool statusUpdated = await authService
                                      .changeBookingStatus(bookingID, "4");
                                  if (!statusUpdated) {
                                    print(
                                        'Cập nhật trạng thái đặt hàng không thành công.'); // Failed to update booking status.
                                    return;
                                  }
                                  bool bookingDeleted = await authService
                                      .deleteBooking(bookingID);
                                  if (!bookingDeleted) {
                                    print(
                                        'Xóa đặt hàng không thành công.'); // Failed to delete booking.
                                    return;
                                  }
                                  print(
                                      'Trạng thái đặt hàng đã được cập nhật và xóa thành công.'); // Booking status updated and deleted successfully.
                                  Navigator.of(context).pop();
                                  fetchBookings();
                                },
                                child: const Text(
                                  'Từ chối', // Reject
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
            },
          ),
        );
      },
    );
  }
}
