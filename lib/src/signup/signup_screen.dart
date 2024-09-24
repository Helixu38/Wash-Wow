import 'package:flutter/gestures.dart';
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

  bool isChecked = false; //checkbox

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
  String termAndConditionError = '';

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
                              termAndConditionError = '';
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
                            if (!isChecked) {
                              termAndConditionError =
                                  'Vui lòng chấp nhận điều khoản';
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
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  12), // Adjust the radius as needed
                            ),
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
                      if (!isChecked)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Center(
                            child: Text(
                              termAndConditionError,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Transform.scale(
                            scale: 1.5,
                            child: Checkbox(
                              side: BorderSide(
                                  color: Color.fromRGBO(4, 90, 208, 1)),
                              activeColor: Color.fromRGBO(4, 90, 208, 1),
                              checkColor: Colors.white,
                              value: isChecked,
                              onChanged: (bool? value) {
                                setState(() {
                                  isChecked = value!;
                                });
                              },
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              text: 'Đồng ý với ',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Color.fromRGBO(4, 90, 208, 1),
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'Điều khoản & Điều kiện',
                                  style: const TextStyle(
                                    color: Color.fromRGBO(4, 90, 208, 1),
                                    decoration: TextDecoration.underline,
                                    decorationColor:
                                        Color.fromRGBO(4, 90, 208, 1),
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
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            Dialog.fullscreen(
                                          backgroundColor: Colors.white,
                                          child: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                const Text(
                                                  'Điều khoản & Điều kiện',
                                                  style: TextStyle(
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color.fromRGBO(
                                                        4, 90, 208, 1),
                                                  ),
                                                ),
                                                const SizedBox(height: 20),
                                                Expanded(
                                                  child: SingleChildScrollView(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: const [
                                                        Text(
                                                          '1. Người dùng đồng ý tuân thủ các quy định về bảo mật thông tin và không chia sẻ tài khoản của mình cho người khác.',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              height: 1.5),
                                                        ),
                                                        SizedBox(height: 10),
                                                        Text(
                                                          '2. Người dùng chịu trách nhiệm về thông tin cá nhân đã cung cấp và các hoạt động thực hiện trên nền tảng.',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              height: 1.5),
                                                        ),
                                                        SizedBox(height: 10),
                                                        Text(
                                                          '3. Công ty có quyền cập nhật các điều khoản này mà không cần thông báo trước. Người dùng cần thường xuyên kiểm tra các điều khoản để đảm bảo nắm rõ các thay đổi mới nhất.',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              height: 1.5),
                                                        ),
                                                        SizedBox(height: 10),
                                                        Text(
                                                          '4. Nếu người dùng vi phạm các điều khoản và điều kiện, công ty có quyền tạm ngừng hoặc chấm dứt tài khoản của người dùng mà không cần thông báo trước.',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              height: 1.5),
                                                        ),
                                                        SizedBox(height: 10),
                                                        Text(
                                                          '5. Người dùng đồng ý rằng công ty không chịu trách nhiệm về bất kỳ thiệt hại nào phát sinh từ việc sử dụng dịch vụ của chúng tôi.',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              height: 1.5),
                                                        ),
                                                        SizedBox(height: 20),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 20),
                                                Center(
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                      ),
                                                      backgroundColor:
                                                          Color.fromRGBO(
                                                              4, 90, 208, 1),
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        horizontal: 30,
                                                        vertical: 10,
                                                      ),
                                                    ),
                                                    child: const Text(
                                                      'Đóng',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
