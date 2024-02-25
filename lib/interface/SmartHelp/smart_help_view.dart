import 'dart:async';
import 'dart:developer';

import 'package:after_layout/after_layout.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:your_rights/Logic/Blocs/last_seen/last_seen_bloc.dart';
import 'package:your_rights/Logic/Blocs/smart_help/smart_help_bloc.dart';
import 'package:your_rights/Logic/Routing/routing_consts.dart';
import 'package:your_rights/constants/interface/ui_colors.dart';
import 'package:your_rights/constants/interface/ui_styles.dart';

class SmartHelpView extends StatefulWidget {
  const SmartHelpView({super.key});

  @override
  State<SmartHelpView> createState() => _SmartHelpViewState();
}

class _SmartHelpViewState extends State<SmartHelpView>
    with AfterLayoutMixin<SmartHelpView> {
  final _searchController = TextEditingController();

  @override
  void afterFirstLayout(BuildContext context) {
    // Calling the same function "after layout" to resolve the issue.
    showDisclaimer();
  }

  void showDisclaimer() {
    bool accepted = false;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () => Future.value(false),
          child: StatefulBuilder(builder: (context, setStateBuilder) {
            return AlertDialog(
              icon: const Icon(Icons.warning, color: Colors.red, size: 50),
              contentPadding: const EdgeInsets.all(8),
              backgroundColor: Colors.white,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '!تنبيه',
                    textAlign: TextAlign.right,
                    style: GoogleFonts.rubik(
                        textStyle: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            color: Colors.red)),
                  ),
                  Text(
                    """Gemini API هذا البرنامج يستعمل
          لتحليل البيانات و البحث عن القوانين المتعلقة بالسؤال المطروح, برجاء عدم ادخال اي بيانات حساسة و قراءة الشروط و الاحكام الخاصة ب 
          GEMINI
                      """,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.rubik(
                        textStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black)),
                  ),
                  CheckboxListTile.adaptive(
                      contentPadding: EdgeInsets.all(0),
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text(
                        "لقد قرأت الشروط و اوافق",
                        style: GoogleFonts.rubik(
                            textStyle: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black)),
                      ),
                      value: accepted,
                      onChanged: (value) {
                        setStateBuilder(() {
                          accepted = value!;
                        });
                      }),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => context.goNamed(RoutingNames.HOME.name),
                  child: Text(
                    'لا اوافق',
                    style: GoogleFonts.rubik(
                        textStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.red)),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'المتابعة',
                    style: GoogleFonts.rubik(
                        textStyle: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: accepted ? Colors.blue : Colors.grey)),
                  ),
                ),
              ],
            );
          }),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Stack(children: [
      //!Blurry Background
      Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/blurry_background.png'),
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
      BlocConsumer<SmartHelpBloc, SmartHelpState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            primary: false,
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              toolbarHeight: screenHeight * 0.1,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  size: 30,
                  color: Colors.white,
                ),
                onPressed: () {
                  context.goNamed(RoutingNames.HOME.name);
                },
              ),
              title: Text(
                'المساعدة الذكية',
                style: MyAppUiStyles.TitleTextStyle,
              ),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            extendBodyBehindAppBar: true,
            // resizeToAvoidBottomInset: false,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                //!To go below the app bar
                SizedBox(
                  height: screenHeight * 0.11,
                  //This Width allows us to extend the column
                  width: screenWidth,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: screenWidth * 0.08, right: screenWidth * 0.08),
                  child: Divider(
                    color: Colors.grey.withAlpha(200),
                  ),
                ),

                //!Smart Help Main Container
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      child: MainContainer(),
                    ),
                  ),
                ),
                //! END Smart Help Main Container
                //! Smart Help Input Field
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Container(
                      width: screenWidth * 0.9,
                      height: screenHeight * 0.08,
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: state is SmartHelpLoading
                                    ? Colors.grey
                                    : MyAppColors.primaryColor,
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.arrow_upward_sharp,
                                  color: Colors.white,
                                  size: 25,
                                ),
                                onPressed: () {
                                  if (_searchController.text.isEmpty) {
                                    return;
                                  }
                                  if (state is SmartHelpLoading) {
                                    return;
                                  }
                                  context.read<SmartHelpBloc>().add(
                                      SmartHelpGetLaws(_searchController.text));
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  EdgeInsets.only(left: screenWidth * 0.05),
                              child: TextField(
                                controller: _searchController,
                                style: GoogleFonts.rubik(
                                    textStyle: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                )),
                                decoration: InputDecoration(
                                  hintText: 'اكتب سؤالك هنا...',
                                  hintStyle: GoogleFonts.rubik(
                                      textStyle: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey,
                                  )),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    ]);
  }
}

