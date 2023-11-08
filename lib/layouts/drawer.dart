import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:travel_guide/screens/home.dart';
import 'package:travel_guide/screens/welcome.dart';
import 'package:travel_guide/screens/wishlist.dart';
import 'package:travel_guide/services/authenticate.dart';

class AccountDrawer extends StatefulWidget {
  const AccountDrawer({Key? key}) : super(key: key);

  @override
  _AccountDrawerState createState() => _AccountDrawerState();
}

class _AccountDrawerState extends State<AccountDrawer> {
  String? name ;
  String? email ;
  @override
  void initState() {
    super.initState();
    getAccountInfo();
  }

  Future<void> getAccountInfo()async{
   var n =await Authenticate.getName() ;
   var e= await Authenticate.getEmail();
    setState(() {
      name =n ;
      email = e ;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Drawer(

      child: Column(
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
             // radius: 30.0,
              backgroundImage: AssetImage('assets/images/user2.png'),            ),
              accountName: Text('$name'),
              accountEmail: Text('$email'),
          ),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: Icon(Icons.home),
                  title : Text('Home Page'),
                  onTap: (){
                    Navigator.push(context,MaterialPageRoute(builder: (context)=>HomePage()));
                  },
                ),
     


                ListTile(
                  leading: Icon(Icons.favorite),
                  title : Text('favourite'),
                  onTap: (){
                    Navigator.push(context,MaterialPageRoute(builder: (context)=>WishListPage(),),);

                  },
                ),
                ListTile(
                  leading: Icon(Icons.help_outline),
                  title : Text('Help'),
                  onTap: (){
                  },
                ),

                ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text('Logout'),
                  onTap: ()async{
                    bool res = await Authenticate.logOut();
                    if (res){
                      Navigator.push(context,MaterialPageRoute(builder: (context)=>WelcomePage(),),);
                    }

                  },
                )
              ],
            ),
          )

        ],
      ),
    );
  }
}
