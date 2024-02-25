import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:your_rights/Logic/Blocs/login/login_bloc.dart';
import 'package:your_rights/Logic/Routing/routing_consts.dart';
import 'package:your_rights/constants/interface/ui_colors.dart';
import 'package:your_rights/constants/interface/ui_styles.dart';
import 'package:your_rights/constants/interface/ui_text.dart';
import 'package:your_rights/constants/interface/my_widgets.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void loginButtonPressed() {
    if (_formKey.currentState!.validate()) {
      context.read<LoginBloc>().add(LoginRequested(
          email: _emailController.text, password: _passwordController.text));
    }
  }

  @override
  Widget build(BuildContext context) {
    var Width = MediaQuery.of(context).size.width;
    var Height = MediaQuery.of(context).size.height;
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginLoading) {
          context.loaderOverlay.show();
        } else {
          context.loaderOverlay.hide();
        }

        if (state is LoginSuccess) {
          context.goNamed(RoutingNames.HOME.name);
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
                    //! Lady Justice Illustration
                    Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: Height * 0.05),
                        child: SvgPicture.asset(
                          'assets/SVG/lady_justice.svg',
                          width: Width * 0.7,
                          height: Width * 0.7,
                        ),
                      ),
                    ),
                    SizedBox(height: Height * 0.01),
                    //! Login Form
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
                            width: Width * 0.9,
                            //height: textBoxHeight,
                            child: TextFormField(
                              textDirection: TextDirection.rtl,
                              keyboardType: TextInputType.emailAddress,
                              controller: _emailController,
                              textAlignVertical: TextAlignVertical.center,
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
                            width: Width * 0.9,

                            //height: textBoxHeight,
                            child: TextFormField(
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: true,
                              textDirection: TextDirection.rtl,
                              controller: _passwordController,
                              textAlignVertical: TextAlignVertical.center,
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
                          const SizedBox(height: 30),
                          //! Login Button
                          InkWell(
                            onTap: loginButtonPressed,
                            child: Container(
                              decoration: BoxDecoration(
                                color: MyAppColors.secondaryColor,
                              ),
                              width: Width * 0.9,
                              height: Height * 0.07,
                              child: Center(
                                child: Text(
                                  MyAppLanguage.login,
                                  style: MyAppUiStyles.dataInputTitleTextStyle,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                          //! END Login Button
                        ],
                      ),
                    ),

                    const SizedBox(height: 15),
                    Divider(
                      color: Colors.grey,
                      thickness: 1,
                      indent: Width * 0.1,
                      endIndent: Width * 0.1,
                    ),
                    const SizedBox(height: 5),
                    Column(
                      children: [
                        Text(MyAppLanguage.dontHaveAnAccount,
                            style: MyAppUiStyles.bottomTitleTextStyle),
                        InkWell(
                          child: UnderlineText(
                            textWidget: Text(MyAppLanguage.createAccount,
                                style: MyAppUiStyles.bottomClickableTextStyle),
                          ),
                          onTap: () {
                            context.pushNamed(RoutingNames.REGISTER.name);
                          },
                        ),
                      ],
                    )
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
