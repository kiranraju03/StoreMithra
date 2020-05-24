import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:flutter_dialogflow/v2/auth_google.dart';

//DialogFlow
// import 'package:flutter_dialogflow_v2/flutter_dialogflow_v2.dart' as df;
import 'package:flutter_dialogflow/dialogflow_v2.dart';
import 'package:provider/provider.dart';
//Unique user ID for session management
import 'package:uuid/uuid.dart';

//Speech Recognition
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import './buttons.dart';
import './chatmessage.dart';
import './providers/product_provider.dart';
// import './widgets/speech_text_convertor.dart';
// import './dialogflow_df.dart';

class HomePageDialogflow extends StatefulWidget {
  HomePageDialogflow({Key key}) : super(key: key);

  @override
  _HomePageDialogflow createState() => new _HomePageDialogflow();
}

class UserName {
  String name;
  UserName(String passedName) {
    name = passedName;
  }
}

class _HomePageDialogflow extends State<HomePageDialogflow> {
  
  List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = new TextEditingController();

  //Speech Recognition
  stt.SpeechToText speech = stt.SpeechToText();
  // String _currentLocaleId = "";
  // List<stt.LocaleName> _localeNames = [];
  bool _hasSpeech = false;

  String lastWords = "";
  String lastError = "";
  String lastStatus = "";

  UserName uname;

  ProductProvider productProvide;

  // String sessionValue;
  static final uuid = Uuid();
  String sessionValue = uuid.v1();

  String searchStringValue = '';

  List _btnList = [];
  // Map fulfillmentText = {};

  var fulfillmentText = {};

  void _resetSession() {
    setState(() {
      print('Reset');
      sessionValue = Uuid().v1();
      fulfillmentText = {};
      _btnList = [];
      _messages = [];
    });
  }

  void _response(query) async {
    _textController.clear();
    print('SessionCREATED');
    print(sessionValue);
    AuthGoogle authGoogle = await AuthGoogle(
            fileJson: "assets/storemitra-gtovui-0c1c50e4acf1.json",
            sessionId: sessionValue)
        .build();
    Dialogflow dialogflow = Dialogflow(authGoogle: authGoogle, language: 'en');
    print('*******QUERY*********');
    print(query);

    AIResponse response = await dialogflow.detectIntent(query);
    print('FIND THE BELOW***************************');

    var intentName = response.queryResult.intent.displayName;
    print(intentName);

    if (intentName == 'getAppliance') {
      print("Inside appliance case");
      Dialogflow dialogflow1 =
          Dialogflow(authGoogle: authGoogle, language: 'en');
      response = await dialogflow1.detectIntent(query);
      print(response.queryResult.intent.displayName);
    }
    if (intentName == "searchAffirmation") {
      print("Searched Correctly");
      var searchText = jsonDecode(response.getMessage());
      var applicanceType = searchText['Appliance'];
      productProvide.setApplianceType(applicanceType);
      searchStringValue = searchText.values.join(" ");
      print(searchStringValue);

      //Fetching the search results
      // String requestHeader =
      //     'https://api.homedepot.com/SearchNav/v2/pages/search?keyword=';
      // String requestTail =
      //     '&key= E0HyOA0cUMawX7HbYEHBAx9SeI1J8cPk&consumergroup=store&storeId=0121&type=json';
      // String requestString = requestHeader + searchStringValue + requestTail;
      // final response = await http.get(requestString);

      //Navigate to Search Page
      Navigator.pushNamed(context, '/productOverview',
          arguments: searchStringValue);
      return;
    }

    print("After if");
    print(response.queryResult.intent.displayName);

    var wh_message = response.webhookStatus.message;

    print(wh_message);

    if ((wh_message == "Webhook execution successful") &&
        (response.getMessage() == null)) {
      print("retrying the search");
      Dialogflow dialogflow2 =
          Dialogflow(authGoogle: authGoogle, language: 'en');
      response = await dialogflow2.detectIntent(query);

      var intentName2 = response.queryResult.intent.displayName;

      if (intentName2 == "searchAffirmation") {
        print("Searched Second time Correctly");
        var searchText = jsonDecode(response.getMessage());
        searchStringValue = searchText.values.join(" ");
        var applicanceType = searchText['Appliance'];
        productProvide.setApplianceType(applicanceType);
        print("Applicance Name : "+ applicanceType);
        print(searchStringValue);

        //Fetching the search results
        // String requestHeader =
        //     'https://api.homedepot.com/SearchNav/v2/pages/search?keyword=';
        // String requestTail =
        //     '&key= E0HyOA0cUMawX7HbYEHBAx9SeI1J8cPk&consumergroup=store&storeId=0121&type=json';
        // String requestString = requestHeader + searchStringValue + requestTail;
        // final response = await http.get(requestString);

        //Navigate to Search Page
        Navigator.pushNamed(context, '/productOverview',
            arguments: searchStringValue);
        return;
      }
    }

    print(response.getMessage());

    Map userMap = jsonDecode(response.getMessage());
    print(userMap['question']);
    print(userMap['options']);

    //Creating list of suggestions buttons
    _btnList = [...userMap['options']];

    ChatMessage message = new ChatMessage(
      // text: fulfillmentText['question'],
      text: userMap['question'],
      name: "StoreMithra",
      type: false,
    );

    setState(() {
      _messages.insert(0, message);
      _btnList = _btnList;
    });
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    ChatMessage message = new ChatMessage(
      text: text,
      name: uname.name,
      type: true,
    );
    setState(() {
      _messages.insert(0, message);
    });
    _response(text);
  }

