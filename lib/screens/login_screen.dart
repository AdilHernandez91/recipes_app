import 'package:flutter/material.dart';

import 'package:recipes_app/resources/auth_repository.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthRepository _repo = AuthRepository();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  bool _isLoading = false;
  String _email;
  String _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('RecipesApp'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: _isLoading ? CircularProgressIndicator() : _buildLoginForm(),
        ),
      )
    );
  }

  Form _buildLoginForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          _buildEmailField(),
          _buildPasswordField(),
          _buildSubmitButton(),
        ],
      ),
    );
  }

  TextFormField _buildEmailField() {
    return TextFormField(
      focusNode: _emailFocus,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: 'Type your email address',
        labelText: 'Email address'
      ),
      onFieldSubmitted: (String value) {
        FocusScope.of(context).requestFocus(_passwordFocus);
      },
      validator: (String value) {
        if (value.isEmpty) {
          return 'Email address is required';
        }
      },
      onSaved: (String value) {
        _email = value;
      },
    );
  }

  TextFormField _buildPasswordField() {
    return TextFormField(
      focusNode: _passwordFocus,
      textInputAction: TextInputAction.done,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Type your password',
        labelText: 'Password'
      ),
      onFieldSubmitted: (String value) {
        _passwordFocus.unfocus();
        _onSubmit();
      },
      validator: (String value) {
        if (value.isEmpty) {
          return 'Password is required';
        }
      },
      onSaved: (String value) {
        _password = value;
      },
    );
  }

  RaisedButton _buildSubmitButton() {
    return RaisedButton(
      textColor: Colors.white,
      child: Text('Login'),
      onPressed: _onSubmit,
    );
  }

  void _onSubmit() async {
    _isLoading = true;
    if (!_formKey.currentState.validate()) return;

    _formKey.currentState.save();
    try {
      await _repo.logInWithEmailAndPassword(_email, _password);
      _isLoading = false;
    } catch (err) {
      _isLoading = false;
      _loginErrorDialog(err.message);
    }
  }

  Future<Null> _loginErrorDialog(String message) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Login Failed'),
          content: Text(message),
          actions: [
            FlatButton(
              child: Text('Close'),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        );
      },
    );
  }
}