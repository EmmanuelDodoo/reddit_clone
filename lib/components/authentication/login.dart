import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reddit_clone/components/authentication/signup.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/models/userprovider.dart';

import '../../models/user.dart';

class LoginModal extends StatefulWidget {
  /// Function to call after a successful login
  final void Function()? onCloseSuccessfully;

  const LoginModal({Key? key, this.onCloseSuccessfully}) : super(key: key);

  @override
  State<LoginModal> createState() => _LoginModalState();
}

class _LoginModalState extends State<LoginModal> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  User? _user;

  bool _obscurePassword = true;

  void loadUser() async {
    String file = "json/user.json";
    User usr = await rootBundle
        .loadString(file)
        .then((value) => User.fromJSON(json: value));
    setState(() {
      _user = usr;
    });
  }

  void _handlePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _handleSubmit(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      // TODO form submission
      UserProvider userProvider =
          Provider.of<UserProvider>(context, listen: false);
      userProvider.setCurrentUser(user: _user!);
      Navigator.of(context).pop();

      /// Call the on close successfully function from widget
      /// if any
      if (widget.onCloseSuccessfully != null) {
        widget.onCloseSuccessfully!();
      }
    }
  }

  void _handleSignUp(BuildContext context) {
    Navigator.of(context).pop();
    showDialog(
        context: context,
        builder: (context) => SignUpModal(
              onCloseSuccessfully: widget.onCloseSuccessfully,
            ));
  }

  Widget _header(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 5, bottom: 15),
      child: Text("Login to your account",
          style: Theme.of(context).textTheme.titleMedium),
    );
  }

  Widget _textArea(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _emailController,
            style: Theme.of(context).textTheme.bodyMedium,
            decoration: const InputDecoration(
              hintText: 'Email or username',
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an email or username';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            style: Theme.of(context).textTheme.bodyMedium,
            decoration: InputDecoration(
              // isCollapsed: true,
              suffixIcon: IconButton(
                onPressed: _handlePasswordVisibility,
                iconSize: 18,
                icon: _obscurePassword
                    ? const Icon(
                        Icons.visibility_rounded,
                      )
                    : const Icon(
                        Icons.visibility_off_rounded,
                      ),
              ),
              hintText: 'Password',
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a password';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buttons(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => _handleSubmit(context),
            child: const Text(
              'Login',
            ),
          ),
        ],
      ),
    );
  }

  Widget _footer(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(0),
        margin: const EdgeInsets.all(0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Don't have an account?",
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(fontStyle: FontStyle.italic),
            ),
            TextButton(
              onPressed: () => _handleSignUp(context),
              child: Text(
                "Sign up",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: Theme.of(context).colorScheme.primary),
              ),
            ),
          ],
        ));
  }

  @override
  void initState() {
    loadUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        padding: const EdgeInsets.all(5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            _header(context),
            _textArea(context),
            _buttons(context),
            _footer(context),
          ],
        ),
      ),
    );
  }
}
