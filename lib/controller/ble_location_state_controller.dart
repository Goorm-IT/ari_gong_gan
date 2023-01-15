import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';

class BLELoctionStateController extends GetxController {
  RxBool bluetoothState = false.obs;
  RxBool locationState = false.obs;

  bool get getBluetoothState => bluetoothState.value;
  bool get getLocationState => locationState.value;

  setBluetoothState(bool state) {
    bluetoothState.value = state;
  }

  Future<bool> checkLocation() async {
    Location location = new Location();
    bool _serviceEnabled = false;
    _serviceEnabled = await location.serviceEnabled();

    return _serviceEnabled;
  }

  setLocationState() async {
    locationState.value = await checkLocation();
  }
}
