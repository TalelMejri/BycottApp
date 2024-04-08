import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:com.talel.boycott/Core/utils/snack_bar_message.dart';
import 'package:com.talel.boycott/Features/Auth/presentation/bloc/signup/signup_bloc.dart';
import 'package:com.talel.boycott/Features/Auth/presentation/pages/login_pages.dart';
import 'package:com.talel.boycott/Features/Auth/presentation/pages/verify_pages.dart';
import 'package:com.talel.boycott/Features/Auth/presentation/widgets/SignUpForm.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignupBloc, SignupState>(
      listener: (context, state) {
        if (state is MessageSignupStateState) {
         Navigator.push(context,
           MaterialPageRoute(builder: (context)=>const VerifyPage()));
        } else if (state is ErrorSignupStateState) {
          SnackBarMessage()
              .showErrorSnackBar(message: state.message, context: context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme:
             const IconThemeData(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(child: Container(
                    child: Column(
                        children: [
                          Image.asset(
                            'images/image1.png',
                             height: 150,
                             width: 150,
                          ),
                          const Padding(
                          padding: EdgeInsets.only(
                              left: 20.0, right: 20.0),
                               child: Column(
                            children: [
                              Text(
                                'Create An Account !',
                                style: TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              ]
                            )
                          ),
                           const SignUpForm(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                   const Text(
                                    'Already Have An Account ?',
                                    style:  TextStyle(
                                        fontSize: 12.0, color: Colors.red),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                     Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()));
                                    },
                                    child:const Text(
                                      'Login',
                                      style: TextStyle(
                                          fontSize: 12.0,
                                          color: Colors.red,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ),
                        ]
                    )
        ),)
      ),
    );
  }
}