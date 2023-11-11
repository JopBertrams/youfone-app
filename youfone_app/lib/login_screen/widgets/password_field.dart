import 'package:flutter/material.dart';
import 'package:youfone_app/styles/colors.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController passwordController;
  final bool fadePassword;
  final bool passwordInvalid;

  final Function(bool) onPasswordTyping;

  const PasswordField(
      {super.key,
      required this.passwordController,
      required this.fadePassword,
      required this.passwordInvalid,
      required this.onPasswordTyping});

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  late TextEditingController passwordController;
  double bottomAnimationValue = 0;
  double opacityAnimationValue = 0;

  late bool passwordInvalid;
  bool obscure = true;
  FocusNode node = FocusNode();
  @override
  void initState() {
    passwordController = widget.passwordController;
    passwordInvalid = widget.passwordInvalid;
    node.addListener(_handleFocusChange);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildPasswordField(),
        Positioned.fill(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: _buildAnimatedLine(),
          ),
        ),
        Positioned.fill(
          child: _buildPasswordVisibilityButton(),
        )
      ],
    );
  }

  Widget _buildPasswordField() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 300),
      tween: Tween(begin: 0, end: widget.fadePassword ? 0 : 1),
      builder: ((_, value, __) => Opacity(
            opacity: value,
            child: TextFormField(
              controller: passwordController,
              focusNode: node,
              decoration: const InputDecoration(hintText: "Wachtwoord"),
              obscureText: obscure,
              onChanged: _handlePasswordChange,
            ),
          )),
    );
  }

  Widget _buildAnimatedLine() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      width: widget.fadePassword ? 0 : 300,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: bottomAnimationValue),
        curve: Curves.easeIn,
        duration: const Duration(milliseconds: 500),
        builder: ((context, value, child) => LinearProgressIndicator(
              value: value,
              backgroundColor: passwordInvalid ? Colors.red : Colors.grey.withOpacity(0.5),
              color: youfoneColor,
            )),
      ),
    );
  }

  Widget _buildPasswordVisibilityButton() {
    return TweenAnimationBuilder<double>(
      tween: Tween(
          begin: 0,
          end: opacityAnimationValue == 0
              ? 0
              : widget.fadePassword
                  ? 0
                  : 1),
      duration: const Duration(milliseconds: 700),
      builder: ((context, value, child) => Opacity(
            opacity: value,
            child: Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0).copyWith(bottom: 0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      obscure = !obscure;
                    });
                  },
                  child: Icon(
                    obscure ? Icons.visibility : Icons.visibility_off,
                    size: 27,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          )),
    );
  }

  void _handlePasswordChange(String value) {
    if (value.isNotEmpty) {
      setState(() {
        _updateAnimationValues(1, 1);
        widget.onPasswordTyping(false); // Pass 'false' to remove the error.
      });
    } else {
      setState(() {
        _updateAnimationValues(0, 0);
        widget.onPasswordTyping(true); // Pass 'true' to show the error.
      });
    }
  }

  void _handleFocusChange() {
    if (!node.hasFocus) {
      _updateAnimationValues(0, 0);
    } else {
      _updateAnimationValues(1, 1);
      if (passwordController.text.isEmpty) {
        _updateAnimationValues(1, 0);
      }
    }
  }

  void _updateAnimationValues(double bottomValue, double opacityValue) {
    setState(() {
      bottomAnimationValue = bottomValue;
      opacityAnimationValue = opacityValue;
    });
  }
}
