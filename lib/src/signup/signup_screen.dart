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
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: const Color.fromRGBO(4, 90, 208, 1),
                ),
              ),
              Text(
                'Điền thông tin của quý khách phía bên dưới,',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              Text(
                'hoặc đăng nhập bằng tài khoản mạng xã hội',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
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
                            hintText: 'Nguyễn Văn A',
                            hintStyle: TextStyle(
                                color: const Color.fromRGBO(208, 207, 207, 1)),
                            contentPadding: const EdgeInsets.all(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Email Field
                      Text(
                        'Địa chỉ Email',
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
                            hintText: 'nguyenvana@gmail.com',
                            hintStyle: TextStyle(
                                color: const Color.fromRGBO(208, 207, 207, 1)),
                            contentPadding: const EdgeInsets.all(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Password Field
                      Text(
                        'Mật khẩu',
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
                            hintText: 'Nhập mật khẩu của bạn.',
                            hintStyle: TextStyle(
                                color: const Color.fromRGBO(208, 207, 207, 1)),
                            contentPadding: const EdgeInsets.all(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Phone Number Field
                      Text(
                        'Số điện thoại',
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
                            hintText: 'Nhập số điện thoại của bạn.',
                            hintStyle: TextStyle(
                                color: const Color.fromRGBO(208, 207, 207, 1)),
                            contentPadding: const EdgeInsets.all(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Address Field
                      Text(
                        'Địa Chỉ',
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
                            hintText: 'Nhập địa chỉ của bạn.',
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
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Row(
                                      children: [
                                        Icon(Icons.check_circle,
                                            color: Colors.white),
                                        SizedBox(width: 10),
                                        Text(
                                            'Đăng ký thành công ! Vui lòng đăng nhập lại'),
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
                                  'Bằng cách nhấp vào đăng kí bạn đồng ý với\n',
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
                                                          'Chào mừng bạn đến với Wash&Wow! Khi bạn sử dụng dịch vụ của chúng tôi, bạn đồng ý với các điều khoản sử dụng dưới đây. Chúng tôi khuyến khích bạn đọc kỹ trước khi sử dụng để đảm bảo quyền lợi của bạn.',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              height: 1.5),
                                                        ),
                                                        TermSection(
                                                          title:
                                                              '1. Trách Nhiệm Của Wash&Wow',
                                                          content: [
                                                            SubSection(
                                                                title:
                                                                    '1.1 Cam Kết Cung Cấp Dịch Vụ'),
                                                            SizedBox(
                                                                height: 10),
                                                            Text(
                                                              'Wash&Wow cam kết cung cấp nền tảng đặt lịch giặt sấy và các dịch vụ liên quan đúng hạn và đảm bảo chất lượng. Chúng tôi cố gắng hết sức để đảm bảo sự chính xác trong thông tin dịch vụ và cửa hàng.',
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  height: 1.5),
                                                            ),
                                                            SizedBox(
                                                                height: 10),
                                                            SubSection(
                                                                title:
                                                                    '1.2 Không Chịu Trách Nhiệm Về Hành Vi Của Các Đối Tác'),
                                                            SizedBox(
                                                                height: 10),
                                                            Text(
                                                              'Chúng tôi không can thiệp vào quá trình vận hành và chất lượng dịch vụ của các cửa hàng giặt sấy đối tác. Wash&Wow không chịu trách nhiệm cho các vấn đề phát sinh do cửa hàng đối tác cung cấp dịch vụ không đạt yêu cầu.',
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  height: 1.5),
                                                            ),
                                                            SizedBox(
                                                                height: 10),
                                                            SubSection(
                                                                title:
                                                                    '1.3 Hỗ Trợ Khách Hàng'),
                                                            SizedBox(
                                                                height: 10),
                                                            Text(
                                                              'Chúng tôi cung cấp kênh hỗ trợ thông qua ứng dụng và trang web để giải đáp mọi thắc mắc và hỗ trợ kịp thời cho người dùng.',
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
                                                              '2. Trách Nhiệm Của Khách Hàng',
                                                          content: [
                                                            SubSection(
                                                                title:
                                                                    '2.1 Tuân Thủ Pháp Luật'),
                                                            SizedBox(
                                                                height: 10),
                                                            Text(
                                                              'Khách hàng phải tuân thủ các quy định của pháp luật Việt Nam trong suốt quá trình sử dụng dịch vụ của Wash&Wow.',
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  height: 1.5),
                                                            ),
                                                            SizedBox(
                                                                height: 10),
                                                            SubSection(
                                                                title:
                                                                    '2.2 Cung Cấp Thông Tin Chính Xác'),
                                                            SizedBox(
                                                                height: 10),
                                                            Text(
                                                              'Khách hàng có trách nhiệm cung cấp thông tin chính xác khi đăng ký tài khoản và đặt dịch vụ, bao gồm họ tên, địa chỉ, và thông tin liên lạc. Nếu có sự thay đổi, khách hàng cần cập nhật kịp thời để đảm bảo không gián đoạn dịch vụ.',
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  height: 1.5),
                                                            ),
                                                            SizedBox(
                                                                height: 10),
                                                            SubSection(
                                                                title:
                                                                    '2.3 Bảo Quản Dữ Liệu Và Bảo Mật Thông Tin'),
                                                            SizedBox(
                                                                height: 10),
                                                            Text(
                                                              'Khách hàng chịu trách nhiệm bảo mật thông tin đăng nhập và tài khoản của mình. Nếu phát hiện có truy cập trái phép, vui lòng thông báo ngay cho chúng tôi để được hỗ trợ kịp thời.',
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
                                                              '3. Các Hình Thức Sử Dụng Không Được Chấp Nhận',
                                                          content: [
                                                            Text(
                                                              'Khách hàng không được phép:\nSử dụng dịch vụ của Wash&Wow để gây tổn hại, xâm nhập trái phép hệ thống của chúng tôi hoặc các đối tác.\nPhát tán các mã độc, virus hay thực hiện các hành vi phá hoại khác.\nCung cấp hoặc phát tán nội dung vi phạm pháp luật.',
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
