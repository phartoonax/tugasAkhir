import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'main_screen.dart';
import 'notes_alkitab.dart';

import 'dart:convert';
import 'package:flutter/services.dart';

class NotesDetail extends StatefulWidget {
  NotesDetail(
      {Key? key,
      required this.isnew,
      required this.startindex,
      required this.endindex,
      required this.datenote,
      this.idrecommend,
      required this.leaderstatus,
      required this.isnewabsen})
      : super(key: key);

  final bool isnew;
  final bool isnewabsen;
  final int startindex;
  final int endindex;
  final String datenote;
  final Map? idrecommend;
  final bool leaderstatus;
  @override
  State<NotesDetail> createState() => _NotesDetailState();
}

List _items = [];

class _NotesDetailState extends State<NotesDetail> {
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
    if (widget.isnew == false) {
      titleController.text = widget.idrecommend!['judul_catatan'];
      notesController.text = widget.idrecommend!['catatan'];
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

  alertpopchecker() {
    if (widget.leaderstatus == true) {
      {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Do you want to share?'),
            content: const Text('Share This note With Your Leader?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  savetodatabase(false);
                },
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () {
                  savetodatabase(true);
                },
                child: const Text('Yes'),
              ),
            ],
          ),
        );
      }
    } else {
      savetodatabase(false);
    }
  }

  savetodatabase(bool share) {
    Map notestemp = {
      "judul_catatan": titleController.text,
      "catatan": notesController.text,
      "idstartkitab": widget.startindex,
      "idendkitab": widget.endindex,
      "sharestatus": share,
    };
    if (widget.isnew == true) {
      Backendless.data.of("Catatan_Sate").save(notestemp).then((value) {
        print("save Status" + value.toString());
        if (widget.isnewabsen == true) {
          Map absentemp = {};
          Backendless.data.of("Absensi").save(absentemp).then((value) {
            print("absen Status" + value.toString());
          });
        }
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => MainScreen()))
              .then((value) {
            setState(() {});
          });
        });
      });
    } else {
      notestemp["objectId"] = widget.idrecommend!['objectId'];
      final unitOfWork = UnitOfWork();
      unitOfWork.update(notestemp, "Catatan_Sate");
      unitOfWork.execute().then((value) {
        print("update Status" + value.toString());
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => MainScreen()))
              .then((value) {
            setState(() {});
          });
        });
      });
    }
  }

  final TextEditingController titleController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final _key = GlobalKey<ExpandableFabState>();
    return Scaffold(
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        type: ExpandableFabType.up,
        key: _key,
        closeButtonStyle: ExpandableFabCloseButtonStyle(
          child: const Icon(Icons.close),
        ),
        child: FloatingActionButton(
          onPressed: (() {
            final state = _key.currentState;
            if (state != null) {
              debugPrint('isOpen:${state.isOpen}');
              state.toggle();
            }
          }),
          // icon: const Icon(Icons.save),
          child: Text("Save"),
        ),
        children: [
          FloatingActionButton.small(
            onPressed: (() => alertpopchecker()),
            child: const Icon(Icons.check),
            // child: Text("Yes"),
          ),
        ],
      ),
      appBar: AppBar(
        title: readrangechecker(),
        automaticallyImplyLeading: widget.isnew,
        actions: [
          IconButton(
              onPressed: () {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NotesAlkitab(
                              datenote: widget.datenote,
                              isnew: widget.isnew,
                              isnewabsen: widget.isnewabsen,
                              endindex: widget.endindex,
                              startindex: widget.startindex,
                              leaderstatus: widget.leaderstatus,
                            )),
                  );
                });
              },
              icon: Icon(Icons.book)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height - 50,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    //Controller: PUT CONTROLLER HERE AND BELOW
                    decoration: InputDecoration.collapsed(
                      hintText: "Insert Your Title Here",
                      hintStyle: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(221, 150, 150, 150)),
                    ),
                    controller: titleController,
                    textCapitalization: TextCapitalization.words,
                    scrollPadding: EdgeInsets.all(20.0),
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    autofocus: true,
                  ),
                ),
                Container(
                  //DATE
                  padding: EdgeInsets.only(left: 15, bottom: 15, top: 10),
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    widget.datenote,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Color.fromARGB(255, 129, 95, 95)),
                  ),
                ),
                Expanded(
                    child: TextField(
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration.collapsed(
                    hintText: "Type Your note here",
                    hintStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Color.fromARGB(221, 199, 185, 185)),
                  ),
                  controller: notesController,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.black87),
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
