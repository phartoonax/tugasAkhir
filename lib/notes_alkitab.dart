// import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:flutter/material.dart';
import 'notes_detail.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class NotesAlkitab extends StatefulWidget {
  const NotesAlkitab(
      {Key? key,
      required this.startindex,
      required this.endindex,
      required this.isnew,
      required this.datenote,
      required this.leaderstatus, required this.isnewabsen})
      : super(key: key);

  final int startindex;
  final int endindex;
  final bool isnew;
  final bool isnewabsen;
  final String datenote;
  final bool leaderstatus;
  @override
  State<NotesAlkitab> createState() => NotesAlkitabState();
}

List _items = [];

class NotesAlkitabState extends State<NotesAlkitab>
    with AutomaticKeepAliveClientMixin {
  Future<void> readJson() async {
    List tempitems = [];
    final String response = await rootBundle.loadString('assets/tbnew.json');
    final data = await json.decode(response);
    setState(() {
      tempitems = data;
      var temp = tempitems.where((bible) =>
          bible["id"] >= widget.startindex && bible["id"] <= widget.endindex);
      _items.addAll(temp);
    });
  }

  @override
  initState() {
    super.initState();
    _items.clear();
    readJson();
  }

  @override
  bool get wantKeepAlive => true;

  pasalchecker(int indx) {
    if (_items[indx]["ayat"] == 1) {
      return Container(
          padding: EdgeInsets.only(top: 5),
          child: RichText(
              text: TextSpan(children: [
            TextSpan(
                text: "Pasal " + _items[indx]["pasal"].toString() + "\n",
                style: Theme.of(context).textTheme.titleLarge),
            TextSpan(
                text: _items[indx]["pasal"].toString() +
                    ":" +
                    _items[indx]["ayat"].toString(),
                style: Theme.of(context).textTheme.labelSmall),
            TextSpan(
                text: _items[indx]["firman"],
                style: Theme.of(context).textTheme.labelLarge),
          ])));
    } else {
      return Container(
        padding: EdgeInsets.only(top: 5),
        child: RichText(
            text: TextSpan(children: [
          TextSpan(
              text: _items[indx]["pasal"].toString() +
                  ":" +
                  _items[indx]["ayat"].toString() +
                  " ",
              style: Theme.of(context).textTheme.labelSmall),
          TextSpan(
              text: _items[indx]["firman"],
              style: Theme.of(context).textTheme.labelLarge)
        ])),
      );
    }
  }

  readrangechecker() {
    if (_items.first["kitab_singkat"] == _items.last["kitab_singkat"]) {
      //sama kitab => check pasal
      if (_items.first["pasal"] == _items.last["pasal"]) {
        return Text(_items.first["kitab_singkat"] +
            " " +
            _items.first["pasal"].toString() +
            ":" +
            _items.first["ayat"].toString() +
            "-" +
            _items.last["ayat"].toString());
      } else {
        return Text(_items.first["kitab_singkat"] +
            " " +
            _items.first["pasal"].toString() +
            ":" +
            _items.first["ayat"].toString() +
            "-" +
            _items.last["pasal"].toString() +
            ":" +
            _items.last["ayat"].toString());
      }
    } else {
      //for the beda kitab
      return Text(_items.first["kitab_singkat"] +
          " " +
          _items.first["pasal"].toString() +
          ":" +
          _items.first["ayat"].toString() +
          "-" +
          _items.last["kitab_singkat"] +
          " " +
          _items.last["pasal"].toString() +
          ":" +
          _items.last["ayat"].toString());
    }
  }

  int pasalcounter = 0;

  @override
  Widget build(BuildContext context) {
    final Future<String> _calculation = Future<String>.delayed(
      const Duration(seconds: 2),
      () => 'Data Loaded',
    );

    return Scaffold(
        appBar: AppBar(
          title:
              readrangechecker(), // temp. REPLACE with actual scripture reading
          automaticallyImplyLeading: widget.isnew,
          actions: [
            Center(
              child: Text(
                widget.datenote,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Colors.white),
              ),
            ),
            Container(
              width: 10,
            ),
            IconButton(
                onPressed: () {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NotesDetail(
                                endindex: widget.endindex,
                                startindex: widget.startindex,
                                isnew: widget.isnew,
                                isnewabsen: widget.isnewabsen,
                                datenote: widget.datenote,
                                leaderstatus: widget.leaderstatus,
                              )),
                    );
                  });
                },
                icon: Icon(Icons.notes_rounded)),
          ],
        ),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: KeepAlive(
            keepAlive: true,
            child: FutureBuilder<String>(
              future: _calculation,
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                List<Widget> children;
                if (snapshot.hasData) {
                  children = <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 10, right: 10, top: 30),
                      child: SingleChildScrollView(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height - 120,
                          child: ListView.builder(
                            itemCount: _items.length,
                            cacheExtent: 300,
                            addAutomaticKeepAlives: true,
                            padding: EdgeInsets.zero,
                            itemBuilder: (BuildContext cont, int indx) {
                              return pasalchecker(indx);
                            },
                          ),
                        ),
                      ),
                    )
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
                      child: Text('Awaiting result...'),
                    ),
                  ];
                }
                return Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: children,
                ));
              },

              /// setup a listview for the scripture. style is tbd.
            ),
          ),
        ));
  }
}
