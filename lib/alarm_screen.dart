import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:MannaGo/splash.dart';

class AlarmScreen extends StatefulWidget {
  const AlarmScreen(
      {Key? key, required this.nama, required this.userid, this.dataalarm})
      : super(key: key);
  final String nama;
  final String userid;
  final Map? dataalarm;

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

bool statusaktif = false;
bool statusrepeat = false;

class _AlarmScreenState extends State<AlarmScreen> {
  late DateTime datepicker;

  Map datareminder = {};
  @override
  void initState() {
    super.initState();

    if (widget.dataalarm != null) {
      if (widget.dataalarm!.isNotEmpty) {
        datepicker = widget.dataalarm!["remind_time"];

        datareminder = widget.dataalarm!;
        if ((datareminder["remind_time"] as DateTime)
            .isBefore(DateTime.now())) {
          statusaktif = datareminder['status'];
        } else {
          statusaktif = false;
        }

        statusrepeat = datareminder['repeat'];

        log(datareminder.toString());
      }
    } else {
      datepicker = DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Container(
        height: 0.95.sh,
        child: Column(
          children: [
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
                    SnackBar sbarnoticesavereminder;
                    if (datareminder.isEmpty) {
                      datareminder = {
                        "remind_time": datepicker,
                        "status": statusaktif,
                        "repeat": statusrepeat
                      };
                    } else {
                      datareminder = {
                        "remind_time": datepicker,
                        "status": statusaktif,
                        "repeat": statusrepeat
                      };
                    }
                    Backendless.data
                        .of("Reminder")
                        .save(datareminder)
                        .then((value) {
                      datareminder.clear();
                      datareminder = value!;

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
                          };
                        Backendless.messaging
                            .publish("Mari Lakukan Saat Teduh, ${widget.nama}!",
                                publishOptions: publishOptions,
                                deliveryOptions: deliveryOptions)
                            .then((status) {
                          print("Message status: $status");
                        });
                      } else {
                        //do nothing else, data is posted
                      }
                      sbarnoticesavereminder = SnackBar(
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
            ),
          ],
        ),
      )),
    );
  }
}
