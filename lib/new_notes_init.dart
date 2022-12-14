// ignore_for_file: non_constant_identifier_names

import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'notes_alkitab.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class NewNotesinitPage extends StatefulWidget {
  NewNotesinitPage(
      {Key? key,
      required this.leaderstatus,
      this.lastreading,
      required this.isnewabsen})
      : super(key: key);
  final bool leaderstatus;
  final bool isnewabsen;
  final Map? lastreading;
  @override
  State<NewNotesinitPage> createState() => _NewNotesinitPageState();
}

List<Map>? itemers = List.empty(growable: true);
List<Map>? kitabs = [
  {"kitab_singkat": ""}
];
String formattedDate = "";

enum Readingmode { sabda, biblestudytools, gms, custom }

class _NewNotesinitPageState extends State<NewNotesinitPage> {
  List _items = [];
  List<Map>? _guide = List.empty(growable: true); //for devGuide
  Set kitab = Set();
  Readingmode? _reading = Readingmode.custom;
  bool recomendationcheck = false;
  bool devotioncheck = false;
  bool songcheck = false;
  bool customselect = true;

  String? initdropdownvalue;
  String? init_start_kitab;
  String? init_start_pasal;
  String? init_start_ayat;

  String? init_end_kitab;
  String? init_end_pasal;
  String? init_end_ayat;

  int lastreadingindex = 0;
  initState() {
    super.initState();
    init();
    var now = new DateTime.now();
    var formatter = new DateFormat('dd-MMM-yy');
    formattedDate = formatter.format(now);
    readJson();
  }

  void init() async {
    Backendless.data.of('Rekomendasi_Genre').find().then((value) {
      itemers!.clear();
      itemers = value?.cast<Map>();
    });
    DataQueryBuilder querry = DataQueryBuilder()
      ..whereClause = "created > '23-Mar-2015'"
      ..pageSize = 100;

    Backendless.data.of('devotion_guide').find(querry).then((value) {
      _guide = value?.cast<Map>();
    });

    setState(() {});
  }

  Future<void> readJson() async {
    final String response = await rootBundle.loadString('assets/tbnew.json');
    final data = await json.decode(response);
    setState(() {
      _items = data;
      _items.forEach((e) {
        kitab.add(e["kitab_singkat"]);
      });
      if (widget.lastreading != null) {
        lastreadingindex = widget.lastreading!["idendkitab"] + 1;

        var stager = _items[lastreadingindex - 1];
        //load start
        init_start_kitab = stager["kitab_singkat"];
        var tempasal = (_items
            .where((kit) => (kit["kitab_singkat"] == stager["kitab_singkat"])));
        tempasal.forEach((element) {
          start_pasal.add(element["pasal"].toString());
        });
        init_start_pasal = stager["pasal"].toString();
        var tempayat =
            (tempasal.where((ayat) => (ayat["pasal"] == init_start_pasal)));
        tempayat.forEach((element) {
          start_ayat.add(element["ayat"].toString());
        });
        init_start_ayat = stager["ayat"].toString();
        //load start done
        if (stager["pasal"] == _items[lastreadingindex]["pasal"]) {
          init_end_kitab = stager["kitab_singkat"];
          init_end_pasal = stager["pasal"].toString();
          init_end_ayat = _items[lastreadingindex]["ayat"].toString();
          end_pasal.addAll(start_pasal);
          end_ayat.addAll(start_ayat);
        } else {
          if (stager["kitab_singkat"] ==
              _items[lastreadingindex]["kitab_singkat"]) {
            //ubah pasal end saja, kitab tetap
            init_end_kitab = stager["kitab_singkat"];
            init_end_pasal = (stager["pasal"] + 1).toString();
            end_pasal.addAll(start_pasal);
            var tempayatend =
                (tempasal.where((ayat) => (ayat["pasal"] == init_end_pasal)));
            tempayatend.forEach((element) {
              end_ayat.add(element["ayat"].toString());
            });
            init_end_ayat = end_ayat.first;
          } else {
            //kitab juga berubah.
            init_end_kitab = (_items[lastreadingindex]["kitab_singkat"]);
            var tempasalend = (_items
                .where((kit) => (kit["kitab_singkat"] == init_end_kitab)));
            tempasalend.forEach((element) {
              end_pasal.add(element["Pasal"].toString());
            });
            init_end_pasal = end_pasal.first;
            var tempayatend =
                (tempasal.where((ayat) => (ayat["pasal"] == init_end_pasal)));
            tempayatend.forEach((element) {
              end_ayat.add(element["ayat"].toString());
            });
            init_end_ayat = end_ayat.first;
          }
        }
      } else {
        start_pasal.clear();
        end_pasal.clear();
        start_ayat.clear();
        end_ayat.clear();
        var temppasal =
            (_items.where((pasal) => (pasal["kitab_singkat"] == kitab.first)));
        temppasal.forEach((element) {
          start_pasal.add(element["pasal"].toString());
          end_pasal.add(element["pasal"].toString());
        });
        var tempayat = (temppasal.where((ayat) => (ayat["pasal"] == 1)));
        tempayat.forEach((element) {
          start_ayat.add(element["ayat"].toString());
          end_ayat.add(element["ayat"].toString());
        });

        init_start_kitab = kitab.first;
        init_start_pasal = start_pasal.elementAt(0).toString();
        init_start_ayat = start_ayat.elementAt(0).toString();
        init_end_kitab = kitab.first;
        init_end_pasal = start_pasal.elementAt(0).toString();
        init_end_ayat = start_ayat.elementAt(1).toString();
      }
    });
  }

