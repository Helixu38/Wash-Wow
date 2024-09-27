import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wash_wow/src/signup/signup_screen.dart';
import 'package:wash_wow/src/services/auth_service.dart';
import 'package:wash_wow/src/home-page/home_page.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
              'ĐĂNG NHẬP',
              style: GoogleFonts.lato(
                fontSize: 30,
                fontWeight: FontWeight.w800,
                color: const Color.fromRGBO(4, 90, 208, 1),
              ),
            ),
            Text(
              'Xin chào quý khách',
              style: GoogleFonts.lato(
                fontSize: 16,
                fontWeight: FontWeight.w300,
                color: const Color.fromARGB(255, 0, 0, 0),
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
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                        ),
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
                        contentPadding: const EdgeInsets.all(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 34), // Spacing
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
                    child: TextField(
                      cursorColor: const Color.fromRGBO(4, 90, 208, 1),
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Nhập mật khẩu của bạn.',
                        contentPadding: const EdgeInsets.all(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Quên mật khẩu?',
                        textAlign: TextAlign.right,
                        style: GoogleFonts.lato(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: const Color.fromRGBO(4, 90, 208, 1),
                          fontStyle: FontStyle.italic,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 37), // Spacing
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        // Clear previous error messages
                        setState(() {
                          emailError = '';
                          passwordError = '';
                        });

                        bool isValid = true;

                        // Validate email
                        if (emailController.text.isEmpty ||
                            !RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                .hasMatch(emailController.text)) {
                          emailError = 'Vui lòng nhập địa chỉ email hợp lệ';
                          isValid = false;
                        }

                        // Validate password
                        if (passwordController.text.isEmpty ||
                            passwordController.text.length < 6) {
                          passwordError = 'Vui lòng nhập mật khẩu hợp lệ';
                          isValid = false;
                        }

                        if (isValid) {
                          bool success = await authService.login(
                            emailController.text,
                            passwordController.text,
                          );

                          if (success) {
                            //Navigate to the homepage
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomePage()),
                            );
                            // Display welcome toast on successful login
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Row(
                                  children: [
                                    Icon(Icons.check_circle,
                                        color: Colors.white),
                                    SizedBox(width: 10),
                                    Text(
                                        'Chào mừng trở lại, ${emailController.text}!'),
                                  ],
                                ),
                                backgroundColor: Colors.green,
                                duration: const Duration(
                                    seconds: 3), // How long the toast lasts
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Đăng nhập không thành công, vui lòng thử lại.')),
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
                        'Đăng Nhập',
                        style: GoogleFonts.lato(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 56), // Spacing
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'hoặc đăng nhập bằng',
                        textAlign: TextAlign.right,
                        style: GoogleFonts.lato(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: const Color.fromRGBO(4, 90, 208, 1),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 37), // Spacing
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: 'Bạn chưa có tài khoản? ',
                          style: GoogleFonts.lato(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: const Color.fromRGBO(119, 119, 119, 1),
                            fontStyle: FontStyle.italic,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Đăng ký ngay',
                              style: const TextStyle(
                                color: Color.fromRGBO(4, 90, 208, 1),
                                decoration: TextDecoration.underline,
                                decorationColor: Color.fromRGBO(4, 90, 208, 1),
                                decorationStyle: TextDecorationStyle
                                    .solid, // solid underline
                                decorationThickness:
                                    1.5, // Makes the underline a bit thicker
                                height:
                                    1.2, // Adds vertical spacing, indirectly pushing underline down
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w700,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SignupScreen(),
                                      ));
                                },
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
