import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:com.talel.boycott/Features/Auth/domain/entities/login_entity.dart';
import 'package:com.talel.boycott/Features/Auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:com.talel.boycott/Features/Auth/presentation/widgets/auth_btn.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});
  @override
  LoginFormState createState() {
    return LoginFormState();
  }
}

class LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _pwdController = TextEditingController();

  bool Hidden=true;

  @override
  void dispose() {
    _usernameController.dispose();
    _pwdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'username is required'; //dans le dossier Strings
                }
                return null;
              },
              keyboardType: TextInputType.emailAddress,
              controller: _usernameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter your email',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextFormField(
              obscureText: Hidden,
              enableSuggestions: false,
              autocorrect: false,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'password is required';
                }
                return null;
              },
              controller: _pwdController,
              decoration:  InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter your password',
                suffixIcon:IconButton(icon: Icon(!Hidden ? Icons.visibility : Icons.visibility_off),onPressed: (){
                       setState(() {
                         Hidden=!Hidden;
                       });
                    },
                )
              ),
            ),
          ),
          // Padding(padding:const EdgeInsets.only(left: 280),child:
          //   GestureDetector(
          //                onTap: () {
          //                            Navigator.push(
          //                 context,
          //                 MaterialPageRoute(
          //                     builder: (context) => const ForgetPasswordPage()));
          //                           },
          //                           child:const Text(
          //                             'Forget Password ?',
          //                             style: TextStyle(
          //                                 fontSize: 12.0,
          //                                 color: Colors.blue,
          //                                 fontWeight: FontWeight.w600
          //                             ),
          //                           ),
          //  ),),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            child: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is LoginProgressState) {
                  return const CircularProgressIndicator(
                    color: Colors.green,
                  );
                } else {
                  return AuthButton(
                      text: "Login",
                      onPressed: validateAndLoginUser,
                      color: Colors.green);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void validateAndLoginUser() {
    if (_formKey.currentState!.validate()) {
      final user = LoginEntity(
          email: _usernameController.text.trim(),
          password: _pwdController.text.trim());
          BlocProvider.of<AuthBloc>(context).add(LoginEvent(user: user));
    }
  }
}