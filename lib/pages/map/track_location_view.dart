import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' hide State;
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_mbtiles/flutter_map_mbtiles.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:path_provider/path_provider.dart';
import 'package:school_erp_mobile/api/fmtc.dart';
import 'package:school_erp_mobile/api/location_service.dart';
import 'package:school_erp_mobile/api/permission_handle_service.dart';
import 'package:school_erp_mobile/components/widget_helper.dart';

import '../../components/color.dart';

class TrackLocationView  extends StatefulWidget{
  @override
  State<TrackLocationView> createState() => _TrackLocationViewState();
}

class _TrackLocationViewState extends State<TrackLocationView> {
   MbTilesTileProvider? tileProvider;
   final store =  FMTCStore("mapStore");

   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // tileProvider =
        // MbTilesTileProvider.fromPath(path: "assets/map/rajasthan.mbtiles");
    initMap();


  }

  void initMap() async {
    final dbPath = await copyMbtiles();
    print("It is called");
     tileProvider = MbTilesTileProvider.fromPath( path:dbPath);
  setState(() {
    
  });
    // use provider in flutter_map
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
  return Scaffold(
    backgroundColor: MyColor.lightBackBlue,
    appBar: AppBar(
      leading: IconButton(onPressed: () => Get.back() , icon: Icon(Icons.arrow_back, color: MyColor.white,)),
      title: Text(
        "Map",
        style: TextStyle(color: MyColor.white, fontWeight: FontWeight.w800),
      ),
      backgroundColor: MyColor.blue,
    ),
    body: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Row(
            spacing: 10,
            children: [

              Expanded(
                child: CustomButton(buttonText: "Start Driving", onTap: () async{
                  // PermissionHandlerService().requestLocationPermission();
                  // PermissionHandlerService().requestBackgroundLocation();
                  // final bool permissionStatus = await PermissionHandlerService().checkPermission();
                  // print(permissionStatus);
                  // if(permissionStatus){
                  //   LocationService.startTraking();
                  // }
                  await Fmtc().downloadArea();

                },),
              ),
              Expanded(
                child: CustomButton(buttonText: "Stop Driving", onTap: () {
                LocationService.stopTracking();
                },),
              )
            ],
          ),
          Expanded(
            child: Builder(builder: (context) {
              if(tileProvider == null){
                return CircularProgressIndicator();
              }
              return FlutterMap(
                options: MapOptions(
                  initialCenter: LatLng(26.521774410590994, 73.04845978208165),
                  initialZoom: 15,
                  minZoom: 10,
                  maxZoom: 16, // 🔥 adjust based on your mbtiles
                  cameraConstraint: CameraConstraint.contain(
                    bounds: LatLngBounds(
                      LatLng(26.0, 72.5),   // southwest
                      LatLng(26.8, 73.5),   // northeast
                    ),
                  ),
                ),

                children: [
                  TileLayer(
                    tms: true,
                    urlTemplate:  "https://tiles.locationiq.com/v3/streets/r/{z}/{x}/{y}.png?key=pk.29cb0db765a296157c14a8aadefeeaab",
                    tileProvider: FMTCTileProvider(stores: {'mapStore':BrowseStoreStrategy.read}, loadingStrategy: BrowseLoadingStrategy.cacheFirst),
                    userAgentPackageName: "Hello",
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: LatLng(26.321774410590994, 73.04845978208165),
                        width: 40,
                        height: 40,
                        child: Icon(Icons.location_on, color: Colors.red),
                      ),
                    ],
                  ),
                ],
              );
            },),
          )

        ],
      ),
    ),

  );

  }
}


Future<String> copyMbtiles() async {
  final dir = await getApplicationDocumentsDirectory();
  final path = "${dir.path}/map.mbtiles";

  // Check if already exists
  if (!File(path).existsSync()) {
    final data = await rootBundle.load("assets/map/rajasthan.mbtiles");
    final bytes = data.buffer.asUint8List();

    await File(path).writeAsBytes(bytes);
  }

  return path;
}