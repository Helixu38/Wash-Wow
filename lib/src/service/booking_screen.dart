import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wash_wow/src/utility/auth_service.dart';
import 'package:wash_wow/src/utility/fetch_service.dart';
import 'package:wash_wow/src/utility/model/store_details.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:qr_flutter/qr_flutter.dart';

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
  String? customerPickupTime = "";
  String? shopPickUpTime = "";
  String? bookingId;
  int? paymentId;
  bool _isPaymentComplete = false;

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
    _tabController = TabController(length: 6, vsync: this); // 5 steps in total
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
          // _buildPaymentTab(),
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
            Text(
              "Thời gian cửa hàng nhận",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: const Color.fromRGBO(4, 90, 208, 1),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                dateTimePickerWidget(context, (selectedDateTime) {
                  setState(() {
                    shopPickUpTime = selectedDateTime;
                  });
                });
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
              child: Row(
                mainAxisSize: MainAxisSize.min, // Keeps button size compact
                children: [
                  Icon(Icons.calendar_today,
                      color: Theme.of(context).primaryColor), // Calendar Icon
                  SizedBox(width: 10), // Spacing between icon and text
                  Text(
                    shopPickUpTime != null ? shopPickUpTime! : 'Pick Date-Time',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor), // Text color
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Thời gian khách nhận hàng ",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: const Color.fromRGBO(4, 90, 208, 1),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                dateTimePickerWidget(context, (selectedDateTime) {
                  setState(() {
                    customerPickupTime = selectedDateTime;
                  });
                });
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
              child: Row(
                mainAxisSize: MainAxisSize.min, // Keeps button size compact
                children: [
                  Icon(Icons.calendar_today,
                      color: Theme.of(context).primaryColor), // Calendar Icon
                  SizedBox(width: 10), // Spacing between icon and text
                  Text(
                    customerPickupTime != null
                        ? customerPickupTime!
                        : 'Pick Date-Time',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor), // Text color
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            ElevatedButton(
              onPressed: () {
                if (customerPickupTime != null && shopPickUpTime != null) {
                  // Parse both times to DateTime objects
                  DateTime customerTime =
                      DateFormat('yyyy-MM-dd-HH:mm').parse(customerPickupTime!);
                  DateTime shopTime =
                      DateFormat('yyyy-MM-dd-HH:mm').parse(shopPickUpTime!);
                  print(
                      "Customer time : $customerTime \n Shop time : $shopTime");

                  // Check if the customer time is at least 2 hours later than shop time
                  if (customerTime.isBefore(shopTime.add(Duration(hours: 2)))) {
                    // Show an error message if validation fails
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            Icon(Icons.error_outline, color: Colors.white),
                            SizedBox(width: 10),
                            Text(
                                "Khách nhận hàng phải muộn hơn 2 tiếng so với \nthời gian cửa hàng nhận."),
                          ],
                        ),
                        backgroundColor: Colors.red,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  } else {
                    _nextPage(); // Proceed to confirmation step
                  }
                } else {
                  // Show a message if either date or time is not selected
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          Icon(Icons.error_outline, color: Colors.white),
                          SizedBox(width: 10),
                          Text("Xin hãy chọn ngày và thời gian nhận hàng"),
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
              child: const Text('Tiếp Theo'),
            ),
          ],
        ),
      ),
    );
  }

