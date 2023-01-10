import 'package:flutter/material.dart';
import 'package:backendless_sdk/backendless_sdk.dart';

import 'package:tugas_akhir/splash.dart';

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({Key? key}) : super(key: key);

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Center(
          child: Container(
        height: 300,
        child: Column(
          children: [
<<<<<<< Updated upstream
            Text(
              'alarm page stageholder',
=======
            Container(
              padding: EdgeInsets.only(right: 30, top: 45),
              alignment: Alignment.topRight,
              child: TextButton(
                  onPressed: () {
                    setState(() {
                      if (datepicker.isBefore(DateTime.now())) {
                        datepicker = datepicker.add(Duration(days: 1));
                      }
                    });
                    //cari deviceid
                    String devid = "";
                    Backendless.messaging
                        .getDeviceRegistration()
                        .then((deviceRegistration) {
                      devid = deviceRegistration!.deviceId!;
                    });
                    print("date: " + datepicker.toString());

                    if (datareminder.isEmpty) {
                      datareminder = {
                        "remind_time": datepicker,
                        "status": statusaktif,
                        "repeat": statusrepeat
                      };
                    } else {}
                    Backendless.data
                        .of("Reminder")
                        .save(datareminder)
                        .then((value) {
                      if (statusaktif = true) {
                        print("data initial|" + value.toString());
                        DeliveryOptions deliveryOptions = DeliveryOptions()
                          ..pushSinglecast = [devid];
                        if (statusrepeat = false) {
                          deliveryOptions..publishAt = datepicker;
                        } else {
                          deliveryOptions
                            ..publishAt = datepicker
                            ..repeatEvery = 86400;
                        }
                        PublishOptions publishOptions = PublishOptions()
                          ..headers = {
                            "android-ticker-text": "Saat Teduh Yuk!",
                            "android-content-title": "Pengingat MannaGo",
                            "android-content-text":
                                "Mari memulai langkah ketaatan setiap hari.",
                            "android-content-sound": "notification",
                          };
                        Backendless.messaging
                            .publish("Mari Lakukan Saat Teduh, ${widget.nama}!",
                                publishOptions: publishOptions,
                                deliveryOptions: deliveryOptions)
                            .then((status) {
                          print("Message status: $status");
                        });
                      } else {
                        //do nothing else
                      }
                      final sbarnoticesavereminder = SnackBar(
                        duration: Duration(seconds: 4),
                        content: const Text("Pengingat anda telah tersimpan"),
                        action: SnackBarAction(
                          label: 'OK',
                          onPressed: () => ScaffoldMessenger.of(context)
                              .hideCurrentSnackBar(),
                        ),
                      );
                      ScaffoldMessenger.of(context)
                          .showSnackBar(sbarnoticesavereminder);
                    });
                    setState(() {});
                  },
                  child: Text(
                    "Simpan",
                    style:
                        TextStyle(fontSize: 20.sm, fontWeight: FontWeight.bold),
                  )),
            ),
            Container(
              height: 0.35.sh,
              padding: EdgeInsets.only(top: 30),
              margin: EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                      color: Color.fromARGB(255, 115, 152, 201), width: 2),
                ),
              ),
              child: Center(
                  child: TimePickerSpinner(
                      is24HourMode: true,
                      normalTextStyle: TextStyle(
                          fontSize: 30.sm,
                          color: Color.fromARGB(255, 190, 190, 190)),
                      highlightedTextStyle: TextStyle(
                          fontSize: 38.sm,
                          color: Theme.of(context).colorScheme.primary),
                      spacing: 50,
                      itemHeight: 80,
                      isForce2Digits: true,
                      onTimeChange: (time) {
                        setState(() {
                          if (time.isBefore(DateTime.now())) {
                            datepicker = time.add(Duration(days: 1));
                          } else {
                            datepicker = time;
                          }
                        });
                      })),
            ),
            Container(
              height: 0.45.sh,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
              child: Column(
                children: [
                  Container(
                    // height: 50.h,
                    width: 0.9.sw,
                    margin: EdgeInsets.only(bottom: 15),

                    child: Card(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          child: Text(
                            "Aktif",
                            style: TextStyle(
                                fontSize: 20.sm, fontWeight: FontWeight.w600),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          child: Switch(
                              value: statusaktif,
                              onChanged: (bool value) {
                                setState(() {
                                  statusaktif = value;
                                });
                              }),
                        )
                      ],
                    )),
                  ),
                  Container(
                    // height: 50.h,
                    width: 0.9.sw,
                    margin: EdgeInsets.only(bottom: 15),

                    child: Card(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          child: Text(
                            "Berulang",
                            style: TextStyle(
                                fontSize: 20.sm, fontWeight: FontWeight.w600),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          child: Switch(
                              value: statusrepeat,
                              onChanged: (bool value) {
                                setState(() {
                                  statusrepeat = value;
                                });
                              }),
                        )
                      ],
                    )),
                  )
                ],
              ),
>>>>>>> Stashed changes
            ),
            ElevatedButton(onPressed: () => logout(), child: Text("logout"))
            
          ],
        ),
      )),
    );
  }

  void logout() {
    Backendless.userService.logout().then((response) {
      // user has been logged out.
    });
    print("user has been loged out");

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SplashScreen()),
      );
    });
  }
}
