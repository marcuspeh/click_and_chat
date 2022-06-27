import 'package:click_and_chat/api/api.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(Home());
}

class Home extends StatelessWidget {
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

  Future<void> removeOneChat() async {
    final prefs = await SharedPreferences.getInstance();
    chatsLeft.value--;
    prefs.setInt('chatsLeft', chatsLeft.value);
  }

  void _launchUrl() async {
    String urlLink = PHONE_URL + countryCode + textInputController.text;
    // if (!await launchUrl(Uri.parse(urlLink), mode: LaunchMode.externalApplication)) {
    //   throw 'Could not launch';
    // }
    removeOneChat();
  }

  Widget getBody() {    
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
                const Padding(
                  padding: EdgeInsets.only(top: 5),
                  child:
                    Text(
                      'Start a conversation with anyone on WhatsApp without saving their number. If you need more, do consider supporting the app by buying more.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16)
                    ),
                ),
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(15.0),
                      padding: const EdgeInsets.all(3.5),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child:  CountryCodePicker(
                        onChanged: (value) {
                          countryCode = value.toString().substring(1);
                        },
                        initialSelection: 'SG',
                        favorite: const ['+65','SG'],
                        showFlagDialog: true,
                        showFlagMain: false,
                        showCountryOnly: false,
                        showOnlyCountryWhenClosed: false,
                        alignLeft: false,
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: textInputController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter your number',
                        ),
                        keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                    ),
                  ]
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  child:
                    Text(
                      'Disclaimer: This app is not affiliated with WhatsApp',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14)
                    ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  child:  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [ 
                      ElevatedButton (  
                        child: const Text("Chat now", style: TextStyle(fontSize: 20),),  
                        onPressed: chatsLeft.value > 0 ?_launchUrl : null
                      ),
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
                    ]
                  ),
                ),
              ],
            )
        )
    );
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
    future: isCheckLeft(),
    builder: (context, snapshot) {
      return getBody();
    },
  );
}