import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:get/get.dart';

class BLELoctionStateController extends GetxController {
  RxBool bluetoothState = false.obs;
  RxBool locationState = false.obs;

  bool get getBluetoothState => bluetoothState.value;
  bool get getLocationState => locationState.value;

  setBluetoothState(bool state) {
    bluetoothState.value = state;
  }

  setLocationState(bool state) {
    locationState.value = state;
  }
}
