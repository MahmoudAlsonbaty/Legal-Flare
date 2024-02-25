import 'dart:developer';

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:your_rights/Data/models/article_model.dart';
import 'package:your_rights/Logic/Blocs/Authentication/authentication_bloc.dart';
import 'package:your_rights/Logic/Blocs/did_you_know/did_you_know_bloc.dart';
import 'package:your_rights/Logic/Blocs/last_seen/last_seen_bloc.dart';
import 'package:your_rights/Logic/Routing/routing_consts.dart';
import 'package:your_rights/constants/interface/my_widgets.dart';
import 'package:your_rights/constants/interface/ui_colors.dart';
import 'package:your_rights/constants/interface/ui_styles.dart';
import 'package:your_rights/constants/interface/ui_text.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      primary: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        toolbarHeight: screenHeight * 0.1,
        centerTitle: true,
        title: Text(
          "مرحبا ${context.read<AuthenticationBloc>().state.user.name}",
          //   Text(
          // "مرحبا د.الجيار",
          style: MyAppUiStyles.TitleTextStyle,
        ),
        actions: [
          IconButton(
            onPressed: () {
              context
                  .read<AuthenticationBloc>()
                  .add(AuthenticationLogoutRequested());
              // context.go(RoutingNames.LOGIN.name);
            },
            icon: const Icon(
              Icons.logout,
              size: 32,
            ),
          )
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
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
          SingleChildScrollView(
            child: Column(
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
                //! How Can we Help You?
                Padding(
                  padding: const EdgeInsets.only(right: 10, top: 8),
                  child: Text(
                    MyAppLanguage.howCanWeHelpYou,
                    style: MyAppUiStyles.TitleTextStyle,
                  ),
                ),
                //! END How Can we Help You?
                SizedBox(height: screenHeight * 0.01),
                //! Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //! Law Firm BUTTON
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          context.pushNamed(RoutingNames.LAWFIRMS.name);
                        },
                        child: Column(
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: MyAppColors.secondaryColor),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.call,
                                  color: Colors.white,
                                  size: 55,
                                ),
                              ),
                            ),
                            //TODO: findout why font isn't getting lighter
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                "مكاتب محاماة",
                                textAlign: TextAlign.center,
                                style: MyAppUiStyles.TitleTextStyle.copyWith(
                                    fontSize: 16, fontWeight: FontWeight.w100),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    //! END LAW FIRM BUTTON

                    //! Ai BUTTON
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          log("PRESSED SMART HELP");
                          context.pushNamed(RoutingNames.SMART_HELP.name);
                        },
                        child: Column(
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: MyAppColors.secondaryColor),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.question_mark,
                                  color: Colors.white,
                                  size: 55,
                                ),
                              ),
                            ),
                            //TODO: findout why font isn't getting lighter
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                "المساعدة الذكية",
                                textAlign: TextAlign.center,
                                style: MyAppUiStyles.TitleTextStyle.copyWith(
                                    fontSize: 16, fontWeight: FontWeight.w100),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    //! END Ai BUTTON
                    //! Explore BUTTON
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          context.pushNamed(RoutingNames.EXPLORE.name);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: MyAppColors.secondaryColor),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.search,
                                  color: Colors.white,
                                  size: 55,
                                ),
                              ),
                            ),
                            //TODO: findout why font isn't getting lighter
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                "تصفح",
                                style: MyAppUiStyles.TitleTextStyle.copyWith(
                                    fontSize: 16, fontWeight: FontWeight.w100),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    //! END Explore BUTTON
                  ],
                ),
                //! END Action Buttons
                SizedBox(height: screenHeight * 0.04),
                //! Did You Know
                Center(
                  child: BlocConsumer<DidYouKnowBloc, DidYouKnowState>(
                    listener: (context, state) {
                      log("Current State: ${state}",
                          name: "DidYouKnow Listener");
                    },
                    builder: (context, state) {
                      return Container(
                          width: screenWidth * 0.9,
                          height: screenHeight * 0.3,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: MyAppColors.secondaryColor),
                          padding: const EdgeInsets.all(10),
                          child: Stack(children: [
                            Builder(
                              builder: (context) {
                                if (state is DidYouKnowFactReceived) {
                                  return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        //TODO: there's probably a better way to do this, read the docs
                                        //! TO EXPAND THE COLUMN
                                        SizedBox(
                                          width: screenWidth * 0.9,
                                        ),
                                        Text(
                                          state.title,
                                          textAlign: TextAlign.right,
                                          style: MyAppUiStyles.TitleTextStyle,
                                        ),
                                        SizedBox(height: screenHeight * 0.02),
                                        Text(
                                          state.body,
                                          textAlign: TextAlign.right,
                                          maxLines: 6,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.rubik(
                                              textStyle: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.white
                                                      .withAlpha(220))),
                                        ),
                                      ]);
                                  // } else if (state is DidYouKnowFactError) {
                                } else {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              },
                            ),
                            //!Refresh button
                            InkWell(
                              onTap: () {
                                context
                                    .read<DidYouKnowBloc>()
                                    .add(DidYouKnowGetFact());
                              },
                              child: Align(
                                alignment: Alignment.bottomLeft,
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  // height: screenHeight * 0.01,
                                  decoration: BoxDecoration(
                                      color: MyAppColors.primaryColor,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Text(
                                    "تحديث",
                                    style:
                                        MyAppUiStyles.TitleTextStyle.copyWith(
                                            fontSize: 15),
                                  ),
                                ),
                              ),
                            )
                            //!END Refresh button
                          ]));
                    },
                  ),
                ),
                //! END Did You Know
                SizedBox(height: screenHeight * 0.01),
                Padding(
                  padding: EdgeInsets.only(
                      left: screenWidth * 0.05, right: screenWidth * 0.05),
                  child: Divider(
                    color: Colors.grey.withAlpha(200),
                  ),
                ),
                //!Previously Opened
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    MyAppLanguage.previouslyViewed,
                    style: MyAppUiStyles.TitleTextStyle,
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                BlocConsumer<LastSeenBloc, LastSeenState>(
                  listener: (context, state) {
                    log("Current State: ${state}", name: "LastSeen Listener");
                  },
                  builder: (context, state) {
                    if (state is LastSeenLoading) {
                      return Center(
                        child: LoadingAnimationWidget.hexagonDots(
                            color: MyAppColors.secondaryColor, size: 50),
                      );
                    }
                    if (state is LastSeenDataRetrieved) {
                      if (state.articles.isEmpty) {
                        return Center(
                          child: Text(
                            "لم تقم بقراءة أي مقالات بعد",
                            style: MyAppUiStyles.TitleTextStyle.copyWith(
                                fontSize: 15, color: Colors.grey),
                          ),
                        );
                      }
                      List<Widget> widgetsToRender = [];
                      state.articles.forEach((key, value) {
                        widgetsToRender.add(PreviouslySeenLawWidget(
                          article: key,
                          date: value.toDate(),
                          lastSeenBloc: context.read<LastSeenBloc>(),
                          screenHeight: screenHeight,
                          screenWidth: screenWidth,
                        ));
                        widgetsToRender
                            .add(SizedBox(height: screenHeight * 0.02));
                      });
                      return Column(
                        children: [...widgetsToRender],
                      );
                    }

                    return Center(
                      child: Text(
                        "حدث خطأ أثناء جلب المقالات السابقة",
                        style: MyAppUiStyles.TitleTextStyle.copyWith(
                            fontSize: 15, color: Colors.grey),
                      ),
                    );
                  },
                ),

                //!End Previously Opened
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PreviouslySeenLawWidget extends StatefulWidget {
  final double screenHeight;
  final double screenWidth;
  final ArticleModel article;
  final DateTime date;
  final LastSeenBloc lastSeenBloc;
  const PreviouslySeenLawWidget(
      {super.key,
      required this.screenHeight,
      required this.screenWidth,
      required this.article,
      required this.date,
      required this.lastSeenBloc});

  @override
  State<PreviouslySeenLawWidget> createState() =>
      _PreviouslySeenLawWidgetState();
}

class _PreviouslySeenLawWidgetState extends State<PreviouslySeenLawWidget> {
  final ExpandableController controller = ExpandableController();

  @override
  void initState() {
    controller.addListener(() {
      // widget.lastSeenBloc.add(LastSeenUpdateLastSeen(widget.article));
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: widget.screenWidth * 0.95,
        child: ExpandablePanel(
          controller: controller,
          theme: const ExpandableThemeData(hasIcon: false, useInkWell: false),
          header: Container(
            padding: EdgeInsets.all(12),
            width: widget.screenWidth * 0.9,
            decoration: const BoxDecoration(
              color: MyAppColors.secondaryColor,
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    dateToString(widget.date) ?? "",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.rubik(
                        textStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withAlpha(200),
                    )),
                  ),
                  Text(
                    widget.article.title,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.rubik(
                        textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    )),
                  ),
                ],
              ),
            ),
          ),
          collapsed: const SizedBox(),
          expanded: Center(
            child: Container(
                width: widget.screenWidth * 0.8,
                decoration: const BoxDecoration(
                  color: MyAppColors.accentColor,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(widget.article.body,
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
    );
  }
}
