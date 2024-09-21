import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wash_wow/src/login/login_screen.dart';
import 'package:wash_wow/src/services/auth_service.dart'; //

class SignupScreen extends StatelessWidget {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  final AuthService authService = AuthService('https://10.0.2.2:7276');

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
              Text(
                'Điền thông tin của quý khách phía bên dưới,',
                style: GoogleFonts.lato(
                  fontSize: 16,
                  fontWeight: FontWeight.w200,
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              Text(
                'hoặc đăng nhập bằng tài khoản mạng xã hội',
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
                      'Họ và tên',
                      style: GoogleFonts.lato(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: const Color.fromRGBO(4, 90, 208, 1),
                      ),
                    ),
                    const SizedBox(height: 5), // Spacing
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color.fromARGB(255, 197, 197, 197)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: fullNameController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Nguyễn Văn A',
                          contentPadding: const EdgeInsets.all(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14), // Spacing
                    Text(
                      'Địa chỉ Email',
                      style: GoogleFonts.lato(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: const Color.fromRGBO(4, 90, 208, 1),
                      ),
                    ),
                    const SizedBox(height: 5), // Spacing
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color.fromARGB(255, 197, 197, 197)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'nguyenvana@gmail.com',
                          contentPadding: const EdgeInsets.all(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14), // Spacing
                    Text(
                      'Mật khẩu',
                      style: GoogleFonts.lato(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: const Color.fromRGBO(4, 90, 208, 1),
                      ),
                    ),
                    const SizedBox(height: 5), // Spacing
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Nhập mật khẩu của bạn.',
                          contentPadding: const EdgeInsets.all(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14), // Spacing
                    Text(
                      'Số điện thoại',
                      style: GoogleFonts.lato(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: const Color.fromRGBO(4, 90, 208, 1),
                      ),
                    ),
                    const SizedBox(height: 5), // Spacing
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: phoneNumberController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Nhập số điện thoại của bạn.',
                          contentPadding: const EdgeInsets.all(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14), // Spacing
                    Text(
                      'Địa Chỉ',
                      style: GoogleFonts.lato(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: const Color.fromRGBO(4, 90, 208, 1),
                      ),
                    ),
                    const SizedBox(height: 5), // Spacing
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: addressController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Nhập địa chỉ của bạn.',
                          contentPadding: const EdgeInsets.all(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 23),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
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
                                  builder: (context) => const LoginScreen()),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Đăng ký không thành công, vui lòng thử lại.')),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          shape: StadiumBorder(),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          backgroundColor: const Color.fromRGBO(4, 90, 208, 1),
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
                            text: 'Bạn đã có tài khoản? ',
                            style: GoogleFonts.lato(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: const Color.fromRGBO(119, 119, 119, 1),
                              fontStyle: FontStyle.italic,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Đăng nhập ngay',
                                style: const TextStyle(
                                  color: Color.fromRGBO(4, 90, 208, 1),
                                  decoration: TextDecoration.underline,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w700,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    // Go to the registration page
                                    print("Đăng ký ngay clicked");
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginScreen(),
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
      ),
    );
  }
}
