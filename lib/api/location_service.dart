import 'package:dio/dio.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;
class LocationService{
  static Future<void> startTraking()  async{

    bg.BackgroundGeolocation.onLocation((location) {
      print("Latitude: ${location.coords.latitude}");
      print("Longitude: ${location.coords.longitude}");
      
    });
    
    bg.BackgroundGeolocation.onMotionChange((location) {
      print("Motion changed: ${location.coords.latitude}");
    },);

    bg.BackgroundGeolocation.ready(bg.Config(
      desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
      distanceFilter: 10,
      stopOnTerminate: false,
      startOnBoot: true,
      enableHeadless: true,
      debug: true,
      logLevel: bg.Config.LOG_LEVEL_VERBOSE,
    )).then((value) {
      if(!value.enabled){
        bg.BackgroundGeolocation.start();
      }
    },);
  }

  static Future<void>  stopTracking() async  {
    await  bg.BackgroundGeolocation.stop();
  }
}