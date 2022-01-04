import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:placement_cell/userdata.dart';
import 'package:email_auth/email_auth.dart';

class AuthForm extends StatefulWidget {
  var isloading;
  final void Function(
          String email, String password, String username, bool islogin, Mode m)
      saveauthform;
  AuthForm(this.saveauthform, this.isloading);
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formkey = GlobalKey<FormState>();
  String _useremail = '';
  String _username = '';
  String _userpassword = '';
  bool otploading = false;
  var _islogin = true;
  var mode = null;
  var emailAuth;
  @override
  void initState() {
    emailAuth = new EmailAuth(
      sessionName: "PlacementApp",
    );
    super.initState();
  }

  TextEditingController _otp = TextEditingController();
  void _submit() {
    var status = _formkey.currentState;
    // log("status " + status.toString());
    final isvalid = status?.validate();
    FocusScope.of(context).unfocus();
    // log("isvalid " + isvalid.toString());

    if (isvalid == true) {
      _formkey.currentState?.save();

      log(_useremail + " " + _userpassword);
      if (mode == null) mode = Mode.Student;
      widget.saveauthform(_useremail, _username, _userpassword, _islogin, mode);
      _formkey.currentState?.reset();
    }
    // FirebaseFirestore.instance.collection(collectionPath)
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
                key: _formkey,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_islogin == false)
                        TextFormField(
                          key: ValueKey('username'),
                          validator: (val) {
                            if (val == null || val.isEmpty) return "invalid";
                            return null;
                          },
                          onSaved: (val) {
                            if (val != null) _username = val;
                          },
                          decoration: InputDecoration(labelText: 'Username'),
                        ),
                      TextFormField(
                        key: ValueKey('email'),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              !value.contains('@')) return "invalid email";
                          return null;
                        },
                        onChanged: (val) {
                          if (val != null) _useremail = val;
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(labelText: 'Email Adress'),
                      ),
                      TextFormField(
                        key: ValueKey('password'),
                        validator: (val) {
                          if (val == null || val.isEmpty || val.length < 7)
                            return 'length must be 7 or greater';
                          return null;
                        },
                        onChanged: (val) {
                          if (val != null) _userpassword = val;
                        },
                        obscureText: true,
                        decoration: InputDecoration(labelText: 'Password'),
                      ),
                      if (_islogin == false)
                        TextFormField(
                          key: ValueKey('reenter password'),
                          validator: (val) {
                            log(_userpassword);
                            log(val.toString() + " " + _userpassword);
                            if (val != _userpassword)
                              return "PASS DO NOT MATCH";
                            return null;
                          },
                          obscureText: true,
                          decoration:
                              InputDecoration(labelText: 'Reenter Password'),
                        ),
                      SizedBox(height: 10),
                      if (_islogin == false)
                        DropdownButton(
                            key: ValueKey("mode"),
                            value: mode,
                            onChanged: (val) {
                              setState(() {
                                mode = val;
                              });
                            },
                            items: [
                              DropdownMenuItem<String>(
                                key: ValueKey('Role'),
                                value: null,
                                child: Text('Choose Role'),
                              ),
                              DropdownMenuItem(
                                key: ValueKey('Student'),
                                value: Mode.Student,
                                child: Text('Student'),
                                onTap: () {
                                  setState(() {
                                    User.mode = Mode.Student;
                                    mode = Mode.Student;
                                  });
                                },
                              ),
                              DropdownMenuItem(
                                key: ValueKey('recruiter'),
                                child: Text('Recruiter'),
                                value: Mode.Recruiter,
                                onTap: () {
                                  setState(() {
                                    User.mode = Mode.Recruiter;
                                    mode = Mode.Recruiter;
                                  });
                                },
                              ),
                              DropdownMenuItem(
                                key: ValueKey('placementofficer'),
                                child: Text('PlacementOfficer'),
                                value: Mode.PlacementOfficer,
                                onTap: () {
                                  setState(() {
                                    User.mode = Mode.PlacementOfficer;
                                    mode = Mode.PlacementOfficer;
                                  });
                                },
                              )
                            ]),
                      //TODO::aDD HERE EMAIL VERIFICATION
                      SizedBox(height: 10),
                      if (_islogin == false)
                        Column(children: [
                          if (otploading == false)
                            TextButton(
                                onPressed: () async {
                                  if (_useremail.isNotEmpty) {
                                    setState(() {
                                      otploading = true;
                                    });
                                    bool result = await emailAuth.sendOtp(
                                        recipientMail: _useremail,
                                        otpLength: 6);
                                    if (result == true)
                                      setState(() {
                                        otploading = false;
                                      });
                                  }
                                },
                                child: Text("Request OTP")),
                          if (otploading == true)
                            Center(child: CircularProgressIndicator()),
                          Container(
                            width: MediaQuery.of(context).size.width / 2,
                            child: TextFormField(
                              validator: (val) {
                                if ((emailAuth as EmailAuth).validateOtp(
                                        recipientMail: _useremail,
                                        userOtp: _otp.value.text) ==
                                    false) return "wrong OTP";
                              },
                              controller: _otp,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  helperText: "Enter OTP sent at the email"),
                            ),
                          ),
                        ]),
                      if (widget.isloading == true)
                        Center(child: CircularProgressIndicator())
                      else
                        ElevatedButton(
                            onPressed: _submit,
                            child: Text(
                              _islogin == true ? 'Login' : 'Signup',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.pink))),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _islogin = !_islogin;
                          });
                        },
                        child: Text(
                          _islogin == true
                              ? 'Create New Account'
                              : 'Already have account',
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                      )
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
