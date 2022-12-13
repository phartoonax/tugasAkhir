// ignore_for_file: non_constant_identifier_names

import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'notes_alkitab.dart';
import 'package:carousel_slider/carousel_slider.dart';

class NewNotesinitPage extends StatefulWidget {
  const NewNotesinitPage({Key? key}) : super(key: key);

  @override
  State<NewNotesinitPage> createState() => _NewNotesinitPageState();
}

List<Map>? itemers = [
  {"judul_genre": ""}
];
List<Map>? kitabs = [
  {"kitab_singkat": ""}
];
String formattedDate = "";

enum Readingmode { sabda, biblestudytools, gms, custom }

class _NewNotesinitPageState extends State<NewNotesinitPage> {
  Readingmode? _reading = Readingmode.custom;
  bool recomendationcheck = false;

  String? initdropdownvalue;
  String? init_start_kitab;
  String? init_start_pasal;
  String? init_start_ayat;

  String? init_end_kitab;
  String? init_end_pasal;
  String? init_end_ayat;

  initState() {
    super.initState();
    init();
    var now = new DateTime.now();
    var formatter = new DateFormat('dd-MM-yy');
    formattedDate = formatter.format(now);
  }

  void init() async {
    Future<List<Map?>?> inititem =
        Backendless.data.of('Rekomendasi_Genre').find().then((value) {
      itemers!.clear();
      itemers = value?.cast<Map>();
    });
    DataQueryBuilder querry = DataQueryBuilder()
      ..sortBy = ["id_kitab"]
      ..pageSize = 66;
    Future<List<Map?>?> initkitab =
        Backendless.data.of('Alkitab_kitab').find(querry).then((value) {
      kitabs!.clear();
      kitabs = value?.cast<Map>();
      print("This is from new notes" + kitabs.toString());
    });

    setState(() {});
  }

  var start_pasal = [
    //TODO: REPLACE THIS WITH ACTUAL DATA FROM BES
    '1',
    '2',
    '3',
    '4',
    '5',
  ];
  var start_ayat = [
    //TODO: REPLACE THIS WITH ACTUAL DATA FROM BES
    '1',
    '2',
    '3',
    '4',
    '5',
  ];

  var end_pasal = [
    //TODO: REPLACE THIS WITH ACTUAL DATA FROM BES
    '1',
    '2',
    '3',
    '4',
    '5',
  ];
  var end_ayat = [
    //TODO: REPLACE THIS WITH ACTUAL DATA FROM BES
    '1',
    '2',
    '3',
    '4',
    '5',
  ];

  void changepasal() {}

  @override
  Widget build(BuildContext context) {
    final Future<String> _calculation = Future<String>.delayed(
      const Duration(seconds: 3),
      () => 'Data Loaded',
    );
    return Scaffold(
        appBar: AppBar(
          title: Text('Add New Notes'),
          leading: BackButton(
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            Center(
              child: Text(formattedDate),
            ),
            IconButton(
                onPressed: (() {}), icon: Icon(Icons.calendar_month_outlined)),
            IconButton(
                onPressed: (() {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if(init_end_ayat=);
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
                      if (newvalue = true) {
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
                            value: false,
                            controlAffinity: ListTileControlAffinity.leading,
                            onChanged: (newvalue) {},
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
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: 5,
                              separatorBuilder: (context, index) =>
                                  const Divider(),
                              itemBuilder: (context, index) => Card(
                                  child: Center(
                                child: Text("Placeholder"),
                              )),
                            ),
                          ),
                          SizedBox(height: 20),
                          CheckboxListTile(
                            contentPadding: EdgeInsets.all(0),
                            visualDensity: VisualDensity.compact,
                            title: const Text("Songs"),
                            value: false,
                            controlAffinity: ListTileControlAffinity.leading,
                            onChanged: (newvalue) {},
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
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: 5,
                              separatorBuilder: (context, index) =>
                                  const Divider(),
                              itemBuilder: (context, index) => Card(
                                  child: Center(
                                child: Text("Placeholder"),
                              )),
                            ),
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
                        height: MediaQuery.of(context).size.height - 670 - 45,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.only(
                          left: 10,
                          right: 10,
                          bottom: 20,
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
                                    onChanged: (value) {},
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
                                    onChanged: (value) {},
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
                                    onChanged: (value) {},
                                  ),
                                ),
                                Expanded(
                                  child: RadioListTile<Readingmode>(
                                    title: const Text("Custom ..."),
                                    value: Readingmode.custom,
                                    // dense: true,
                                    visualDensity: VisualDensity.compact,
                                    groupValue: _reading,
                                    onChanged: (value) {},
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        //cover

                        height: recomendationcheck
                            ? MediaQuery.of(context).size.height - 670 - 45
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
                      ),
                      // mulai
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: DropdownButton(
                            // kitab
                            value: init_start_kitab,
                            hint: Text(""),
                            icon: const Icon(Icons.keyboard_arrow_down),
                            iconSize: 0.0,
                            isDense: true,
                            items: kitabs!.map((Map items) {
                              return DropdownMenuItem(
                                value: items["kitab_singkat"],
                                child: Text(items["kitab_singkat"]),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                init_start_kitab = value.toString();
                                init_start_pasal = start_pasal[0].toString();
                                init_start_ayat = start_ayat[0].toString();
                                init_end_kitab = value.toString();
                                init_end_pasal = start_pasal[0].toString();
                                init_end_ayat = start_ayat[1].toString();
                              });
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 7.0),
                        child: DropdownButton(
                            // pasal
                            value: init_start_pasal,
                            hint: Text(""),
                            icon: const Icon(Icons.keyboard_arrow_down),
                            iconSize: 0.0,
                            isDense: true,
                            items: start_pasal.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(items),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                init_start_pasal = value.toString();

                                init_start_ayat = start_ayat[0].toString();
                                init_end_ayat = start_ayat[1].toString();
                              });
                            }),
                      ),
                      Container(
                        child: Text(" : "),
                        padding: EdgeInsets.only(right: 7),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: DropdownButton(

                            // ayat
                            value: init_start_ayat,
                            hint: Text(""),
                            icon: const Icon(Icons.keyboard_arrow_down),
                            iconSize: 0.0,
                            isDense: true,
                            items: start_ayat.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(items),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                init_start_ayat = value.toString();
                              });
                            }),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 10.0),
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
                            isDense: true,
                            items: kitabs!.map((Map items) {
                              return DropdownMenuItem(
                                value: items["kitab_singkat"],
                                child: Text(items["kitab_singkat"]),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                init_end_kitab = value.toString();
                                init_end_pasal = end_pasal[0].toString();
                                init_end_ayat = end_ayat[0].toString();
                              });
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 7.0),
                        child: DropdownButton(
                            // pasal
                            value: init_end_pasal,
                            hint: Text(""),
                            icon: const Icon(Icons.keyboard_arrow_down),
                            iconSize: 0.0,
                            isDense: true,
                            items: end_pasal.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(items),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                init_end_pasal = value.toString();
                              });
                            }),
                      ),
                      Container(
                        child: Text(" : "),
                        padding: EdgeInsets.only(right: 7),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: DropdownButton(

                            // ayat
                            value: init_end_ayat,
                            hint: Text(""),
                            icon: const Icon(Icons.keyboard_arrow_down),
                            iconSize: 0.0,
                            isDense: true,
                            items: end_ayat.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(items),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                init_end_ayat = value.toString();
                              });
                            }),
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
