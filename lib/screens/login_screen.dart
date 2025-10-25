import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gym_fitness_app/screens/home_dashboard.dart';
import 'package:gym_fitness_app/screens/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailOrPhoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _rememberMe = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('user_email');
    final savedPassword = prefs.getString('user_password');
    if (savedEmail != null && savedPassword != null) {
      setState(() {
        _emailOrPhoneController.text = savedEmail;
        _passwordController.text = savedPassword;
        _rememberMe = true;
      });
    }
  }

  @override
  void dispose() {
    _emailOrPhoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSocialLogin(String provider) {
    setState(() {
      _isLoading = true;
    });
    // Simulate social login
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeDashboardScreen()),
      );
    });
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // Retrieve stored credentials
      final prefs = await SharedPreferences.getInstance();
      final storedEmail = prefs.getString('user_email');
      final storedPassword = prefs.getString('user_password');

      // Validate credentials
      if (storedEmail == null || storedPassword == null) {
        setState(() {
          _errorMessage = 'No user found. Please sign up first.';
          _isLoading = false;
        });
        return;
      }

      if (storedEmail == _emailOrPhoneController.text &&
          storedPassword == _passwordController.text) {
        // Save credentials if Remember Me is checked
        if (_rememberMe) {
          await prefs.setString('user_email', _emailOrPhoneController.text);
          await prefs.setString('user_password', _passwordController.text);
        } else {
          await prefs.remove('user_email');
          await prefs.remove('user_password');
        }

        // Successful login
        Future.delayed(Duration(seconds: 1), () {
          setState(() {
            _isLoading = false;
          });
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeDashboardScreen()),
          );
        });
      } else {
        // Invalid credentials
        setState(() {
          _errorMessage = 'Incorrect email or password';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.white,
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/gym.jpg',
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.error, color: Colors.red);
                    },
                  ),
                ),
              ),
              SizedBox(height: 20),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: 'Gym',
                      style: TextStyle(color: Colors.green),
                    ),
                    TextSpan(
                      text: ' & ',
                      style: TextStyle(color: Colors.black),
                    ),
                    TextSpan(
                      text: 'Fitness',
                      style: TextStyle(color: Colors.blue),
                    ),
                    TextSpan(
                      text: ' App',
                      style: TextStyle(color: Colors.pink),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      if (_errorMessage != null)
                        Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Text(
                            _errorMessage!,
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      TextFormField(
                        controller: _emailOrPhoneController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.withOpacity(0.2),
                          hintText: 'Email or Phone',
                          hintStyle: TextStyle(color: Colors.grey[600]),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: TextStyle(color: Colors.black),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email or phone';
                          }
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                  .hasMatch(value) &&
                              !RegExp(r'^\+?[1-9]\d{1,14}$').hasMatch(value)) {
                            return 'Please enter a valid email or phone number';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.withOpacity(0.2),
                          hintText: 'Password',
                          hintStyle: TextStyle(color: Colors.grey[600]),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey[600],
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                        style: TextStyle(color: Colors.black),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: _rememberMe,
                                onChanged: (value) {
                                  setState(() {
                                    _rememberMe = value ?? false;
                                  });
                                },
                              ),
                              Text(
                                'Remember Me',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'Forgot password?',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      _isLoading
                          ? CircularProgressIndicator(color: Colors.green)
                          : Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.green, Colors.lightBlue],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ElevatedButton(
                                onPressed: _handleLogin,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  minimumSize: Size(double.infinity, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 0,
                                ),
                                child: Text(
                                  'Log In',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                              ),
                            ),
                      SizedBox(height: 20),
                      Text(
                        'Or continue with',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () => _handleSocialLogin('google'),
                            icon: CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.white,
                              child: Image.asset(
                                'assets/images/google.jpeg',
                                width: 24,
                                height: 24,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(Icons.error, color: Colors.red);
                                },
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          IconButton(
                            onPressed: () => _handleSocialLogin('facebook'),
                            icon: CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.white,
                              child: Image.asset(
                                'assets/images/facebook.jpeg',
                                width: 24,
                                height: 24,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(Icons.error, color: Colors.red);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUpScreen()),
                          );
                        },
                        child: Text(
                          "Don't have an account? SIGN UP",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'Terms of Service',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ),
                          Text(
                            '|',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'Privacy Policy',
                              style: TextStyle(color: Colors.grey[600]),
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
    );
  }
}
