import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinbox/material.dart';

class ShopRegisterForm extends StatefulWidget {
  const ShopRegisterForm({super.key});

  @override
  State<ShopRegisterForm> createState() => _ShopRegisterFormState();
}

class _ShopRegisterFormState extends State<ShopRegisterForm> {
  final PageController _pageController = PageController();
  int activeIndex = 0;
  List<bool> isChecked = [false, false, false, false, false, false, false];
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
          additionalDetails(),
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
          buildTextField('Nguyễn Văn A', 'Tên cửa hàng'),
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
          buildTextField('Nhập địa chỉ cửa hàng', 'Địa chỉ cửa hàng'),
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
          buildTextField('Nhập số điện thoại', 'Số điện thoại cửa hàng'),
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
          buildTextField('Têncửahàng@email.com', 'Email cửa hàng'),
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
              const SizedBox(
                  width: 10), // Add some space between the text and spinner
              buildNumberSpinner(),
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
              const SizedBox(
                  width: 10), // Add some space between the text and spinner
              buildNumberSpinner(),
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
                  // Left Column
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildRow('Giặt thường', 0),
                        const SizedBox(height: 15),
                        _buildRow('Giặt khô', 1),
                        const SizedBox(height: 15),
                        _buildRow('Sửa quần áo', 2),
                        const SizedBox(height: 15),
                        _buildRow('Giặt nặng (chăn mền)', 3),
                      ],
                    ),
                  ),

                  const SizedBox(width: 20), // Space between two columns

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildRow('Giặt hấp', 4),
                        const SizedBox(height: 15),
                        _buildRow('Tẩy vết bẩn', 5),
                        const SizedBox(height: 15),
                        _buildRow('Ủi quần áo', 6),
                      ],
                    ),
                  ),
                ],
              ),
              buildNavigationButtons(),
              const SizedBox(height: 42),
            ],
          )
        ]));
  }

  Widget imageDetails() {
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
          
              buildNavigationButtons(),
              const SizedBox(height: 42),
            ],
          )
        );
  }

  Widget buildDeviceRow(String device, String label) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.lato(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: const Color.fromRGBO(4, 90, 208, 1),
            ),
          ),
        ),
        const SizedBox(width: 10),
        buildNumberSpinner(),
      ],
    );
  }

  Widget _buildRow(String text, int index) {
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
        buildCheckBox(index),
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Xác nhận thông tin',
            style: GoogleFonts.lato(
              fontSize: 24,
              fontWeight: FontWeight.w400,
              color: const Color.fromRGBO(4, 90, 208, 1),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Handle submission here
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                backgroundColor: const Color.fromRGBO(4, 90, 208, 1),
              ),
              child: const Text(
                'Gửi thông tin',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextField(String hintText, String labelText) {
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
          labelStyle: TextStyle(color: Colors.grey), // Optional label style
        ),
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
                  side: BorderSide(color: Theme.of(context).primaryColor)),
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
              if (activeIndex < 3) {
                // Adjust based on the number of steps
                setState(() {
                  activeIndex++;
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                  );
                });
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
}
// Make sure to import the SpinBox package

Widget buildNumberSpinner() {
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
          min: 1,
          max: 100,
          value: 0,
          onChanged: (value) => print(value),
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
