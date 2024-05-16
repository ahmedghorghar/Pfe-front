// lib/main.dart


import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tataguid/blocs/guest/guest_bloc.dart';
import 'package:tataguid/blocs/login/login_bloc.dart';
import 'package:tataguid/blocs/profile/profile_bloc.dart';
import 'package:tataguid/blocs/resetPassword/reset_password_bloc.dart';
import 'package:tataguid/blocs/signup/signup_bloc.dart';
import 'package:tataguid/pages/onboarding_page.dart';
import 'package:tataguid/repository/auth_repo.dart';
import 'package:provider/provider.dart';
import 'package:tataguid/repository/guest_repository.dart';
import 'package:tataguid/repository/password_reset_repo.dart';
import 'package:tataguid/repository/profil_repo.dart';
import 'package:tataguid/ui/LoginUi.dart';
import 'package:tataguid/ui/get_contacts.dart';
import 'package:tataguid/ui/post_contacts.dart';

void main() => runApp(TataGuid());

class TataGuid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthRepository authRepository = AuthRepository();
    final ForgotPasswordRepository forgotPasswordRepository = ForgotPasswordRepository();
    final ProfileRepository profileRepository = ProfileRepository();
    final GuestRepository guestRepository = GuestRepository();

    return MultiProvider(
      providers: [
        Provider<AuthRepository>.value(value: authRepository),
        BlocProvider<LoginBloc>(
          create: (context) => LoginBloc(authRepository: authRepository),
        ),
        BlocProvider<SignupBloc>(
          create: (context) => SignupBloc(authRepository: authRepository),
        ),
        BlocProvider<ResetPasswordBloc>(
          create: (context) => ResetPasswordBloc(
              forgotPasswordRepository: forgotPasswordRepository),
        ),
        BlocProvider<ProfileBloc>(
          create: (context) => ProfileBloc(
              profileRepository: profileRepository),
        ),
        BlocProvider<GuestBloc>(
          create: (context) => GuestBloc(
              guestRepository: guestRepository),
        ),
      ],
        child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/login_ui',
        routes: {
          '/': (context) => OnboardingPage(),
          '/user_dashboard': (context) => UserPage(),
          '/agency_panel': (context) => AgencyPanelScreen(),
          '/login_ui': (context) => LoginUi(), // Your login page
          '/Guest': (context) => UserPage(),
        },
        onGenerateRoute: (settings) {
          if (Platform.isAndroid || Platform.isIOS) {
            return MaterialPageRoute(
              builder: (context) => PlatformErrorScreen(),
            );
          }
          return null;
        },
      ),
    );
  }
}

class PlatformErrorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Platform Error'),
      ),
      body: Center(
        child: Text(
          'Unsupported operation: Platform._operatingSystem',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}