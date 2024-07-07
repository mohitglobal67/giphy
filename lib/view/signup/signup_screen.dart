import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:giphy_app/config/color/color.dart';
import 'package:giphy_app/config/textstyle/text_style.dart';
import 'package:giphy_app/provider/auth_provider.dart';
import 'package:giphy_app/utils/routes/routes_name.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Signup'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              obscureText: false,
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'Enter Your Email.',
                hintStyle: text2Regular(AppColors.blackColor),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.black,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.red,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            TextFormField(
              obscureText: true,
              controller: _passwordController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'Enter Your Password.',
                hintStyle: text2Regular(AppColors.blackColor),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.black,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.red,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final authService =
                    Provider.of<AuthService>(context, listen: false);
                final user = await authService.registerWithEmailAndPassword(
                    _emailController.text, _passwordController.text);
                if (user != null) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    RoutesName.login,
                    (routes) => false,
                  );
                } else {
                  setState(() {
                    _error = 'Signup failed';
                  });
                }
              },
              child: Text('Signup'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  RoutesName.login,
                  (routes) => false,
                );
              },
              child: Text('Already have an account? Login'),
            ),
            if (_error.isNotEmpty)
              Text(_error, style: TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}