  Set start_pasal = {
    '1',
    '2',
    '3',
    '4',
    '5',
  };
  Set start_ayat = {
    '1',
    '2',
    '3',
    '4',
    '5',
  };

  Set end_pasal = {
    '1',
    '2',
    '3',
    '4',
    '5',
  };
  Set end_ayat = {
    '1',
    '2',
    '3',
    '4',
    '5',
  };

  @override
  Widget build(BuildContext context) {
    final Future<String> _calculation = Future<String>.delayed(
      const Duration(seconds: 3),
      () => 'Data Loaded',
    );
    return Scaffold(
        appBar: AppBar(
          title: Text('Add New Notes'),
          leading: BackButton(),
          actions: [
            Center(
              child: Text(
                formattedDate,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Colors.white),
              ),
            ),
            Container(
              width: 10,
            ),
            // IconButton(
            // onPressed: (() {}), icon: Icon(Icons.calendar_month_outlined)),
            IconButton(
                onPressed: (() {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (init_end_ayat == null || init_end_pasal == null) {
                      final sbarerror = SnackBar(
                        content: const Text(
                            "Mohon isi bacaan Alkitab terlebih dahulu"),
                        action: SnackBarAction(
                          label: 'OK',
                          onPressed: () => ScaffoldMessenger.of(context)
                              .hideCurrentSnackBar(),
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(sbarerror);
                    } else {
                      if (init_end_ayat == init_start_ayat &&
                          init_end_pasal == init_start_pasal) {
                        final sbarerror = SnackBar(
                          content: const Text(
                              "Mohon, memilih bacaan Alkitab lebih dari 1 ayat"),
                          action: SnackBarAction(
                            label: 'OK',
                            onPressed: () => ScaffoldMessenger.of(context)
                                .hideCurrentSnackBar(),
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(sbarerror);
                      } else {
                        int starti = 0;
                        int endi = 0;
                        starti = _items.singleWhere((e) =>
                            e["kitab_singkat"] == init_start_kitab &&
                            e["pasal"] ==
                                int.parse(init_start_pasal as String) &&
                            e["ayat"] ==
                                int.parse(init_start_ayat as String))["id"];
                        endi = _items.singleWhere((e) =>
                            e["kitab_singkat"] == init_end_kitab &&
                            e["pasal"] == int.parse(init_end_pasal as String) &&
                            e["ayat"] ==
                                int.parse(init_end_ayat as String))["id"];

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NotesAlkitab(
                                    startindex: starti,
                                    endindex: endi,
                                    isnew: true,
                                    isnewabsen: widget.isnewabsen,
                                    datenote: formattedDate,
                                    leaderstatus: widget.leaderstatus,
                                  )),
                        );
                      }
                    }
                    ;
                  });
                }),
                icon: Icon(Icons.chevron_right))
          ],
        ),
        body: FutureBuilder<String>(
            future: _calculation,
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              List<Widget> children;
              if (snapshot.hasData) {
                children = <Widget>[
                  CheckboxListTile(
                    contentPadding: EdgeInsets.all(0),
                    visualDensity: VisualDensity.compact,
                    title: const Text("I want to use the recomendation"),
                    value: recomendationcheck,
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (newvalue) {
                      recomendationcheck = newvalue!;
                      if (newvalue == true) {
                        initdropdownvalue = itemers![0]["judul_genre"];
                      } else {
                        initdropdownvalue = null;
                      }
                      setState(() {});
                    },
                  ),
                  Stack(alignment: AlignmentDirectional.center, children: [
                    Container(
                      height: 470 + 36,
                      padding: EdgeInsets.only(
                        left: 10,
                        right: 10,
                        bottom: 20,
                        top: 0,
                      ),
                      margin: EdgeInsets.only(bottom: 0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color.fromARGB(255, 217, 185, 165),
                          width: 0.7,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text("Genre : ",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontFamily: 'Roboto',
                                  )),
                              Container(width: 15),
                              DropdownButton(
                                  value: initdropdownvalue,
                                  hint: Text(""),
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  items: itemers!.map((Map items) {
                                    return DropdownMenuItem(
                                      value: items["judul_genre"],
                                      child: Text(items["judul_genre"]),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      initdropdownvalue = value.toString();
                                    });
                                  }),
                            ],
                          ),
                          CheckboxListTile(
                            contentPadding: EdgeInsets.all(0),
                            visualDensity: VisualDensity.compact,
                            title: const Text("Devotions"),
                            value: devotioncheck,
                            controlAffinity: ListTileControlAffinity.leading,
                            onChanged: (newvalue) {
                              setState(() {
                                devotioncheck = newvalue!;
                              });
                            },
                          ),
                          Container(
                            margin: EdgeInsets.all(0),
                            //the fuscia box
                            height: 160,
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255, 217, 185, 165),
                                border: Border.all(
                                    color: Color.fromARGB(255, 217, 185, 165)),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromARGB(97, 0, 0, 0),
                                    spreadRadius: 0.5,
                                    blurRadius: 5,
                                    offset: Offset(0, 5),
                                  )
                                ]),
                            child: devotioncheck
                                ? ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: 5,
                                    separatorBuilder: (context, index) =>
                                        const Divider(),
                                    itemBuilder: (context, index) => Card(
                                        child: Expanded(
                                      child: Text("Placeholder"),
                                    )),
                                  )
                                : Container(),
                          ),
                          SizedBox(height: 20),
                          CheckboxListTile(
                            contentPadding: EdgeInsets.all(0),
                            visualDensity: VisualDensity.compact,
                            title: const Text("Songs"),
                            value: songcheck,
                            controlAffinity: ListTileControlAffinity.leading,
                            onChanged: (newvalue) {
                              songcheck = newvalue!;
                              setState(() {});
                            },
                          ),
                          Container(
                            //the tosca box
                            height: 160,
                            decoration: BoxDecoration(
                                color: Color(0xffc1ffba),
                                border: Border.all(color: Color(0xffc1ffba)),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromARGB(97, 0, 0, 0),
                                    spreadRadius: 0.5,
                                    blurRadius: 5,
                                    offset: Offset(0, 5),
                                  )
                                ]),
                            child: songcheck
                                ? ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: 5,
                                    separatorBuilder: (context, index) =>
                                        const Divider(),
                                    itemBuilder: (context, index) => Card(
                                        child: Center(
                                      child: Text("Placeholder"),
                                    )),
                                  )
                                : Container(),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      //cover

                      height: recomendationcheck ? 0 : 470 + 36,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        border: Border.all(
                          color: Color.fromARGB(255, 217, 185, 165),
                          width: 0.7,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ]),
                  SizedBox(
                    height: 10.9,
                  ),
                  Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height - 670 - 50,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.only(
                          left: 10,
                          right: 10,
                          bottom: 5,
                          top: 0,
                        ),
                        margin: EdgeInsets.only(top: 0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color.fromARGB(255, 217, 185, 165),
                            width: 0.7,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: RadioListTile<Readingmode>(
                                    value: Readingmode.sabda,
                                    groupValue: _reading,
                                    onChanged: (value) {
                                      start_pasal.clear();
                                      end_pasal.clear();
                                      start_ayat.clear();
                                      end_ayat.clear();
                                      var temppasal = (_items.where((pasal) =>
                                          (pasal["kitab_singkat"] == value)));
                                      temppasal.forEach((element) {
                                        start_pasal
                                            .add(element["pasal"].toString());
                                        end_pasal
                                            .add(element["pasal"].toString());
                                      });
                                      var tempayatawal = (temppasal.where(
                                          (ayat) => (ayat["pasal"] == 1)));
                                      tempayatawal.forEach((element) {
                                        start_ayat
                                            .add(element["ayat"].toString());
                                        end_ayat
                                            .add(element["ayat"].toString());
                                      });

                                      init_start_kitab = value.toString();
                                      init_start_pasal =
                                          start_pasal.elementAt(0).toString();
                                      init_start_ayat =
                                          start_ayat.elementAt(0).toString();
                                      init_end_kitab = value.toString();
                                      init_end_pasal =
                                          start_pasal.elementAt(0).toString();
                                      init_end_ayat =
                                          start_ayat.elementAt(1).toString();

                                      _reading = value;
                                    },
                                    // dense: true,
                                    visualDensity: VisualDensity.compact,
                                    title: const Text("SABDA - BAST"),
                                  ),
                                ),
                                Expanded(
                                  child: RadioListTile<Readingmode>(
                                    title: const Text(
                                        "Biblestudytools - chronological"),
                                    value: Readingmode.biblestudytools,
                                    groupValue: _reading,
                                    // dense: true,
                                    visualDensity: VisualDensity.compact,
                                    onChanged: (value) {
                                      _reading = value;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: RadioListTile<Readingmode>(
                                    title: const Text("GMS - ILMB"),
                                    value: Readingmode.gms,
                                    groupValue: _reading,
                                    // dense: true,
                                    visualDensity: VisualDensity.compact,
                                    onChanged: (value) {
                                      setState(() {
                                        init_start_kitab = "Neh";
                                        customselect = false;
                                        start_pasal.clear();
                                        end_pasal.clear();
                                        start_ayat.clear();
                                        end_ayat.clear();
                                        var temppasal = (_items.where((pasal) =>
                                            (pasal["kitab_singkat"] ==
                                                init_start_kitab)));
                                        temppasal.forEach((element) {
                                          start_pasal
                                              .add(element["pasal"].toString());
                                          end_pasal
                                              .add(element["pasal"].toString());
                                        });
                                        var tempayatawal = (temppasal.where(
                                            (ayat) => (ayat["pasal"] ==
                                                int.parse(init_start_pasal
                                                    as String))));
                                        tempayatawal.forEach((element) {
                                          start_ayat
                                              .add(element["ayat"].toString());
                                        });
                                        var tempayatakhir = (temppasal.where(
                                            (ayat) => (ayat["pasal"] ==
                                                int.parse(init_end_pasal
                                                    as String))));
                                        tempayatakhir.forEach((element) {
                                          end_ayat
                                              .add(element["ayat"].toString());
                                        });

                                        _reading = value;
                                      });
                                      // start_pasal.clear();
                                      // end_pasal.clear();
                                      // start_ayat.clear();
                                      // end_ayat.clear();
                                      // var temppasal = (_items.where((pasal) =>
                                      //     (pasal["kitab_singkat"] == value)));
                                      // temppasal.forEach((element) {
                                      //   start_pasal.add(element["pasal"].toString());
                                      //   end_pasal.add(element["pasal"].toString());
                                      // });
                                      // var tempayat = (temppasal
                                      //     .where((ayat) => (ayat["pasal"] == 1)));
                                      // tempayat.forEach((element) {
                                      //   start_ayat.add(elesment["ayat"].toString());
                                      //   end_ayat.add(element["ayat"].toString());
                                      // });

                                      // init_start_kitab = value.toString();
                                      // init_start_pasal =
                                      //     start_pasal.elementAt(0).toString();
                                      // init_start_ayat =
                                      //     start_ayat.elementAt(0).toString();
                                      // init_end_kitab = value.toString();
                                      // init_end_pasal =
                                      //     start_pasal.elementAt(0).toString();
                                      // init_end_ayat =
                                      //     start_ayat.elementAt(1).toString();
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: RadioListTile<Readingmode>(
                                    title: const Text("Custom ..."),
                                    value: Readingmode.custom,
                                    // dense: true,
                                    visualDensity: VisualDensity.compact,
                                    groupValue: _reading,
                                    onChanged: (value) {
                                      customselect = true;
                                      _reading = value;
                                    },
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        //cover

                        height: devotioncheck
                            ? MediaQuery.of(context).size.height - 670 - 50
                            : 0,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          border: Border.all(
                            color: Color.fromARGB(255, 217, 185, 165),
                            width: 0.7,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                        child: Row(
                          children: [
                            Text("reading : ",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'Roboto',
                                )),
                          ],
                        ),
<<<<<<< Updated upstream
                      ),
                      // mulai
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: DropdownButton(
                            // kitab
                            value: init_start_kitab,
                            hint: Text(""),
                            underline: Container(
                              height: 1.5,
                              color: Colors.blueGrey[200],
                            ),
                            icon: const Icon(Icons.keyboard_arrow_down),
                            iconSize: 0.0,
                            isDense: true,
                            items: kitab
                                .map((items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: SizedBox(
                                        width: 37,
                                        child: Text(items,
                                            textAlign: TextAlign.center)),
                                  );
                                })
                                .toSet()
                                .toList(),
                            onChanged: customselect
                                ? (value) {
                                    setState(() {
                                      //setting start pasal list
                                      start_pasal.clear();
                                      end_pasal.clear();
                                      start_ayat.clear();
                                      end_ayat.clear();
                                      var temppasal = (_items.where((pasal) =>
                                          (pasal["kitab_singkat"] == value)));
                                      temppasal.forEach((element) {
                                        start_pasal
                                            .add(element["pasal"].toString());
                                        end_pasal
                                            .add(element["pasal"].toString());
                                      });
                                      var tempayat = (temppasal.where(
                                          (ayat) => (ayat["pasal"] == 1)));
                                      tempayat.forEach((element) {
                                        start_ayat
                                            .add(element["ayat"].toString());
                                        end_ayat
                                            .add(element["ayat"].toString());
                                      });

                                      init_start_kitab = value.toString();
                                      init_start_pasal =
                                          start_pasal.elementAt(0).toString();
                                      init_start_ayat =
                                          start_ayat.elementAt(0).toString();
                                      init_end_kitab = value.toString();
                                      init_end_pasal =
                                          start_pasal.elementAt(0).toString();
                                      init_end_ayat =
                                          start_ayat.elementAt(1).toString();
                                    });
                                  }
                                : null),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 2.0),
                        child: DropdownButton(
                            // pasal
                            value: init_start_pasal,
                            hint: Text(""),
                            icon: const Icon(Icons.keyboard_arrow_down),
                            iconSize: 0.0,
                            underline: Container(
                              height: 1.5,
                              color: Colors.blueGrey[200],
                            ),
                            isDense: true,
                            items: start_pasal.map((items) {
                              return DropdownMenuItem(
                                value: items,
                                child: SizedBox(
                                    width: 20,
                                    child: Text(items,
                                        textAlign: TextAlign.center)),
                              );
                            }).toList(),
                            onChanged: customselect
                                ? (value) {
                                    if (init_start_kitab == init_end_kitab) {
=======
                        // mulai
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: DropdownButton(
                              // kitab
                              value: devotioncheck ? null : init_start_kitab,
                              hint: Text(""),
                              underline: Container(
                                height: 1.5,
                                color: Colors.blueGrey[200],
                              ),
                              icon: const Icon(Icons.keyboard_arrow_down),
                              iconSize: 0.0,
                              isDense: true,
                              items: kitab
                                  .map((items) {
                                    return DropdownMenuItem(
                                      value: items,
                                      child: SizedBox(
                                          width: 37,
                                          child: Text(items,
                                              textAlign: TextAlign.center)),
                                    );
                                  })
                                  .toSet()
                                  .toList(),
                              onChanged: customselect
                                  ? (value) {
>>>>>>> Stashed changes
                                      setState(() {
                                        //reset list ayat
                                        start_ayat.clear();
                                        end_ayat.clear();
                                        var tempayat = (_items.where((ayat) =>
                                            (ayat["pasal"] ==
                                                    int.parse(
                                                        value as String) &&
                                                ayat["kitab_singkat"] ==
                                                    init_start_kitab)));
                                        tempayat.forEach((element) {
                                          start_ayat
                                              .add(element["ayat"].toString());
                                          end_ayat
                                              .add(element["ayat"].toString());
                                        });

                                        init_start_pasal = value.toString();
                                        init_end_pasal = value.toString();

                                        init_start_ayat =
                                            start_ayat.elementAt(0).toString();
                                        init_end_ayat =
                                            start_ayat.elementAt(1).toString();
                                      });
                                    } else {
                                      setState(() {
                                        start_ayat.clear();

                                        var tempayat = (_items.where((ayat) =>
                                            (ayat["pasal"] ==
                                                    int.parse(
                                                        value as String) &&
                                                ayat["kitab_singkat"] ==
                                                    init_start_kitab)));
                                        tempayat.forEach((element) {
                                          start_ayat
                                              .add(element["ayat"].toString());
                                        });

                                        init_start_pasal = value.toString();

                                        init_start_ayat =
                                            start_ayat.elementAt(0).toString();
                                      });
                                    }
                                  }
                                : null),
                      ),
                      Container(
                        child: Text(" : "),
                        padding: EdgeInsets.only(right: 2),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: DropdownButton(

                            // ayat
                            value: init_start_ayat,
                            hint: Text(""),
                            icon: const Icon(Icons.keyboard_arrow_down),
                            iconSize: 0.0,
                            underline: Container(
                              height: 1.5,
                              color: Colors.blueGrey[200],
                            ),
                            isDense: true,
                            items: start_ayat.map((items) {
                              return DropdownMenuItem(
                                value: items,
                                child: SizedBox(
                                    width: 20,
                                    child: Text(
                                      items,
                                      textAlign: TextAlign.center,
                                    )),
                              );
                            }).toList(),
                            onChanged: customselect
                                ? (value) {
                                    setState(() {
                                      init_start_ayat = value.toString();

                                      if (init_start_pasal == init_end_pasal) {
                                        if (value.toString() ==
                                            start_ayat.last.toString()) {
                                          if (init_start_pasal ==
                                              start_pasal.last.toString()) {
                                            int indexkitab = (kitab.toList())
                                                .indexOf(init_start_kitab);
                                            end_pasal.clear();
                                            end_ayat.clear();
                                            var tempasal = (_items.where(
                                                (kit) =>
                                                    (kit["kitab_singkat"] ==
                                                        kitab.elementAt(
                                                            indexkitab + 1))));
                                            init_end_kitab =
                                                tempasal.first["kitab_singkat"];
                                            tempasal.forEach((element) {
                                              end_pasal.add(
                                                  element["pasal"].toString());
                                            });
                                            init_end_pasal =
                                                end_pasal.first.toString();
                                            var tempayat = (tempasal.where(
                                                (ayat) =>
                                                    (ayat["pasal"] == 1)));
                                            tempayat.forEach((element) {
                                              end_ayat.add(
                                                  element["ayat"].toString());
                                            });
                                            init_end_ayat =
                                                end_ayat.first.toString();
                                          } else {
                                            init_end_pasal = (int.parse(
                                                        init_start_pasal
                                                            as String) +
                                                    1)
                                                .toString();

                                            end_ayat.clear();

                                            var tempayat = (_items.where(
                                                (ayat) => (ayat["pasal"] ==
                                                        int.parse(init_end_pasal
                                                            as String) &&
                                                    ayat["kitab_singkat"] ==
                                                        init_start_kitab)));
                                            tempayat.forEach((element) {
                                              end_ayat.add(
                                                  element["ayat"].toString());
                                            });
                                            init_end_ayat =
                                                end_ayat.first.toString();
                                          }
                                        } else {
                                          init_end_ayat =
                                              (int.parse(value as String) + 1)
                                                  .toString();
                                        }
                                      }
                                    });
                                  }
                                : null),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 5.0),
                        child: Text(" - "),
                      ),
                      // selesai
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: DropdownButton(
                            // kitab
                            value: init_end_kitab,
                            hint: Text(""),
                            icon: const Icon(Icons.keyboard_arrow_down),
                            iconSize: 0.0,
                            underline: Container(
                              height: 1.5,
                              color: Colors.blueGrey[200],
                            ),
                            isDense: true,
                            items: kitab
                                .map((items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: SizedBox(
                                        width: 37,
                                        child: Text(items,
                                            textAlign: TextAlign.center)),
                                  );
                                })
                                .toSet()
                                .toList(),
                            onChanged: customselect
                                ? (value) {
                                    setState(() {
                                      int indexmulai;
                                      int indexakhir;
                                      List tempkitab = kitab.toList();
                                      indexmulai =
                                          tempkitab.indexOf(init_start_kitab);
                                      indexakhir =
                                          tempkitab.indexOf(value.toString());
                                      if (indexakhir < indexmulai) {
                                        final sbarerror = SnackBar(
                                          content: const Text(
                                              "Sorry, but this chapter is before the chapter you have selected. please select the same or the chapter after your previous selection"),
                                          action: SnackBarAction(
                                            label: 'OK',
                                            onPressed: () =>
                                                ScaffoldMessenger.of(context)
                                                    .hideCurrentSnackBar(),
                                          ),
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(sbarerror);
                                      } else {
                                        end_pasal.clear();
                                        end_ayat.clear();

                                        var temppasal = (_items.where((pasal) =>
                                            (pasal["kitab_singkat"] == value)));
                                        temppasal.forEach((element) {
                                          start_pasal
                                              .add(element["pasal"].toString());
                                          end_pasal
                                              .add(element["pasal"].toString());
                                        });
                                        var tempayat = (temppasal.where(
                                            (ayat) => (ayat["pasal"] == 1)));
                                        tempayat.forEach((element) {
                                          start_ayat
                                              .add(element["ayat"].toString());
                                          end_ayat
                                              .add(element["ayat"].toString());
                                        });

                                        init_end_kitab = value.toString();
                                        init_end_pasal =
                                            start_pasal.elementAt(0).toString();
                                        init_end_ayat =
                                            start_ayat.elementAt(1).toString();
                                      }
                                    });
                                  }
                                : null),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 2.0),
                        child: DropdownButton(
                            // pasal
                            value: init_end_pasal,
                            hint: Text(""),
                            icon: const Icon(Icons.keyboard_arrow_down),
                            iconSize: 0.0,
                            underline: Container(
                              height: 1.5,
                              color: Colors.blueGrey[200],
                            ),
                            isDense: true,
                            items: end_pasal.map((items) {
                              return DropdownMenuItem(
                                value: items,
                                child: SizedBox(
                                    width: 20,
                                    child: Text(
                                      items,
                                      textAlign: TextAlign.center,
                                    )),
                              );
                            }).toList(),
                            onChanged: customselect
                                ? (value) {
                                    setState(() {
                                      var indexmulai;
                                      var indexakhir;
                                      indexmulai = _items.singleWhere(
                                          (element) =>
                                              element["pasal"] ==
                                                  int.parse(init_start_pasal
                                                      as String) &&
                                              element["kitab_singkat"] ==
                                                  init_start_kitab.toString() &&
                                              element["ayat"] ==
                                                  int.parse(init_start_ayat
                                                      as String));
                                      indexakhir = _items.singleWhere(
                                          (element) =>
                                              element["pasal"] ==
                                                  int.parse(value as String) &&
                                              element["kitab_singkat"] ==
                                                  init_end_kitab &&
                                              element["ayat"] ==
                                                  int.parse(
                                                      init_end_ayat as String));

                                      if (indexakhir["pasal"] <
                                          indexmulai["pasal"]) {
                                        final sbarerror = SnackBar(
                                          content: const Text(
                                              "Sorry, but this chapter is before the chapter you have selected. please select the same or the chapter after your previous selection"),
                                          action: SnackBarAction(
                                            label: 'OK',
                                            onPressed: () =>
                                                ScaffoldMessenger.of(context)
                                                    .hideCurrentSnackBar(),
                                          ),
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(sbarerror);
                                      } else if (indexakhir["pasal"] ==
                                          indexmulai["pasal"]) {
                                        end_ayat.clear();
                                        end_ayat.addAll(start_ayat);
                                        init_end_pasal = value.toString();

                                        init_end_ayat = (int.parse(
                                                    init_start_ayat as String) +
                                                1)
                                            .toString();
                                      } else {
                                        end_ayat.clear();
                                        var tempayat = (_items.where((ayat) =>
                                            (ayat["pasal"] ==
                                                    int.parse(
                                                        value as String) &&
                                                ayat["kitab_singkat"] ==
                                                    init_end_kitab)));
                                        tempayat.forEach((element) {
                                          end_ayat
                                              .add(element["ayat"].toString());
                                        });

                                        init_end_pasal = value.toString();

                                        init_end_ayat =
                                            end_ayat.elementAt(0).toString();
                                      }
                                    });
                                  }
                                : null),
                      ),
                      Container(
                        child: Text(" : "),
                        padding: EdgeInsets.only(right: 2),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: DropdownButton(

                            // ayat
                            value: init_end_ayat,
                            hint: Text(""),
                            icon: const Icon(Icons.keyboard_arrow_down),
                            iconSize: 0.0,
                            underline: Container(
                              height: 1.5,
                              color: Colors.blueGrey[200],
                            ),
                            isDense: true,
                            items: end_ayat.map((items) {
                              return DropdownMenuItem(
                                value: items,
                                child: SizedBox(
                                    width: 20,
                                    child: Text(
                                      items,
                                      textAlign: TextAlign.center,
                                    )),
                              );
                            }).toList(),
                            onChanged: customselect
                                ? (value) {
                                    setState(() {
                                      var indexmulai;
                                      var indexakhir;
                                      indexmulai = _items.singleWhere(
                                          (element) =>
                                              element["pasal"] ==
                                                  int.parse(init_start_pasal
                                                      as String) &&
                                              element["kitab_singkat"] ==
                                                  init_start_kitab &&
                                              element["ayat"] ==
                                                  int.parse(init_start_ayat
                                                      as String));
                                      indexakhir = _items.singleWhere(
                                          (element) =>
                                              element["pasal"] ==
                                                  int.parse(init_end_pasal
                                                      as String) &&
                                              element["kitab_singkat"] ==
                                                  init_end_kitab &&
                                              element["ayat"] ==
                                                  int.parse(value as String));

                                      if (indexakhir["id"] < indexmulai["id"]) {
                                        final sbarerror = SnackBar(
                                          content: const Text(
                                              "Sorry, but this chapter is before the chapter you have selected. please select the same or the chapter after your previous selection"),
                                          action: SnackBarAction(
                                            label: 'OK',
                                            onPressed: () =>
                                                ScaffoldMessenger.of(context)
                                                    .hideCurrentSnackBar(),
                                          ),
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(sbarerror);
                                      } else {
                                        init_end_ayat = value.toString();
                                      }
                                    });
                                  }
                                : null),
                      ),
                    ],
                  ),
                ];
              } else {
                children = <Widget>[
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text('Loading Options...'),
                  ),
                ];
              }
              return Center(
                  child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: children,
                ),
              ));
            }));
  }
}
