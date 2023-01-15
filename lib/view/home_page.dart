// import 'dart:async';
// import 'dart:io';
// import 'package:ari_gong_gan/controller/requirement_state_controller.dart';
// import 'package:ari_gong_gan/view/app_broadcasting.dart';
// import 'package:ari_gong_gan/view/app_scanning.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_beacon/flutter_beacon.dart';
// import 'package:get/get.dart';
// import 'package:permission_handler/permission_handler.dart';

// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
//   final controller = Get.find<RequirementStateController>();
//   StreamSubscription<BluetoothState>? _streamBluetooth;
//   int currentIndex = 0;

//   @override
//   void initState() {
//     WidgetsBinding.instance.addObserver(this);

//     super.initState();
//     listeningState();
//   }

//   listeningState() async {
//     print('Listening to bluetooth state');
//     _streamBluetooth = flutterBeacon
//         .bluetoothStateChanged()
//         .listen((BluetoothState state) async {
//       controller.updateBluetoothState(state);
//       await checkAllRequirements();
//     });
//   }

//   checkAllRequirements() async {
//     final bluetoothState = await flutterBeacon.bluetoothState;
//     controller.updateBluetoothState(bluetoothState);
//     print('BLUETOOTH $bluetoothState');

//     final authorizationStatus = await flutterBeacon.authorizationStatus;
//     controller.updateAuthorizationStatus(authorizationStatus);
//     print('AUTHORIZATION $authorizationStatus');

//     final locationServiceEnabled =
//         await flutterBeacon.checkLocationServicesIfEnabled;
//     controller.updateLocationService(locationServiceEnabled);
//     print('LOCATION SERVICE $locationServiceEnabled');

