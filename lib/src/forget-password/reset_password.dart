import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wash_wow/src/login/login_screen.dart';
import 'package:wash_wow/src/utility/auth_service.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController tokenController = TextEditingController();
  final TextEditingController passwordAgainController = TextEditingController();

  final AuthService authService = AuthService('https://washwowbe.onrender.com');

  @override
  void dispose() {
    tokenController.dispose();
    passwordAgainController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  String passwordError = '';
  String passwordAgainError = '';
  String tokenError = '';

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
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Token Field
                  Text(
                    'Mã Token',
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: const Color.fromRGBO(4, 90, 208, 1),
                    ),
                  ),
                  if (tokenError.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Text(
                        tokenError,
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                  _buildTextField(tokenController, 'Nhập mã token của bạn', false),

                  const SizedBox(height: 10),

                  // New Password Field
                  Text(
                    'Mật khẩu mới',
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
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                  _buildTextField(passwordController, 'Nhập mật khẩu mới', true),

                  const SizedBox(height: 10),

                  // Confirm Password Field
                  Text(
                    'Nhập lại mật khẩu mới',
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: const Color.fromRGBO(4, 90, 208, 1),
                    ),
                  ),
                  if (passwordAgainError.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Text(
                        passwordAgainError,
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                  _buildTextField(passwordAgainController, 'Nhập lại mật khẩu mới', true),

                  const SizedBox(height: 87),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _handleResetPassword,
                      style: ElevatedButton.styleFrom(
                        shape: StadiumBorder(),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 15),
                        backgroundColor: const Color.fromRGBO(4, 90, 208, 1),
                      ),
                      child: Text(
                        'Đổi mật khẩu',
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

  Widget _buildTextField(TextEditingController controller, String hintText, bool obscureText) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromARGB(255, 197, 197, 197)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        cursorColor: const Color.fromRGBO(4, 90, 208, 1),
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(color: const Color.fromRGBO(208, 207, 207, 1)),
          contentPadding: const EdgeInsets.all(10),
        ),
      ),
    );
  }

  Future<void> _handleResetPassword() async {
    setState(() {
      passwordError = '';
      tokenError = '';
      passwordAgainError = '';
    });

    bool isValid = true;

    if (passwordController.text.isEmpty || passwordController.text.length < 6) {
      passwordError = 'Mật khẩu phải có ít nhất 6 ký tự';
      isValid = false;
    }
    if (passwordAgainController.text.isEmpty || passwordAgainController.text.length < 6) {
      passwordAgainError = 'Mật khẩu phải có ít nhất 6 ký tự';
      isValid = false;
    }
    if (passwordAgainController.text != passwordController.text) {
      passwordAgainError = 'Mật khẩu phải khớp với nhau';
      isValid = false;
    }
    if (tokenController.text.isEmpty) {
      tokenError = 'Vui lòng nhập mã token';
      isValid = false;
    }

    if (isValid) {
      String? result = await authService.resetPassword(
        tokenController.text,
        passwordController.text,
      );

      if (result == "Success") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 10),
                Text('Mật khẩu của bạn đã được reset'),
              ],
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
        // Clear the text fields after successful reset
        passwordController.clear();
        passwordAgainController.clear();
        tokenController.clear();
        
        // Navigate to login screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Yêu cầu không thành công, vui lòng thử lại.'),
          ),
        );
      }
    } else {
      setState(() {});
    }
  }
}
