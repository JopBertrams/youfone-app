import 'package:flutter/material.dart';
import 'package:youfone_app/styles/colors.dart';

class EmailField extends StatefulWidget {
  final TextEditingController emailController;
  final bool fadeEmail;
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
  late TextEditingController emailController;
  EdgeInsets paddingAnimationValue = const EdgeInsets.only(top: 22);

  late AnimationController _animationController;
  late Animation<Color?> _animation;
  late bool emailInvalid;

  double bottomAnimationValue = 0;
  double opacityAnimationValue = 0;

  FocusNode node = FocusNode();

  bool isTyping = false;
  bool isEmailValid = false;

  @override
  void initState() {
    emailController = widget.emailController;
    emailInvalid = widget.emailInvalid;
    _animationController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 300));

    final tween = ColorTween(begin: Colors.grey.withOpacity(0), end: const Color(0xff21579C));
    _animation = tween.animate(_animationController)..addListener(() => setState(() {}));

    node.addListener(() {
      if (node.hasFocus) {
        setState(() {
          _updateBottomAnimation(1);
        });
      } else {
        setState(() {
          _updateBottomAnimation(0);
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildEmailTextField(),
        Positioned.fill(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: _buildAnimatedLine(),
          ),
        ),
        if (isTyping && !isEmailValid) _buildXIcon(),
        if (isEmailValid) _buildCheckIcon(),
      ],
    );
  }

  Widget _buildEmailTextField() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 300),
      tween: Tween(begin: 0, end: widget.fadeEmail ? 0 : 1),
      builder: ((_, value, __) => Opacity(
            opacity: value,
            child: TextFormField(
              controller: emailController,
              focusNode: node,
              decoration: const InputDecoration(hintText: "E-mail"),
              keyboardType: TextInputType.emailAddress,
              onChanged: _handleEmailChange,
            ),
          )),
    );
  }

  Widget _buildAnimatedLine() {
    return AnimatedContainer(
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
    );
  }

  Widget _buildXIcon() {
    return Positioned.fill(
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
    );
  }

  Widget _buildCheckIcon() {
    return Positioned.fill(
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
    );
  }

  void _handleEmailChange(String value) async {
    if (value.isNotEmpty) {
      if (isValidEmail(value)) {
        setState(() {
          _updateBottomAnimation(0);
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
          _updateBottomAnimation(1);
          opacityAnimationValue = 0;
          paddingAnimationValue = const EdgeInsets.only(top: 22);
          isEmailValid = false; // Set email validity to false
          widget.onEmailTyping(false); // Pass 'true' to remove the error while typing.
        });
      }
      isTyping = true;
    } else {
      setState(() {
        _updateBottomAnimation(0);
        isTyping = false;
        isEmailValid = false;
        // Notify the parent widget that the user is typing in the email field.
        widget.onEmailTyping(
            true); // Pass 'true' to show the error. // Set email validity to false when the email field is empty
      });
    }
  }

  void _updateBottomAnimation(double value) {
    if (mounted) {
      setState(() {
        bottomAnimationValue = value;
      });
    }
  }

  bool isValidEmail(String email) {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zAZ]{2,}))$')
        .hasMatch(email);
  }
}
