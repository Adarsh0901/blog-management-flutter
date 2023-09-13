import 'package:blog_management/services/common_services.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _firebaseAuth = FirebaseAuth.instance;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() {
    return _LoginScreen();
  }
}

class _LoginScreen extends State<LoginScreen> {
  final _commonService = CommonServices();
  final _loginForm = GlobalKey<FormState>();
  bool _isLogin = true;
  var _emailId = '';
  var _password = '';

  _login() async {
    var isValid = _loginForm.currentState!.validate();
    if(!isValid){

    }

    _loginForm.currentState!.save();
    try{
      if(_isLogin){
        await _firebaseAuth.signInWithEmailAndPassword(email: _emailId, password: _password);
      }else{
        await _firebaseAuth.createUserWithEmailAndPassword(email: _emailId, password: _password);
      }
    }catch(err){
      if(context.mounted){
        _commonService.showMessage(context, err.toString(), Colors.red);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: width > 390 ? 390 : width,
                child: Card(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Form(
                        key: _loginForm,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15),
                              child: Text(_isLogin ?
                                'Login Form' : 'Signup Form',
                                style: const TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15),
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Email ID',
                                ),
                                keyboardType: TextInputType.emailAddress,
                                autocorrect: false,
                                textCapitalization: TextCapitalization.none,
                                validator: (value){
                                  if(value == null || value.trim().isEmpty || !value.contains('@')){
                                    return 'Enter a valid Email Address';
                                  }
                                  return null;
                                },
                                onSaved: (value){
                                  _emailId = value!;
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15),
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Password',
                                ),
                                obscureText: true,
                                validator: (value){
                                  if(value == null || value.trim().isEmpty){
                                    return 'Password should not be empty';
                                  }
                                  return null;
                                },
                                onSaved: (value){
                                  _password = value!;
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            ElevatedButton(
                              onPressed: _login,
                              child: Text(_isLogin ? 'Login' : 'Signup'),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _isLogin = !_isLogin;
                                });
                              },
                              child: Text(_isLogin
                                  ? 'Create an account'
                                  : 'I already have an account'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
