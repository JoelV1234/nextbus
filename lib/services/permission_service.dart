import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Future<bool> isSmsAllowed() async {
    return Permission.sms.isGranted;
  }

  Future<bool> getSmsPermission() async {
    final statusSms = await Permission.sms.request();
    return statusSms.isGranted;
  }
}
