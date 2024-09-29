import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinbox/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wash_wow/src/account/account_screen.dart';
import 'package:wash_wow/src/services/auth_service.dart';
import 'package:wash_wow/src/services/model/store_details.dart';

class ShopRegisterForm extends StatefulWidget {
  const ShopRegisterForm({super.key});

  @override
  State<ShopRegisterForm> createState() => _ShopRegisterFormState();
}

class _ShopRegisterFormState extends State<ShopRegisterForm> {
  final AuthService authService = AuthService('https://10.0.2.2:7276');
  final PageController _pageController = PageController();
  int activeIndex = 0;
  List<bool> isChecked = [false, false, false, false, false, false, false];
  //Image
  List<File> _images = []; // List to hold selected images
  final ImagePicker _picker = ImagePicker();
  // Function to pick images from gallery or camera
  Future<void> _pickImage() async {
    // Check if the current number of images is already 3
    if (_images.length >= 3) {
      _showImageLimitWarning(); // Show warning if more than 3 images are selected
      return;
    }

    // Use the ImagePicker to select a single image
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // Create a File object from the picked file
      File imageFile = File(pickedFile.path);

      // Upload the image to Firebase Storage
      String fileName = Uri.parse(imageFile.path).pathSegments.last;
      Reference storageReference =
          FirebaseStorage.instance.ref().child('images/$fileName');

      // Upload the file
      UploadTask uploadTask = storageReference.putFile(imageFile);
      await uploadTask.whenComplete(() {});

      // Get the download URL
      String downloadUrl = await storageReference.getDownloadURL();

      setState(() {
        // Add the file to _images
        _images.add(imageFile);
        storeDetails.images
            .add(downloadUrl); // Add the download URL to StoreDetails
      });
    }
  }

  StoreDetails storeDetails = StoreDetails(
    storeName: '',
    address: '',
    phoneNumber: '',
    email: '',
    services: [],
    deviceTypes: [],
    images: [],
  );

  List<int> deviceCounts = [0, 0];
  List<bool> serviceSelections = List.filled(7, false);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Đăng ký trở thành đối tác',
          style: GoogleFonts.lato(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      body: PageView(
        controller: _pageController,
        physics:
            NeverScrollableScrollPhysics(), // Disable swipe for manual control
        children: [
          basicDetails(),
          imageDetails(),
          confirmationPage(),
          // Add more pages as needed
        ],
      ),
    );
  }

  Widget basicDetails() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView(
        children: [
          Center(
            child: Text(
              "Thông tin cửa hàng",
              style: GoogleFonts.lato(
                fontSize: 24,
                fontWeight: FontWeight.w400,
                color: const Color.fromRGBO(4, 90, 208, 1),
              ),
            ),
          ),
          const SizedBox(height: 35),
          Text(
            'Tên cửa hàng',
            style: GoogleFonts.lato(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: const Color.fromRGBO(4, 90, 208, 1),
            ),
          ),
          const SizedBox(height: 5),
          buildTextField('Nguyễn Văn A', 'Tên cửa hàng', (value) {
            setState(() {
              storeDetails.storeName = value; // Update model
            });
          }),
          const SizedBox(height: 25),
          Text(
            'Địa chỉ cửa hàng',
            style: GoogleFonts.lato(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: const Color.fromRGBO(4, 90, 208, 1),
            ),
          ),
          const SizedBox(height: 5),
          buildTextField('Nhập địa chỉ cửa hàng', 'Địa chỉ cửa hàng', (value) {
            setState(() {
              storeDetails.address = value; // Update model
            });
          }),
          const SizedBox(height: 25),
          Text(
            'Số điện thoại cửa hàng',
            style: GoogleFonts.lato(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: const Color.fromRGBO(4, 90, 208, 1),
            ),
          ),
          const SizedBox(height: 5),
          buildTextField('Nhập số điện thoại', 'Số điện thoại cửa hàng',
              (value) {
            setState(() {
              storeDetails.phoneNumber = value; // Update model
            });
          }),
          const SizedBox(height: 25),
          Text(
            'Email cửa hàng',
            style: GoogleFonts.lato(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: const Color.fromRGBO(4, 90, 208, 1),
            ),
          ),
          const SizedBox(height: 5),
          buildTextField('Têncửahàng@email.com', 'Email cửa hàng', (value) {
            setState(() {
              storeDetails.email = value; // Update model
            });
          }),
          const SizedBox(height: 25),
          buildNavigationButtons(),
        ],
      ),
    );
  }

  Widget additionalDetails() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView(children: [
        Center(
          child: Text(
            'Thông tin cửa hàng',
            style: GoogleFonts.lato(
              fontSize: 24,
              fontWeight: FontWeight.w400,
              color: const Color.fromRGBO(4, 90, 208, 1),
            ),
          ),
        ),
        const SizedBox(height: 35),
        Text(
          'Các thiết bị tại cửa hàng',
          style: GoogleFonts.lato(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: const Color.fromRGBO(4, 90, 208, 1),
          ),
        ),
        const SizedBox(height: 25),
        Text(
          'Máy giặt',
          style: GoogleFonts.lato(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: const Color.fromRGBO(4, 90, 208, 1),
          ),
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'Cửa trên',
                style: GoogleFonts.lato(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: const Color.fromRGBO(4, 90, 208, 1),
                ),
              ),
            ),
            const SizedBox(width: 10),
            buildNumberSpinner(0), // Pass index to track the device count
          ],
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'Cửa trước',
                style: GoogleFonts.lato(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: const Color.fromRGBO(4, 90, 208, 1),
                ),
              ),
            ),
            const SizedBox(width: 10),
            buildNumberSpinner(1), // Pass index to track the device count
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 43),
            Text(
              'Các loại dịch vụ',
              style: GoogleFonts.lato(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: const Color.fromRGBO(4, 90, 208, 1),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildRow('Giặt thường', 0),
                      const SizedBox(height: 15),
                      buildRow('Giặt khô', 1),
                      const SizedBox(height: 15),
                      buildRow('Sửa quần áo', 2),
                      const SizedBox(height: 15),
                      buildRow('Giặt nặng (chăn mền)', 3),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildRow('Giặt hấp', 4),
                      const SizedBox(height: 15),
                      buildRow('Tẩy vết bẩn', 5),
                      const SizedBox(height: 15),
                      buildRow('Ủi quần áo', 6),
                    ],
                  ),
                ),
              ],
            ),
            buildNavigationButtons(),
            const SizedBox(height: 42),
          ],
        )
      ]),
    );
  }

  Widget imageDetails() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView(
        children: [
          Center(
            child: Text(
              'Thông tin cửa hàng',
              style: GoogleFonts.lato(
                fontSize: 24,
                fontWeight: FontWeight.w400,
                color: const Color.fromRGBO(4, 90, 208, 1),
              ),
            ),
          ),
          const SizedBox(height: 35),
          Text(
            'Ảnh cửa hàng',
            style: GoogleFonts.lato(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: const Color.fromRGBO(4, 90, 208, 1),
            ),
          ),
          const SizedBox(height: 25),
          Text(
            'Đăng tải ít nhất 3 ảnh',
            style: GoogleFonts.lato(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: const Color.fromRGBO(4, 90, 208, 1),
            ),
          ),
          const SizedBox(height: 15),

          // Button to pick images
          ElevatedButton.icon(
            onPressed: _pickImage,
            icon: const Icon(Icons.add_a_photo),
            label: const Text("Chọn ảnh"),
          ),
          const SizedBox(height: 20),

          // Display selected images in a grid
          _images.isNotEmpty
              ? buildImageGrid()
              : Text(
                  'Chưa có ảnh nào được chọn',
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                ),
          const SizedBox(height: 42),

          // Build navigation buttons
          buildNavigationButtons(),
        ],
      ),
    );
  }

  Widget buildImageGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(), // Disable scrolling
      itemCount: _images.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // Change this to 2 for wider images
        crossAxisSpacing: 10, // Increase spacing if needed
        mainAxisSpacing: 10, // Increase spacing if needed
        childAspectRatio: 1, // Aspect ratio to control height/width
      ),
      itemBuilder: (context, index) {
        return Stack(
          children: [
            ClipRRect(
              borderRadius:
                  BorderRadius.circular(8), // Optional: Add rounded corners
              child: Image.file(
                _images[index],
                fit: BoxFit.cover, // Use BoxFit.cover for full coverage
              ),
            ),
            Positioned(
              right: 0,
              child: IconButton(
                icon: Icon(
                  Icons.remove_circle,
                  color: Colors.red,
                ),
                onPressed: () {
                  setState(() {
                    _images.removeAt(index);
                  });
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void _showImageLimitWarning() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Giới hạn ảnh đã vượt quá'),
          content: Text('Bạn chỉ có thể chọn tối đa 3 ảnh.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget buildRow(String text, int index) {
    return Row(
      children: [
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.lato(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: const Color.fromRGBO(4, 90, 208, 1),
            ),
          ),
        ),
        Transform.scale(
          scale: 1.5,
          child: Checkbox(
            side: BorderSide(color: Color.fromRGBO(4, 90, 208, 1)),
            activeColor: Color.fromRGBO(4, 90, 208, 1),
            checkColor: Colors.white,
            value: serviceSelections[index],
            onChanged: (bool? value) {
              if (value != null) {
                setState(() {
                  serviceSelections[index] = value;

                  if (value) {
                    // Add service to StoreDetails if it's not already in the list
                    if (!storeDetails.services.contains(text)) {
                      storeDetails.services.add(text);
                    }
                  } else {
                    // Remove service from StoreDetails
                    storeDetails.services.remove(text);
                  }
                });
              }
            },
          ),
        ),
      ],
    );
  }

  Widget buildCheckBox(int index) {
    return Transform.scale(
      scale: 1.5,
      child: Checkbox(
        side: const BorderSide(color: Color.fromRGBO(4, 90, 208, 1)),
        activeColor: const Color.fromRGBO(4, 90, 208, 1),
        checkColor: Colors.white,
        value: isChecked[index], // Use the index to get the specific state
        onChanged: (bool? value) {
          setState(() {
            isChecked[index] = value!; // Update the specific checkbox state
          });
        },
      ),
    );
  }

  Widget confirmationPage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView(
        children: [
          Center(
            child: Text(
              'Xác nhận thông tin',
              style: GoogleFonts.lato(
                fontSize: 24,
                fontWeight: FontWeight.w400,
                color: const Color.fromRGBO(4, 90, 208, 1),
              ),
            ),
          ),
          const SizedBox(height: 35),
          Text(
            'Tên cửa hàng: ${storeDetails.storeName}',
            style: GoogleFonts.lato(fontSize: 16),
          ),
          Text(
            'Địa chỉ: ${storeDetails.address}',
            style: GoogleFonts.lato(fontSize: 16),
          ),
          Text(
            'Số điện thoại: ${storeDetails.phoneNumber}',
            style: GoogleFonts.lato(fontSize: 16),
          ),
          Text(
            'Email: ${storeDetails.email}',
            style: GoogleFonts.lato(fontSize: 16),
          ),
          Text(
            'Image: ${storeDetails.images}',
            style: GoogleFonts.lato(fontSize: 16),
          ),
          Text(
            'Service: ${storeDetails.services}',
            style: GoogleFonts.lato(fontSize: 16),
          ),
          Text(
            'Device: ${storeDetails.deviceTypes}',
            style: GoogleFonts.lato(fontSize: 16),
          ),
          // Add any additional details to confirm...
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              submitStoreDetails(); // Call the method to submit details
            },
            child: Text('Gửi thông tin'),
          ),
        ],
      ),
    );
  }

  Future<void> submitStoreDetails() async {
    try {
      // Construct the store details map with required field IDs and values
      List<Map<String, dynamic>> storeDetailsMap = [
        {
          'fieldID': 1, // ID for storeName
          'value': storeDetails.storeName,
        },
        {
          'fieldID': 2, // ID for address
          'value': storeDetails.address,
        },
        {
          'fieldID': 3, // ID for storeEmail
          'value': storeDetails.phoneNumber,
        },
        {
          'fieldID': 4, // ID for phoneNumber
          'value': storeDetails.email,
        },
      ];


      // Call your auth service's post method here
      await authService.submitForm(1, storeDetails.images, storeDetailsMap);
      print(storeDetails.images);
      print(storeDetailsMap);

      // Display success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đăng ký thành công!')),
      );

      // Optionally, navigate to a different screen or reset the form
      Navigator.pop(context); // Go back to the previous screen or reset
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã xảy ra lỗi: $e')),
      );
    }
  }

  Widget buildTextField(
      String hintText, String labelText, Function(String) onChanged) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextFormField(
        cursorColor: const Color.fromRGBO(4, 90, 208, 1),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey),
          contentPadding: const EdgeInsets.all(10),
          labelStyle: TextStyle(color: Colors.grey),
        ),
        onChanged: onChanged,
      ),
    );
  }

  Widget buildNavigationButtons() {
    return Column(
      children: [
        const SizedBox(height: 30), // Space before buttons
        Container(
          width: double.infinity, // Full width
          child: ElevatedButton(
            onPressed: () {
              if (activeIndex > 0) {
                setState(() {
                  activeIndex--;
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                  );
                });
              }
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(8), // Adjust the radius as needed
                side: BorderSide(color: Theme.of(context).primaryColor),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              backgroundColor: Colors.white,
            ),
            child: Text(
              'Quay lại',
              style: TextStyle(
                  fontSize: 16, color: Theme.of(context).primaryColor),
            ),
          ),
        ),
        const SizedBox(height: 15),
        Container(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              storeDetails.deviceTypes = [
                'Cửa trên: ${deviceCounts[0]}',
                'Cửa trước: ${deviceCounts[1]}'
              ];
              print(storeDetails.address);
              print(storeDetails.images); // Store device types and counts
              print(storeDetails.services);
              if (activeIndex < 3) {
                // Adjust based on the number of steps
                setState(() {
                  activeIndex++;
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                  );
                });
              } else {
                // Navigate to the AccountScreen on the last page
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => AccountScreen()),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              backgroundColor: const Color.fromRGBO(4, 90, 208, 1),
            ),
            child: const Text(
              'Tiếp tục',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildNumberSpinner(int index) {
    return Column(
      children: [
        Container(
          width: 200,
          decoration: BoxDecoration(
            border:
                Border.all(color: Colors.grey), // Match the button border color
            borderRadius:
                BorderRadius.circular(8), // Match the button border radius
          ),
          child: SpinBox(
            min: 0,
            max: 100,
            value: deviceCounts[index]
                .toDouble(), // Use the value from deviceCounts
            onChanged: (value) {
              deviceCounts[index] =
                  value.toInt(); // Update the deviceCounts array
              print(
                  'Updated device count for index $index: ${deviceCounts[index]}');
            },
            textStyle: GoogleFonts.lato(
              color: const Color.fromRGBO(4, 90, 208, 1), // Text color
              fontSize: 16,
            ),
            decoration: InputDecoration(
              border: InputBorder.none, // Remove the default border
              contentPadding: const EdgeInsets.all(10),
            ),
            incrementIcon: Icon(
              Icons.add,
              color: const Color.fromRGBO(4, 90, 208, 1),
            ),
            decrementIcon: Icon(
              Icons.remove,
              color: const Color.fromRGBO(4, 90, 208, 1),
            ),
          ),
        ),
      ],
    );
  }
}
