/* // lib/blocs/signup/signup_bloc.dart

import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:tataguid/blocs/signup/signup_event.dart';
import 'package:tataguid/blocs/signup/signup_state.dart';

import '../../repository/auth_repo.dart';

class SignupBloc extends Bloc<SignupEvents, SignupState> {
  final AuthRepository authRepository;

  SignupBloc({required this.authRepository}) : super(LogoutState()) {
    on<RegisterButtonPressed>(_onRegisterButtonPressed);
  }

  Logger _logger = Logger();
  bool isAgency = false;
  String? email;
  String? password;
  String? name;
  String? agencyName;
  String? type;
  String? language;
  String? country;
  String? location;
  String? description;

  void _onRegisterButtonPressed(
    RegisterButtonPressed event,
    Emitter<SignupState> emit,
  ) async {
    emit(SignupLoadingState()); // Emit loading state before API call
    _logger.i(event);
    // Log the event details with values
    _logger.i('''
      Email: ${event.email}
      Password: ${event.password} (hidden for security)
      Name: ${event.name}
      Agency Name: ${event.agencyName}
      Type: ${event.type}
      Language: ${event.language}
      Country: ${event.country}
      Location: ${event.location}
      Description: ${event.description}
    ''');
    // Check for missing agency-specific fields before sending data
    if (isAgency && (event.agencyName.isEmpty || event.location.isEmpty || event.description.isEmpty)) {
      emit(SignupErrorState("Please fill in all required fields!"));
      return; // Exit the method if data is missing
    }
    try {
      var data = await authRepository.signUp(
        name: event.name,
        agencyName: event.agencyName,
        email: event.email,
        password: event.password,
        type: event.type,
        language: event.language,
        country: event.country,
        location: event.location,
        description: event.description,
      );
      _logger.i(data);
      // Use a switch statement for type-safe handling:
      switch (event.type) {
        case 'agency': // Updated to match the type string
          emit(AgencySignupSuccessState());
          clearData();
          break; // Handle successful user signup
        case 'user': // Updated to match the type string
          emit(UserSignupSuccessState());
          clearData();
          break; // Handle successful agency signup
        default:
          emit(SignupErrorState('Invalid user type: ${event.type}'));
          break; // Handle invalid type case
      }
    } catch (error) {
      _logger.e(error);
      emit(SignupErrorState(error.toString())); // Emit error state with message
    }
  }

  void clearData() {
    isAgency = false;
    email = null;
    password = null;
    name = null;
    agencyName = null;
    type = null;
    language = null;
    country = null;
    location = null;
    description = null;
  }
} */



// lib/blocs/signup/signup_bloc.dart

import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:tataguid/blocs/signup/signup_event.dart';
import 'package:tataguid/blocs/signup/signup_state.dart';

import '../../repository/auth_repo.dart';

class SignupBloc extends Bloc<SignupEvents, SignupState> {
  final AuthRepository authRepository;

  SignupBloc({required this.authRepository}) : super(LogoutState()) {
    on<StartSignupEvent>(_onStartSignupEvent);
    on<TriggerEmailPasswordEvent>(_onTriggerEmailPasswordEvent);
    on<TriggerRoleSelectionEvent>(_onTriggerRoleSelectionEvent);
    on<SignupUserFieldsEvent>(_onTriggerUserFieldsEvent); // Changed event type
    on<SignupAgencyFieldsEvent>(_onTriggerAgencyFieldsEvent); // Changed event type
    on<FinalizeSignupEvent>(_onFinalizeSignupEvent);
  }

  Logger _logger = Logger();
  String? email;
  String? password;
  String? name;
  String? agencyName;
  String? type;
  String? language;
  String? country;
  String? location;
  String? description;

  void _onStartSignupEvent(StartSignupEvent event, Emitter<SignupState> emit) {
    emit(SignupInitState()); // Emit initial state
  }

  void _onTriggerEmailPasswordEvent(
    TriggerEmailPasswordEvent event,
    Emitter<SignupState> emit,
  ) async {
    email = event.email;
    password = event.password;
    emit(SignupLoadingState());
    emit(EmailPasswordProcessedState());
  //ceate the code to print the email an the password
  print(email);
  print(password);  

  }


  void _onTriggerRoleSelectionEvent(
    TriggerRoleSelectionEvent event,
    Emitter<SignupState> emit,
  ) async {
    type = event.type;
    emit(SignupRoleSelectedState(type!)); 
  if (type == 'user') {
      emit(SignupUserFieldsState(
        name: name ?? '',
        language: language ?? '',
        country: country ?? '',
      ));
    } else if (type == 'agency') {
      emit(SignupAgancyFieldsState(
        agencyName: agencyName ?? '',
        location: location ?? '',
        description: description ?? '',
      ));
    }
  }

   void _onTriggerUserFieldsEvent(
    SignupUserFieldsEvent event,
    Emitter<SignupState> emit,
  ) async {
    name = event.name;
    language = event.language;
    country = event.country;
    emit(SignupLoadingState());
  }
// SignupAgencyFieldsEvent
  void _onTriggerAgencyFieldsEvent(
    SignupAgencyFieldsEvent event,
    Emitter<SignupState> emit,
  ) async {
    agencyName = event.agencyName;
    location = event.location;
    description = event.description;
    emit(SignupLoadingState());
  }

  void _onFinalizeSignupEvent(
    FinalizeSignupEvent event,
    Emitter<SignupState> emit,
  ) async {
    emit(SignupLoadingState()); // Emit loading state before API call
    try {
      var data = await authRepository.signUp(
        name: event.name,
        agencyName: event.agencyName,
        email: event.email,
        password: event.password,
        type: event.type,
        language: event.language,
        country: event.country,
        location: event.location,
        description: event.description,
      );
      _logger.i(data);
      // Use a switch statement for type-safe handling:
      if (data['message'] == "User created successfully") {
      emit(UserSignupSuccessState());
    } else if (data['message'] == "Agency created successfully") {
      emit(AgencySignupSuccessState());
    } else {
      emit(SignupErrorState('Failed to sign up'));
    }
  } catch (error) {
    _logger.e(error);
    emit(SignupErrorState(error.toString()));
  }
}
  }/* 
      switch (event.type) {
        case 'agency':
          emit(AgencySignupSuccessState());
          break;
        case 'user':
          emit(UserSignupSuccessState());
          break;
        default:
          emit(SignupErrorState('Invalid user type: ${event.type}'));
          break;
      }
    } catch (error) {
      _logger.e(error);
      emit(SignupErrorState(error.toString())); // Emit error state with message
    } */

