import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:your_rights/Data/models/user_model.dart';
import 'package:your_rights/Logic/Blocs/register/register_bloc.dart';
import 'package:your_rights/Logic/Routing/routing_consts.dart';
import 'package:your_rights/constants/interface/ui_colors.dart';
import 'package:your_rights/constants/interface/ui_styles.dart';
import 'package:your_rights/constants/interface/ui_text.dart';
import 'package:your_rights/constants/interface/my_widgets.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  void registerButtonPressed() {
    if (_formKey.currentState!.validate()) {
      log("Register Button Pressed");
      MyAppUser myUser = MyAppUser.empty();
      myUser = myUser.copyWith(
        userID: "",
        email: _emailController.text,
      );

      context.read<RegisterBloc>().add(RegisterRequested(
            user: myUser,
            password: _passwordController.text,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    var textBoxWidth = screenWidth * 0.9;
    // var textBoxHeight = screenHeight * 0.060;
    return BlocConsumer<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state is RegisterLoading) {
          context.loaderOverlay.show();
        } else {
          context.loaderOverlay.hide();
        }
        if (state is RegisterSuccess) {
          context.read<RegisterBloc>().add(RegisterSendEmailConfirm());
          context.pushNamed(RoutingNames.REGISTER_CONIFRM_EMAIL.name,
              extra: context.read<RegisterBloc>());
        }
      },
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          primary: false,
          body: Stack(
            children: [
              //!Blurry Background
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/blurry_background2.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              //! END Blurry Background

              //!Gradient To make Text Readable
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.center,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.8),
                    ],
                  ),
                ),
              ),
              //! END Gradient To make Text Readable
              SingleChildScrollView(
                child: Column(
                  children: [
                    //! Title
                    Padding(
                      padding: EdgeInsets.only(
                          top: screenHeight * 0.07,
                          right: screenWidth * 0.05,
                          bottom: screenHeight * 0.1),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          MyAppLanguage.createAccount,
                          style: GoogleFonts.rubik(
                              textStyle: const TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white)),
                          textDirection: TextDirection.rtl,
                        ),
                      ),
                    ),
                    //! END Title
                    SizedBox(height: screenHeight * 0.01),
                    //! Register Form
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          //! Email Input
                          Text(
                            ": ${MyAppLanguage.enterEmail}",
                            style: MyAppUiStyles.dataInputTitleTextStyle,
                            textAlign: TextAlign.right,
                          ),
                          const SizedBox(height: 5),
                          Container(
                            width: textBoxWidth,
                            //height: textBoxHeight,
                            child: TextFormField(
                              textDirection: TextDirection.rtl,
                              controller: _emailController,
                              textAlignVertical: TextAlignVertical.center,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: MyAppLanguage.enterEmail,
                                hintStyle: MyAppUiStyles.dataInputHintTextStyle,
                                hintTextDirection: TextDirection.rtl,
                                suffixIcon: const Icon(Icons.email),
                                isCollapsed: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      MyAppUiStyles.borderRadius),
                                ),
                              ),
                              validator: (value) {
                                value ??= "";
                                // Regex for email validation
                                String pattern =
                                    r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$';
                                RegExp regex = new RegExp(pattern);
                                if (!regex.hasMatch(value)) {
                                  return MyAppLanguage.enterValidEmail;
                                }
                                return null;
                              },
                            ),
                          ),
                          //! END Email Input
                          const SizedBox(height: 10),
                          //! Password Input
                          Text(
                            ": ${MyAppLanguage.enterPassword}",
                            style: MyAppUiStyles.dataInputTitleTextStyle,
                            textAlign: TextAlign.right,
                          ),
                          const SizedBox(height: 5),
                          Container(
                            width: textBoxWidth,
                            //height: textBoxHeight,
                            child: TextFormField(
                              controller: _passwordController,
                              textAlignVertical: TextAlignVertical.center,
                              textDirection: TextDirection.rtl,
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: true,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: MyAppLanguage.enterPassword,
                                hintStyle: MyAppUiStyles.dataInputHintTextStyle,
                                hintTextDirection: TextDirection.rtl,
                                suffixIcon: const Icon(Icons.lock),
                                isCollapsed: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      MyAppUiStyles.borderRadius),
                                ),
                              ),
                              validator: (value) {
                                value ??= "";
                                if (value.length < 8) {
                                  return MyAppLanguage.enterValidPassword;
                                }
                                return null;
                              },
                            ),
                          ),
                          //! END Password Input
                          const SizedBox(height: 10),
                          //! Confirm Password Input
                          Text(
                            ": ${MyAppLanguage.confirmEnterPassword}",
                            style: MyAppUiStyles.dataInputTitleTextStyle,
                            textAlign: TextAlign.right,
                          ),
                          Container(
                            width: textBoxWidth,
                            //height: textBoxHeight,
                            child: TextFormField(
                              controller: _confirmPasswordController,
                              textAlignVertical: TextAlignVertical.center,
                              textDirection: TextDirection.rtl,
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: true,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: MyAppLanguage.confirmEnterPassword,
                                hintStyle: MyAppUiStyles.dataInputHintTextStyle,
                                hintTextDirection: TextDirection.rtl,
                                suffixIcon: const Icon(Icons.lock),
                                isCollapsed: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      MyAppUiStyles.borderRadius),
                                ),
                              ),
                              validator: (value) {
                                value ??= "";
                                if (value != _passwordController.text) {
                                  return MyAppLanguage.passwordNotMatch;
                                }
                                return null;
                              },
                            ),
                          ),
                          //! END Confirm Password Input
                          const SizedBox(height: 30),
                          //! Register Button
                          InkWell(
                            onTap: registerButtonPressed,
                            child: Container(
                              decoration: const BoxDecoration(
                                color: MyAppColors.secondaryColor,
                              ),
                              width: screenWidth * 0.9,
                              height: screenHeight * 0.06,
                              child: Center(
                                child: Text(
                                  MyAppLanguage.createAccount,
                                  style: MyAppUiStyles.dataInputTitleTextStyle,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                          //! END Register Button
                        ],
                      ),
                    ),

                    const SizedBox(height: 5),
                    Divider(
                      color: Colors.grey,
                      thickness: 1,
                      indent: screenWidth * 0.1,
                      endIndent: screenWidth * 0.1,
                    ),
                    const SizedBox(height: 5),
                    //! Have an Account?
                    Column(
                      children: [
                        Text(MyAppLanguage.haveAnAccount,
                            style: MyAppUiStyles.bottomTitleTextStyle),
                        InkWell(
                          child: UnderlineText(
                            textWidget: Text(MyAppLanguage.login,
                                style: MyAppUiStyles.bottomClickableTextStyle),
                          ),
                          onTap: () {
                            context.goNamed(RoutingNames.LOGIN.name);
                          },
                        ),
                        const SizedBox(height: 15),
                      ],
                    )
                    //! END Have an Account?
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
