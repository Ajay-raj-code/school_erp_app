import 'package:permission_handler/permission_handler.dart';

class PermissionHandlerService{


  Future<void> requestLocationPermission() async {

    var status = await Permission.location.request();

    if (status.isGranted) {
      print("Location permission granted");
    }
    else if (status.isDenied) {
      print("Location permission denied");
    }
    else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  Future<void> requestBackgroundLocation() async {

    var status = await Permission.locationAlways.request();

    if (status.isGranted) {
      print("Background location granted");
    }
  }

  Future<bool> checkPermission() async {

    var status = await Permission.location.status;

    if (status.isGranted) {
      return true;
    }

    await Permission.location.request();
    return false;
  }
}