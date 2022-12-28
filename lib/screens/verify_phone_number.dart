import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_auth_bloc/cubit/cubit/auth_cubit.dart';
import 'package:phone_auth_bloc/screens/home_screen.dart';

class VerifyPhoneNumberScreen   extends StatelessWidget {

  TextEditingController otpController = TextEditingController();

  VerifyPhoneNumberScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Verify Phone Number"),
      ),
      body: SafeArea(
        child: ListView(
          children: [

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  TextField(
                    controller: otpController,
                    maxLength: 6,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "6-Digit OTP",
                      counterText: ""
                    ),
                  ),

                  const SizedBox(height: 10,),

                  BlocConsumer<AuthCubit, AuthState>(
                    listener: (context, state) {
                      
                      if(state is AuthLoggedInState) {
                        Navigator.popUntil(context, (route) => route.isFirst);
                        Navigator.pushReplacement(context, CupertinoPageRoute(
                          builder: (context) => const HomeScreen()
                        ));
                      }
                      else if(state is AuthErrorState) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.red,
                            content: Text(state.error),
                            duration: const Duration(milliseconds: 2000),
                          )
                        );
                      }

                    },
                    builder: (context, state) {

                      if(state is AuthLoadingState) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      return SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: CupertinoButton(
                          onPressed: () {
                            
                            BlocProvider.of<AuthCubit>(context).verifyOTP(otpController.text);

                          },
                          color: Colors.blue,
                          child: const Text("Verify"),
                        ),
                      );
                    },
                  ),

                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}