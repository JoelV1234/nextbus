import 'package:another_telephony/telephony.dart';

class SmsProvider {
  final Telephony telephony = Telephony.instance;

  Future<void> requestPermissions() async {
    await telephony.requestPhoneAndSmsPermissions;
  }

  Future<void> sendSms(String phoneNumber, String message) async {
    await telephony.sendSms(to: phoneNumber, 
    message: message);
  }

  Future<void> listenIncomingSms(
    dynamic onNewMessage,
    dynamic onBackgroundMessage,
  ) async {
    telephony.listenIncomingSms(
      onNewMessage: onNewMessage,
      onBackgroundMessage: onBackgroundMessage,
    );
  }
}
