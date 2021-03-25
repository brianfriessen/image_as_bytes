import 'dart:async';
import 'dart:convert';

//import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

//Boilerplate
class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  static const String _title = 'JPG to Bytes';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: HomeWidget(),
    );
  }
}

class HomeWidget extends StatefulWidget {
  const HomeWidget({Key key}) : super(key: key);

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  String _url = 'https://picsum.photos/250?image=9'; //default url so there is something to display
  final _myController = TextEditingController(); //needed to get the contents of the text field

  //Function to update the url based on contents ot the text field
  _setURL(String url) {
    setState(() {
      _url = url;
    });
  }

  //Function that provides the Future which will trigger a rebuild of the gui
  Future<String> _getBytes(url) async {
    http.Response _response = await http.get(url);
    String _base64 = base64Encode(_response.bodyBytes);
    return _base64;
  }

  //Boilerplate
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _myController.text = _url; //give the field the default

    return Scaffold(
      appBar: AppBar(
        title: const Text('Get Image as Bytes'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
              // Flexible widget was the only one that seemed to work with large amount of text to display
              flex: 1,
              child: Center(child: Image.network(_url))),
          Flexible(
              flex: 1,
              child: ConstrainedBox(
                  constraints: BoxConstraints.tight(const Size(200, 50)), // control the size of the text field
                  // ..maybe not the right way to do this
                  child: TextField(
                    controller: _myController,
                    decoration: InputDecoration(
                      labelText: 'Image URL',
                      hintText: 'www.someimage.com/image9',
                     // icon: Icon(Icons.arrow_circle_down)
                    ),
                  ))),
          Flexible(
              flex: 1,
              child: TextButton.icon(
                  onPressed: () => _setURL(_myController.text),
                  icon: Icon(Icons.add_a_photo),
                  label: Text("Get Image"))),
          FutureBuilder(
              future: _getBytes(_url),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Flexible(
                      flex: 6,
                      //child: SelectableText(snapshot.data),
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(20),
                          // without scroll view inside a flexible widget get render errors
                          scrollDirection: Axis.vertical,
                          child: SelectableText(snapshot.data) // need to use selectable text not text widget

                          ));
                } else {
                  return Text('waiting');
                }
              })
        ],
      ),
    );
  }
}
