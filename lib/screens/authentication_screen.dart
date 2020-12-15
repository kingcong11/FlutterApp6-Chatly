/* Packages */
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loading_overlay/loading_overlay.dart';

/* Helpers */
import '../helpers/database.dart';

/* Providers */
import 'package:chatly/providers/authentication_service_provider.dart';

enum AuthMode {
  Signin,
  Signup,
}

class AuthenticationScreen extends StatefulWidget {
  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen>
    with TickerProviderStateMixin {
  /* Properties */
  AnimationController _animationController;
  Animation<double> _opacityAnimation;

  final GlobalKey<FormState> _formKey = GlobalKey();

  DatabaseHelper db = new DatabaseHelper();
  var _isLoading = false;
  var _authMode = AuthMode.Signin;

  String _userUsername = '';
  String _userEmail = '';
  String _userPassword = '';

  @override
  void initState() {
    // set up animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /* Properties */
    final _mediaQuery = MediaQuery.of(context);
    final _deviceSize = _mediaQuery.size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: _deviceSize.height,
          width: _deviceSize.width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: LoadingOverlay(
            isLoading: _isLoading,
            color: Colors.grey[800],
            progressIndicator: SpinKitFadingCircle(
              color: Theme.of(context).primaryColor,
              size: 50.0,
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Container(
                    height: (_deviceSize.height - _mediaQuery.padding.top) * .4,
                    alignment: Alignment.bottomLeft,
                    padding: const EdgeInsets.only(left: 45, bottom: 20.0),
                    child: AnimatedCrossFade(
                      duration: Duration(milliseconds: 350),
                      crossFadeState: (_authMode == AuthMode.Signin)
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                      firstChild: HeadingText(text1: 'Welcome', text2: 'Back'),
                      secondChild:
                          HeadingText(text1: 'Create', text2: 'Account'),
                      firstCurve: Curves.fastLinearToSlowEaseIn,
                    ),
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 350),
                    height: (_deviceSize.height - _mediaQuery.padding.top) * .6,
                    padding: EdgeInsets.only(
                      left: 40.0,
                      right: 40.0,
                      top: (_authMode == AuthMode.Signin) ? 60 : 45,
                      bottom: 10.0,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          AnimatedContainer(
                            duration: Duration(milliseconds: 350),
                            curve: Curves.slowMiddle,
                            constraints: BoxConstraints(
                              minHeight:
                                  (_authMode == AuthMode.Signin) ? 0 : 60,
                              maxHeight:
                                  (_authMode == AuthMode.Signin) ? 0 : 120,
                            ),
                            child: FadeTransition(
                              opacity: _opacityAnimation,
                              child: TextFormField(
                                key: ValueKey('username'),
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  labelText: 'Username',
                                  labelStyle: TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w600,
                                  ),
                                  errorStyle: TextStyle(height: 0.6),
                                ),
                                validator: (value) {
                                  return _validateInput(value, 'username');
                                },
                                onSaved: (value) => _userUsername = value,
                              ),
                            ),
                          ),
                          TextFormField(
                            key: ValueKey('email'),
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              labelStyle: TextStyle(
                                fontSize: 20.0,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w600,
                              ),
                              errorStyle: TextStyle(height: 0.6),
                            ),
                            validator: (value) {
                              return _validateInput(value, 'email');
                            },
                            onSaved: (value) => _userEmail = value,
                          ),
                          TextFormField(
                            key: ValueKey('password'),
                            obscureText: true,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: TextStyle(
                                fontSize: 20.0,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w600,
                              ),
                              errorStyle: TextStyle(height: 0.6),
                            ),
                            validator: (value) {
                              return _validateInput(value, 'password');
                            },
                            onSaved: (value) => _userPassword = value,
                          ),
                          SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                (_authMode == AuthMode.Signin)
                                    ? 'Sign in'
                                    : 'Sign up',
                                style: TextStyle(
                                  fontSize: 26.0,
                                  color: Color(0xFF494d57),
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Builder(
                                builder: (ctx) => GestureDetector(
                                  child: Container(
                                    height: 70,
                                    width: 70,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        begin: Alignment.bottomLeft,
                                        end: Alignment.topRight,
                                        colors: [
                                          Color(0xFF494d57),
                                          Color(0xFF535964),
                                        ],
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.arrow_forward,
                                      size: 38,
                                      color: Colors.white,
                                    ),
                                  ),
                                  onTap: () {
                                    _trySubmitForm(ctx);
                                  },
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                child: Text(
                                  (_authMode == AuthMode.Signin)
                                      ? 'Sign up'
                                      : 'Sign in',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    if (_authMode == AuthMode.Signin) {
                                      _authMode = AuthMode.Signup;
                                      _animationController.forward();
                                    } else {
                                      _authMode = AuthMode.Signin;
                                      _animationController.reverse();
                                    }
                                  });
                                },
                              ),
                              Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /* Methods */
  String _validateInput(String value, String field) {
    if (value == null || value.isEmpty) {
      var displayField = field[0].toUpperCase() + field.substring(1);

      if (_authMode == AuthMode.Signin && field == 'username') {
        return null;
      } else {
        return '$displayField is required.';
      }
    }
    switch (field) {
      case 'username':
        if (value.length <= 7 && _authMode == AuthMode.Signup) {
          return 'Username should at least 8 characters long.';
        }
        break;
      case 'email':
        if (!EmailValidator.validate(value)) {
          return 'Please enter a valid Email Address.';
        }
        break;
      case 'password':
        if (value.length <= 7) {
          return 'Password should at least 8 characters long.';
        }
        break;
    }
    return null;
  }

  void _trySubmitForm(BuildContext ctx) {
    // close soft keyboard first
    FocusScope.of(context).unfocus();

    var isValid = _formKey.currentState.validate();

    if (!isValid) {
      return;
    } else {
      _formKey.currentState.save();
      _submitForm(
        _userUsername.trim(),
        _userEmail.trim(),
        _userPassword,
        _authMode,
        ctx,
      );
    }
  }

  Future<void> _submitForm(
    String username,
    String email,
    String password,
    AuthMode request,
    BuildContext ctx,
  ) async {
    setState(() {
      _isLoading = true;
    });
    UserCredential _authResult;

    try {
      if (request == AuthMode.Signin) {
        _authResult = await Provider.of<AuthenticationService>(context, listen: false).signIn(email, password);
      } else if (request == AuthMode.Signup) {
        _authResult = await Provider.of<AuthenticationService>(context, listen: false).signUp(email, password);

        await db.uploadUserInfo(_authResult.user.uid, {
          'username': username.trim().toLowerCase(),
          'email': email,
        });
      }
    } on FirebaseAuthException catch (e) {
      print('Error Caught on FirebaseAuthException');
      print(e.message);
      Scaffold.of(ctx).showSnackBar(SnackBar(
        content: Text(e.message),
        backgroundColor: Color(0xFFd74646),
      ));

      setState(() {
        _isLoading = false;
      });
    } on PlatformException catch (e) {
      print('Error Caught on PlatformException');
      Scaffold.of(ctx).showSnackBar(SnackBar(
        content: Text(e.message),
        backgroundColor: Color(0xFFd74646),
      ));
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error Caught on Generic Exception');
      print(e);
      setState(() {
        _isLoading = false;
      });
    }
  }
}

class HeadingText extends StatelessWidget {
  final String text1;
  final String text2;

  HeadingText({
    @required this.text1,
    this.text2 = '',
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      '$text1 \n$text2',
      textAlign: TextAlign.start,
      style: TextStyle(
        fontSize: 40,
        height: 1.0,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
