import '../constants.dart';

String getApiLink(String countryCode, String phoneNumber) {
  return "$api$countryCode$phoneNumber";
}