import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:your_rights/Logic/Blocs/Authentication/authentication_bloc.dart';
import 'package:your_rights/Logic/Blocs/did_you_know/did_you_know_bloc.dart';
import 'package:your_rights/Logic/Blocs/explore/explore_bloc.dart';
import 'package:your_rights/Logic/Blocs/last_seen/last_seen_bloc.dart';
import 'package:your_rights/Logic/Blocs/law_firms/law_firms_bloc.dart';
import 'package:your_rights/Logic/Blocs/login/login_bloc.dart';
import 'package:your_rights/Logic/Blocs/register/register_bloc.dart';
import 'package:your_rights/Logic/Blocs/smart_help/smart_help_bloc.dart';
import 'package:your_rights/Logic/Routing/routing_consts.dart';
import 'package:your_rights/interface/Explore/explore_view.dart';
import 'package:your_rights/interface/Home/home_view.dart';
import 'package:your_rights/interface/LawFirms/law_firms_view.dart';
import 'package:your_rights/interface/Login/login_view.dart';
import 'package:your_rights/interface/Register/register_confirm_view.dart';
import 'package:your_rights/interface/Register/register_data_view.dart';
import 'package:your_rights/interface/Register/register_view.dart';
import 'package:your_rights/interface/SmartHelp/smart_help_view.dart';

