import 'package:click_and_chat/api/api.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(Home());
}

class Home extends StatelessWidget {
  String countryCode = "65";
  final textInputController = TextEditingController();

  void _launchUrl() async {
    String urlLink = PHONE_URL + countryCode + textInputController.text;
    print("########################");
    print(urlLink);
    if (!await launchUrl(Uri.parse(urlLink), mode: LaunchMode.externalApplication)) {
      throw 'Could not launch';
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
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
              padding: EdgeInsets.only(top: 5, bottom: 20),
              child:
                Text(
                  'This app is built as a side project for starting a conversation with anyone on WhatsApp using their API. This app is not affiliated with WhatsApp at all.',
                  textAlign: TextAlign.center,
                  style: TextStyle()
                ),
            ),
            Row(
              children: [
                CountryCodePicker(
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
            ElevatedButton (  
              child: const Text("Text now", style: TextStyle(fontSize: 20),),  
              onPressed: _launchUrl
            )  
          ],
        )
    )
  );
}