  //Text Input position
  Widget _buildTextComposer() {
    return new IconTheme(
      data: new IconThemeData(color: Theme.of(context).accentColor),
      child: new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: new TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted,
                decoration:
                    new InputDecoration.collapsed(hintText: 'Send a message'),
              ),
            ),

            //CALL THE VOICE INPUT HERE
            // SpeechTextConvert(),
            speechText(),

            new Container(
              margin: new EdgeInsets.symmetric(horizontal: 4.0),
              child: new IconButton(
                  icon: new Icon(Icons.send),
                  onPressed: () => _handleSubmitted(_textController.text)),
            ),
          ],
        ),
      ),
    );
  }

  //Speech to Text component

  Future<void> initSpeechState() async {
    bool hasSpeech = await speech.initialize(
        onError: errorListener, onStatus: statusListener);
    if (hasSpeech) {
      // _localeNames = await speech.locales();

      // var systemLocale = await speech.systemLocale();
      // _currentLocaleId = systemLocale.localeId;
      print("System has voice enabled");
    }

    if (!mounted) return;

    setState(() {
      _hasSpeech = hasSpeech;
    });
  }

  void startListening() {
    lastWords = "";
    lastError = "";
    speech.listen(
        onResult: resultListener,
        listenFor: Duration(seconds: 10),
        localeId: 'en_US',
        // onSoundLevelChange: soundLevelListener,
        cancelOnError: true,
        partialResults: false);
    setState(() {});
  }

  void resultListener(SpeechRecognitionResult result) {
    setState(() {
      // lastWords = "${result.recognizedWords} - ${result.finalResult}";
      lastWords = "${result.recognizedWords}";
      print(lastWords);
    });
    _handleSubmitted(lastWords);
  }

  void errorListener(SpeechRecognitionError error) {
    setState(() {
      lastError = "${error.errorMsg} - ${error.permanent}";
    });
  }

  void statusListener(String status) {
    setState(() {
      lastStatus = "$status";
    });
  }

  Widget speechText() {
    if (!_hasSpeech) {
      initSpeechState();
    }
    return IconButton(
      icon: Icon(Icons.mic),
      onPressed: !_hasSpeech || speech.isListening ? null : startListening,
    );
  }

  @override
  Widget build(BuildContext context) {

    productProvide = Provider.of<ProductProvider>(context, listen: false);

    Object userNameField = ModalRoute.of(context).settings.arguments;

    uname = UserName(userNameField);

    return new Scaffold(
      appBar: new AppBar(
          title: new Text('StoreMithra',
              style: TextStyle(fontFamily: 'Samarkan')),
          actions: <Widget>[
            //Adding the search widget in AppBar
            IconButton(
              tooltip: 'Reset',
              icon: const Icon(Icons.replay),
              //Don't block the main thread
              onPressed: () {
                _resetSession();
              },
            ),
          ]),
      body: new Column(children: <Widget>[
        //Messages Display
        new Flexible(
            child: new ListView.builder(
          padding: new EdgeInsets.all(8.0),
          reverse: true,
          itemBuilder: (_, int index) => _messages[index],
          itemCount: _messages.length,
        )),
        //Suggesstion Buttons
        Container(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.all(5),
            children: [
              // for (int i = 0; i < min(2, _btnList.length); i++)
              //   Button(() => _handleSubmitted, _btnList[i])
              ...(_btnList).map((btnName) {
                return Button(() => _handleSubmitted(btnName), btnName);
              }).toList(),
            ],
          ),
        ),
        new Divider(height: 1.0),
        //Text Input
        new Container(
          decoration: new BoxDecoration(color: Theme.of(context).cardColor),
          child: _buildTextComposer(),
        ),
      ]),
    );
  }
}
