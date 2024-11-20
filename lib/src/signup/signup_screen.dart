import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_maps_webservices/places.dart';
import 'package:wash_wow/src/login/login_screen.dart';
import 'package:wash_wow/src/utility/auth_service.dart';
import 'package:wash_wow/src/utility/google_map_service.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordAgainController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  final PlacesService placesService = PlacesService();
  List<Prediction> predictions = [];

  void fetchPlacePredictions(String query) async {
    predictions = await placesService.fetchPlacePredictions(query);
    setState(() {});
  }

  final AuthService authService = AuthService('https://washwowbe.onrender.com');

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    passwordAgainController.dispose();
    phoneNumberController.dispose();
    addressController.dispose();
    super.dispose();
  }

  // Error message variables for each field
  String fullNameError = '';
  String emailError = '';
  String passwordError = '';
  String passwordAgainError = '';
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
                'Sign Up',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: const Color.fromRGBO(4, 90, 208, 1),
                ),
              ),
              Text(
                'Enter your information below',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              // Text(
              //   'hoặc đăng nhập bằng tài khoản mạng xã hội',
              //   style: TextStyle(
              //     fontSize: 16,
              //     fontWeight: FontWeight.w400,
              //     color: const Color.fromARGB(255, 0, 0, 0),
              //   ),
              // ),
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
                        'Full name',
                        style: TextStyle(
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
                          cursorColor: const Color.fromRGBO(4, 90, 208, 1),
                          controller: fullNameController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'John Doe',
                            hintStyle: TextStyle(
                                color: const Color.fromRGBO(208, 207, 207, 1)),
                            contentPadding: const EdgeInsets.all(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Email Field
                      Text(
                        'Email',
                        style: TextStyle(
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
                          cursorColor: const Color.fromRGBO(4, 90, 208, 1),
                          controller: emailController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'johndoe@gmail.com',
                            hintStyle: TextStyle(
                                color: const Color.fromRGBO(208, 207, 207, 1)),
                            contentPadding: const EdgeInsets.all(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Password Field
                      Text(
                        'Password',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: const Color.fromRGBO(4, 90, 208, 1),
                        ),
                      ),
                      //TO DO : add re-enter password field
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
                          cursorColor: const Color.fromRGBO(4, 90, 208, 1),
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter your password.',
                            hintStyle: TextStyle(
                                color: const Color.fromRGBO(208, 207, 207, 1)),
                            contentPadding: const EdgeInsets.all(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Re-enter Password Field
                      Text(
                        'Re-enter your password',
                        style: TextStyle(
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
                          cursorColor: const Color.fromRGBO(4, 90, 208, 1),
                          controller: passwordAgainController,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Re-enter your password.',
                            hintStyle: TextStyle(
                                color: const Color.fromRGBO(208, 207, 207, 1)),
                            contentPadding: const EdgeInsets.all(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Phone Number Field
                      Text(
                        'Phone number',
                        style: TextStyle(
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
                          cursorColor: const Color.fromRGBO(4, 90, 208, 1),
                          controller: phoneNumberController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter your phone number.',
                            hintStyle: TextStyle(
                                color: const Color.fromRGBO(208, 207, 207, 1)),
                            contentPadding: const EdgeInsets.all(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Address Field
                      Text(
                        'Address',
                        style: TextStyle(
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
                          cursorColor: const Color.fromRGBO(4, 90, 208, 1),
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
                            hintText: 'Enter your address.',
                            hintStyle: TextStyle(
                                color: const Color.fromRGBO(208, 207, 207, 1)),
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
                              passwordAgainError = '';
                              phoneNumberError = '';
                              addressError = '';
                            });

                            // Validate and set error messages
                            bool isValid = true;
                            if (fullNameController.text.isEmpty) {
                              fullNameError = 'Please enter your fullname';
                              isValid = false;
                            }
                            if (emailController.text.isEmpty ||
                                !RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                    .hasMatch(emailController.text)) {
                              emailError = 'Please enter a valid email address';
                              isValid = false;
                            }
                            if (passwordController.text.isEmpty ||
                                passwordController.text.length < 6) {
                              passwordError =
                                  'Password must have at least 6 characters';
                              isValid = false;
                            }
                            if (passwordAgainController.text.isEmpty ||
                                passwordAgainController.text.length < 6) {
                              passwordAgainError =
                                  'Password must have at least 6 characters';
                              isValid = false;
                            }
                            if (passwordAgainController.text !=
                                passwordController.text) {
                              passwordAgainError =
                                  'Password must match with each other';
                              isValid = false;
                            }
                            if (phoneNumberController.text.isEmpty ||
                                !RegExp(r'^\d{10}$')
                                    .hasMatch(phoneNumberController.text)) {
                              phoneNumberError =
                                  'Please enter a valid phone number';
                              isValid = false;
                            }
                            if (addressController.text.isEmpty) {
                              addressError = 'Please enter your address';
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
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Row(
                                      children: [
                                        Icon(Icons.check_circle,
                                            color: Colors.white),
                                        SizedBox(width: 10),
                                        Text(
                                            'Sign up successfully ! Please sign in again'),
                                      ],
                                    ),
                                    backgroundColor: Colors.green,
                                    duration: const Duration(
                                        seconds: 3), // Duration of the toast
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Row(
                                      children: [
                                        Icon(Icons.error_outline,
                                            color: Colors.white),
                                        SizedBox(width: 10),
                                        Text(
                                            'Đăng ký không thành công, vui lòng thử lại.'),
                                      ],
                                    ),
                                    backgroundColor: Colors.red,
                                    duration: const Duration(
                                        seconds: 2), // Duration of the toast
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
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 23),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text:
                                  "By signing up you are agreeing with\n",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Color.fromRGBO(4, 90, 208, 1),
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'Terms & Agreement',
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
                                                  'Terms & Agreement',
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
                                                          'Welcome to Wash&Wow! By using our services, you agree to the terms of use below. We encourage you to read them carefully before using to ensure your rights.',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              height: 1.5),
                                                        ),
                                                        TermSection(
                                                          title:
                                                              '1. Responsibilities of Wash&Wow',
                                                          content: [
                                                            SubSection(
                                                                title:
                                                                    '1.1 Commitment to Provide Services'),
                                                            SizedBox(
                                                                height: 10),
                                                            Text(
                                                              'Wash&Wow is committed to providing the scheduling platform for laundry and related services on time and ensuring quality. We strive to maintain accuracy in service information and store details.',
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  height: 1.5),
                                                            ),
                                                            SizedBox(
                                                                height: 10),
                                                            SubSection(
                                                                title:
                                                                    '1.2 No Responsibility for Partner Actions'),
                                                            SizedBox(
                                                                height: 10),
                                                            Text(
                                                              'We do not interfere with the operations or service quality of partner laundry stores. Wash&Wow is not responsible for issues arising from partner stores not providing the required service quality.',
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  height: 1.5),
                                                            ),
                                                            SizedBox(
                                                                height: 10),
                                                            SubSection(
                                                                title:
                                                                    '1.3 Customer Support'),
                                                            SizedBox(
                                                                height: 10),
                                                            Text(
                                                              'We provide a support channel through the app and website to answer inquiries and assist users in a timely manner.',
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  height: 1.5),
                                                            ),
                                                            SizedBox(
                                                                height: 10),
                                                          ],
                                                        ),
                                                        TermSection(
                                                          title:
                                                              '2. Responsibilities of Customers',
                                                          content: [
                                                            SubSection(
                                                                title:
                                                                    '2.1 Compliance with the Law'),
                                                            SizedBox(
                                                                height: 10),
                                                            Text(
                                                              'Customers must comply with the laws of Vietnam while using Wash&Wow services.',
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  height: 1.5),
                                                            ),
                                                            SizedBox(
                                                                height: 10),
                                                            SubSection(
                                                                title:
                                                                    '2.2 Providing Accurate Information'),
                                                            SizedBox(
                                                                height: 10),
                                                            Text(
                                                              'Customers are responsible for providing accurate information when registering an account and placing a service order, including full name, address, and contact details. If any changes occur, customers must update their information promptly to ensure no service disruption.',
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  height: 1.5),
                                                            ),
                                                            SizedBox(
                                                                height: 10),
                                                            SubSection(
                                                                title:
                                                                    '2.3 Data Security and Confidentiality'),
                                                            SizedBox(
                                                                height: 10),
                                                            Text(
                                                              'Customers are responsible for securing their login and account information. If unauthorized access is detected, please notify us immediately for timely assistance.',
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  height: 1.5),
                                                            ),
                                                            SizedBox(
                                                                height: 10),
                                                          ],
                                                        ),
                                                        TermSection(
                                                          title:
                                                              '3. Unacceptable Uses',
                                                          content: [
                                                            Text(
                                                              'Customers are not allowed to:\nUse Wash&Wow services to cause harm or illegally access our systems or those of our partners.\nSpread malware, viruses, or engage in other destructive actions.\nCung cấp hoặc phát tán nội dung vi phạm pháp luật.',
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  height: 1.5),
                                                            ),
                                                            SizedBox(
                                                                height: 10),
                                                          ],
                                                        ),
                                                        TermSection(
                                                          title:
                                                              '4. Thanh Toán Và Hoàn Trả',
                                                          content: [
                                                            SubSection(
                                                                title:
                                                                    '4.1 Thanh Toán'),
                                                            SizedBox(
                                                                height: 10),
                                                            Text(
                                                              'Khách hàng phải thanh toán đầy đủ các khoản phí theo quy định khi sử dụng dịch vụ. Thông tin chi phí sẽ được hiển thị rõ ràng trước khi đặt lịch giặt sấy.',
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  height: 1.5),
                                                            ),
                                                            SizedBox(
                                                                height: 10),
                                                            SubSection(
                                                                title:
                                                                    '4.2 Chính Sách Hoàn Trả'),
                                                            SizedBox(
                                                                height: 10),
                                                            Text(
                                                              'Chúng tôi sẽ hoàn tiền trong các trường hợp sau:\nWash&Wow ngừng cung cấp dịch vụ sau khi khách hàng đã thanh toán.\nDịch vụ không được cung cấp trong vòng 48 giờ kể từ khi đặt hàng.\nTrường hợp lỗi không thuộc về Wash&Wow hoặc do cửa hàng đối tác cung cấp không đảm bảo, chúng tôi không chịu trách nhiệm hoàn tiền.',
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  height: 1.5),
                                                            ),
                                                            SizedBox(
                                                                height: 10),
                                                          ],
                                                        ),
                                                        TermSection(
                                                          title:
                                                              '5. Ngừng Cung Cấp Dịch Vụ',
                                                          content: [
                                                            Text(
                                                              'Wash&Wow có quyền ngừng cung cấp dịch vụ nếu khách hàng vi phạm các điều khoản sau:\nCung cấp thông tin sai lệch, gây tổn hại cho hệ thống hoặc đối tác.\nVi phạm các quy định liên quan đến an toàn và bảo mật dịch vụ.\nKhông thanh toán chi phí sau khi đã quá hạn.',
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  height: 1.5),
                                                            ),
                                                            SizedBox(
                                                                height: 10),
                                                          ],
                                                        ),
                                                        TermSection(
                                                          title:
                                                              '6. Thay Đổi Điều Khoản Sử Dụng',
                                                          content: [
                                                            Text(
                                                              'Chúng tôi có thể điều chỉnh và cập nhật điều khoản sử dụng khi cần thiết. Mọi thay đổi sẽ được công bố trên trang web và ứng dụng của Wash&Wow, và có hiệu lực ngay sau khi công bố.',
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  height: 1.5),
                                                            ),
                                                            SizedBox(
                                                                height: 10),
                                                          ],
                                                        ),
                                                        TermSection(
                                                          title:
                                                              '7. Chính Sách Bảo Mật Thông Tin',
                                                          content: [
                                                            Text(
                                                              'Chúng tôi cam kết bảo vệ thông tin cá nhân của khách hàng và không chia sẻ cho bất kỳ bên thứ ba nào mà không có sự đồng ý của bạn, trừ trường hợp pháp luật yêu cầu.',
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  height: 1.5),
                                                            ),
                                                            SizedBox(
                                                                height: 10),
                                                          ],
                                                        ),
                                                        TermSection(
                                                          title:
                                                              '8. Hỗ Trợ Và Khiếu Nại',
                                                          content: [
                                                            Text(
                                                              'Mọi thắc mắc hoặc khiếu nại liên quan đến việc sử dụng dịch vụ của Wash&Wow, xin vui lòng liên hệ với chúng tôi qua hello.washnwow@gmail.com. Chúng tôi cam kết phản hồi trong vòng 24 giờ làm việc.',
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  height: 1.5),
                                                            ),
                                                            SizedBox(
                                                                height: 10),
                                                          ],
                                                        ),
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
                      ),
                      const SizedBox(height: 37), // Spacing
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: 'Bạn đã có tài khoản? ',
                              style: TextStyle(
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
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => LoginScreen(),
                                          ));
                                    },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 37),
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

class TermSection extends StatelessWidget {
  final String title;
  final List<Widget> content;

  const TermSection({
    Key? key,
    required this.title,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            height: 1.5,
            color: Color.fromRGBO(4, 90, 208, 1),
          ),
        ),
        const SizedBox(height: 10),
        ...content,
        const SizedBox(height: 10),
      ],
    );
  }
}

class SubSection extends StatelessWidget {
  final String title;

  const SubSection({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        height: 1.5,
        color: Color.fromRGBO(4, 90, 208, 1),
      ),
    );
  }
}
