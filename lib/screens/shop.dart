import 'package:click_and_chat/api/api.dart';
import 'package:click_and_chat/screens/home.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ShopView extends StatelessWidget {
  String countryCode = "65";
  final textInputController = TextEditingController();
  final chatsLeft = ValueNotifier<int>(0);
  

  Future<void> isCheckLeft() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("chatsLeft")) {
      prefs.setInt('chatsLeft', 20);
    }
    chatsLeft.value = await prefs.getInt("chatsLeft") ?? 0;
  }

  Future<void> addChat(int n, double cost) async {
    final prefs = await SharedPreferences.getInstance();
    chatsLeft.value += n;
    prefs.setInt('chatsLeft', chatsLeft.value);
  }

  Widget getPriceRow(int n, double cost, double width) {
    String chatsHeader;
    String chatsPrice;

    if (n == 1) {
      chatsHeader = n.toString() + " chat";
    } else {
      chatsHeader = n.toString() + " chats";
    }
    
    if (cost == 0.0) {
      chatsPrice = 'Free';
    } else {
      chatsPrice = "\$" + cost.toString();
    }
    

    return Padding(
      padding: EdgeInsets.only(left: width, right: width),
      child: 
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center, 
          children: [
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: 
                Text(
                  chatsHeader,
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 14)
                ),
            ),
            ElevatedButton (  
              child: Text(chatsPrice, style: TextStyle(fontSize: 20)),  
              onPressed: () => addChat(n, cost),
              style: ElevatedButton.styleFrom(
                  minimumSize: Size(width, 35) // put the width and height you want
                ),
            ),
          ]
        )
    );
  }


  Widget linkToShop(BuildContext context) {    
    TextStyle linkStyle = TextStyle(color: Colors.blue);
    return RichText(
      text: TextSpan(
        style: linkStyle,
        text: "Click here to go back",
        recognizer: TapGestureRecognizer()
        ..onTap = () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => Home(),
            ),
          );
        }
      )
    );
  }
  
  Widget getBody(BuildContext context) {  
    double buttonWidth = MediaQuery.of(context).size.width / 5;  
    return Scaffold(
      body: 
        Padding(
          padding: EdgeInsets.all(20.0),
          child:
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Click and chat!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                getPriceRow(1, 0.00, buttonWidth),
                getPriceRow(10, 0.99, buttonWidth),
                getPriceRow(25, 1.99, buttonWidth),
                getPriceRow(50, 3.99, buttonWidth),
                getPriceRow(100, 6.99, buttonWidth),
                Padding(
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  child:  
                      ValueListenableBuilder(
                        valueListenable: chatsLeft,
                        builder: (context, value, widget) {
                          return Text(
                            'You have ' + chatsLeft.value.toString() + ' chats left for today',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 14)
                          );
                        }
                      ),
                ),
                linkToShop(context)
              ],
            )
        )
    );
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
    future: isCheckLeft(),
    builder: (context, snapshot) {
      return getBody(context);
    },
  );
}