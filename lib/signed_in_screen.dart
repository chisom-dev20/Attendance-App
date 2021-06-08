import 'package:flutter/material.dart';

class SignedInScreen extends StatefulWidget{
  
  final String course;
   
  SignedInScreen({this.course});
  @override
  _SignedInScreenState createState() => new _SignedInScreenState();
  
}

class _SignedInScreenState extends State<SignedInScreen> {
String _selectedCourse;
  
  @override
  Widget build(BuildContext context) {
    _selectedCourse = widget.course;
    print('$_selectedCourse');
    final height = MediaQuery.of(context).size.height;
          return new Scaffold(
            body: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
                          child: SingleChildScrollView(
                  child: new Container(
                    padding: EdgeInsets.only(left: 25.0, right: 25.0,),
                    margin: null,
                      child: new Center(
                      child: Container(
                        height: height,
                           child: new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          verticalDirection: VerticalDirection.down,
                        children: _message()
                      ), 
                  )
          ),
                ),
              ),
            )
          );
  }

  List<Widget> _message(){
    return
    [
      new Text("You have successfully signed the Attendance for Todays $_selectedCourse Lecture", style: new TextStyle(fontSize: 20.0, fontStyle: FontStyle.italic, color: Colors.orange, )),
          
          ];
  }
  
}
