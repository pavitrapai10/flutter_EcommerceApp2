import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isUsernameValid = false;
  bool isPasswordValid = false;
  String? usernameError;
  String? passwordError;

  Future<void> _saveUsername(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
  }

  Future<String?> _getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  void _validateUsername(String value) {
    setState(() {
      usernameError = value.isEmpty ? "Username is required" : null;
      isUsernameValid = usernameError == null;
    });
  }

  void _validatePassword(String value) {
    setState(() {
      if (value.isEmpty) {
        passwordError = "Password is required";
      } else if (value.length < 8) {
        passwordError = "Minimum 8 characters required";
      } else if (!RegExp(r'[A-Z]').hasMatch(value)) {
        passwordError = "Must contain 1 uppercase letter";
      } else if (!RegExp(r'[a-z]').hasMatch(value)) {
        passwordError = "Must contain 1 lowercase letter";
      } else if (!RegExp(r'\d').hasMatch(value)) {
        passwordError = "Must contain 1 digit";
      } else if (!RegExp(r'[@$!%*?&]').hasMatch(value)) {
        passwordError = "Must contain 1 special character";
      } else {
        passwordError = null;
      }
      isPasswordValid = passwordError == null;
    });
  }

  Future<void> _handleLogin() async {
    String username = _usernameController.text;
    await _saveUsername(username);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Username saved!')),
    );
    _login();  // Navigate to home screen
  }

  void _login() {
    if (isUsernameValid && isPasswordValid) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Wishlist", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: "Username",
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: usernameError != null ? Colors.red : Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: usernameError != null ? Colors.red : Colors.blue),
                  ),
                ),
                onChanged: _validateUsername,
              ),
              if (usernameError != null)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(usernameError!, style: const TextStyle(color: Colors.red, fontSize: 12)),
                ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: passwordError != null ? Colors.red : Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: passwordError != null ? Colors.red : Colors.blue),
                  ),
                ),
                onChanged: _validatePassword,
              ),
              if (passwordError != null)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(passwordError!, style: const TextStyle(color: Colors.red, fontSize: 12)),
                ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: (isUsernameValid && isPasswordValid) ? _handleLogin : null,
                child: const Text("Login"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
