import 'dart:async';
import 'dart:developer';

import 'package:expandable/expandable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:your_rights/Data/models/article_model.dart';
import 'package:your_rights/Logic/Blocs/explore/explore_bloc.dart';
import 'package:your_rights/Logic/Blocs/last_seen/last_seen_bloc.dart';
import 'package:your_rights/Logic/Routing/routing_consts.dart';
import 'package:your_rights/constants/interface/ui_colors.dart';
import 'package:your_rights/constants/interface/ui_styles.dart';

class ExploreView extends StatefulWidget {
  const ExploreView({super.key});

  @override
  State<ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends State<ExploreView> {
  @override
  void initState() {
    context
        .read<ExploreBloc>()
        .add(ExploreGetArticlesFromDatabase(userSearch: "", userTags: []));
    super.initState();
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

      Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          primary: false,
          appBar: AppBar(
            //TODO: implement a way to sign out
            backgroundColor: Colors.transparent,
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
            centerTitle: true,
            title: Text(
              "تصفح",
              style: MyAppUiStyles.TitleTextStyle,
            ),
          ),
          extendBodyBehindAppBar: true,
          body: SingleChildScrollView(
            child: Column(
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
                BlocConsumer<ExploreBloc, ExploreState>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    return MainContent();
                  },
                ),
              ],
            ),
          ))
    ]);

    //! END Gradient To make Text Readable
  }
}

class MainContent extends StatefulWidget {
  MainContent({super.key});

  @override
  State<MainContent> createState() => _MainContentState();
}

class _MainContentState extends State<MainContent> {
  TextEditingController searchController = TextEditingController();
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Timer? _debounceSearch;
  final searchAfterDuration = Duration(milliseconds: 500);

  final Map<String, bool> tags = {
    "الضرائب": false,
    "العمل": false,
    "الاجور": false,
    "الطلاق": false,
    "الميراث": false,
    "الديون": false,
    "المرأة": false,
    "الملكية": false,
    "الصحة": false,
  };
  final Map<String, List<String>> systemTags = {
    "الضرائب": ["taxes"],
    "العمل": ["work", "fired"],
    "الاجور": ["wage"],
    "الطلاق": ["divorce"],
    "الميراث": ["inheritance"],
    "الديون": ["debts"],
    "المرأة": ["women"],
    "الملكية": ["property"],
    "الصحة": ["health"],
  };
  void sendSearchUpdate() {
    List<String> userTags = [];
    tags.forEach((key, value) {
      if (value) {
        systemTags[key]!.forEach((element) {
          userTags.add(element);
        });
      }
    });
    context.read<ExploreBloc>().add(ExploreGetArticlesFromDatabase(
        userSearch: searchController.text, userTags: userTags));
  }

  @override
  Widget build(BuildContext context) {
    ExploreState state = context.read<ExploreBloc>().state;
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    List<Widget> choiceChips = [];
    for (var tag in tags.keys) {
      choiceChips.add(ChoiceChip(
        backgroundColor: MyAppColors.secondaryColor,
        selectedColor: MyAppColors.primaryColor,
        showCheckmark: false,
        label: Text(
          tag,
          style: MyAppUiStyles.TitleTextStyle.copyWith(fontSize: 14),
        ),
        avatar: Icon(
          Icons.search,
          size: 20,
        ),
        selected: tags[tag]!,
        onSelected: (bool selected) {
          tags[tag] = selected;
          sendSearchUpdate();
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        labelPadding: const EdgeInsets.all(4),
      ));
    }

    List<Widget> articlesToBeDisplayed = [];
    if (state is ExploreLoaded) {
      for (var article in state.articles) {
        articlesToBeDisplayed.add(ArticleWidget(
          screenHeight: screenHeight,
          screenWidth: screenWidth,
          article: article,
          lastSeenBloc: context.read<LastSeenBloc>(),
        ));
        articlesToBeDisplayed.add(SizedBox(
          height: 8,
        ));
      }
    } else if (state is ExploreLoading) {
      articlesToBeDisplayed.add(Center(
        child: LoadingAnimationWidget.hexagonDots(
            color: MyAppColors.secondaryColor, size: 50),
      ));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        //! Search Bar
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SearchBar(
            controller: searchController,
            onChanged: (value) {
              if (_debounceSearch != null) {
                _debounceSearch!.cancel();
              }
              _debounceSearch = Timer(searchAfterDuration, () {
                log("TIMER RAN");
                sendSearchUpdate();
              });
            },
            leading: Icon(
              Icons.search,
              color: Colors.black,
              size: 30,
            ),
            textStyle: MaterialStateProperty.all(GoogleFonts.rubik(
                textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Colors.white))),
            hintText: "ابحث عن موضوع...",
            hintStyle: MaterialStateProperty.all(GoogleFonts.rubik(
                textStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withAlpha(200)))),
            backgroundColor:
                MaterialStateProperty.all(Color.fromARGB(237, 165, 187, 202)),
          ),
        ),
        //! End Search Bar
        SizedBox(
          width: screenWidth,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "المواضيع",
            style: MyAppUiStyles.TitleTextStyle,
          ),
        ),
        Column(
          children: [
            Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: screenWidth,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        direction: Axis.horizontal,
                        children: [
                          ...choiceChips,
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: screenWidth * 0.03, right: screenWidth * 0.03),
              child: Divider(
                color: Colors.grey.withAlpha(200),
              ),
            ),
            //!Articles
            ...articlesToBeDisplayed,
            //! END Articles
          ],
        ),
      ],
    );
  }
}

class ArticleWidget extends StatefulWidget {
  final double screenHeight;
  final double screenWidth;
  final ArticleModel article;
  final LastSeenBloc lastSeenBloc;
  const ArticleWidget(
      {super.key,
      required this.screenHeight,
      required this.screenWidth,
      required this.article,
      required this.lastSeenBloc});

  @override
  State<ArticleWidget> createState() => _ArticleWidgetState();
}

class _ArticleWidgetState extends State<ArticleWidget> {
  final ExpandableController controller = ExpandableController();

  @override
  void initState() {
    controller.addListener(() {
      widget.lastSeenBloc.add(LastSeenUpdateLastSeen(widget.article));
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
              child: Text(
                widget.article.title,
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
                width: widget.screenWidth * 0.85,
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
