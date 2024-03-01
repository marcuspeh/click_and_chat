import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../util/get_api_link.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final FlCountryCodePicker countryPicker;
  late final TextEditingController phoneTextController;

  CountryCode? countryCode;
  bool hasMaxLengthError = false;

  void _launchUrl() async {
    String urlLink = getApiLink(countryCode!.dialCode, phoneTextController.text);
    Uri uri = Uri.parse(urlLink);
    if (!await launchUrl(uri)) {
      throw 'Could not launch';
    }
  }

  void _countryPickerOnTap() async {
    final code = await countryPicker.showPicker(
      context: context,
      scrollToDeviceLocale: true,
    );
    if (code != null) {
      setState(() => countryCode = code);
    }
  }

  @override
  void initState() {
    super.initState();

    String code = PlatformDispatcher.instance.locale.countryCode ?? 'US';
    countryCode = CountryCode.fromCode(code);

    phoneTextController = TextEditingController()
      ..addListener(() {
        if (countryCode != null &&
            countryCode!.nationalSignificantNumber != null) {
          if (phoneTextController.text.length !=
              countryCode!.nationalSignificantNumber!) {
            hasMaxLengthError = true;
          } else {
            hasMaxLengthError = false;
          }

          setState(() {});
        }
      });

    countryPicker = const FlCountryCodePicker(
      countryTextStyle: TextStyle(
        color: Colors.red,
        fontSize: 16,
      ),
      dialCodeTextStyle: TextStyle(color: Colors.green, fontSize: 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Click and Chat'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              maxLines: 1,
              controller: phoneTextController,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                prefix: GestureDetector(
                  onTap: _countryPickerOnTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: const BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    child: Text(countryCode?.dialCode ?? '+1',
                        style: const TextStyle(color: Colors.white)),
                  ),
                ),
                labelText: 'Phone Number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: const BorderSide(),
                ),
                fillColor: Colors.white,
                filled: true,
                errorText: hasMaxLengthError || phoneTextController.text != ""
                    ? 'Please enter exactly ${countryCode?.nationalSignificantNumber} digits.'
                    : null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 5),
              child:  Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [ 
                  ElevatedButton (  
                    onPressed: !hasMaxLengthError && phoneTextController.text.isNotEmpty ?_launchUrl : null,  
                    child: const Text("Chat now", style: TextStyle(fontSize: 20),)
                  ),
                ]
              )
            ),
            const Text(
              "Chat on WhatsApp without saving numbers",
            )
          ],
        ),
      )
    );
  }
}

