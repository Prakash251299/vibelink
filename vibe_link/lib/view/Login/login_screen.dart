import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vibe_link/controller/login/login.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
              Color(0xffB81736),
              Color(0xff281537),
            ]),
          ),
          child: const Padding(
            padding: EdgeInsets.only(top: 60.0, left: 22),
            child: Text(
              'Hello\nSign in!',
              style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 200.0),
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40), topRight: Radius.circular(40)),
              color: Colors.white,
            ),
            height: double.infinity,
            width: double.infinity,
            child:  Padding(
              padding: const EdgeInsets.only(left: 18.0,right: 18),
              child: SingleChildScrollView(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const TextField(
                      decoration: InputDecoration(
                        suffixIcon: Icon(Icons.check,color: Colors.grey,),
                        label: Text('Gmail',style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color:Color(0xffB81736),
                        ),)
                      ),
                    ),
                    const TextField(
                      decoration: InputDecoration(
                          suffixIcon: Icon(Icons.visibility_off,color: Colors.grey,),
                          label: Text('Password',style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color:Color(0xffB81736),
                          ),)
                      ),
                    ),
                    const SizedBox(height: 20,),
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Text('Forgot Password?',style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Color(0xff281537),
                      ),),
                    ),
                    const SizedBox(height: 70,),
                    Container(
                      height: 55,
                      width: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xffB81736),
                            Color(0xff281537),
                          ]
                        ),
                      ),
                      child: Center(child: Text('SIGN IN',style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white
                      ),),),
                    ),
                    SizedBox(height:20),
                    GestureDetector(
                      child: Container(
                        height: 55,
                        width: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xffB81736),
                              Color(0xff281537),
                            ]
                          ),
                        ),
                        child: Center(child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children:[
                            SvgPicture.asset(
                              'assets/google.svg'
                            ),
                          Text('Google sign in',style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white
                        ),),]),),
                      ),
                      onTap: (){
                        LoginPage _loginController = LoginPage();
                        _loginController.login(context);
                      },
                    ),
                    
                    const SizedBox(height: 150,),
                    const Align(
                      alignment: Alignment.bottomRight,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("Don't have account?",style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey
                          ),),
                          Text("Sign up",style: TextStyle(///done login page
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: Colors.black
                          ),),
                        ],
                      ),
                    )
                
                  ],
                ),
              ),

            ),
          ),
        ),
      ],
    ));
  }
}