// lib/blocs/login/login_bloc.dart

// import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:tataguid/storage/token_storage.dart';
import '../../repository/auth_repo.dart';
import './login_event.dart';
import './login_state.dart';
import 'package:tataguid/storage/profil_storage.dart'; // Import the profil_storage.dart file

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepository;

  LoginBloc({required this.authRepository}) : super(LoginInitState()) {
    on<LoginButtonPressed>(_onLoginButtonPressed);
    on<LogoutEvent>(_onLogoutPressed);
  }

  void _onLoginButtonPressed(
    LoginButtonPressed event,
    Emitter<LoginState> emit,
  ) async {
    print('Login button pressed: Email: ${event.email}, Password: ${event.password}');
    emit(LoginLoadingState()); // Emit loading state before API call

    try {
      final response = await authRepository.login(event.email, event.password);

      TokenStorage.storeToken(response.token);

      if (response.type == "user") {
        emit(UserLoginSuccessState(type: 'user')); // Navigate to user dashboard
        emit(NavigateToUserDashboard());
        // Store user's name in SharedPreferences
        await ProfileUserStorage.storeUserName(response.name);
      } else if (response.type == "agency") {
        emit(AgencyLoginSuccessState(type: 'agency')); // Navigate to agency panel
        emit(NavigateToAgencyPanel());
        // Store user's agency profile data
      _storeAgencyProfileData(event.email, response.agencyName);
      } else {
        emit(LoginErrorState("unsupported user type!"));
      }
      // Store user's email in the profil_storage.dart file
      await ProfileUserStorage.storeEmail(event.email);
    } catch (e) {
      emit(LoginErrorState("An error occurred: $e"));
    }
  }

  // In login_bloc.dart

  void _onLogoutPressed(
    LogoutEvent event,
    Emitter<LoginState> emit,
  ) async {
    try{
    await TokenStorage.deleteToken(); // Delete token from storage
    emit(LogoutSuccessState()); // Emit logout success state
    }catch(e){
      print('Error occurred during logout; $e');
    }
  }

  void _storeAgencyProfileData(String email, String agencyName) async {
    await ProfileAgencyStorage.storeAgencyEmail(email); // Store agnecy's email
    await ProfileAgencyStorage.storeAgencyName(
        agencyName); // Store agnecy's name
  }

  @override
  void onEvent(LoginEvent event) {
    super.onEvent(event);
    if (event is LoginButtonPressed) {
      print(
          'LoginButtonPressed event received: Email: ${event.email}, Password: ${event.password}');
    }
  }
}