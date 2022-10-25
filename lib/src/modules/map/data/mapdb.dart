import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';

import '../../../models/adsb/adsb.dart';
import '../../../models/ship/ship.dart';

class MapDB {
  static final DatabaseReference _firebaseDatabase =
      FirebaseDatabase.instance.ref();
  final DatabaseReference _adsbRef = _firebaseDatabase.child('adsb');
  final DatabaseReference _shipsRef = _firebaseDatabase.child('ships/1');
  // Future<MapMarkersData> _getRTDBData() async {
  //   final DataSnapshot adsbData = await _firebaseDatabase.child('adsb').get();
  //   final DataSnapshot shipsData =
  //       await _firebaseDatabase.child('ships/1').get();

  //   if (adsbData.exists) {
  //     final String encodedData = jsonEncode(adsbData.value);
  //     final String encodedShipsData = jsonEncode(shipsData.value);

  //     final Map<String, dynamic> adsbMap =
  //         jsonDecode(encodedData) as Map<String, dynamic>;

  //     final List<ADSB> adsbList = adsbMap.values.map((dynamic e) {
  //       return ADSB.fromJson(e as Map<String, dynamic>);
  //     }).toList();
  //     final List<dynamic> shipsList =
  //         jsonDecode(encodedShipsData) as List<dynamic>;

  //     final List<Ship> ships = shipsList.map((dynamic e) {
  //       return Ship.fromJson(e as Map<String, dynamic>);
  //     }).toList();

  //     return MapMarkersData(
  //       adsbs: adsbList,
  //       ships: ships,
  //     );
  //   } else {
  //     return MapMarkersData(
  //       adsbs: <ADSB>[],
  //       ships: <Ship>[],
  //     );
  //   }
  // }

  Stream<List<ADSB>> adsbStream() {
    return _adsbRef.onValue.map((DatabaseEvent event) {
      if (event.snapshot.exists) {
        final DataSnapshot data = event.snapshot;
        final String encodedData = jsonEncode(data.value);

        final Map<String, dynamic> adsbMap =
            jsonDecode(encodedData) as Map<String, dynamic>;

        final List<ADSB> adsbList = adsbMap
            .map<String, ADSB>((String key, dynamic value) {
              final Map<String, dynamic> data = value as Map<String, dynamic>;
              data['id'] = key;

              return MapEntry<String, ADSB>(
                key,
                ADSB.fromJson(data),
              );
            })
            .values
            .toList();

        return adsbList;
      } else {
        return [];
      }
    });
  }

  Stream<List<Ship>> shipsStream() {
    return _shipsRef.onValue.map((DatabaseEvent event) {
      if (event.snapshot.exists) {
        final DataSnapshot data = event.snapshot;

        final String encodedData = jsonEncode(data.value);

        final List<dynamic> shipsList =
            jsonDecode(encodedData) as List<dynamic>;

        final List<Ship> ships = shipsList
            .asMap()
            .map<int, Ship>((int index, dynamic value) {
              final Map<String, dynamic> data = value as Map<String, dynamic>;
              data['id'] = index.toString();

              return MapEntry<int, Ship>(
                index,
                Ship.fromJson(data),
              );
            })
            .values
            .toList();

        return ships;
      } else {
        return [];
      }
    });
  }
}

class MapMarkersData {
  MapMarkersData({
    required this.ships,
    required this.adsbs,
  });

  final List<Ship> ships;
  final List<ADSB> adsbs;
}