//     if (controller.bluetoothEnabled &&
//         controller.authorizationStatusOk &&
//         controller.locationServiceEnabled) {
//       print('STATE READY');
//       if (currentIndex == 0) {
//         print('SCANNING');
//         controller.startScanning();
//       } else {
//         print('BROADCASTING');
//         controller.startBroadcasting();
//       }
//     } else {
//       print('STATE NOT READY');
//       controller.pauseScanning();
//     }
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) async {
//     print('AppLifecycleState = $state');
//     if (state == AppLifecycleState.resumed) {
//       if (_streamBluetooth != null) {
//         if (_streamBluetooth!.isPaused) {
//           _streamBluetooth?.resume();
//         }
//       }
//       await checkAllRequirements();
//     } else if (state == AppLifecycleState.paused) {
//       _streamBluetooth?.pause();
//     }
//   }

//   @override
//   void dispose() {
//     _streamBluetooth?.cancel();

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Flutter Beacon'),
//         centerTitle: false,
//         actions: <Widget>[
//           Obx(() {
//             if (!controller.locationServiceEnabled)
//               return IconButton(
//                 tooltip: 'Not Determined',
//                 icon: Icon(Icons.portable_wifi_off),
//                 color: Colors.grey,
//                 onPressed: () {},
//               );

//             if (!controller.authorizationStatusOk)
//               return IconButton(
//                 tooltip: 'Not Authorized',
//                 icon: Icon(Icons.portable_wifi_off),
//                 color: Colors.red,
//                 onPressed: () async {
//                   await flutterBeacon.requestAuthorization;
//                 },
//               );

//             return IconButton(
//               tooltip: 'Authorized',
//               icon: Icon(Icons.wifi_tethering),
//               color: Colors.blue,
//               onPressed: () async {
//                 await flutterBeacon.requestAuthorization;
//               },
//             );
//           }),
//           Obx(() {
//             return IconButton(
//               tooltip: controller.locationServiceEnabled
//                   ? 'Location Service ON'
//                   : 'Location Service OFF',
//               icon: Icon(
//                 controller.locationServiceEnabled
//                     ? Icons.location_on
//                     : Icons.location_off,
//               ),
//               color:
//                   controller.locationServiceEnabled ? Colors.blue : Colors.red,
//               onPressed: controller.locationServiceEnabled
//                   ? () {}
//                   : handleOpenLocationSettings,
//             );
//           }),
//           Obx(() {
//             final state = controller.bluetoothState.value;

//             if (state == BluetoothState.stateOn) {
//               return IconButton(
//                 tooltip: 'Bluetooth ON',
//                 icon: Icon(Icons.bluetooth_connected),
//                 onPressed: () {},
//                 color: Colors.lightBlueAccent,
//               );
//             }

//             if (state == BluetoothState.stateOff) {
//               return IconButton(
//                 tooltip: 'Bluetooth OFF',
//                 icon: Icon(Icons.bluetooth),
//                 onPressed: handleOpenBluetooth,
//                 color: Colors.red,
//               );
//             }

//             return IconButton(
//               icon: Icon(Icons.bluetooth_disabled),
//               tooltip: 'Bluetooth State Unknown',
//               onPressed: () {},
//               color: Colors.grey,
//             );
//           }),
//         ],
//       ),
//       body: FutureBuilder(
//           future: checkPerm(),
//           builder: (context, snapshot) {
//             if (snapshot.hasData) {
//               return IndexedStack(
//                 index: currentIndex,
//                 children: [
//                   TabScanning(),
//                   TabBroadcasting(),
//                 ],
//               );
//             } else {
//               return Container();
//             }
//           }),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: currentIndex,
//         onTap: (index) async {
//           setState(() {
//             currentIndex = index;
//           });
//           print(
//               '서비스serviceStatus:  ${await Permission.location.serviceStatus}');
//           print('그냥status:  ${await Permission.location.status}');

//           if (currentIndex == 0) {
//             controller.startScanning(); //이걸 누르면 스캔 하기 시작함!! 그래서 아까 멈춘듯
//           } else {
//             controller.pauseScanning();
//             controller.startBroadcasting();
//           }
//         },
//         items: [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.list),
//             label: 'Scan',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.bluetooth_audio),
//             label: 'Broadcast',
//           ),
//         ],
//       ),
//     );
//   }

//   handleOpenLocationSettings() async {
//     if (Platform.isAndroid) {
//       await flutterBeacon.openLocationSettings;
//     } else if (Platform.isIOS) {
//       await showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             title: Text('Location Services Off'),
//             content: Text(
//               'Please enable Location Services on Settings > Privacy > Location Services.',
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: Text('OK'),
//               ),
//             ],
//           );
//         },
//       );
//     }
//   }

//   handleOpenBluetooth() async {
//     if (Platform.isAndroid) {
//       try {
//         await flutterBeacon.openBluetoothSettings;
//       } on PlatformException catch (e) {
//         print(e);
//       }
//     } else if (Platform.isIOS) {
//       await showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             title: Text('Bluetooth is Off'),
//             content: Text('Please enable Bluetooth on Settings > Bluetooth.'),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: Text('OK'),
//               ),
//             ],
//           );
//         },
//       );
//     }
//   }

//   checkPerm() async {
//     if (Platform.isAndroid) {
//       print("하고 있지?");
//       var status = await Permission.bluetoothScan.status;

//       print(status);
//       if (status.isDenied) {
//         await Permission.bluetoothScan.request();
//       }
//       // if (await Permission.bluetoothScan.isRestricted) {
//       //   print("아니 왜 거절해");
//       // }
//       // if (await Permission.bluetoothScan.isPermanentlyDenied) {
//       //   print("ped");
//       // }
//       // if (await Permission.bluetoothScan.isDenied) {
//       //   openAppSettings();
//       //   print("ped");
//       // }

//       if (await Permission.bluetoothScan.status.isPermanentlyDenied) {
//         openAppSettings();
//         print("여기 아니야?");
//       }
//     }
//     return "asd";
//   }
// }
