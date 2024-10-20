import 'package:flutter/material.dart';
import 'package:wash_wow/src/utility/auth_service.dart';
import 'package:wash_wow/src/utility/fetch_service.dart';
import 'package:wash_wow/src/utility/model/store_details.dart'; // Assuming this is where your fetchLaundryShopByID function is

class BookingScreen extends StatefulWidget {
  final String serviceId, laundryShopId;
  const BookingScreen(
      {super.key, required this.serviceId, required this.laundryShopId});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final PageController _pageController = PageController(initialPage: 0);
  String? selectedServiceId;
  String selectedShopName = '';
  String selectedShopID = '';
  String? selectedServiceName;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String selectedVoucherID = '';
  List<BookingItem> bookingItems = [];
  bool? isBookingSuccess;
  final AuthService authService = AuthService('https://10.0.2.2:7276');
  double? laundryWeight;
  String notes = "";

  String formatPickupDateTime(DateTime date, TimeOfDay time) {
    String formattedDate = "${date.year.toString().padLeft(4, '0')}-"
        "${date.month.toString().padLeft(2, '0')}-"
        "${date.day.toString().padLeft(2, '0')}";

    String formattedTime = "${time.hour.toString().padLeft(2, '0')}:"
        "${time.minute.toString().padLeft(2, '0')}";

    return "$formattedDate $formattedTime";
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this); // 5 steps in total
  }

  void _nextPage() {
    if (_tabController.index < 4) {
      // Prevent going beyond the last page
      _tabController.animateTo(_tabController.index + 1);
      _pageController.animateToPage(
        _tabController.index + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Process'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Thông tin Shop'), // Shop Info
            Tab(text: 'Dịch vụ'), // Services
            Tab(text: 'Đặt lịch'), // Set Pickup Time
            Tab(text: 'Thông Tin'), // Confirmation
            Tab(text: 'Xác nhận'), // Rating
            // Tab(text: 'Thanh toán'),
          ],
          onTap: (index) {}, // Disable direct tab clicks by ignoring tap events
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        physics:
            const NeverScrollableScrollPhysics(), // Prevent swiping between tabs
        children: [
          _buildShopInfo(widget.laundryShopId), // Shop Info tab
          _buildServicesTab(widget.laundryShopId), // Services tab
          _buildPickupTimeTab(), // Set Pickup Time tab
          _buildConfirmationTab(), // Confirmation tab
          _buildResultTab(),
          // _buildPaymentTab(), // Rating tab
        ],
      ),
    );
  }

  // Tab 1: Shop Info
  Widget _buildShopInfo(String laundryShopID) {
    return FutureBuilder<Map<String, dynamic>>(
      future: fetchLaundryShopByID(laundryShopID),
      builder:
          (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          var shopData = snapshot.data!;
          selectedShopName = shopData['name'];
          selectedShopID = shopData['id'];
          print(selectedShopName);
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Shop Name: ${shopData['name']}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                Text('Address: ${shopData['address']}',
                    style: const TextStyle(fontSize: 16)),
                Text('Phone: ${shopData['phoneContact']}',
                    style: const TextStyle(fontSize: 16)),
                Text('Total Machines: ${shopData['totalMachines']}',
                    style: const TextStyle(fontSize: 16)),
                Text('Status: ${shopData['status']}',
                    style: const TextStyle(fontSize: 16)),
                Text('Opening Hour: ${shopData['openingHour']}',
                    style: const TextStyle(fontSize: 16)),
                Text('Closing Hour: ${shopData['closingHour']}',
                    style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _nextPage, // Move to the next tab
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          8), // Adjust the radius as needed
                      side: BorderSide(color: Theme.of(context).primaryColor),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                    backgroundColor: Colors.white,
                  ),
                  child: Text(
                    'Chọn dịch vụ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Center(child: Text('No data found'));
        }
      },
    );
  }

  // Tab 2: Services
  Widget _buildServicesTab(String laundryShopID) {
    return FutureBuilder<List<dynamic>>(
      future: fetchLandryShopServices(laundryShopID, 1, 10),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          List<dynamic> services = snapshot.data!;

          return ListView.builder(
            itemCount: services.length,
            itemBuilder: (context, index) {
              var service = services[index];
              return Card(
                shadowColor: Colors.black,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(service['name'],
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  subtitle: Text(
                      'Price: ${service['pricePerKg']}'), // Adjust based on your service fields
                  trailing: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedServiceId = service['id'];
                        selectedServiceName = service['name'];

                        // Add the selected service to booking items
                        bookingItems
                            .add(BookingItem(servicesId: selectedServiceId!));
                      });

                      // print(widget.laundryShopId);
                      print(
                          "Service ID : $selectedServiceId , Service Name : $selectedServiceName");
                      print(
                          "Booking Items: ${bookingItems.map((item) => item.servicesId).toList()}");

                      _nextPage(); // Move to the next tab
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            16), // Adjust the radius as needed
                        side: BorderSide(color: Theme.of(context).primaryColor),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 10),
                      backgroundColor: Colors.white,
                    ),
                    child: const Text('Chọn'),
                  ),
                ),
              );
            },
          );
        } else {
          return const Center(child: Text('No services found'));
        }
      },
    );
  }

