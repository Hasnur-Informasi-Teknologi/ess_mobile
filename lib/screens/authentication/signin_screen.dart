// ignore_for_file: use_build_context_synchronously

import 'package:get/get.dart';
import 'package:mobile_ess/models/http_exception.dart';
import 'package:mobile_ess/screens/user/main/main_screen.dart';
import 'package:mobile_ess/themes/constant.dart';
import 'package:mobile_ess/widgets/error_dialog_widget.dart';
import 'package:provider/provider.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  String? userNrp, userPass;
  final _formKey = GlobalKey<FormState>();
  final _nrpController = TextEditingController();
  final _passController = TextEditingController();
  double _maxHeight = 40.0;
  double _maxHeightPass = 40.0;

  bool _obscureText = true;
  bool _isLoading = false;

  Future<void> _signIn() async {
    setState(() {
      _isLoading = true;
    });

    if (_formKey.currentState!.validate() == false) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    _formKey.currentState!.save();

    userNrp = _nrpController.text;
    userPass = _passController.text;

    try {
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // prefs.setBool('isUserLogin', true);
      // await Provider.of<AuthProvider>(context, listen: false)
      //     .signIn(userNrp!, userPass!)
      //     .then((_) => Navigator.pushReplacement(context,
      //         MaterialPageRoute(builder: (ctx) => const HomeScreen())));

      Get.offAllNamed('/user/main');
    } on HttpException catch (e) {
      String errorMessage = '';

      if (e.toString().contains('USER_NOT_FOUND')) {
        errorMessage = 'USER NOT FOUND';
      } else if (e.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'INVALID PASSWORD';
      } else if (e.toString().contains('USER_NOT_REGISTERED')) {
        errorMessage = 'USER NOT REGISTERED';
      }
      _showErrorDialog(errorMessage);

      // Future.delayed(
      //     const Duration(seconds: 2),
      //     () => Navigator.pushReplacement(context,
      //         MaterialPageRoute(builder: (ctx) => const HomeScreen())));
    } catch (e) {
      Get.offAllNamed('/user/main');

      // _showErrorDialog('USER NOT REGISTERED');
      // Future.delayed(
      //   const Duration(seconds: 2),
      //   () => Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(
      //       builder: (ctx) => const MainScreen(),
      //     ),
      //   ),
      // );
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _showErrorDialog(String errorMessage) {
    showDialog(
        context: context,
        builder: (ctx) {
          return ErrorDialogWidget(message: errorMessage);
        });
  }

  String? _validatorNrp(value) {
    if (value == null || value.isEmpty) {
      setState(() {
        _maxHeight = 60.0;
      });
      return 'NRP Kosong';
    } else if (value.length < 8) {
      setState(() {
        _maxHeight = 60.0;
      });
      return 'Password Kosong';
    }
    setState(() {
      _maxHeight = 40.0;
    });
    return null;
  }

  String? _validatorPassword(value) {
    if (value == null || value.isEmpty) {
      setState(() {
        _maxHeightPass = 60.0;
      });
      return 'Password Kosong';
    }
    setState(() {
      _maxHeightPass = 40.0;
    });
    return null;
  }

  void _showPassword() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textSmall = size.width * 0.027;
    double textMedium = size.width * 0.0329;
    double textLarge = size.width * 0.04;
    double textExtraLarge = size.width * 0.07;
    double sizedBoxHeightTall = size.height * 0.0163;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;
    double paddingHorizontalNarrow = size.width * 0.035;
    double padding10 = size.width * 0.023;
    double padding40 = size.width * 0.095;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
          statusBarColor: Color(secondaryBackground),
          statusBarBrightness: Brightness.dark),
      child: Scaffold(
        backgroundColor: const Color(secondaryBackground),
        appBar: AppBar(
          backgroundColor: const Color(secondaryBackground),
          elevation: 0,
          toolbarHeight: 0,
        ),
        body: _isLoading
            ? const CircularProgressIndicator()
            : SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: paddingHorizontalNarrow),
                      Image.asset('assets/images/logo-hasnur.png', width: 100),
                      SizedBox(height: paddingHorizontalNarrow),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: padding40, vertical: padding10),
                        child: Text(
                          'Employee Self Service Login',
                          style: TextStyle(
                            fontSize: textExtraLarge,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                      SizedBox(height: sizedBoxHeightExtraTall),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.87,
                        height: MediaQuery.of(context).size.height * 0.53,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: paddingHorizontalNarrow,
                              vertical: padding40),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    'SELAMAT DATANG',
                                    style: TextStyle(
                                        fontSize: textExtraLarge,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.bold,
                                        color: const Color(primaryYellow)),
                                  ),
                                  SizedBox(
                                    height: sizedBoxHeightTall,
                                  ),
                                  Text(
                                    'Silahkan masukkan NRP dan Password Anda untuk melakukan login',
                                    style: TextStyle(
                                        fontSize: textLarge,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                  SizedBox(
                                    height: sizedBoxHeightTall,
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Form(
                                    key: _formKey,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'NRP : ',
                                          style: TextStyle(
                                              color: const Color(primaryBlack),
                                              fontSize: textMedium,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w300),
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        TextFormField(
                                          controller: _nrpController,
                                          validator: _validatorNrp,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                borderSide: const BorderSide(
                                                    color: Colors.transparent,
                                                    width: 0)),
                                            focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                borderSide: const BorderSide(
                                                    color: Colors.black,
                                                    width: 1)),
                                            enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                borderSide: const BorderSide(
                                                    color: Colors.grey,
                                                    width: 0)),
                                            constraints: BoxConstraints(
                                                maxHeight: _maxHeight),
                                            filled: true,
                                            fillColor: const Color(
                                                secondaryBackground),
                                            hintText: 'Masukkan NRP Anda',
                                            hintStyle: TextStyle(
                                              fontSize: textSmall,
                                              fontFamily: 'Poppins',
                                              color:
                                                  const Color(textPlaceholder),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: sizedBoxHeightTall),
                                        Text(
                                          'Password : ',
                                          style: TextStyle(
                                              color: const Color(primaryBlack),
                                              fontSize: textMedium,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w300),
                                        ),
                                        SizedBox(
                                          height: sizedBoxHeightShort,
                                        ),
                                        TextFormField(
                                          controller: _passController,
                                          obscureText: _obscureText,
                                          validator: _validatorPassword,
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  borderSide: const BorderSide(
                                                      color: Colors.transparent,
                                                      width: 0)),
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  borderSide: const BorderSide(
                                                      color: Colors.black,
                                                      width: 1)),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                borderSide: const BorderSide(
                                                    color: Colors.grey,
                                                    width: 0),
                                              ),
                                              constraints: BoxConstraints(
                                                  maxHeight: _maxHeightPass),
                                              filled: true,
                                              fillColor: const Color(
                                                  secondaryBackground),
                                              hintText:
                                                  'Masukkan Password Anda',
                                              hintStyle: TextStyle(
                                                fontSize: textSmall,
                                                fontFamily: 'Poppins',
                                                color: const Color(
                                                    textPlaceholder),
                                              ),
                                              suffixIcon: IconButton(
                                                  onPressed: _showPassword,
                                                  icon: Icon(_obscureText
                                                      ? Icons.visibility
                                                      : Icons.visibility_off))),
                                        ),
                                        SizedBox(height: sizedBoxHeightTall),
                                        SizedBox(
                                          width: double.infinity,
                                          height: 50,
                                          child: ElevatedButton(
                                            onPressed: _signIn,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color(primaryYellow),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            child: Text(
                                              'Login',
                                              style: TextStyle(
                                                  color:
                                                      const Color(primaryBlack),
                                                  fontSize: textMedium,
                                                  fontFamily: 'Poppins',
                                                  letterSpacing: 0.9,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    ]),
              ),
      ),
    );
  }
}
