import 'package:flutter/material.dart';
import '../loading_screen/youfone_login.dart';
import './widgets/email_field.dart';
import './widgets/login_button.dart';
import '../loading_screen/loading_screen.dart';
import '../dashboard_screen/dashboard_screen.dart';
import './widgets/password_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  double elementsOpacity = 1;
  double loadingBallSize = 1;
  bool showLoadingScreen = false;
  bool showEmailError = false;
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
        child: showLoadingScreen
            ? const Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30.0),
                child: LoadingScreen())
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 70),
                      TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 300),
                        tween: Tween(begin: 1, end: elementsOpacity),
                        builder: (_, value, __) => Opacity(
                          opacity: value,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                                style:
                                    TextStyle(color: Colors.black.withOpacity(0.7), fontSize: 25),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          children: [
                            EmailField(
                              fadeEmail: elementsOpacity == 0,
                              emailController: emailController,
                              emailInvalid: showLoginError,
                              onEmailTyping: handleEmailTyping,
                            ),
                            if (showEmailError)
                              AnimatedPadding(
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
                              ),
                            const SizedBox(height: 40),
                            PasswordField(
                              fadePassword: elementsOpacity == 0,
                              passwordController: passwordController,
                              passwordInvalid: showLoginError,
                            ),
                            const SizedBox(height: 10),
                            if (showLoginError)
                              AnimatedPadding(
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
                              ),
                            const SizedBox(height: 60),
                            LoginButton(
                                elementsOpacity: elementsOpacity,
                                onTap: () {
                                  setState(() async {
                                    if (!isEmailValid()) {
                                      showEmailError = true;
                                    } else {
                                      elementsOpacity = 0;
                                      await Future.delayed(const Duration(milliseconds: 300), () {
                                        setState(() {
                                          showLoadingScreen = true;
                                        });
                                        tryLogin().then((result) {
                                          if (result['loginSuccessful'] == true) {
                                            getYoufoneData(result['responseBody']).then((result) {
                                              Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const DashboardScreen()),
                                                  (route) => false);
                                            });
                                          } else {
                                            setState(() {
                                              showLoginError = true;
                                              elementsOpacity = 1;
                                              showLoadingScreen = false;
                                            });
                                          }
                                        });
                                      });
                                    }
                                  });
                                }),
                            const SizedBox(height: 20),
                            TweenAnimationBuilder<double>(
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
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Future<Map<String, dynamic>> tryLogin() async {
    return await youfoneLogin(emailController.text, passwordController.text);
  }

  Future<Map<String, dynamic>> getYoufoneData(Map<String, dynamic> loginResponseBody) {
    // TODO: Retrieve data from Youfone API and show the dashboard screen.
    return Future.delayed(const Duration(seconds: 1), () {
      return {'loginSuccessful': true};
    });
  }

  bool isEmailValid() {
    String email = emailController.text;
    return RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
    ).hasMatch(email);
  }

  void handleEmailTyping(bool showError) {
    setState(() {
      showEmailError = showError;
    });
  }
}
