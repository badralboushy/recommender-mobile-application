import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:travel_guide/screens/home.dart';
import 'package:travel_guide/screens/signup.dart';
import 'package:travel_guide/services/authenticate.dart';

import 'login.dart';
class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {

  @override
  void initState() {
    super.initState();
    checkUser();
  }

  void checkUser()async{
    var isExist = await Authenticate.getToken();
    var name = await Authenticate.getName() ;
    var email = await Authenticate.getEmail();
    if (isExist!=null)
      {
        Navigator.push(context,MaterialPageRoute(builder: (context)=>HomePage()));
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.symmetric(horizontal: 30,vertical: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,

              children:<Widget> [
                Column(
                  children: <Widget> [
                    Text(
                      'Welcome',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'If you\'re offered a seat on a rocket ship,\n don\'t ask what seat!\n Just get on',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[700],

                      ),
                      textAlign: TextAlign.center,
                    )

                  ],
                ),
                Container(
                  height: MediaQuery.of(context).size.height/3,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/welcome.png'),
                      )
                  ),

                ),
                Column(
                  children: [
                    MaterialButton(onPressed:(){
                      Navigator.push(context,MaterialPageRoute(builder: (context)=>LoginPage()));

                    },
                      minWidth: double.infinity,
                      height: 60,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.circular(50)
                      ),
                      child: Text(
                        'Login',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    MaterialButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>SignupPage()));
                    },
                        color: Color(0xff0095ff),
                        height: 60,
                        minWidth: double.infinity,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)
                        ),
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        )
                    ),
                  ],
                )
              ],
            )

        ),
      ),
    );
  }
}



