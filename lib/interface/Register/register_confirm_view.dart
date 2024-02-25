import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:your_rights/Data/models/user_model.dart';
import 'package:your_rights/Logic/Blocs/Authentication/authentication_bloc.dart';
import 'package:your_rights/Logic/Blocs/register/register_bloc.dart';
import 'package:your_rights/Logic/Routing/routing_consts.dart';
import 'package:your_rights/constants/interface/ui_colors.dart';
import 'package:your_rights/constants/interface/ui_styles.dart';
import 'package:your_rights/constants/interface/ui_text.dart';
import 'package:your_rights/constants/interface/my_widgets.dart';

class RegisterConfirmView extends StatefulWidget {
  const RegisterConfirmView({super.key});

  @override
  State<RegisterConfirmView> createState() => _RegisterConfirmViewState();
}

class _RegisterConfirmViewState extends State<RegisterConfirmView> {
  void ContinueButtonPressed() {
    context.read<RegisterBloc>().add(RegisterCheckEmailConfirmed());
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return BlocConsumer<RegisterBloc, RegisterState>(
        listener: (context, state) {
      context.loaderOverlay.hide();
      if (state is RegisterConfirmEmailConfirmed) {
        log("==========Email Confirmed==========");
        MyAppUser user = context.read<AuthenticationBloc>().state.user;
        user = user.copyWith(
          confirmedEmail: true,
        );
        context.read<RegisterBloc>().add(RegisterDataUpdate(user: user));
      } else if (state is RegisterConfirmEmailNotConfirmed) {
        log("==========Email Not Confirmed==========");
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor: MyAppColors.accentColor,
                title: Text(
                  "تنبيه",
                  style: GoogleFonts.rubik(
                      textStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.yellow)),
                  textAlign: TextAlign.center,
                ),
                content: Text(
                  "لم يتم تأكيد البريد الإلكتروني بعد",
                  style: GoogleFonts.rubik(
                      textStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: Colors.white)),
                  textAlign: TextAlign.center,
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      context.pop();
                    },
                    child: Text(
                      "حسنا",
                      style: GoogleFonts.rubik(
                          textStyle: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.white)),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              );
            });
      } else if (state is RegisterDateUpdateSuccess) {
        context.pushNamed(RoutingNames.REGISTER_DATA.name,
            extra: context.read<RegisterBloc>());
      }
    }, builder: (context, state) {
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
                          bottom: screenHeight * 0.02),
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
                    //! Email Sent Illustration
                    Center(
                      child: SvgPicture.asset(
                        'assets/SVG/email_confirm.svg',
                        width: screenWidth * 0.9,
                        height: screenWidth * 0.9,
                      ),
                    ),
                    //! END Email Sent Illustration
                    SizedBox(height: screenHeight * 0.01),
                    //! Email Sent Text
                    Text(
                      MyAppLanguage.weSentConfirmation,
                      style: MyAppUiStyles.bottomTitleTextStyle,
                    ),
                    Text(
                      context.read<AuthenticationBloc>().state.user.email,
                      style: MyAppUiStyles.bottomClickableTextStyle.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      MyAppLanguage.pleaseCheck,
                      style: MyAppUiStyles.bottomTitleTextStyle,
                      textAlign: TextAlign.center,
                    ),
                    //! END Email Sent Text
                    SizedBox(height: screenHeight * 0.02),
                    //! Continue Button
                    InkWell(
                      onTap: ContinueButtonPressed,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: MyAppColors.secondaryColor,
                        ),
                        width: screenWidth * 0.9,
                        height: screenHeight * 0.06,
                        child: Center(
                          child: Text(
                            MyAppLanguage.continueText,
                            style: MyAppUiStyles.dataInputTitleTextStyle,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    //! END Continue Button
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              //! Something Went Wrong?
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(MyAppLanguage.somethingWentWrong,
                        style: MyAppUiStyles.bottomTitleTextStyle),
                    InkWell(
                      child: UnderlineText(
                        textWidget: Text(MyAppLanguage.goBack,
                            style: MyAppUiStyles.bottomClickableTextStyle),
                      ),
                      onTap: () {
                        context.pop();
                      },
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              )
              //! END Something Went Wrong?
            ],
          ));
    });
  }
}
