import 'package:flutter/material.dart';
import 'package:travel_guide/screens/login.dart';
import 'package:travel_guide/services/authenticate.dart';

import 'home.dart';

class SignupPage extends StatelessWidget {

  TextEditingController _name = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _confirmpassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,),


        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
          height: MediaQuery.of(context).size.height - 50,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text("Sign up",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,

                    ),),
                  SizedBox(height: 20,),
                  Text("Create an account, It's free ",
                    style: TextStyle(
                        fontSize: 15,
                        color:Colors.grey[700]),)


                ],
              ),
              Column(
                children: <Widget>[
                  inputFile(label: "Username" ,textEditingController: _name ),
                  inputFile(label: "Email" ,textEditingController: _email),
                  inputFile(label: "Password",textEditingController: _password ,obscureText: true),
                  inputFile(label: "Confirm Password ",textEditingController: _confirmpassword,obscureText: true),
                ],
              ),
              Container(
                padding: EdgeInsets.only(top: 3, left: 3),
                decoration:
                BoxDecoration(
                    borderRadius: BorderRadius.circular(50),


                ),
                child: MaterialButton(
                  minWidth: double.infinity,
                  height: 60,
                  onPressed: ()async {
                    if(_name.text.isEmpty){
                      Authenticate.showAlert(context, 'Username field is Empty');
                      return ;
                    }else if(_email.text.isEmpty){
                      Authenticate.showAlert(context, 'Email field is Empty');
                      return ;
                    }else if(_password.text.isEmpty){
                      Authenticate.showAlert(context, 'Password field is Empty');
                      return ;
                    }else if(_confirmpassword.text.isEmpty){
                      Authenticate.showAlert(context, 'Confirm password field is Empty');
                      return ;
                    }else if(_confirmpassword.text != _password.text){
                      Authenticate.showAlert(context, 'confirm password and password don\'t match');
                      return ;
                    }
                   bool response = await Authenticate.register(_name.text,_email.text,_password.text ,_confirmpassword.text);
                    if ( response ) {
                      Navigator.push(context,MaterialPageRoute(builder: (context)=>LoginPage()));
                    }
                    else {
                      // TODO : Show Error Message For Registering.
                      Authenticate.showAlert(context, 'User already Exists');

                    }
                  },
                  color: Color(0xff0095FF),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),

                  ),
                  child: Text(
                    "Sign up", style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Colors.white,

                  ),
                  ),

                ),



              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Already have an account?"),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context,MaterialPageRoute(builder: (context)=>LoginPage()));
                    },
                    child: Text(" Login", style:TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18
                    ),
                    ),
                  )
                ],
              )



            ],

          ),


        ),

      ),

    );
  }
}



// we will be creating a widget for text field
Widget inputFile({label,@required textEditingController, obscureText = false})
{
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        label,
        style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color:Colors.black87
        ),

      ),
      SizedBox(
        height: 5,
      ),
      TextField(
        controller: textEditingController,
        obscureText: obscureText,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0,
                horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.grey.shade400,
              ),

            ),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400)
            )
        ),
      ),
      SizedBox(height: 10,)
    ],
  );
}


//TODO api key for google map
//AIzaSyCCVFpeACtNvqhBfRSB0RjDEs0ztE7cBaY