// Tab 3: Set Pickup Time
  Widget _buildPickupTimeTab() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0), // Add padding around the content
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                dateTimePickerWidget(context);
              },
              child: Text('Pick Date-Time'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmationTab() {
    return Center(
      child: SingleChildScrollView(
        // Wrap the content in a SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Add padding around the content
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Xác nhận thông tin',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF045AD1)),
              ),
              const SizedBox(height: 20),

              // Display Selected Pickup Time
              Text(
                'Thời gian nhận hàng',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: const Color.fromRGBO(4, 90, 208, 1),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  selectedDate != null && selectedTime != null
                      ? formatPickupDateTime(selectedDate!, selectedTime!)
                      : 'Chưa chọn thời gian',
                  style: const TextStyle(fontSize: 16),
                ),
              ),

              const SizedBox(height: 20),

// Display Laundry Shop Name
              Text(
                'Tên tiệm giặt',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: const Color.fromRGBO(4, 90, 208, 1),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  selectedShopName.isNotEmpty
                      ? selectedShopName
                      : 'Chưa chọn', // Replace with actual shop name
                  style: const TextStyle(fontSize: 16),
                ),
              ),

              const SizedBox(height: 20),

// Display Selected Service Name
              Text(
                'Dịch vụ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: const Color.fromRGBO(4, 90, 208, 1),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  selectedServiceName ??
                      'Chưa chọn', // Replace with actual service name
                  style: const TextStyle(fontSize: 16),
                ),
              ),

              const SizedBox(height: 20),

              const SizedBox(height: 20),

              Text(
                'Trọng lượng đồ giặt',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: const Color.fromRGBO(4, 90, 208, 1),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  keyboardType: TextInputType.number,
                  cursorColor: const Color.fromRGBO(4, 90, 208, 1),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Nhập khối lượng giặt của bạn (kg).',
                    hintStyle: TextStyle(
                        color: const Color.fromRGBO(208, 207, 207, 1)),
                    contentPadding: const EdgeInsets.all(10),
                  ),
                  onChanged: (value) {
                    // Save the input value for laundry weight
                    setState(() {
                      laundryWeight = double.tryParse(value);
                    });
                  },
                ),
              ),

              const SizedBox(height: 20),

              // Input Field for Notes
              Text(
                'Ghi chú',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: const Color.fromRGBO(4, 90, 208, 1),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  maxLines: 3,
                  cursorColor: const Color.fromRGBO(4, 90, 208, 1),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Nhập ghi chú của bạn.',
                    hintStyle: TextStyle(
                        color: const Color.fromRGBO(208, 207, 207, 1)),
                    contentPadding: const EdgeInsets.all(10),
                  ),
                  onChanged: (value) {
                    // Save the input value for notes
                    setState(() {
                      notes = value;
                    });
                  },
                ),
              ),

              const SizedBox(height: 20),

              const SizedBox(height: 20),

              // Confirm & Proceed Button
              ElevatedButton(
                onPressed: () async {
                  if (laundryWeight != null &&
                      laundryWeight! > 0 &&
                      selectedDate != null &&
                      selectedTime != null) {
                    TimeOfDay adjustedTime = TimeOfDay(
                      hour: (selectedTime!.hour + 2) %
                          24, // Ensuring the hour wraps around after 24
                      minute: selectedTime!.minute,
                    );
                    print(
                        "Pick Up Date : $selectedDate \n Pick Up Time : $selectedTime \n Pick Up Time : $adjustedTime \n Selected Service  : $selectedServiceName \n Selected Serivce ID: $selectedServiceId \n Selected Shop ID : $selectedShopID \n Selected Shop : $selectedShopName \n Note: $notes \n Laundry Weight : $laundryWeight");
                    bool? isSuccess = await authService.booking(
                        laundryWeight,
                        notes,
                        formatPickupDateTime(selectedDate!, selectedTime!),
                        formatPickupDateTime(selectedDate!, adjustedTime),
                        selectedShopID,
                        selectedVoucherID,
                        bookingItems);

                    setState(() {
                      isBookingSuccess = isSuccess; // Update the booking status
                    });

                    _nextPage(); // Navigate to the result tab
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            Icon(Icons.error_outline, color: Colors.white),
                            SizedBox(width: 10),
                            Text("Xin hãy điền hết thông tin"),
                          ],
                        ),
                        backgroundColor: Colors.red,
                        duration:
                            const Duration(seconds: 2), // Duration of the toast
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(8), // Adjust the radius as needed
                    side: BorderSide(color: Theme.of(context).primaryColor),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  backgroundColor: Colors.white,
                ),
                child: const Text('Xác nhận'),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Tab 5: Success/Failure Tab
  Widget _buildResultTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          isBookingSuccess == true
              ? const Text(
                  'CẢM ƠN BẠN ĐÃ SỬ DỤNG DỊCH VỤ',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF045AD1),
                  ),
                  textAlign: TextAlign.center,
                )
              : isBookingSuccess == false
                  ? const Text(
                      'Booking Failed!',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    )
                  : const CircularProgressIndicator(),
          // ElevatedButton(
          //   onPressed: () async {
          //     if (laundryWeight != null &&
          //         laundryWeight! > 0 &&
          //         selectedDate != null &&
          //         selectedTime != null) {
          //       bool? isSuccess = await authService.pay(

          //           );

          //       setState(() {
          //         isBookingSuccess = isSuccess; // Update the booking status
          //       });

          //       _nextPage(); // Navigate to the result tab
          //     }
          //   },
          //   style: ElevatedButton.styleFrom(
          //     shape: RoundedRectangleBorder(
          //       borderRadius:
          //           BorderRadius.circular(8), // Adjust the radius as needed
          //       side: BorderSide(color: Theme.of(context).primaryColor),
          //     ),
          //     padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          //     backgroundColor: Colors.white,
          //   ),
          //   child: const Text('Thanh toán'),
          // ) // Show a loading indicator before the result
        ],
      ),
    );
  }

  //Tab 6: Payment Tab
  // Widget _buildPaymentTab() {
  //   return Center();
  // }
}
