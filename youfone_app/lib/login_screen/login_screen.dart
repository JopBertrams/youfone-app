import 'package:flutter/material.dart';
import '../loading_screen/youfone_data.dart';
import '../loading_screen/youfone_login.dart';
import '../loading_screen/loading_screen.dart';
import './widgets/email_field.dart';
import './widgets/password_field.dart';
import './widgets/login_button.dart';
import '../dashboard_screen/dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  double elementsOpacity = 1;
  bool showLoadingScreen = false;
  bool showEmailError = false;
  bool showPasswordError = false;
  bool showLoginError = false;

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        bottom: false,
        child: showLoadingScreen ? _buildLoadingScreen() : _buildLoginScreen(),
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30.0), child: LoadingScreen());
  }

  Widget _buildLoginScreen() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 70),
            _buildLogoAndWelcome(),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  EmailField(
                    fadeEmail: elementsOpacity == 0,
                    emailController: emailController,
                    emailInvalid: showLoginError,
                    onEmailTyping: _handleEmailTyping,
                  ),
                  if (showEmailError) _buildEmailError(),
                  const SizedBox(height: 40),
                  PasswordField(
                    fadePassword: elementsOpacity == 0,
                    passwordController: passwordController,
                    passwordInvalid: showLoginError,
                    onPasswordTyping: _handlePasswordTyping,
                  ),
                  if (showPasswordError) _buildPasswordError(),
                  const SizedBox(height: 10),
                  if (showLoginError) _buildLoginError(),
                  const SizedBox(height: 60),
                  LoginButton(
                    elementsOpacity: elementsOpacity,
                    onTap: _handleLoginOnTap,
                  ),
                  const SizedBox(height: 20),
                  _buildForgotPassword(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoAndWelcome() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 300),
      tween: Tween(begin: 1, end: elementsOpacity),
      builder: (_, value, __) => Opacity(
        opacity: value,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 25),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                image: const DecorationImage(
                  image: AssetImage('assets/images/logo.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              "Welkom,",
              style: TextStyle(color: Colors.black, fontSize: 35),
            ),
            Text(
              "Log in om verder te gaan",
              style: TextStyle(color: Colors.black.withOpacity(0.7), fontSize: 25),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailError() {
    return AnimatedPadding(
      curve: Curves.easeIn,
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.only(top: 10),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: elementsOpacity),
        duration: const Duration(milliseconds: 300),
        builder: ((context, value, child) => Opacity(
              opacity: value,
              child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    "E-mail is ongeldig",
                    style: TextStyle(color: Colors.red, fontSize: 14),
                  )),
            )),
      ),
    );
  }

  Widget _buildPasswordError() {
    return AnimatedPadding(
      curve: Curves.easeIn,
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.only(top: 10),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: elementsOpacity),
        duration: const Duration(milliseconds: 300),
        builder: ((context, value, child) => Opacity(
              opacity: value,
              child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    "Vul een wachtwoord in",
                    style: TextStyle(color: Colors.red, fontSize: 14),
                  )),
            )),
      ),
    );
  }

  Widget _buildLoginError() {
    return AnimatedPadding(
      curve: Curves.easeIn,
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.only(top: 10),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: elementsOpacity),
        duration: const Duration(milliseconds: 300),
        builder: ((context, value, child) => Opacity(
              opacity: value,
              child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Row(children: [
                    Icon(Icons.error_rounded, color: Colors.red),
                    SizedBox(width: 5),
                    Text(
                      "E-mail of wachtwoord is onjuist",
                      style: TextStyle(color: Colors.red, fontSize: 14),
                    )
                  ])),
            )),
      ),
    );
  }

  Widget _buildForgotPassword() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 1, end: elementsOpacity),
      duration: const Duration(milliseconds: 300),
      builder: (_, value, __) => Opacity(
        opacity: value,
        child: GestureDetector(
          onTap: () {
            // TODO: Add the forgot password screen
            debugPrint("Forgot password pressed");
          },
          child: const Text(
            "Wachtwoord vergeten?",
            style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  bool isEmailValid() {
    String email = emailController.text;
    return RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
    ).hasMatch(email);
  }

  void _handleEmailTyping(bool showError) {
    setState(() {
      showEmailError = showError;
    });
  }

  void _handlePasswordTyping(bool showError) {
    setState(() {
      showPasswordError = showError;
    });
  }

  Future<void> _handleLoginOnTap() async {
    setState(() {
      showEmailError = !isEmailValid();
      showPasswordError = passwordController.text.isEmpty;
      if (isEmailValid() && passwordController.text.isNotEmpty) {
        elementsOpacity = 0;
        showLoadingScreen = true;
      }
    });

    if (!showEmailError && !showPasswordError) {
      await Future.delayed(const Duration(milliseconds: 300));
      if (!mounted) return;

      bool? loginSuccessful = await youfoneLogin(emailController.text, passwordController.text);
      if (!mounted) return;

      if (loginSuccessful == true) {
        var data = await getYoufoneData();
        if (!mounted) return;

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => DashboardScreen(
              youfoneData: data,
            ),
          ),
          (route) => false,
        );
      } else if (loginSuccessful == false) {
        setState(() {
          showLoginError = true;
          elementsOpacity = 1;
          showLoadingScreen = false;
        });
      } else {
        setState(() {
          elementsOpacity = 1;
          showLoadingScreen = false;
        });
      }
    }
  }
}
