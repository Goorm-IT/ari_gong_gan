import 'dart:async';
import 'dart:io';
import 'package:ari_gong_gan/const/colors.dart';
import 'package:ari_gong_gan/controller/requirement_state_controller.dart';
import 'package:ari_gong_gan/model/today_reservation_list.dart';
import 'package:ari_gong_gan/provider/today_reservation_provider.dart';
import 'package:ari_gong_gan/screen/home_sreen/book_card_divided.dart';
import 'package:ari_gong_gan/screen/home_sreen/empty_book_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OpenBookCard extends StatefulWidget {
  const OpenBookCard({super.key});

  @override
  State<OpenBookCard> createState() => _OpenBookCardState();
}

class _OpenBookCardState extends State<OpenBookCard>
    with WidgetsBindingObserver {
  final controller = Get.find<RequirementStateController>();

  StreamSubscription<RangingResult>? _streamRanging;
  final _regionBeacons = <Region, List<Beacon>>{};
  final _beacons = <Beacon>[];
  StreamSubscription<BluetoothState>? _streamBluetooth;
  int buttonStatus = 0;
  double _settingErrorOpacitiy = 0.0;

  bool isBeaconSearch = false;

  List<TodayReservation> _list = [];

  final PageController _pageController = PageController(initialPage: 0);
  listeningState() async {
    print('Listening to bluetooth state');
    _streamBluetooth = flutterBeacon
        .bluetoothStateChanged()
        .listen((BluetoothState state) async {
      print('state: $state');
      controller.updateBluetoothState(state);
      await checkAllRequirements();
    });
  }

  checkAllRequirements() async {
    final bluetoothState = await flutterBeacon.bluetoothState;
    controller.updateBluetoothState(bluetoothState);
    print('BLUETOOTH $bluetoothState');

    final authorizationStatus = await flutterBeacon.authorizationStatus;
    controller.updateAuthorizationStatus(authorizationStatus);
    print('AUTHORIZATION $authorizationStatus');

    final locationServiceEnabled =
        await flutterBeacon.checkLocationServicesIfEnabled;
    controller.updateLocationService(locationServiceEnabled);
    print('LOCATION SERVICE $locationServiceEnabled');

    // if (controller.bluetoothEnabled &&
    //     controller.authorizationStatusOk &&
    //     controller.locationServiceEnabled) {
    //   print('STATE READY');
    //   if (isBeaconSearch == true) {
    //     print('SCANNING');
    //     controller.startScanning();
    //   } else {
    //     print('STOPScannig');
    //     controller.pauseScanning();
    //   }
    // } else {
    //   print('STATE NOT READY');
    //   controller.pauseScanning();
    // }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    _list = context
        .read<TodayReservationProvider>()
        .todayReservation
        .where((TodayReservation element) {
      return element.resStatus != "delete";
    }).toList();
    listeningState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    print('AppLifecycleState = $state');
    if (state == AppLifecycleState.resumed) {
      if (_streamBluetooth != null) {
        if (_streamBluetooth!.isPaused) {
          _streamBluetooth?.resume();
        }
      }
      await checkAllRequirements();
    } else if (state == AppLifecycleState.paused) {
      _streamBluetooth?.pause();
    }
  }

  @override
  void dispose() {
    _streamRanging?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_list.isEmpty) {
      return EmptyBookCard();
    } else {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
          color: Colors.white,
        ),
        height: 290,
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Container(
              height: 37,
              margin: const EdgeInsets.only(left: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  settingCheck(),
                  Container(
                    margin: const EdgeInsets.only(right: 30, top: 10),
                    child: ClipOval(
                      child: Container(
                        color: Color(0xff4988e1),
                        height: 25,
                        width: 25,
                        child: IconButton(
                          iconSize: 20,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          padding: const EdgeInsets.all(0),
                          splashRadius: 10.0,
                          icon: Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            AnimatedOpacity(
              duration: Duration(milliseconds: 300),
              opacity: _settingErrorOpacitiy,
              child: Container(
                height: 15,
                color: PRIMARY_COLOR_DEEP,
                child: Center(
                  child: Text(
                    "상단의 설정버튼을 확인해주세요",
                    style: TextStyle(fontSize: 11, color: Colors.white),
                  ),
                ),
              ),
            ),
            Container(
              height: 200,
              child: PageView.builder(
                itemCount: _list.length,
                controller: _pageController,
                onPageChanged: (change) {
                  setState(() {
                    _settingErrorOpacitiy = 0.0;
                  });
                },
                itemBuilder: ((BuildContext context, int index) {
                  return BookCardDivied(
                    index: index,
                    isSetting: (double isSetting) {
                      if (mounted) {
                        setState(() {
                          _settingErrorOpacitiy = isSetting;
                        });
                      }
                    },
                  );
                }),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            SmoothPageIndicator(
                controller: _pageController,
                count: _list.length,
                effect: ExpandingDotsEffect(
                  dotWidth: 8,
                  dotHeight: 8,
                  activeDotColor: PRIMARY_COLOR_DEEP,
                  dotColor: Color(0xff80bcfa),
                ),
                onDotClicked: (index) {
                  _pageController.animateToPage(
                    index,
                    duration: Duration(milliseconds: 250),
                    curve: Curves.easeIn,
                  );
                })
          ],
        ),
      );
    }
  }

  Widget settingCheck() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Obx(() {
          if (!controller.authorizationStatusOk)
            return customIconButton(
              tooltip: 'Not Authorized',
              onPressed: () async {
                try {
                  await flutterBeacon.requestAuthorization;
                } catch (e) {}
              },
              icon: Icon(Icons.location_off),
              color: Colors.yellow,
            );

          return customIconButton(
            tooltip: controller.locationServiceEnabled
                ? 'Location Service ON'
                : 'Location Service OFF',
            onPressed: controller.locationServiceEnabled
                ? () {}
                : handleOpenLocationSettings,
            icon: Icon(
              controller.locationServiceEnabled
                  ? Icons.location_on
                  : Icons.location_off,
            ),
            color: controller.locationServiceEnabled ? Colors.blue : Colors.red,
          );
        }),
        Obx(() {
          if (!controller.locationServiceEnabled)
            return customIconButton(
              tooltip: 'Not Determined',
              onPressed: () {},
              icon: Icon(Icons.portable_wifi_off),
              color: Colors.grey,
            );

          if (!controller.authorizationStatusOk)
            return customIconButton(
              tooltip: 'Not Authorized',
              onPressed: () async {
                try {
                  await flutterBeacon.requestAuthorization;
                } catch (e) {}
              },
              icon: Icon(Icons.portable_wifi_off),
              color: Colors.red,
            );

          return customIconButton(
            tooltip: 'Authorized',
            onPressed: () async {
              try {
                await flutterBeacon.requestAuthorization;
              } catch (e) {}
            },
            icon: Icon(Icons.wifi_tethering),
            color: Colors.blue,
          );
        }),
        Obx(() {
          final state = controller.bluetoothState.value;

          if (state == BluetoothState.stateOn) {
            return customIconButton(
              tooltip: 'Bluetooth ON',
              onPressed: () {},
              icon: Icon(Icons.bluetooth_connected),
              color: Colors.lightBlueAccent,
            );
          }

          if (state == BluetoothState.stateOff) {
            return customIconButton(
              tooltip: 'Bluetooth OFF',
              onPressed: handleOpenBluetooth,
              icon: Icon(Icons.bluetooth),
              color: Colors.red,
            );
          }
          return customIconButton(
            tooltip: 'Bluetooth State Unknown',
            onPressed: () {},
            icon: Icon(Icons.bluetooth_disabled),
            color: Colors.grey,
          );
        }),
      ],
    );
  }

  handleOpenLocationSettings() async {
    if (Platform.isAndroid) {
      try {
        await flutterBeacon.requestAuthorization;
      } catch (e) {}
      await flutterBeacon.openLocationSettings;
    } else if (Platform.isIOS) {
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Location Services Off'),
            content: Text(
              'Please enable Location Services on Settings > Privacy > Location Services.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  handleOpenBluetooth() async {
    if (Platform.isAndroid) {
      try {
        await flutterBeacon.openBluetoothSettings;
      } on PlatformException catch (e) {
        print(e);
      }
    } else if (Platform.isIOS) {
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Bluetooth is Off'),
            content: Text('Please enable Bluetooth on Settings > Bluetooth.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Widget customIconButton(
      {required String tooltip,
      required Function()? onPressed,
      required Icon icon,
      required Color color}) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 40,
        child: IconButton(
            padding: const EdgeInsets.all(0),
            iconSize: 25,
            splashRadius: 20,
            icon: icon,
            tooltip: tooltip,
            onPressed: onPressed,
            color: color),
      ),
    );
  }
}
