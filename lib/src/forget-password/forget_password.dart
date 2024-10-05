import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wash_wow/src/forget-password/reset_password.dart';
import 'package:wash_wow/src/utility/auth_service.dart';
import 'package:wash_wow/src/signup/signup_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final AuthService authService = AuthService('https://10.0.2.2:7276');

  // Error message variables for email and password
  String emailError = '';

  String passwordError = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(color: Colors.white),
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
              'QUÊN MẬT KHẨU',
              style: GoogleFonts.lato(
                fontSize: 30,
                fontWeight: FontWeight.w800,
                color: const Color.fromRGBO(4, 90, 208, 1),
              ),
            ),
            const SizedBox(height: 50), // Spacing
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: const Color.fromARGB(255, 197, 197, 197)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      cursorColor: const Color.fromRGBO(4, 90, 208, 1),
                      controller: emailController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'nguyenvana@gmail.com',
                        hintStyle: TextStyle(
                            color: const Color.fromRGBO(208, 207, 207, 1)),
                        contentPadding: const EdgeInsets.all(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 113), // Spacing
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        // Clear previous error messages
                        setState(() {
                          emailError = '';
                        });

                        bool isValid = true;
                        // Validate email
                        if (emailController.text.isEmpty ||
                            !RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                .hasMatch(emailController.text)) {
                          emailError = 'Vui lòng nhập địa chỉ email hợp lệ';
                          isValid = false;
                        }
                        if (isValid) {
                          // Call the forgetPassword function from authService
                          String? result = await authService.forgetPassword(
                            emailController.text,
                          );

                          if (result == "Success. Please check your mail") {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Row(
                                  children: [
                                    Icon(Icons.check_circle,
                                        color: Colors.white),
                                    SizedBox(width: 10),
                                    Text(
                                        'Đã gửi yêu cầu đặt lại mật khẩu đến \n ${emailController.text}!'),
                                  ],
                                ),
                                backgroundColor: Colors.green,
                                duration: const Duration(
                                    seconds: 3), // Duration of the toast
                              ),
                            );
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ResetPasswordScreen()),
                            );
                            // Optionally navigate or reset the form here
                          } else {
                            // Handle error scenario
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Row(
                                  children: [
                                    Icon(Icons.error_outline,
                                        color: Colors.white),
                                    SizedBox(width: 10),
                                    Text(
                                        'Yêu cầu không thành công, vui lòng thử lại.'),
                                  ],
                                ),
                                backgroundColor: Colors.red,
                                duration: const Duration(
                                    seconds: 3), // Duration of the toast
                              ),
                            );
                          }
                        } else {
                          // Rebuild to show error messages
                          setState(() {});
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: StadiumBorder(),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 15),
                        backgroundColor: const Color.fromRGBO(4, 90, 208, 1),
                      ),
                      child: Text(
                        'Gửi link xác nhận đổi mật khẩu',
                        style: GoogleFonts.lato(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
