import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:latlong2/latlong.dart';

class Fmtc{
  final store =  FMTCStore("mapStore");
  Future<void> downloadArea() async{
    final region = RectangleRegion(
      LatLngBounds(
        LatLng(26.0, 72.5), // SW
        LatLng(26.8, 73.5), // NE
      ),
    );
    final options = TileLayer(
      urlTemplate: "https://tiles.locationiq.com/v3/streets/r/{z}/{x}/{y}.png?key=pk.29cb0db765a296157c14a8aadefeeaab",
    );
    await store.download.startForeground(
      instanceId: 1,
      region: region.toDownloadable(minZoom: 10, maxZoom: 16, options: options),
    );
    print("Download started ✅ the map");

  }



}