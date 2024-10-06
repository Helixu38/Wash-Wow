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
          _buildResultTab(), // Rating tab
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
                    shape: const StadiumBorder(), // Rounded stadium shape
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10), // Padding for the button
                    backgroundColor: const Color.fromRGBO(
                        4, 90, 208, 1), // Button background color
                  ),
                  child: Text(
                    'Chọn dịch vụ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
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

                      print(widget.laundryShopId);
                      print(
                          "Service ID : $selectedServiceId , Service Name : $selectedServiceName");
                      print(
                          "Booking Items: ${bookingItems.map((item) => item.servicesId).toList()}");

                      _nextPage(); // Move to the next tab
                    },
                    child: const Text('Select'),
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
            const Text(
              'Select Pickup Time',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Display selected date and time
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200], // Light grey background
                borderRadius: BorderRadius.circular(8), // Rounded corners
                border: Border.all(color: Colors.grey, width: 1), // Border
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    selectedDate != null && selectedTime != null
                        ? 'Selected Pickup Time: ${formatPickupDateTime(selectedDate!, selectedTime!)}'
                        : 'No time selected',
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Please select a date and time',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Button to select date
            ElevatedButton(
              onPressed: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: selectedDate ?? DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 30)),
                  builder: (BuildContext context, Widget? child) {
                    return Theme(
                      data: ThemeData.light().copyWith(
                        primaryColor: Colors
                            .blue, // Customize the color of the date picker
                        colorScheme: ColorScheme.light(primary: Colors.blue),
                        buttonTheme: const ButtonThemeData(
                            textTheme: ButtonTextTheme.primary),
                      ),
                      child: child!,
                    );
                  },
                );

                if (pickedDate != null) {
                  setState(() {
                    selectedDate = pickedDate;
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)), // Rounded button
              ),
              child: const Text('Select Date'),
            ),

            const SizedBox(height: 10),

            // Button to select time
            ElevatedButton(
              onPressed: () async {
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: selectedTime ?? TimeOfDay.now(),
                  builder: (BuildContext context, Widget? child) {
                    return Theme(
                      data: ThemeData.light().copyWith(
                        primaryColor: Colors
                            .blue, // Customize the color of the time picker
                        colorScheme: ColorScheme.light(primary: Colors.blue),
                        buttonTheme: const ButtonThemeData(
                            textTheme: ButtonTextTheme.primary),
                      ),
                      child: child!,
                    );
                  },
                );

                if (pickedTime != null) {
                  setState(() {
                    selectedTime = pickedTime;
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)), // Rounded button
              ),
              child: const Text('Select Time'),
            ),

            const SizedBox(height: 20),

            // Proceed to confirmation step
            ElevatedButton(
              onPressed: () {
                if (selectedDate != null && selectedTime != null) {
                  // Combine selected date and time
                  DateTime pickupDateTime = DateTime(
                    selectedDate!.year,
                    selectedDate!.month,
                    selectedDate!.day,
                    selectedTime!.hour,
                    selectedTime!.minute,
                  );

                  // You can now use `pickupDateTime` for backend confirmation
                  // Example: print(pickupDateTime); or send it to your backend

                  _nextPage(); // Proceed to confirmation step
                } else {
                  // Show a message if date or time is not selected
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Please select both date and time')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)), // Rounded button
              ),
              child: const Text('Next: Xác nhận'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmationTab() {
    double? laundryWeight = 10;
    String notes = "";
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
                'Confirm Booking',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Display Selected Pickup Time
              Text(
                'Pickup Time:',
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
                      : 'Not selected',
                  style: const TextStyle(fontSize: 16),
                ),
              ),

              const SizedBox(height: 20),

// Display Laundry Shop Name
              Text(
                'Laundry Shop:',
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
                      : 'Not selected', // Replace with actual shop name
                  style: const TextStyle(fontSize: 16),
                ),
              ),

              const SizedBox(height: 20),

// Display Selected Service Name
              Text(
                'Service:',
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
                      'Not selected', // Replace with actual service name
                  style: const TextStyle(fontSize: 16),
                ),
              ),

              const SizedBox(height: 20),

              const SizedBox(height: 20),

              Text(
                'Laundry Weight',
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
                    laundryWeight = double.tryParse(
                        value); // Replace with your variable to hold the weight
                  },
                ),
              ),

              const SizedBox(height: 20),

              // Input Field for Notes
              Text(
                'Notes',
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
                    hintText: 'Enter your notes here.',
                    hintStyle: TextStyle(
                        color: const Color.fromRGBO(208, 207, 207, 1)),
                    contentPadding: const EdgeInsets.all(10),
                  ),
                  onChanged: (value) {
                    // Save the input value for notes
                    notes =
                        value; // Replace with your variable to hold the notes
                  },
                ),
              ),

              const SizedBox(height: 20),

              const SizedBox(height: 20),

              // Confirm & Proceed Button
              ElevatedButton(
                onPressed: () async {
                  if (laundryWeight != null && laundryWeight! > 0) {
                    print(
                        "Pick Up Date : $selectedDate \n Pick Up Time : $selectedTime \n Selected Service  : $selectedServiceName \n Selected Serivce ID: $selectedServiceId \n Selected Shop ID : $selectedShopID \n Selected Shop : $selectedShopName \n Note: $notes \n Laundry Weight : $laundryWeight");
                    bool? isSuccess = await authService.booking(
                        laundryWeight,
                        notes,
                        formatPickupDateTime(selectedDate!, selectedTime!),
                        selectedShopID,
                        selectedVoucherID,
                        bookingItems);

                    setState(() {
                      isBookingSuccess = isSuccess; // Update the booking status
                    });

                    _nextPage(); // Navigate to the result tab
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Please enter a valid laundry weight')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text('Confirm & Next'),
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
                  : const CircularProgressIndicator(), // Show a loading indicator before the result
        ],
      ),
    );
  }
}
