import 'package:flutter/material.dart';
import 'package:flutter_google_maps_webservices/places.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wash_wow/src/login/login_screen.dart';
import 'package:wash_wow/src/services/auth_service.dart';
import 'package:wash_wow/src/services/google_map_service.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  final PlacesService placesService = PlacesService();
  List<Prediction> predictions = [];

  void fetchPlacePredictions(String query) async {
    predictions = await placesService.fetchPlacePredictions(query);
    setState(() {});
  }

  final AuthService authService = AuthService('https://10.0.2.2:7276');

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneNumberController.dispose();
    addressController.dispose();
    super.dispose();
  }

  // Error message variables for each field
  String fullNameError = '';
  String emailError = '';
  String passwordError = '';
  String phoneNumberError = '';
  String addressError = '';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Image.asset(
                  'assets/images/logos/Logosmall.png',
                  width: 75,
                  height: 75,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'ĐĂNG KÝ',
                style: GoogleFonts.lato(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: const Color.fromRGBO(4, 90, 208, 1),
                ),
              ),
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Full Name Field
                      Text(
                        'Họ và tên',
                        style: GoogleFonts.lato(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: const Color.fromRGBO(4, 90, 208, 1),
                        ),
                      ),
                      if (fullNameError.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Text(
                            fullNameError,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextFormField(
                          controller: fullNameController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Nguyễn Văn A',
                            contentPadding: const EdgeInsets.all(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Email Field
                      Text(
                        'Địa chỉ Email',
                        style: GoogleFonts.lato(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: const Color.fromRGBO(4, 90, 208, 1),
                        ),
                      ),
                      if (emailError.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Text(
                            emailError,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'nguyenvana@gmail.com',
                            contentPadding: const EdgeInsets.all(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Password Field
                      Text(
                        'Mật khẩu',
                        style: GoogleFonts.lato(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: const Color.fromRGBO(4, 90, 208, 1),
                        ),
                      ),
                      if (passwordError.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Text(
                            passwordError,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Nhập mật khẩu của bạn.',
                            contentPadding: const EdgeInsets.all(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Phone Number Field
                      Text(
                        'Số điện thoại',
                        style: GoogleFonts.lato(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: const Color.fromRGBO(4, 90, 208, 1),
                        ),
                      ),
                      if (phoneNumberError.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Text(
                            phoneNumberError,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextFormField(
                          controller: phoneNumberController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Nhập số điện thoại của bạn.',
                            contentPadding: const EdgeInsets.all(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Address Field
                      Text(
                        'Địa Chỉ',
                        style: GoogleFonts.lato(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: const Color.fromRGBO(4, 90, 208, 1),
                        ),
                      ),
                      if (addressError.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Text(
                            addressError,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextFormField(
                          controller: addressController,
                          onChanged: (value) {
                            if (value.isNotEmpty && value.length >= 3) {
                              fetchPlacePredictions(value);
                            } else {
                              setState(() {
                                predictions = [];
                              });
                            }
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Nhập địa chỉ của bạn.',
                            contentPadding: const EdgeInsets.all(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 23),
                      if (predictions.isNotEmpty)
                        Container(
                          height: 200,
                          child: ListView.builder(
                            itemCount: predictions.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(predictions[index].description!),
                                onTap: () {
                                  setState(() {
                                    addressController.text =
                                        predictions[index].description!;
                                    predictions = [];
                                  });
                                },
                              );
                            },
                          ),
                        ),
                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            // Clear previous error messages
                            setState(() {
                              fullNameError = '';
                              emailError = '';
                              passwordError = '';
                              phoneNumberError = '';
                              addressError = '';
                            });

                            // Validate and set error messages
                            bool isValid = true;
                            if (fullNameController.text.isEmpty) {
                              fullNameError = 'Vui lòng nhập họ và tên';
                              isValid = false;
                            }
                            if (emailController.text.isEmpty ||
                                !RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                    .hasMatch(emailController.text)) {
                              emailError = 'Vui lòng nhập địa chỉ email hợp lệ';
                              isValid = false;
                            }
                            if (passwordController.text.isEmpty ||
                                passwordController.text.length < 6) {
                              passwordError =
                                  'Mật khẩu phải có ít nhất 6 ký tự';
                              isValid = false;
                            }
                            if (phoneNumberController.text.isEmpty ||
                                !RegExp(r'^\d{10}$')
                                    .hasMatch(phoneNumberController.text)) {
                              phoneNumberError =
                                  'Vui lòng nhập số điện thoại hợp lệ (10 chữ số)';
                              isValid = false;
                            }
                            if (addressController.text.isEmpty) {
                              addressError = 'Vui lòng nhập địa chỉ';
                              isValid = false;
                            }

                            if (isValid) {
                              bool success = await authService.register(
                                fullNameController.text,
                                emailController.text,
                                passwordController.text,
                                phoneNumberController.text,
                                addressController.text,
                              );

                              if (success) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginScreen(),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Đăng ký không thành công, vui lòng thử lại.'),
                                  ),
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            shape: StadiumBorder(),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 15),
                            backgroundColor:
                                const Color.fromRGBO(4, 90, 208, 1),
                          ),
                          child: Text(
                            'Đăng Ký',
                            style: GoogleFonts.lato(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 23),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
