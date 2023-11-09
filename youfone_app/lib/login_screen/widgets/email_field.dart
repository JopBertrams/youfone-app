import 'package:flutter/material.dart';
import 'package:youfone_app/styles/colors.dart';

class EmailField extends StatefulWidget {
  final bool fadeEmail;
  final TextEditingController emailController;
  final bool emailInvalid;
  final Function(bool) onEmailTyping;
  const EmailField(
      {super.key,
      required this.emailController,
      required this.fadeEmail,
      required this.emailInvalid,
      required this.onEmailTyping});

  @override
  State<EmailField> createState() => _EmailFieldState();
}

class _EmailFieldState extends State<EmailField> with SingleTickerProviderStateMixin {
  double bottomAnimationValue = 0;
  double opacityAnimationValue = 0;
  EdgeInsets paddingAnimationValue = const EdgeInsets.only(top: 22);
  bool isTyping = false;
  bool isEmailValid = false;

  late TextEditingController emailController;
  late AnimationController _animationController;
  late Animation<Color?> _animation;
  late bool emailInvalid;

  FocusNode node = FocusNode();
  @override
  void initState() {
    emailController = widget.emailController;
    emailInvalid = widget.emailInvalid;
    _animationController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    final tween = ColorTween(begin: Colors.grey.withOpacity(0), end: const Color(0xff21579C));

    _animation = tween.animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
    super.initState();

    node.addListener(() {
      if (node.hasFocus) {
        setState(() {
          bottomAnimationValue = 1;
        });
      } else {
        setState(() {
          bottomAnimationValue = 0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 300),
          tween: Tween(begin: 0, end: widget.fadeEmail ? 0 : 1),
          builder: ((_, value, __) => Opacity(
                opacity: value,
                child: TextFormField(
                  controller: emailController,
                  focusNode: node,
                  decoration: const InputDecoration(hintText: "E-mail"),
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) async {
                    if (value.isNotEmpty) {
                      if (isValidEmail(value)) {
                        setState(() {
                          bottomAnimationValue = 0;
                          opacityAnimationValue = 1;
                          paddingAnimationValue = const EdgeInsets.only(top: 0);
                          isEmailValid = true; // Set email validity to true
                          // Notify the parent widget that the user is typing in the email field.
                          widget.onEmailTyping(false); // Pass 'false' to remove the error.
                        });
                        _animationController.forward();
                      } else {
                        _animationController.reverse();
                        setState(() {
                          bottomAnimationValue = 1;
                          opacityAnimationValue = 0;
                          paddingAnimationValue = const EdgeInsets.only(top: 22);
                          isEmailValid = false; // Set email validity to false
                        });
                      }
                      isTyping = true;
                    } else {
                      setState(() {
                        bottomAnimationValue = 0;
                        isTyping = false;
                        isEmailValid = false;
                        // Notify the parent widget that the user is typing in the email field.
                        widget.onEmailTyping(
                            true); // Pass 'true' to show the error. // Set email validity to false when the email field is empty
                      });
                    }
                  },
                ),
              )),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              width: widget.fadeEmail ? 0 : 300,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: bottomAnimationValue),
                curve: Curves.easeIn,
                duration: const Duration(milliseconds: 500),
                builder: ((context, value, child) => LinearProgressIndicator(
                      value: value,
                      backgroundColor: emailInvalid ? Colors.red : Colors.grey.withOpacity(0.5),
                      color: youfoneColor,
                    )),
              ),
            ),
          ),
        ),
        if (isTyping && !isEmailValid) // Show the close/cross icon conditionally
          Positioned.fill(
            child: AnimatedPadding(
              curve: Curves.easeIn,
              duration: const Duration(milliseconds: 500),
              padding: const EdgeInsets.only(top: 5), // Adjust the top padding value here
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: widget.fadeEmail ? 0 : 1),
                duration: const Duration(milliseconds: 500),
                builder: ((context, value, child) => Opacity(
                      opacity: value,
                      child: Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0)
                              .copyWith(bottom: 2), // Adjust the bottom padding value here
                          child: const Icon(
                            Icons.close_rounded,
                            size: 27,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    )),
              ),
            ),
          ),
        if (isEmailValid) // Show the check icon when email is valid
          Positioned.fill(
            child: AnimatedPadding(
              curve: Curves.easeIn,
              duration: const Duration(milliseconds: 500),
              padding: paddingAnimationValue,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: widget.fadeEmail ? 0 : 1),
                duration: const Duration(milliseconds: 500),
                builder: ((context, value, child) => Opacity(
                      opacity: value,
                      child: Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0).copyWith(bottom: 0),
                          child: Icon(
                            Icons.check_rounded,
                            size: 27,
                            color: _animation.value,
                          ),
                        ),
                      ),
                    )),
              ),
            ),
          ),
      ],
    );
  }

  bool isValidEmail(String email) {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zAZ]{2,}))$')
        .hasMatch(email);
  }
}
