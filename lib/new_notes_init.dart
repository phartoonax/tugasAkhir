import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:flutter/material.dart';

class NewNotesinitPage extends StatefulWidget {
  const NewNotesinitPage({Key? key}) : super(key: key);

  @override
  State<NewNotesinitPage> createState() => _NewNotesinitPageState();
}

List<Map>? itemers = [
  {"": ""}
];

class _NewNotesinitPageState extends State<NewNotesinitPage> {
  bool recomendationcheck = false;

  String? initdropdownvalue;
  String? init_start_kitab;
  String? init_start_pasal;
  String? init_start_ayat;

  String? init_end_kitab;
  String? init_end_pasal;
  String? init_end_ayat;
  

  Future<List<Map?>?> inititem =
      Backendless.data.of('Rekomendasi_Genre').find().then((value) {
    itemers!.clear();
    itemers = value?.cast<Map>();
  });

  initState() {
    super.initState();
    init();
  }

  void init() async {}

  var start_Kitab = [
    //TODO: REPLACE THIS WITH ACTUAL DATA FROM BES
    'Kej',
    'Kel',
    'Ima',
    'Bil',
    'Ula',
  ];
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

  var end_kitab = [
    //TODO: REPLACE THIS WITH ACTUAL DATA FROM BES
    'Kej',
    'Kel',
    'Ima',
    'Bil',
    'Ula',
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
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Add New Notes'),
          leading: BackButton(
            onPressed: () => Navigator.pop(context),
          ),
          actions: [],
        ),
        body: Padding(
            padding: const EdgeInsets.all(0),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  CheckboxListTile(
                    contentPadding: EdgeInsets.all(0),
                    visualDensity: VisualDensity.compact,
                    title: const Text("I want to use the recomendation"),
                    value: recomendationcheck,
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (newvalue) {
                      recomendationcheck = newvalue!;
                      initdropdownvalue = itemers![0]["judul_genre"];
                      setState(() {});
                    },
                  ),
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
                  SizedBox(
                    height: 10.9,
                  ),
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
                      children: [],
                    ),
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
                            items: start_Kitab.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(items),
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
                            items: end_kitab.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(items),
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
                  )
                ],
              ),
            )),
      ),
    );
  }
}
