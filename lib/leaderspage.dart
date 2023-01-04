// ignore_for_file: dead_code, unused_local_variable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:date_format/date_format.dart';

const List<Text> options = <Text>[
  Text('Notes'),
  Text('Attendence'),
];
List _items = []; //for the alkitab

class LeadersPage extends StatefulWidget {
  const LeadersPage(
      {Key? key,
      required this.leaderStatus,
      required this.isleaded,
      this.namateacher,
      this.listmurid,
      required this.finishloading,
      this.listcatatanshare})
      : super(key: key);
  final bool finishloading;
  final bool leaderStatus;
  final bool isleaded;
  final String? namateacher;
  final List<Map>? listcatatanshare;
  final List<Map>? listmurid;
  @override
  State<LeadersPage> createState() => _LeadersPageState();
}

class _LeadersPageState extends State<LeadersPage> {
  bool jsonloader = false;
  @override
  void initState() {
    super.initState();
    readJson();
    if (widget.listcatatanshare == null) {}
  }

  Future<void> readJson() async {
    List tempitems = [];
    final String response = await rootBundle.loadString('assets/tbnew.json');
    final data = await json.decode(response);
    setState(() {
      tempitems = data;

      _items.addAll(tempitems);
      jsonloader = true;
    });
  }

  int selc = 0;
  void _onItemTapped(int index) {
    setState(() {
      selc = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var leadscreens = [
      NotesScreen(
        isleaded: widget.isleaded,
        leaderStatus: widget.leaderStatus,
        listmurid: widget.listmurid,
        listcatatanshare: widget.isleaded ? widget.listcatatanshare : null,
      ),
      AttendanceScreen(listmurid: widget.listmurid),
    ];
    if (widget.finishloading == true && jsonloader == true) {
      if (widget.isleaded == true || widget.leaderStatus == true) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: SingleChildScrollView(
              child: SizedBox(
                height: 0.9.sh,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 10, right: 10, bottom: 20),
                      child: Text(
                        widget.leaderStatus
                            ? 'Here is your Disciples'
                            : 'Your Leader Is: ' + widget.namateacher!,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 28,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    widget.leaderStatus
                        ? ToggleTextBtnsFb1(
                            texts: options,
                            selected: (i) {
                              _onItemTapped(i);
                            },
                          )
                        : SizedBox(
                            height: 40,
                          ),
                    Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(10),
                        child: leadscreens[selc])
                  ],
                ),
              ),
            ),
          ),
        );
      } else {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          body: Center(
            child: Container(
              child: Expanded(
                  child: Container(
                padding: EdgeInsets.all(20),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      style: TextStyle(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer),
                      children: [
                        TextSpan(
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontFamily: 'EB Garamond',
                                fontSize: 18.sm),
                            text:
                                '"Anda tidak mempunyai pemimpin rohani yang ditujukan. Hubungi Admin pada '),
                        TextSpan(
                            style: TextStyle(
                                fontStyle: FontStyle.normal,
                                fontFamily: 'EB Garamond',
                                fontSize: 18.sm,
                                color: Color.fromARGB(255, 54, 54, 54)),
                            text: "phartoonax@gmail.com"),
                        TextSpan(
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontFamily: 'EB Garamond',
                                fontSize: 18.sm),
                            text: ' untuk meminta bantuan lanjutan."')
                      ]),
                ),
              )),
            ),
          ),
        );
      }
    } else {
      return Scaffold(
        body: Center(
          child: SizedBox(
            width: 30.w,
            height: 30.h,
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }
  }
}

class ToggleTextBtnsFb1 extends StatefulWidget {
  final List<Text> texts;
  final Function(int) selected;
  final Color selectedColor;
  final bool multipleSelectionsAllowed;
  final bool stateContained;
  final bool canUnToggle;
  ToggleTextBtnsFb1(
      {required this.texts,
      required this.selected,
      this.selectedColor = const Color(0xFF6200EE),
      this.stateContained = true,
      this.canUnToggle = false,
      this.multipleSelectionsAllowed = false,
      Key? key});

  @override
  _ToggleTextBtnsFb1State createState() => _ToggleTextBtnsFb1State();
}

class _ToggleTextBtnsFb1State extends State<ToggleTextBtnsFb1> {
  late List<bool> isSelected = [];
  @override
  void initState() {
    isSelected.add(true);
    isSelected.add(false);

    super.initState();
  }

  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ToggleButtons(
            color: Colors.black.withOpacity(0.60),
            selectedColor: widget.selectedColor,
            selectedBorderColor: widget.selectedColor,
            fillColor: widget.selectedColor.withOpacity(0.08),
            splashColor: widget.selectedColor.withOpacity(0.12),
            hoverColor: widget.selectedColor.withOpacity(0.04),
            borderRadius: BorderRadius.circular(4.0),
            borderColor: Colors.grey,
            isSelected: isSelected,
            highlightColor: Colors.transparent,
            onPressed: (index) {
              // send callback
              widget.selected(index);
              // if you wish to have state:
              if (widget.stateContained) {
                if (!widget.multipleSelectionsAllowed) {
                  final selectedIndex = isSelected[index];
                  isSelected = isSelected.map((e) => e = false).toList();
                  if (widget.canUnToggle) {
                    isSelected[index] = selectedIndex;
                  }
                }
                setState(() {
                  for (int i = 0; i < isSelected.length; i++) {
                    isSelected[i] = i == index;
                  }
                });
              }
            },
            children: widget.texts
                .map(
                  (e) => Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: e,
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class NotesScreen extends StatefulWidget {
  const NotesScreen(
      {Key? key,
      required this.leaderStatus,
      required this.isleaded,
      required this.listmurid,
      this.listcatatanshare})
      : super(key: key);
  final bool leaderStatus;
  final bool isleaded;
  final List<Map>? listcatatanshare;
  final List<Map>? listmurid;
  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

readrangechecker(int awal, int akhir) {
  if (_items[awal]["kitab_singkat"] == _items[akhir]["kitab_singkat"]) {
    //sama kitab => check pasal
    if (_items[awal]["pasal"] == _items[akhir]["pasal"]) {
      return Text(_items[awal]["kitab_singkat"] +
          " " +
          _items[awal]["pasal"].toString() +
          ":" +
          _items[awal]["ayat"].toString() +
          " - " +
          _items[akhir]["ayat"].toString());
    } else {
      return Text(_items[awal]["kitab_singkat"] +
          " " +
          _items[awal]["pasal"].toString() +
          ":" +
          _items[awal]["ayat"].toString() +
          " - " +
          _items[akhir]["pasal"].toString() +
          ":" +
          _items[akhir]["ayat"].toString());
    }
  } else {
    //for the beda kitab
    return Text(_items[awal]["kitab_singkat"] +
        " " +
        _items[awal]["pasal"].toString() +
        ":" +
        _items[awal]["ayat"].toString() +
        " - " +
        _items[akhir]["kitab_singkat"] +
        " " +
        _items[akhir]["pasal"].toString() +
        ":" +
        _items[akhir]["ayat"].toString());
  }
}

class _NotesScreenState extends State<NotesScreen> {
  @override
  Widget build(BuildContext context) {
    if (widget.leaderStatus == true) {
      return Container(
        //below the button, the actual list
        // decoration: BoxDecoration(
        //     border: Border.all(
        //       color: Color(0xFFA8775B),
        //     ),
        //     borderRadius: BorderRadius.all(Radius.circular(7))),
        height: 0.68.sh,
        child: ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: widget.listmurid?.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Card(
              child: ExpansionTile(
                  leading: Icon(
                    Icons.person,
                  ),
                  title: Text(widget.listmurid?[index]['nama']),
                  children: <Widget>[
                    Divider(
                      endIndent: 5,
                      indent: 5,
                      color: Color.fromARGB(255, 99, 120, 136),
                    ),
                    ((widget.listmurid?[index]['notes'] as List<Map>)
                            .isNotEmpty)
                        ? ListView.builder(
                            itemCount:
                                (widget.listmurid?[index]['notes']).length,
                            padding: EdgeInsets.zero,
                            physics: ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (BuildContext cont, int indx) {
                              bool isalkitab = false;
                              if (widget.listmurid?[index]['notes'][indx]
                                      ["idstartkitab"] !=
                                  null) {
                                isalkitab = true;
                              }
                              return Card(
                                child: ExpansionTile(
                                  leading: Icon(Icons.description),
                                  title: Text(widget.listmurid?[index]['notes']
                                      [indx]['judul_catatan']),
                                  subtitle: isalkitab
                                      ? readrangechecker(
                                          widget.listmurid?[index]['notes']
                                                  [indx]['idstartkitab'] -
                                              1,
                                          widget.listmurid?[index]['notes']
                                                  [indx]['idendkitab'] -
                                              1)
                                      : Text(widget.listmurid?[index]['notes']
                                                  [indx]['rekomendasi_renungan']
                                              ["judul_renungan"] +
                                          "|" +
                                          widget.listmurid?[index]['notes']
                                                  [indx]["rekomendasi_renungan"]
                                              ["penulis"]),
                                  children: [
                                    Card(
                                      child: Container(
                                        child: Text(widget.listmurid?[index]
                                            ['notes'][indx]["catatan"]),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            })
                        : Container(
                            padding: EdgeInsets.all(10),
                            child: Center(
                              child: Container(
                                child: Text(
                                  "User Ini belum mempunyai Catatan yang Dibagikan sama Sekali. Silahkan Kontak pengguna ini untuk mengubah status catatannya.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 14.sm),
                                ),
                              ),
                            ),
                          ),
                  ]),
            );
          },
        ),
      );
    } else if (widget.isleaded == true) {
      //untuk murid
      return Column(
        children: [
          Container(
            child: Text(
              'Catatan yang sudah anda bagikan adalah: ',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 17.sm,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            //below the button, the actual list
            decoration: BoxDecoration(
                border: Border.all(
                  color: Color(0xFFA8775B),
                ),
                borderRadius: BorderRadius.all(Radius.circular(7))),
            height: 0.68.sh,
            child: (widget.listcatatanshare != null)
                ? ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: widget.listcatatanshare!.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      bool isalkitab = false;
                      if (widget.listcatatanshare?[index]["idstartkitab"] !=
                          null) {
                        isalkitab = true;
                      }
                      return Card(
                        child: ExpansionTile(
                          leading: Icon(Icons.description),
                          title: Text(
                              widget.listcatatanshare?[index]['judul_catatan']),
                          subtitle: isalkitab
                              ? readrangechecker(
                                  widget.listcatatanshare?[index]
                                          ['idstartkitab'] -
                                      1,
                                  widget.listcatatanshare?[index]
                                          ['idendkitab'] -
                                      1)
                              : Text(widget.listcatatanshare?[index]
                                          ['rekomendasi_renungan']
                                      ["judul_renungan"] +
                                  "|" +
                                  widget.listcatatanshare?[index]
                                      ["rekomendasi_renungan"]["penulis"]),
                          children: [
                            Card(
                              child: Container(
                                child: Text(
                                    widget.listcatatanshare?[index]["catatan"]),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : Center(
                    child: Container(
                      child: Expanded(
                          child: Container(
                        padding: EdgeInsets.all(20),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer),
                              children: [
                                TextSpan(
                                    style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontFamily: 'EB Garamond',
                                        fontSize: 18.sm),
                                    text:
                                        '"Anda masih belum mempunyai catatan yang dibagikan kepada pemimpin anda. Silahkan kembali ke halaman Utama untuk mengubah status catatan anda"'),
                              ]),
                        ),
                      )),
                    ),
                  ),
          ),
        ],
      );
    } else {
      return Container(
        child: Center(
            child: Text("THIS ONE IS IMPOSSIBLE TO SEE. THIS IS A MISTAKE")),
      );
    }
  }
}

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({Key? key, required this.listmurid}) : super(key: key);
  final List<Map>? listmurid;
  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 0.68.sh,
        child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: widget.listmurid?.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Card(
                child: (ExpansionTile(
                  title: Text(widget.listmurid?[index]['nama']),
                  children: <Widget>[
                    Divider(
                      endIndent: 5,
                      indent: 5,
                      color: Color.fromARGB(255, 99, 120, 136),
                    ),
                    ListView.builder(
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 8),
                        physics: ClampingScrollPhysics(),
                        itemCount:
                            (widget.listmurid?[index]['absen'] as List<bool>)
                                .length,
                        shrinkWrap: true,
                        itemBuilder: ((contxt, indx) {
                          var dates = formatDate(
                              DateTime.now().subtract(Duration(days: indx)),
                              [dd, ' ', M, ' ', yyyy]);
                          return Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 3),
                            child: RichText(
                                text: TextSpan(
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 19, 30, 54)),
                                    children: [
                                  TextSpan(text: dates),
                                  TextSpan(text: " : "),
                                  TextSpan(
                                      text: widget.listmurid?[index]['absen']
                                              [indx]
                                          ? "✔"
                                          : "❌")
                                ])),
                          );
                        }))
                  ],
                )),
              );
            }));
  }
}
