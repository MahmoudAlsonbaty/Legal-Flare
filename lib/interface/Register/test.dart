import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:your_rights/constants/interface/ui_colors.dart';
import 'package:your_rights/constants/interface/ui_styles.dart';
import 'package:your_rights/constants/interface/ui_text.dart';

class testScreen extends StatefulWidget {
  const testScreen({super.key});

  @override
  State<testScreen> createState() => _testScreenState();
}

class _testScreenState extends State<testScreen> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var textBoxWidth = screenWidth * 0.9;
    return Scaffold(
        backgroundColor: MyAppColors.accentColor,
        body: Padding(
          padding: const EdgeInsets.only(top: 80.0),
          child: Center(
            child: Form(
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
                        // height: textBoxHeight,
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          selectionHeightStyle: BoxHeightStyle.max,
                          textAlignVertical: TextAlignVertical.center,
                          textDirection: TextDirection.rtl,
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
                            if (value == null || value.isEmpty) {
                              return "";
                            }
                            // Regex for email validation
                            String pattern =
                                r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$';
                            RegExp regex = new RegExp(pattern);
                            if (!regex.hasMatch(value)) {
                              return 'Enter a valid email';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Processing Data')));
                            }
                          },
                          child: Text("Submit")),
                    ])),
          ),
        ));
    //! END Email Input);
  }
}
