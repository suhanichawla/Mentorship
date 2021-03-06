

import 'package:dbapp/services/profile.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dbapp/services/auth.dart';
import 'package:dbapp/screens/sidebarScreens/about.dart';
import 'package:dbapp/screens/sidebarScreens/faqs.dart';
import 'package:dbapp/screens/sidebarScreens/feedback.dart';
import 'package:dbapp/screens/sidebarScreens/guidelines.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dbapp/shared/loading.dart';


class profile extends StatefulWidget {
  @override
  _profileState createState() => new _profileState();
}

class _profileState extends State<profile> {
   final AuthService _auth=AuthService();
   final FirebaseAuth _authUser = FirebaseAuth.instance;
  Future<FirebaseUser> getCurrentUser(){
    return _authUser.currentUser();
  }
    String name='';
    String email='';
    int year;
    String branch='';
    int roll;
    int contact;
    String linked;
    String git;
    List languages=[];
    List domains=[];
    bool hostel=false;
    bool mentor;
    bool loading=true;
  @override
  void initState(){
    super.initState();
    print("hi");
    getCurrentUser().then((user){
        ProfileService()
      .getMenteeProfile(user.uid)
      .then((DocumentSnapshot docs){
        if(docs.exists){
          print(docs.data["email"]);
          setState(() {
              name=docs.data["name"];
              email=docs.data["email"];
              year=docs.data["year"];
              roll=docs.data["rollNo"];
              contact=docs.data["contact"];
              git=docs.data['githubURL'];
              linked=docs.data['linkedInURL'];
              languages=docs.data['languages'];
              domains=docs.data['domains'];
              hostel=docs.data['hosteller'];
              mentor=false;
              loading=false;
          });
        }else{
            ProfileService().getMentorProfile(user.uid)
            .then((DocumentSnapshot docs){
              if(docs.exists){
                print(docs.data["year"]);
                setState(() {
                    name=docs.data["name"];
                    email=docs.data["email"];
                    year=docs.data["year"];
                    roll=docs.data["rollNo"];
                    git=docs.data['githubURL'];
                    linked=docs.data['linkedInURL'];
                    contact=docs.data["contact"];
                    languages=docs.data['languages'];
                    domains=docs.data['domains'];
                    hostel=docs.data['hosteller'];
                    mentor=true;
                    loading=false;
                });
              }
            });
        }
     });
    });
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title:Text("Your Profile"),
        backgroundColor:Colors.teal[300] ,
        elevation: 0.0,
        // actions: <Widget>[
        //   FlatButton.icon(
        //     onPressed: () async{
        //       await _auth.signOut();
        //     }, 
        //     icon: Icon(Icons.person),
        //     label:Text('logout')
        //     )
        // ],
      ),
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            new ListTile(
              title: new Text("Code of Conduct"),
              trailing: new Icon(Icons.arrow_right),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new Guidelines()));
              }
            ),
            new ListTile(
              title: new Text("About"),
              trailing: new Icon(Icons.arrow_right),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new About()));
              }
            ),
            new ListTile(
              title: new Text("FAQs"),
              trailing: new Icon(Icons.arrow_right),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new FAQS()));
              }
            ),
            
            new ListTile(
              title: new Text("Contact us and feedback"),
              trailing: new Icon(Icons.arrow_right),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new MyFeedback()));
              }
            ),
             
            new Divider(),
            new ListTile(
              trailing: Transform.scale(
                scale: 1.4,
                child: Switch(
                  value: _darkTheme,
                  onChanged: (val) {
                    setState(() {
                      _darkTheme = val;
                    });
                    onThemeChanged(val, _themeChanger);
                  },
                ),
              ),
              // leading: new IconButton(
              //             onPressed: () => _themeChanger.setTheme(Theme.dark()),
              //             icon: Icon(
              //               Icons.brightness_3
              //             ),
              //             color: Hexcolor('#565656'),
              //           ),
              // title: new Text("Change Theme"),
              // onTap: () {
              //   Navigator.of(context).pop();
              //   Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new ThemeChanger(ThemeData.dark())));
              // }
            ),           
            new Divider(),
            new ListTile(
              title: new Text("Logout"),
              trailing: new Icon(Icons.people),
              onTap: () async => await _auth.signOut()
            ),
          ],
        ),
      ),
      body: loading ?  Loading() : new Stack(
        children: <Widget>[
          
          ClipPath(
            child: 
            // Container(
            //   decoration: BoxDecoration(
            //     image: DecorationImage(
            //       image: AssetImage(
            //         "assets/images/bg2.jpg",
            //       ),    
            //     ),
            //   ),
            //   color: Hexcolor('#565656'),
            // ),
            Column(
              children: <Widget>[
                Image.asset(
                  "assets/images/bg2.jpg",
                  width: MediaQuery.of(context).size.width,
                ),
              ],
            ),

            clipper: getClipper(),
          ),
          Positioned(
            
            width: MediaQuery.of(context).size.width ,
            top: MediaQuery.of(context).size.height / 9,
            child: Column(
              children: <Widget>[
                Container(
                  width: 150.0,
                  height: 150.0,
                  decoration: BoxDecoration(
                    color: Hexcolor('#96ece7'),
                    // image: DecorationImage(
                    //   image: AssetImage("assets/images/profilebg.jpg"),
                    //   fit: BoxFit.fit,
                    // ),
                    borderRadius: BorderRadius.all(Radius.circular(175.0)),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 7.0,
                        color: Colors.black,
                      )
                    ]
                  ),
                ),
                SizedBox( height: 35),
                Text(
                  name,
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      // color: Hexcolor('#565656'),
                      // fontFamily: GoogleFonts,
                      fontSize: 28,
                    ),
                  ),
                ),
                SizedBox( height: 8),
                Text(
                  mentor==false ? "Mentee" : "Mentor",
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      fontSize: 20,
                      color: Hexcolor('#96ece7'),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),

                SizedBox( height: 15),
                Text(
                  email==null? "null" : email,
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      //color: Hexcolor('#565656'),
                      fontSize: 20,
                    ),
                  ),
                ),
                
                SizedBox( height: 10),
                Text(
                  contact.toString(),
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                     // color: Hexcolor('#565656'),
                      fontSize: 20,
                    ),
                  ),
                ),

                SizedBox( height: 10),
                Text(
                  year == null ? "null" : year.toString()+" "+branch,
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                     // color: Hexcolor('#565656'),
                      fontSize: 20,
                    ),
                  ),
                ),

                SizedBox( height: 10),
                Text(
                  roll==null ? "nul" : roll.toString(),
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      // color: Hexcolor('#565656'),
                      fontSize: 20,
                    ),
                  ),
                ),

                SizedBox( height: 10),
                Text(
                  linked==null ? "null" : linked,
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      //color: Hexcolor('#565656'),
                      fontSize: 20,
                    ),
                  ),
                ),

                SizedBox( height: 10),
                Text(
                  git==null? "null" : git,
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      //color: Hexcolor('#565656'),
                      fontSize: 20,
                    ),
                  ),
                ),

                SizedBox( height: 10),
                Text(
                  languages.length==0? "null" : "Languages: "+languages.toString(),
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      //color: Hexcolor('#565656'),
                      fontSize: 20,
                    ),
                  ),
                ),
                SizedBox( height: 10),
                Text(
                  domains.length==0? "null" : "Domains: "+domains.toString(),
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      //color: Hexcolor('#565656'),
                      fontSize: 20,
                    ),
                  ),
                ),

                SizedBox( height: 10),
                Text(
                  hostel ? "Hosteller: Yes" : "Hosteller: No",
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      //color: Hexcolor('#565656'),
                      fontSize: 20,
                    ),
                  ),
                ),

                SizedBox( height: 25),
                Container(
                  height: 30,
                  width: 95,
                  child: Material(
                    borderRadius: BorderRadius.circular(25),
                    shadowColor: Colors.blueGrey[200],
                    elevation: 7.0,
                    child: GestureDetector(
                      onTap: () {},
                      child: Center(
                        child: Text(
                          'Edit Info',
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                              color: Colors.teal[300],
                            ),
                          ),
                        ),
                      ),
                      
                    ),
                  ),
                ),
              ],
            ) 
          )
          
        ],        
      ),
    );
  }
}

class getClipper extends CustomClipper<Path>{
  @override
  Path getClip(Size size){
    var path = new Path();
    path.lineTo(0.0, size.height/3.3);
    path.lineTo(size.width + 500, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper){
    return true;
  }
}