class MainContainer extends StatefulWidget {
  MainContainer({
    super.key,
  });

  @override
  State<MainContainer> createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer> {
  final List<ExpandableController> controllers = [];

  @override
  void initState() {
    super.initState();
    controllers.forEach((element) {
      element.addListener(() {
        log("Expanded : ${element.expanded}");
      });
    });
  }

  @override
  void dispose() {
    controllers.forEach((element) {
      element.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final widthAvailable = MediaQuery.of(context).size.width;
    final heightAvailable = MediaQuery.of(context).size.height;
    final smartHelpBloc = context.read<SmartHelpBloc>();
    Widget result;
    //! BEFORE ANYTHING
    if (smartHelpBloc.state is SmartHelpInitial) {
      result = Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(width: widthAvailable * 0.9),
        ],
      );

      //! WHEN LOADING
    } else if (smartHelpBloc.state is SmartHelpLoading) {
      final state = smartHelpBloc.state as SmartHelpLoading;
      result = Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(width: widthAvailable * 0.9),
          Padding(
            padding: const EdgeInsets.only(top: 16, right: 8),
            child: Container(
              decoration: const BoxDecoration(
                color: MyAppColors.accentColor,
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              padding:
                  const EdgeInsets.only(left: 20, top: 8, right: 8, bottom: 8),
              child: Text(
                state.userPrompt,
                textAlign: TextAlign.right,
                style: GoogleFonts.rubik(
                    textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                )),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8, left: 8),
                child: Container(
                    decoration: const BoxDecoration(
                      color: MyAppColors.primaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: LoadingAnimationWidget.staggeredDotsWave(
                        color: Colors.white, size: 30)),
              ),
            ],
          )
        ],
      );
      //! WHEN DATA IS RETRIEVED
    } else if (smartHelpBloc.state is SmartHelpDataRetrieved) {
      final state = smartHelpBloc.state as SmartHelpDataRetrieved;
      List<Widget> articleWidgets = [
        Padding(
          padding: const EdgeInsets.only(top: 16, right: 8),
          child: Container(
            // height: heightAvailable * 0.05,
            decoration: const BoxDecoration(
              color: MyAppColors.accentColor,
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            padding:
                const EdgeInsets.only(left: 20, top: 8, right: 8, bottom: 8),
            child: Text(
              state.userPrompt,
              textAlign: TextAlign.right,
              style: GoogleFonts.rubik(
                  textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              )),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ];

      for (var article in state.articles) {
        controllers.add(ExpandableController());
        controllers.last.addListener(() {
          context.read<LastSeenBloc>().add(LastSeenUpdateLastSeen(article));
        });
        articleWidgets.add(
          Row(
            children: [
              SizedBox(
                width: widthAvailable * 0.9,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: ExpandablePanel(
                    controller: controllers.last,
                    theme: const ExpandableThemeData(
                        hasIcon: false, useInkWell: false),
                    header: Container(
                      padding: EdgeInsets.all(12),
                      width: widthAvailable * 0.9,
                      decoration: const BoxDecoration(
                        color: MyAppColors.primaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      child: Center(
                        child: Text(
                          article.title,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.rubik(
                              textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          )),
                        ),
                      ),
                    ),
                    collapsed: const SizedBox(),
                    expanded: Center(
                      child: Container(
                          width: widthAvailable * 0.8,
                          decoration: const BoxDecoration(
                            color: MyAppColors.secondaryColor,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(15),
                                bottomRight: Radius.circular(15)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(article.body,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.rubik(
                                    textStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ))),
                          )),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
        //Add a space between each article
        articleWidgets.add(const SizedBox(height: 10));
      }
      result = Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [SizedBox(width: widthAvailable * 0.9), ...articleWidgets],
      );
    } else if (smartHelpBloc.state is SmartHelpError) {
      //TODO: implement the error case
      result = Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(width: widthAvailable * 0.9),
        ],
      );
    } else {
      result = Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(width: widthAvailable * 0.9),
        ],
      );
    }
    return SingleChildScrollView(child: result);
  }
}