class MainRouter {
  final AuthenticationBloc authBloc;
  MainRouter({required AuthenticationBloc authBloc}) : this.authBloc = authBloc;
  GoRouter routes() {
    return GoRouter(
      debugLogDiagnostics: true,
      //! Uncomment This after testing the Smart Help View
      initialLocation: "/",
      // initialLocation: "/SmartHelp",
      routes: [
        GoRoute(
          path: '/',
          name: RoutingNames.HOME.name,
          builder: (context, state) => MultiBlocProvider(providers: [
            BlocProvider<DidYouKnowBloc>(create: (context) {
              return DidYouKnowBloc()..add(DidYouKnowGetFromDatabase());
            }),
            BlocProvider<LastSeenBloc>(create: (context) {
              return LastSeenBloc(
                  context.read<AuthenticationBloc>().firebaseRepository,
                  context.read<AuthenticationBloc>())
                ..add(const LastSeenGetLastSeen());
            }),
          ], child: const HomeView()),
        ),
        GoRoute(
          path: '/lawFirms',
          name: RoutingNames.LAWFIRMS.name,
          builder: (context, state) => BlocProvider(
            create: (context) => LawFirmsBloc(
                context.read<AuthenticationBloc>().firebaseRepository)
              ..add(LawFirmsGetLawFirmsFromDatabase()),
            child: LawFirmsView(),
          ),
        ),
        GoRoute(
          path: '/SmartHelp',
          name: RoutingNames.SMART_HELP.name,
          builder: (context, state) => MultiBlocProvider(providers: [
            BlocProvider(
              create: (context) => SmartHelpBloc(
                  context.read<AuthenticationBloc>().firebaseRepository),
            ),
            BlocProvider<LastSeenBloc>(create: (context) {
              return LastSeenBloc(
                  context.read<AuthenticationBloc>().firebaseRepository,
                  context.read<AuthenticationBloc>());
            }),
          ], child: const SmartHelpView()),
        ),
        GoRoute(
          path: '/Explore',
          name: RoutingNames.EXPLORE.name,
          builder: (context, state) => MultiBlocProvider(providers: [
            // TODO: Add the blocs for the explore page
            BlocProvider(
              create: (context) => ExploreBloc(
                  context.read<AuthenticationBloc>().firebaseRepository),
            ),
            BlocProvider<LastSeenBloc>(create: (context) {
              return LastSeenBloc(
                  context.read<AuthenticationBloc>().firebaseRepository,
                  context.read<AuthenticationBloc>());
            }),
          ], child: const ExploreView()),
        ),
        GoRoute(
            path: '/Login',
            name: RoutingNames.LOGIN.name,
            builder: (context, state) => BlocProvider(
                create: (context) => LoginBloc(
                    context.read<AuthenticationBloc>().firebaseRepository,
                    context.read<AuthenticationBloc>()),
                child: const LoginView()),
            routes: [
              GoRoute(
                path: 'register',
                name: RoutingNames.REGISTER.name,
                builder: (context, state) => BlocProvider(
                    create: (context) => RegisterBloc(
                        context.read<AuthenticationBloc>().firebaseRepository,
                        context.read<AuthenticationBloc>()),
                    child: const RegisterView()),
              ),
              GoRoute(
                  path: 'confirmEmail',
                  name: RoutingNames.REGISTER_CONIFRM_EMAIL.name,
                  builder: (context, state) {
                    RegisterBloc regBloc;
                    if (state.extra != null) {
                      regBloc = state.extra as RegisterBloc;
                    } else {
                      regBloc = RegisterBloc(
                          context.read<AuthenticationBloc>().firebaseRepository,
                          context.read<AuthenticationBloc>());
                    }
                    return BlocProvider.value(
                      value: regBloc,
                      child: const RegisterConfirmView(),
                    );
                  }),
              GoRoute(
                  path: 'data',
                  name: RoutingNames.REGISTER_DATA.name,
                  builder: (context, state) {
                    RegisterBloc regBloc;
                    if (state.extra != null) {
                      regBloc = state.extra as RegisterBloc;
                    } else {
                      regBloc = RegisterBloc(
                          context.read<AuthenticationBloc>().firebaseRepository,
                          context.read<AuthenticationBloc>());
                    }

                    return BlocProvider.value(
                      value: regBloc,
                      child: const RegisterDataView(),
                    );
                  }),
            ]),
      ],
      redirect: (context, state) {
        final isAuthenticated =
            authBloc.state.status == AuthenticationStatus.authenticated;

        log("A REDIRECT IS CALLED", name: "====MainRouter Redirect====");
        log("path ${state.path}, full path ${state.fullPath}, matchedLocation ${state.matchedLocation}, name ${state.name}, URI ${state.uri} ",
            name: "====MainRouter Redirect====");

        //! REDIRECT FOR LOGGING OUT
        if (!isAuthenticated &&
            state.matchedLocation ==
                state.namedLocation(RoutingNames.HOME.name)) {
          return state.namedLocation(RoutingNames.LOGIN.name);
        }
        log("didn't redirect for logging out",
            name: "====MainRouter Redirect====");
        //! REDIRECT FOR GETTING USER DATA
        if (isAuthenticated && !authBloc.state.user.confirmedEmail) {
          return state.namedLocation(RoutingNames.REGISTER_CONIFRM_EMAIL.name);
        }
        log("didn't redirect for Email Confirmation",
            name: "====MainRouter Redirect====");
        //! REDIRECT FOR GETTING USER DATA
        if (isAuthenticated && !(authBloc.state.user.hasInfo)) {
          return state.namedLocation(RoutingNames.REGISTER_DATA.name);
        }
        log("didn't redirect for getting user data",
            name: "====MainRouter Redirect====");

        //! REDIRECT AFTER GETTING USER DATA
        if (isAuthenticated &&
            state.matchedLocation ==
                state.namedLocation(RoutingNames.REGISTER_DATA.name)) {
          return state.namedLocation(RoutingNames.HOME.name);
        }
        log("didn't redirect for after getting user data",
            name: "====MainRouter Redirect====");

        //! REDIRECT FOR LOGGED IN USER
        if (isAuthenticated &&
            authBloc.state.user.hasInfo &&
            state.matchedLocation ==
                state.namedLocation(RoutingNames.LOGIN.name)) {
          return state.namedLocation(RoutingNames.HOME.name);
        }
        log("didn't redirect for LOGGED IN USER on home screen",
            name: "====MainRouter Redirect====");

        context.loaderOverlay.hide();
        return null;
      },
      refreshListenable: authBloc,
    );
  }
}