// dateTimePickerWidget function with a callback
  dateTimePickerWidget(
      BuildContext context, Function(String) onDateTimeSelected) {
    return DatePicker.showDatePicker(
      context,
      dateFormat: 'yyyy MMMM dd HH:mm',
      initialDateTime: DateTime.now(),
      minDateTime: DateTime(2000),
      maxDateTime: DateTime(3000),
      onMonthChangeStartWithFirstDate: true,
      onConfirm: (dateTime, List<int> index) {
        String formattedDateTime =
            DateFormat('yyyy-MM-dd-HH:mm').format(dateTime);
        onDateTimeSelected(
            formattedDateTime); // Call the callback to update the correct time
      },
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
                'Thời gian cửa hàng nhận',
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
                  shopPickUpTime ?? 'Chưa chọn thời gian',
                  style: const TextStyle(fontSize: 16),
                ),
              ),

              const SizedBox(height: 20),

              Text(
                'Thời gian nhận hàng ',
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
                  customerPickupTime ?? 'Chưa chọn thời gian',
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
                      shopPickUpTime != null &&
                      customerPickupTime != null) {
                    print(
                        "Shop pick time : $shopPickUpTime \n Customer pick time : $customerPickupTime\n Selected Service  : $selectedServiceName \n Selected Serivce ID: $selectedServiceId \n Selected Shop ID : $selectedShopID \n Selected Shop : $selectedShopName \n Note: $notes \n Laundry Weight : $laundryWeight");
                    Map<String, dynamic>? bookingResult =
                        await authService.booking(
                            laundryWeight,
                            notes,
                            shopPickUpTime,
                            customerPickupTime,
                            selectedShopID,
                            selectedVoucherID,
                            bookingItems);

                    if (bookingResult != null) {
                      // If booking was successful, update the state
                      setState(() {
                        isBookingSuccess = true;

                        print('Booking ID: $bookingId, Payment ID: $paymentId');
                      });

                      // Optionally, you can access bookingId and paymentId
                      bookingId = bookingResult['bookingId'];
                      paymentId = bookingResult[
                          'paymentId']; // Update the booking status
                      _nextPage(); // Navigate to the result tab
                    } else {
                      // Handle the case where booking was not successful
                      setState(() {
                        isBookingSuccess = false; // Update the booking status
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              Icon(Icons.error_outline, color: Colors.white),
                              SizedBox(width: 10),
                              Text("Đặt chỗ không thành công"),
                            ],
                          ),
                          backgroundColor: Colors.red,
                          duration: const Duration(
                              seconds: 2), // Duration of the toast
                        ),
                      );
                    }

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
    // Check if booking was successful and start the timer to navigate
    if (isBookingSuccess == true) {
      // Start a timer to navigate to the next page after 15 seconds
      Future.delayed(const Duration(seconds: 5), () {
        _nextPage(); // Navigate to the next page
      });
    }

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
        ],
      ),
    );
  }

// Tab 6: Payment Tab
  // Widget _buildPaymentTab() {
  //   return FutureBuilder<Map<String, dynamic>?>(
  //     future: authService.pay(bookingId, paymentId),
  //     builder: (context, snapshot) {
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         print("Booking ID : $bookingId \n Payment ID : $paymentId");
  //         return const Center(
  //           child: CircularProgressIndicator(), // Loading indicator
  //         );
  //       } else if (snapshot.hasError) {
  //         return Center(
  //           child: Text("Error: ${snapshot.error}"), // Error handling
  //         );
  //       } else if (snapshot.hasData) {
  //         // Payment response received
  //         final paymentResponse = snapshot.data;
  //         if (paymentResponse != null && paymentResponse['qrCode'] != null) {
  //           // Extract the QR code data from the response
  //           final String qrCodeData = paymentResponse['qrCode'];

  //           // Call changePaymentStatus after 15 seconds to mark payment as complete
  //           Future.delayed(const Duration(seconds: 5), () async {
  //             bool success = await authService.changePaymentStatus(
  //                 paymentId, bookingId, 0);
  //             if (success) {
  //               ScaffoldMessenger.of(context).showSnackBar(
  //                 SnackBar(
  //                   content: Row(
  //                     children: [
  //                       Icon(Icons.check_circle, color: Colors.white),
  //                       SizedBox(width: 10),
  //                       Text(
  //                           'Thanh toán đã được nhận. \nCảm ơn bạn rất nhiều!'),
  //                     ],
  //                   ),
  //                   backgroundColor: Colors.green,
  //                   duration:
  //                       const Duration(seconds: 3), // Duration of the toast
  //                 ),
  //               );
  //             }
  //           });

  //           // Display the QR code and message in the UI
  //           return Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               const Text(
  //                 "Quét mã QR dưới đây để thanh toán:",
  //                 style: TextStyle(
  //                   fontSize: 18.0,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //               const SizedBox(height: 20), // Spacing between text and QR code
  //               QrImageView(
  //                 data: qrCodeData, // Use the QR code data from the backend
  //                 version: QrVersions.auto, // Automatically adjust the version
  //                 size: 200.0, // Set the size of the QR code
  //               ),
  //               const SizedBox(
  //                   height: 20), // Additional spacing after the QR code
  //               const Text(
  //                 "Cảm ơn bạn đã sử dụng dịch vụ!",
  //                 style: TextStyle(
  //                   fontSize: 16.0,
  //                 ),
  //               ),
  //             ],
  //           );
  //         } else {
  //           // Handle the case where payment failed or QR code is missing
  //           return const Center(
  //             child: Text("Thanh toán thất bại hoặc mã QR không khả dụng"),
  //           );
  //         }
  //       } else {
  //         return const Center(
  //           child: Text(
  //               "Có lỗi xảy ra, vui lòng thử lại"), // Fallback error handling
  //         );
  //       }
  //     },
  //   );
  // }
}
