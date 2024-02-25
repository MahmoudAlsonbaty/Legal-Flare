import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:your_rights/Data/repositories/firebase_repo.dart';
import 'package:your_rights/Logic/Blocs/Authentication/authentication_bloc.dart';
import 'package:your_rights/Logic/Routing/router.dart';
import 'package:your_rights/constants/interface/ui_colors.dart';
import 'package:your_rights/constants/interface/ui_styles.dart';
import 'package:your_rights/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  //This is for testing purposes, remove it before production and test it
  try {
    await FirebaseAuth.instance.currentUser?.reload();
  } catch (e) {}
  Bloc.observer = SimpleBlocObserver();
  final FirebaseRepository _firebaseRepository = FirebaseRepository();
  runApp(MultiBlocProvider(
      providers: [
        BlocProvider(
          lazy: false,
          create: (context) =>
              AuthenticationBloc(firebaseRepository: _firebaseRepository),
        ),
      ],
      child: GlobalLoaderOverlay(
          useDefaultLoading: false,
          overlayColor: Colors.black.withOpacity(0.5),
          overlayWidgetBuilder: (progress) {
            String message = "";
            if (progress != null) {
              message = progress.toString();
            }
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LoadingAnimationWidget.halfTriangleDot(
                      color: MyAppColors.accentColor, size: 50),
                  const SizedBox(height: 20),
                  Text(
                    message,
                    style: MyAppUiStyles.TitleTextStyle.copyWith(fontSize: 20),
                  )
                ],
              ),
            );
          },
          child: const MyApp())));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Law',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
            primary: MyAppColors.primaryColor,
            secondary: MyAppColors.secondaryColor,
            tertiary: MyAppColors.accentColor),
        // colorScheme: ColorScheme(
        //     primary: MyAppColors.primaryColor,
        //     secondary: MyAppColors.secondaryColor,
        //     tertiary: MyAppColors.accentColor, brightness: Brightness.light, onPrimary: null),
        useMaterial3: true,
      ),
      routerConfig:
          MainRouter(authBloc: context.read<AuthenticationBloc>()).routes(),
    );
  }
}

class SimpleBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    log('\x1B[32mBloc Event: ${event.toString()}\x1B[32m',
        name: "${bloc.runtimeType}");
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    log('\x1B[32mBloc Transition: ${transition.toString()}\x1B[32m',
        name: "${bloc.runtimeType}");
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    log('\x1B[32mBloc Error: ${error.toString()}\x1B[32m',
        name: "${bloc.runtimeType}", error: error, stackTrace: stackTrace);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    log('\x1B[32mBloc Change: ${change.toString()}\x1B[32m',
        name: "${bloc.runtimeType}");
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    log('\x1B[32mBloc Close: ${bloc.toString()}\x1B[32m',
        name: "${bloc.runtimeType}");
  }

  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    log('\x1B[32mBloc Create: ${bloc.toString()}\x1B[32m',
        name: "${bloc.runtimeType}");
  }
}
