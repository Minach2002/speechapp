import 'package:flutter/material.dart';
import 'package:real_project/screens/signin_screen.dart';
import 'package:real_project/screens/signup_screen.dart';
import 'package:real_project/theme/theme.dart';
import 'package:real_project/widgets/custom_scaffold.dart';
import 'package:real_project/widgets/welcome_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        children: [
          Flexible(
            flex: 8,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 40.0),
              child: Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: 'Deepvoice Ai\n ',
                        style: TextStyle(
                          fontSize: 45.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      TextSpan(
                        text: '\nHear the emotions, feel the voice!',
                        style: TextStyle(fontSize: 20,
                        color:Colors.white
                        ),
                        
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: Align(
              alignment: Alignment.bottomRight,
              child: Row(
                children: [
                 const Expanded(
                    child: WelcomeButton(
                      buttonText: 'Sign in',
                      onTap:SignInScreen() ,
                      color: Colors.transparent,
                      textColor: Colors.white,
                    ),
                    ) ,
              
                  Expanded(
                    child: WelcomeButton(
                      buttonText: 'Sign up',
                      onTap: const SignUpScreen(),
                      color: Colors.white,
                      textColor: Colors.black,
                    ),
                    ) ,
                  
                  ],
                ),
            ),
            ),
        ],
      ),
    );
  }
}
