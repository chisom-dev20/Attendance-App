import 'package:flutter/material.dart';
import 'package:sms/sms.dart';
import 'package:Attendance/signed_in_screen.dart';


class LoginPage extends StatefulWidget {

  final String course;
  LoginPage({this.course});
   @override
  State<StatefulWidget> createState() => new _LoginPageState();
 
}

class Courses{
  int id;
  String name;

  Courses(this.id, this.name);

  static List<Courses> getCourses() {
    return <Courses>[
      Courses(1, 'IT102'),
      Courses(2, 'MATH104'),
      Courses(3, 'ENG101'),
      Courses(4, 'MATH100'),
      Courses(5, 'CS306')
    ];

  }

}
class _LoginPageState extends State<LoginPage> {

  String course = " ";
  List<Courses> _courses = Courses.getCourses();
  List <DropdownMenuItem<Courses>> _dropdownMenuItems;
  Courses _selectedCourse;

  final formKey = new GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _idnumberController = TextEditingController();

  String _idnumber;
  String _name;
  String _errorMessage;
  bool _isIos;
  bool _isLoading = false;

    @override 
    void initState(){
       _dropdownMenuItems = buildDropdownMenuItems(_courses);
    _selectedCourse = _dropdownMenuItems[0].value; 
      super.initState();
      _errorMessage = "";
      _isLoading = false;
    }

    List<DropdownMenuItem<Courses>>buildDropdownMenuItems(List courses){
    List<DropdownMenuItem<Courses>> items = List();
      for(Courses course in courses) {
        items.add(DropdownMenuItem(value: course, 
        child: Text(course.name),
        )
        );
      }
        return items;
      }
    String select;
   onChangeDropdownItem(Courses selectedCourse){
    setState((){
      _selectedCourse = selectedCourse;
    });
    }

    bool validateAndSave() {
      final form = formKey.currentState;
    if (form.validate()) {
      form.save(); 
     return true;
      }
      else {
      return false;
      }
    }

   
    void _deliveringSMS() {
    try{
    SmsSender sender = SmsSender();
    String address = "+233206217770";
    SmsMessage message = SmsMessage(address, 'The student $_name with ID Number $_idnumber has signed attendance for todays $select class');
    message.onStateChanged.listen((state) {
      if (state == SmsMessageState.Sent) {
        print("SMS is sent!");
      setState(() {
        _isLoading = false;
      });
       Navigator.push(context, 
              MaterialPageRoute(
                builder: (_) => SignedInScreen (course: select,)));

      } else if (state == SmsMessageState.Delivered) {
        print("SMS is delivered!");
      }
    });
    sender.sendSms(message);
    }
    catch (e) {
      setState(() {
        _isLoading = false;
        if(_isIos)
        {
          _errorMessage = e.details;
        }
        else 
        _errorMessage = e.message;
      });
    }
  }

    void _verifyIdnumber() {
      setState(() {
        _isLoading =true;
      });
      _idnumber = _idnumberController.text;
      _idnumber = _idnumber.toLowerCase();
      _name = _nameController.text;
      
    try {
      _deliveringSMS();}
    catch(e){  
    { _errorMessage = "Something went wrong, Please check to see you have enough airtime on the sim card dedicated for SMS";
       setState(() {
        _isLoading = false;
      });
    } 
  }
   
  }
  
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
      _isIos = Theme.of(context).platform == TargetPlatform.iOS;
    return new Scaffold (
      body: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
                          child: SingleChildScrollView(
                  child: new Container(
                    padding: EdgeInsets.only(left: 25.0, right: 25.0,),
                    margin: null,
                    child: new Form(
                      key: formKey,
                      child: new Center(
                      child: Container(
                        height: height,
                               child: new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          verticalDirection: VerticalDirection.down,
                        children: _addBanner() +
                          _enterDetails() +
                          _showErrorMessage() +
                          _showCircularProgress(),
                    ),
                      ), 
                  )
          ),
           ),
              ),
            )
          );
        }

   List<Widget> _showCircularProgress() {
     Padding(padding: EdgeInsets.only(top: 30.0));
    if (_isLoading) {
      return [Center(child: CircularProgressIndicator())];
    }
    return [
      Container(
        height: 0.0,
        width: 0.0,
      )
    ];
  }

  List<Widget> _addBanner(){
          return[new Text("ATTENDANCE APP", style: new TextStyle(fontSize: 40.0, fontStyle: FontStyle.italic, color: Colors.orange)),
          ];
        }

  List <Widget> _enterDetails(){ 
return[
  Padding(padding: EdgeInsets.only(top: 30.0)),
    new TextFormField(
                decoration: new InputDecoration(labelText: 'Full Name', icon: Icon(Icons.person) ),
                controller: _nameController,
                validator: (_nameController) => _nameController.trim().length < 4 ? 'Please enter a valid name' : null, 
              ),
              new TextFormField(
               decoration: new InputDecoration(labelText: 'ID Number', icon: Icon(Icons.card_travel), ),
               controller: _idnumberController,
               validator:
                 (_idnumberController) => _idnumberController.trim().length != 12 ? 'Please enter a valid ID Number' : null,
               ),
               new DropdownButtonFormField(
               decoration: new InputDecoration(labelText: 'Course', icon: Icon(Icons.book),),
                value: _selectedCourse,
                items: _dropdownMenuItems,
                onChanged: onChangeDropdownItem,
                ),
               new FlatButton(
                child: new Text('Sign Attendance', style: new TextStyle(fontSize: 20.0, color: Colors.orange),),
                onPressed : () {
                    select = _selectedCourse.name; 
                    print ('$select');
      if (validateAndSave()){
                     showDialog(
      context: context, 
      barrierDismissible: true,
      builder: (BuildContext context){
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
        ),
       
        contentPadding: EdgeInsets.only(top:10.0, left: 10.0, right: 10.0, bottom: 10.0),
        title: Text("Confirmation", style: new TextStyle(color: Colors.orange, fontSize: 20.0),),
        content: Text(" An SMS will be sent to the lecturer. SMS charges will apply. Do you wish to continue?", style: TextStyle(color: Colors.black, fontSize: 15.0),
        
        ),
          actions: <Widget>[
             FlatButton(
              child: Text("No", style: new TextStyle(color: Colors.black)),
              onPressed:() => Navigator.pop(context),
            ),
            FlatButton(
              child: Text("Yes", style: new TextStyle(color: Colors.orange),),
              onPressed: (){
                _verifyIdnumber();
                Navigator.pop(context);
              }
            ),
          ]
      );
      }
    );
      }
      }
    )
];
  }

  List<Widget> _showErrorMessage(){
    Padding(padding: EdgeInsets.only(top: 30.0));
        if (_errorMessage.length > 0 && _errorMessage != null)
        {
          return [
            new Text(
              _errorMessage,
              style: TextStyle(
                fontSize: 13.0,
                color: Colors.red,
                height: 1.0,
                fontWeight: FontWeight.w300
              ),
            )
          ];
        }
        else{
          return [
            new Container(
              height: 0.0,
            )
          ];
        }
      }
  }


  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }