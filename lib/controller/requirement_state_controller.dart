import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:get/get.dart';

class RequirementStateController extends GetxController {
  var _startScanning = false.obs;
  var _pauseScanning = false.obs;

  bool get scanningStatus => _startScanning.value;

  startScanning() {
    _startScanning.value = true;
    _pauseScanning.value = false;
  }

  pauseScanning() {
    _startScanning.value = false;
    _pauseScanning.value = true;
  }

  Stream<bool> get startStream {
    return _startScanning.stream;
  }

  Stream<bool> get pauseStream {
    return _pauseScanning.stream;
  }

  @override
  String toString() => "_startScanning.value: ${_startScanning.value}";
}
