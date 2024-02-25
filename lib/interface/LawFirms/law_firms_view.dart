import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:your_rights/Data/models/law_firm_model.dart';
import 'package:your_rights/Data/repositories/firebase_repo.dart';
import 'package:your_rights/Logic/Blocs/law_firms/law_firms_bloc.dart';
import 'package:your_rights/Logic/Routing/routing_consts.dart';
import 'package:your_rights/constants/interface/ui_colors.dart';
import 'package:your_rights/constants/interface/ui_styles.dart';

class LawFirmsView extends StatefulWidget {
  const LawFirmsView({super.key});

  @override
  State<LawFirmsView> createState() => _LawFirmsViewState();
}

class _LawFirmsViewState extends State<LawFirmsView> {
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
              "مكاتب محاماة",
              style: MyAppUiStyles.TitleTextStyle,
            ),
          ),
          extendBodyBehindAppBar: true,
          body: BlocConsumer<LawFirmsBloc, LawFirmsState>(
            listener: (context, state) {},
            builder: (context, state) {
              List<Widget> lawFirmsWidgets = [];
              if (state is LawFirmsLoading) {
                lawFirmsWidgets.add(const Center(
                  child: CircularProgressIndicator(),
                ));
              } else if (state is LawFirmsRetrieved) {
                state.lawFirms.forEach((element) {
                  lawFirmsWidgets.add(LawFirmWidget(lawFirm: element));
                  lawFirmsWidgets.add(const SizedBox(height: 20));
                });
              } else if (state is LawFirmsFailed) {
                lawFirmsWidgets.add(Center(
                  child: Text(
                    "Failed to retrieve Law Firms",
                    style: MyAppUiStyles.TitleTextStyle,
                  ),
                ));
              }

              return SingleChildScrollView(
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

                    ...lawFirmsWidgets,
                  ],
                ),
              );
            },
          ))
    ]);
  }
}

class LawFirmWidget extends StatelessWidget {
  final LawFirm lawFirm;
  const LawFirmWidget({super.key, required this.lawFirm});

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Container(
      width: screenWidth * 0.9,
      height: screenHeight * 0.18,
      decoration: BoxDecoration(
        color: MyAppColors.secondaryColor.withAlpha(150),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(
              Icons.corporate_fare,
              color: Colors.black,
              size: 60,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  lawFirm.name,
                  style: GoogleFonts.rubik(
                      textStyle: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: Colors.white)),
                ),
                const SizedBox(height: 6),
                Text(
                  lawFirm.location,
                  style: GoogleFonts.rubik(
                      textStyle: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withAlpha(200))),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.phone,
                      color: MyAppColors.primaryColor,
                      size: 25,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      lawFirm.telephone,
                      style: GoogleFonts.rubik(
                          textStyle: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.white)),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
