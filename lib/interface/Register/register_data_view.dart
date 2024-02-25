import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

class RegisterDataView extends StatefulWidget {
  const RegisterDataView({super.key});

  @override
  State<RegisterDataView> createState() => _RegisterDataViewState();
}

class _RegisterDataViewState extends State<RegisterDataView> {
  final TextEditingController _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  String? _selectedJob = MyAppLanguage.jobs[0];
  String? _selectedStatus = MyAppLanguage.maritalStatuses[0];

  void ContinueButtonPressed() {
    MyAppUser user = context.read<AuthenticationBloc>().state.user;
    user = user.copyWith(
        confirmedEmail: true,
        name: _nameController.text,
        dateOfBirth: _selectedDate,
        maritalStatus: _selectedStatus,
        jobStatus: _selectedJob);
    context.read<RegisterBloc>().add(RegisterDataUpdate(user: user));
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    var textBoxWidth = screenWidth * 0.9;
    return BlocConsumer<RegisterBloc, RegisterState>(
        listener: (context, state) {
      if (state is RegisterLoading) {
        context.loaderOverlay.show();
      } else {
        context.loaderOverlay.hide();
      }
      if (state is RegisterDateUpdateSuccess) {
        context.goNamed(RoutingNames.HOME.name);
      } else if (state is RegisterDataUpdateFailure) {
        //!TODO: Show Error Message
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
                    //! Data Input
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          //! Name
                          Text(
                            ": ${MyAppLanguage.name}",
                            style: MyAppUiStyles.dataInputTitleTextStyle,
                            textAlign: TextAlign.right,
                          ),
                          const SizedBox(height: 5),
                          Container(
                            width: textBoxWidth,
                            child: TextFormField(
                              textDirection: TextDirection.rtl,
                              controller: _nameController,
                              textAlignVertical: TextAlignVertical.center,
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: MyAppLanguage.name,
                                hintStyle: MyAppUiStyles.dataInputHintTextStyle,
                                hintTextDirection: TextDirection.rtl,
                                suffixIcon: const Icon(Icons.person),
                                isCollapsed: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      MyAppUiStyles.borderRadius),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return MyAppLanguage.enterName;
                                }
                                return null;
                              },
                            ),
                          ),
                          //! END Name
                          SizedBox(height: screenHeight * 0.01),
                          //! Date Of Birth
                          Text(
                            ": ${MyAppLanguage.dateOfBirth}",
                            style: MyAppUiStyles.dataInputTitleTextStyle,
                            textAlign: TextAlign.right,
                          ),
                          const SizedBox(height: 5),
                          Container(
                            width: textBoxWidth,
                            child: TextFormField(
                              onTap: () {
                                showDatePicker(
                                  context: context,
                                  initialDate: DateTime(2002),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime(2008),
                                ).then((value) {
                                  log("DATE SELECTED: ");
                                  _selectedDate = value;
                                  if (value != null) {
                                    context.read<RegisterBloc>().add(
                                        RegisterUpdateUI(
                                            data: dateToString(value)!));
                                  } else {
                                    context.read<RegisterBloc>().add(
                                        RegisterUpdateUI(
                                            data: MyAppLanguage.dateOfBirth));
                                  }
                                });
                              },
                              textDirection: TextDirection.rtl,
                              readOnly: true,
                              textAlignVertical: TextAlignVertical.center,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: dateToString(_selectedDate) ??
                                    MyAppLanguage.dateOfBirth,
                                hintStyle: MyAppUiStyles.dataInputHintTextStyle,
                                hintTextDirection: TextDirection.rtl,
                                suffixIcon:
                                    const Icon(Icons.edit_calendar_outlined),
                                isCollapsed: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      MyAppUiStyles.borderRadius),
                                ),
                              ),
                              validator: (value) {
                                //TODO: VALIDATE DATE
                                if (value == null || value.isEmpty) {
                                  return "";
                                }
                                return null;
                              },
                            ),
                          ),
                          //! END Date Of Birth
                          SizedBox(height: screenHeight * 0.01),
                          //! Job
                          Text(
                            ": ${MyAppLanguage.job}",
                            style: MyAppUiStyles.dataInputTitleTextStyle,
                            textAlign: TextAlign.right,
                          ),
                          const SizedBox(height: 5),
                          //TODO: fix the height issue
                          //TODO: fix the text direction issue
                          Container(
                            width: textBoxWidth,
                            child: DropdownButtonFormField(
                              icon: Icon(null),
                              value: _selectedJob,
                              items: MyAppLanguage.jobs
                                  .map((item) => DropdownMenuItem(
                                        child: Text(item),
                                        value: item,
                                      ))
                                  .toList(),
                              decoration: InputDecoration(
                                suffixIcon:
                                    Icon(Icons.keyboard_arrow_down_sharp),
                                filled: true,
                                fillColor: Colors.white,
                                hintText: _selectedJob ?? "",
                                hintStyle: MyAppUiStyles.dataInputHintTextStyle,
                                hintTextDirection: TextDirection.rtl,

                                // isCollapsed: true
                                isDense: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      MyAppUiStyles.borderRadius),
                                ),
                              ),
                              onChanged: (value) {
                                log("JOB SELECTED: $value");
                                _selectedJob = value;
                              },
                            ),
                          ),
                          //! END Job
                          SizedBox(height: screenHeight * 0.01),

                          //! Marital Status
                          Text(
                            ": ${MyAppLanguage.maritalStatus}",
                            style: MyAppUiStyles.dataInputTitleTextStyle,
                            textAlign: TextAlign.right,
                          ),
                          const SizedBox(height: 5),
                          //TODO: fix the height issue
                          //TODO: fix the text direction issue
                          Container(
                            width: textBoxWidth,
                            child: DropdownButtonFormField(
                              icon: Icon(null),
                              value: _selectedStatus,
                              items: MyAppLanguage.maritalStatuses
                                  .map((item) => DropdownMenuItem(
                                        child: Text(item),
                                        value: item,
                                      ))
                                  .toList(),
                              decoration: InputDecoration(
                                suffixIcon:
                                    Icon(Icons.keyboard_arrow_down_sharp),
                                filled: true,
                                fillColor: Colors.white,
                                hintText: _selectedStatus ?? "",
                                hintStyle: MyAppUiStyles.dataInputHintTextStyle,
                                hintTextDirection: TextDirection.rtl,

                                // isCollapsed: true
                                isDense: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      MyAppUiStyles.borderRadius),
                                ),
                              ),
                              onChanged: (value) {
                                log("Status SELECTED: $value");
                                _selectedStatus = value;
                              },
                            ),
                          ),
                          //! END Marital Status
                          SizedBox(height: screenHeight * 0.03),
                        ],
                      ),
                    ),

                    //! END Data Input
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
