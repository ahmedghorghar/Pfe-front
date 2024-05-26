// lib/ui/SignUpUi.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tataguid/blocs/signup/signup_bloc.dart';
import 'package:tataguid/blocs/signup/signup_event.dart';
import 'package:tataguid/blocs/signup/signup_state.dart';
import 'package:flutter/material.dart'show ScaffoldMessenger; // Use 'material.dart'
import 'package:provider/provider.dart';
import 'package:tataguid/components/my_textfield.dart';
import 'package:tataguid/models/User.dart';
import 'package:tataguid/repository/auth_repo.dart';
import 'package:tataguid/storage/token_storage.dart';
import 'package:tataguid/ui/LoginUi.dart';
import 'package:tataguid/ui/signup_option.dart';
import 'package:tataguid/widgets/BuildTextfield.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController emailController =
      TextEditingController(text: 'raserfinblade@gmail.com');
  /* final TextEditingController emailController =
      TextEditingController(text: 'gg@gmail.com'); */
  final TextEditingController passwordController =
      TextEditingController(text: '12345678');
  final TextEditingController confirmpassController =
      TextEditingController(text: '12345678');
  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>(); // For SnackBar

  String errorMessage = '';

  void _clearErrorMessage() {
    setState(() {
      errorMessage = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final AuthRepository authRepository = Provider.of<AuthRepository>(context,
        listen: false); // Access the repository
    final SignupBloc signupBloc = BlocProvider.of<SignupBloc>(context);

    const logo = Center(
      child: Icon(Icons.supervised_user_circle, size: 150, color: Colors.blue),
    );

    // BuildTextFormField and other widgets omitted for brevity

    final email = BuildTextFormField(
      'Email',
      emailController,
      (value) {
        if (!RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+\.[a-zA-Z]+")
            .hasMatch(value!)) {
          return "Invalid Email Format";
        }
        return null;
      },
      TextInputType.emailAddress,
      Icons.email,
    );

    final pass = BuildTextFormField(
      'Password',
      passwordController,
      (value) {
        // Implement password strength validation
        if (value!.isEmpty) {
          return "Password cannot be empty";
        }
        return null;
      },
      TextInputType.visiblePassword,
      Icons.lock,
    );

    final confirmpass = BuildTextFormField(
      'Confirm password',
      confirmpassController,
      (value) {
        // Password validation logic
        return null;
      },
      TextInputType.visiblePassword,
      Icons.lock,
    );

    final signUpButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.lightBlueAccent,
        ),
        onPressed: () {
          String email = emailController.text.trim();
          String password = passwordController.text.trim();
          String confirmPassword = confirmpassController.text.trim();

          // Validate email format
          if (!RegExp(
                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+\.[a-zA-Z]+")
              .hasMatch(email)) {
            _showErrorSnackBar('Invalid email format.');
            return; // Exit the function if email format is invalid
          }

          if (!_isValidPassword(password)) {
            _showErrorSnackBar('Password must be at least 8 characters long.');
            return;
          }
          // Validate password and confirm password
          if (password.isEmpty || confirmPassword.isEmpty) {
            _showErrorSnackBar('Password fields cannot be empty.');
            return; // Exit the function if password fields are empty
          }

          if (password != confirmPassword) {
            _showErrorSnackBar('Passwords do not match.');
            return; // Exit the function if passwords do not match
          }

          // Perform signup logic
          signupBloc
              .add(TriggerEmailPasswordEvent(email: email, password: password));
          //navigate to the SignupOptions()
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SignupOptions(
                        email: email,
                        password: password,
                      )));
        },
        child: const Text('Next', style: TextStyle(color: Colors.white)),
      ),
    );

    final alreadyHave = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account?',
          style: TextStyle(color: Colors.grey[700]),
        ),
        const SizedBox(width: 5),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LoginUi(),
              ),
            );
          },
          child: Text(
            'Log In',
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: BlocListener<SignupBloc, SignupState>(
        listener: (context, state) {
          if (state is SignupErrorState) {
            _showErrorSnackBar(state.message);
          } else if (state is UserSignupSuccessState ||
              state is AgencySignupSuccessState) {
            _handleSuccessfulSignup(state);
          }
        },
        child: Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: size.width * 0.04),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                logo,
                const SizedBox(height: 20),
                email,
                const SizedBox(height: 20),
                pass,
                const SizedBox(height: 20),
                confirmpass,
                const SizedBox(height: 20),
                signUpButton,
                const SizedBox(height: 40),
                alreadyHave,
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _handleSuccessfulSignup(SignupState state) {
    if (state is UserSignupSuccessState || state is AgencySignupSuccessState) {
      confirmpassController.clear();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SignupOptions(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          ),
          settings: RouteSettings(
              arguments: state), // Pass the signup state as an argument
        ),
      );
    } else {
      _showErrorSnackBar('Invalid signup state.');
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  bool _isValidPassword(String password) {
    return password.length >= 8; // Password length validation
    // You can include additional password validation logic here if needed
  }

  void _storeToken(String token) async {
    await TokenStorage.storeToken(token);
  }
}
