import 'package:flutter/material.dart';
import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'alarm_screen.dart';
import 'leaderspage.dart';
import 'new_notes_init.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'notes_detail.dart';
import 'package:upgrader/upgrader.dart';

const String SERVER_URL = "https://eu-api.backendless.com";
const String APPLICATION_ID = "A5B771C1-B135-1146-FFC2-204701E95500";
const String ANDROID_API_KEY = "0CCFCDB3-0974-43B5-BD23-61FA6745C4A3";
const String IOS_API_KEY = "140898C0-D6DC-459E-A62E-20FF3A644653";
const String JS_API_KEY = "D4EF9175-2546-4B17-9038-14A77F5186F5";

class MainScreen extends StatefulWidget {
  MainScreen({Key? key, this.id}) : super(key: key);
  final String? id;
  @override
  State<MainScreen> createState() => _MainScreenState();
}

String namas = "";
String ids = "";
List<Map> listnote = List<Map>.empty(growable: true);
List<Map> listabsen = List<Map>.empty(growable: true);

List _items = []; //for the alkitab

bool notesstatus = false;

bool leadstatus = false;

class _MainScreenState extends State<MainScreen> {
  Future<void> readJson() async {
    List tempitems = [];
    final String response = await rootBundle.loadString('assets/tbnew.json');
    final data = await json.decode(response);
    setState(() {
      tempitems = data;

      _items.addAll(tempitems);
    });
  }

  @override
  initState() {
    super.initState();
    loadnotes();
    readJson();
  }

  Future<void> loadnotes() async {
    notesstatus = false;
    String currentUserObjectId = "";
    currentUserObjectId = (await Backendless.userService.loggedInUser())!;
    Backendless.data
        .of("Users")
        .findById(currentUserObjectId)
        .then((user) async {
      namas = user!["name"];

      ids = currentUserObjectId;
      Map parsedat;
      Future<Map?> userdat = Backendless.data
          .of('Users')
          .findById(ids, relations: ["leader_student"], relationsDepth: 1);
      parsedat = (await userdat)!;
      print("From loadnotes | logindata = " + parsedat.toString());
      if (parsedat["leader_student"].toString() != "[]") {
        leadstatus = true;
<<<<<<< Updated upstream
=======
        (parsedat["leader_student"] as List).forEach((element) {
          BackendlessUser tempuser = element;
          Map touser = {
            "nama": tempuser.getProperty("name").toString(),
            "id": tempuser.getProperty("objectId").toString(),
          };
          DataQueryBuilder tempquerry = DataQueryBuilder()
            ..whereClause =
                "ownerId = '${element.getProperty("objectId").toString()}'"
            ..sortBy = ["created"];
          //manageing absen
          List<Map> tempabsen = List.empty(growable: true);

          Backendless.data.of('Absensi').find(tempquerry).then((value) {
            tempabsen.addAll(value!.cast<Map>());
            //14 days checker
            var dates = (DateTime.now().subtract(Duration(days: 13)));
            List<bool> absenmurid = List.empty(growable: true);
            int indexdb = 0;
            for (int i = 0; i < 14; i++) {
              if (tempabsen.isNotEmpty && tempabsen.length > indexdb) {
                if ((tempabsen[indexdb]['created'] as DateTime).day ==
                    dates.add(Duration(days: i)).day) {
                  indexdb++;
                  absenmurid.add(true);
                } else {
                  absenmurid.add(false);
                }
              } else {
                absenmurid.add(false);
              }
            }
            setState(() {
              touser["absen"] = absenmurid;
            });
          });

          //searching catatan murid
          tempquerry.whereClause =
              "ownerId = '${element.getProperty("objectId").toString()}' && sharestatus=true";
          tempquerry.related = ['rekomendasi_renungan'];
          tempquerry.relationsDepth = 1;

          Backendless.data.of('Catatan_Sate').find(tempquerry).then((value) {
            if (value!.isEmpty == true) {
              print("TEST IS TRUE");
              touser["notes"] = List<Map>.empty();
            } else {
              List<Map> notesmurid = List.empty(growable: true);
              value.forEach(
                (element) {
                  notesmurid.add(element!);
                },
              );
              setState(() {
                touser["notes"] = notesmurid;
                print(value);
              });
            }
          }).catchError((onError, stackTrace) {
            print("There has been an error inside: $onError");
            PlatformException platformException = onError;
            print("Server reported an error inside.");
            print("Exception code: ${platformException.code}");
            print("Exception details: ${platformException.details}");
            print("Stacktrace: $stackTrace");
          }, test: (e) => e is PlatformException);
          listmurid.add(touser);
        }); //end foreach

        print("list Murid|" + listmurid.toString());
>>>>>>> Stashed changes
      }
      DataQueryBuilder searchnotes = DataQueryBuilder()
        ..whereClause = "ownerId = '$currentUserObjectId'"
        ..sortBy = ["created DESC"];

      Backendless.data.of('Catatan_Sate').find(searchnotes).then((foundnotes) {
        listnote.clear();
        listnote.addAll(foundnotes!.cast<Map>());
        notesstatus = true;

        setState(() {});
      });
      //search date, pull data absensi
      var dateforcomp = DateTime.now();

      for (int i = 0; i <= 6; i++) {
        if ((dateforcomp.subtract(Duration(days: i))).weekday ==
            DateTime.monday) {
          var dates = (dateforcomp.subtract(Duration(days: i)));
          searchnotes
            ..whereClause =
                "ownerId = '$currentUserObjectId' && created at or after '" +
                    dates.month.toString() +
                    "-" +
                    dates.day.toString() +
                    "-" +
                    dates.year.toString() +
                    "'"
            ..sortBy = ["created"];
        }
      }
      Backendless.data.of('Absensi').find(searchnotes).then((foundabsen) {
        listabsen.clear();
        listabsen.addAll(foundabsen!.cast<Map>());
        notesstatus = true;
        print("List Absen: " + listabsen.toString());
        setState(() {});
      });

      setState(() {});
    });
    setState(() {});
  }

  void _onItemTapped(int index) {
    if (index != 2) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var screens = [
      ContentMain(
        name: namas,
        id: ids,
        notes: listnote,
        statusnotesload: notesstatus,
        absen: listabsen,
      ),
      AlarmScreen(),
      null,
      LeadersPage(
        leaderStatus: leadstatus,
      ),
      AlarmScreen(),
    ];
    return UpgradeAlert(
      child: Scaffold(
        body: RefreshIndicator(
            onRefresh: loadnotes,
            child: Container(child: screens[_selectedIndex])),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              bool deciderabsen;
              if ((listabsen.last['created'] as DateTime).weekday ==
                  dates.weekday) {
                deciderabsen = false;
              } else {
                deciderabsen = true;
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => listnote.isEmpty
                        ? NewNotesinitPage(
                            leaderstatus: leadstatus,
                            isnewabsen: true,
                          )
                        : NewNotesinitPage(
                            leaderstatus: leadstatus,
                            isnewabsen: deciderabsen,
                            lastreading: listnote.first,
                          )),
              ).then((value) {
                loadnotes();
                setState(() {});
              });
            });
          },
          child: Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: Theme(
          data: ThemeData(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            elevation: 20.0,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.bookmark_border),
                label: 'Devotions',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.alarm),
                label: 'Reminder',
              ),
              BottomNavigationBarItem(
                backgroundColor: Colors.white,
                icon: const SizedBox.shrink(),
                label: "",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.people),
                label: 'Leadership',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.face),
                label: 'Profile',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Color(0xffF04F2C),
            unselectedItemColor: Colors.black,
            onTap: _onItemTapped,
            enableFeedback: false,
          ),
        ),
      ),
    );
  }
}

class SwitchExample extends StatefulWidget {
  const SwitchExample({Key? key});

  @override
  State<SwitchExample> createState() => _SwitchExampleState();
}

class _SwitchExampleState extends State<SwitchExample> {
  bool light = true;

  @override
  Widget build(BuildContext context) {
    return Switch(
      // This bool value toggles the switch.
      value: light,
      activeColor: Colors.red,
      activeThumbImage: AssetImage('assets/GB.png'),
      inactiveThumbImage: AssetImage('assets/ID.png'),
      onChanged: (bool value) {
        // This is called when the user toggles the switch.
        setState(() {
          light = value;
        });
      },
    );
  }
}

class ContentMain extends StatefulWidget {
  final String name;
  final String id;
  final List<Map>? notes;
  final List<Map>? absen;
  final bool statusnotesload;
  const ContentMain({
    Key? key,
    required this.id,
    required this.name,
    required this.notes,
    required this.statusnotesload,
    required this.absen,
  }) : super(key: key);

  @override
  State<ContentMain> createState() => _ContentMainState();
}

List<bool> confirmabsen = List<bool>.empty(growable: true);
DateTime dates = DateTime.now();

class _ContentMainState extends State<ContentMain> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey[300],
      //Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 50, left: 10, right: 10),
              child: Row(
                // 'appbar'
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.only(
                        top: 10, left: 10, right: 10, bottom: 5),
                    child: widget.name == ""
                        ? Center(
                            child: SizedBox(
                              width: 30,
                              height: 30,
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : Text(
                            'Hai, ' + widget.name + '!',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 28,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                  ),
<<<<<<< Updated upstream
                ],
              ),
            ),
            Container(
              //list and cronies
              margin: EdgeInsets.only(
                top: 25.0,
              ),
              height: 475,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 15),
                    child: Row(
                      // for the top of list and 2 buttons
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          child: Text(
                            "Here's Your Daily Notes",
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 19,
                            ),
=======
                ),
                Container(
                  //box for 2 box
                  height: 110.h,
                  margin: EdgeInsets.only(top: 10, left: 5, right: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 140,
                        width: 180,
                        child: IconButton(
                          padding: EdgeInsets.all(0),
                          onPressed: () {
                            confirmabsen.clear();
                            bool checkabsen = false;
                            int indexfordb = 0;

                            for (int i = 0; i <= 6; i++) {
                              if ((DateTime.now().subtract(Duration(days: i)))
                                      .weekday ==
                                  DateTime.monday) {
                                dates = (DateTime.now().subtract(
                                    Duration(days: i))); //searching for monday
                              }
                            }
                            int intforcheckindex = widget.absen!.isNotEmpty
                                ? (widget.absen!.last['created'] as DateTime)
                                        .weekday -
                                    dates.weekday +
                                    1
                                : 1;
                            for (int i = 0; i < intforcheckindex; i++) {
                              if (widget.absen!.isNotEmpty) {
                                if ((dates.add(Duration(days: i))).day ==
                                    (widget.absen![indexfordb]['created']
                                            as DateTime)
                                        .day) {
                                  indexfordb++;
                                  confirmabsen.add(true);
                                } else {
                                  confirmabsen.add(false);
                                }
                              } else {
                                confirmabsen.add(false);
                              }
                            }
                            int leng = confirmabsen.length;
                            for (int j = 1; j <= 7 - leng; j++) {
                              confirmabsen.add(false);
                            }
                            if (widget.absen!.isNotEmpty) {
                              if ((widget.absen!.last['created'] as DateTime)
                                      .day ==
                                  DateTime.now().day) {
                                checkabsen = true;
                              }
                            }
                            showDialog(
                                context: context,
                                builder: (BuildContext context) => CustomDialog(
                                      name: widget.name,
                                      checkined: checkabsen,
                                      numberofcheckinweek: widget.absen!.length,
                                      listnote: listnotes,
                                      absen: confirmabsen,
                                    ));
                          },
                          icon: Image.asset(
                            'assets/Checkin.png',
                            fit: BoxFit.fill,
>>>>>>> Stashed changes
                          ),
                        ),
                        Spacer(),
                        // buttons for sorting
                        Container(
                          child: IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.search),
                          ),
                        ),
                        Container(
                          child: IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.view_module),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    //below the button, the actual list
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Color(0xFFA8775B),
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(7))),
                    height: 425,
                    child: shownotes(),
                  ),
                ],
              ),
            ),
            Container(
              //box for 2 box
              height: 140,
              margin: EdgeInsets.only(top: 15, left: 5, right: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 140,
                    width: 180,
                    child: IconButton(
                      padding: EdgeInsets.all(0),
                      onPressed: () {
                        confirmabsen.clear();
                        bool checkabsen = false;
                        int indexfordb = 0;

                        for (int i = 0; i <= 6; i++) {
                          if ((DateTime.now().subtract(Duration(days: i)))
                                  .weekday ==
                              DateTime.monday) {
                            dates = (DateTime.now().subtract(
                                Duration(days: i))); //searching for monday
                          }
                        }
                        int intforcheckindex = widget.absen!.isNotEmpty
                            ? (widget.absen!.last['created'] as DateTime).day -
                                dates.day +
                                1
                            : 1;
                        for (int i = 0; i < intforcheckindex; i++) {
                          if (widget.absen!.isNotEmpty) {
                            if ((dates.add(Duration(days: i))).day ==
                                (widget.absen![indexfordb]['created']
                                        as DateTime)
                                    .day) {
                              indexfordb++;
                              confirmabsen.add(true);
                            } else {
                              confirmabsen.add(false);
                            }
                          } else {
                            confirmabsen.add(false);
                          }
                        }
                        int leng = confirmabsen.length;
                        for (int j = 1; j <= 7 - leng; j++) {
                          confirmabsen.add(false);
                        }
                        if (widget.absen!.isNotEmpty) {
                          if ((widget.absen!.last['created'] as DateTime).day ==
                              DateTime.now().day) {
                            checkabsen = true;
                          }
                        }
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => CustomDialog(
                                  name: widget.name,
                                  checkined: checkabsen,
                                  numberofcheckinweek: widget.absen!.length,
                                  absen: confirmabsen,
                                ));
                      },
                      icon: Image.asset(
                        'assets/Checkin.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Container(
                    height: 140,
                    width: 180,
                    child: IconButton(
                      padding: EdgeInsets.all(0),
                      onPressed: () {},
                      icon: Image.asset(
                        'assets/recomdSetting.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
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

  shownotes() {
    if (widget.statusnotesload == false) {
      return Center(
        child: SizedBox(
          width: 60,
          height: 60,
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      if (widget.notes!.length == 0) {
        return Flex(direction: Axis.horizontal, children: [
          Expanded(
              child: Container(
            child: Text(
              "You have no notes yet. Let's start your Devotion Journey today!",
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          )),
        ]);
      } else {
        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: widget.notes!.length,
          itemBuilder: (context, index) {
            var now = widget.notes![index]['created'];
            var formatter = new DateFormat('dd MMM yy');
            formattedDate = formatter.format(now);
            return Card(
              child: Slidable(
                key: const ValueKey(0),
                endActionPane: ActionPane(motion: BehindMotion(), children: [
                  SlidableAction(
                    onPressed: (context) {},
                    backgroundColor: Color(0xFF7BC043),
                    foregroundColor: Colors.white,
                    icon: Icons.archive,
                    label: 'Archive',
                  ),
                  SlidableAction(
                    onPressed: (context) {
                      Backendless.data
                          .of("Catatan_Sate")
                          .remove(entity: widget.notes![index])
                          .then((value) => print(value));
                      widget.notes!.removeAt(index);
                      setState(() {});
                    },
                    backgroundColor: Color.fromARGB(255, 207, 3, 3),
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: 'delete',
                  ),
                ]),
                child: ListTile(
                  leading: Icon(
                    Icons.description,
                  ),
                  title: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(widget.notes![index]['judul_catatan']),
                  ),
                  subtitle: readrangechecker(
                      widget.notes![index]['idstartkitab'] - 1,
                      widget.notes![index]['idendkitab'] - 1),
                  dense: false,
                  trailing: Text(formattedDate),
                  onTap: () {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NotesDetail(
                                  endindex: widget.notes![index]['idendkitab'],
                                  startindex: widget.notes![index]
                                      ['idstartkitab'],
                                  isnew: false,
                                  isnewabsen: false,
                                  idrecommend: widget.notes![index],
                                  datenote: formattedDate,
                                  leaderstatus: leadstatus,
                                )),
                      );
                    });
                  },
                ),
              ),
            );
          },
        );
      }
    }
  }
}

class CustomDialog extends StatefulWidget {
  final String name;
  final bool checkined;
  final int numberofcheckinweek;
  final List<bool>? absen;

  CustomDialog(
      {super.key,
      required this.name,
      required this.checkined,
      required this.numberofcheckinweek,
      required this.absen});
  @override
  State<CustomDialog> createState() => _CustomDialogState();
}

var dateday = DateTime.now().weekday;

class _CustomDialogState extends State<CustomDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  Icon iconsearcher(int i) {
    if (widget.absen![i - 1] == true) {
      return Icon(
        Icons.hotel_class,
        color: Colors.green[700],
        size: 40,
      );
    } else {
      if (dateday == i) {
        return Icon(
          Icons.star_half,
          color: Colors.amber,
          size: 40,
        );
      } else {
        return Icon(
          Icons.hotel_class,
          color: Colors.blueGrey[300],
          size: 40,
        );
      }
    }
  }

  Widget dialogContent(BuildContext context) {
    var names = widget.name;
    int checkcount = widget.numberofcheckinweek;
    return Container(
      margin: EdgeInsets.only(left: 0.0, right: 0.0),
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
              top: 18.0,
            ),
            margin: EdgeInsets.only(top: 13.0, right: 8.0),
            decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 0.0,
                    offset: Offset(0.0, 0.0),
                  ),
                ]),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  height: 10.0,
                ),
                Container(
                    child: Column(
                  children: [
                    Container(
                      alignment: AlignmentDirectional.topStart,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            right: 10.0, bottom: 10, top: 5, left: 5),
                        child: new Text("Selamat Datang, $names!",
                            style:
                                TextStyle(fontSize: 24.0, color: Colors.black)),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.all(7),
                        child: RichText(
                          text: TextSpan(
                              children: widget.checkined
                                  ? [
                                      TextSpan(
                                          text:
                                              "Anda sudah melakukan absen pada hari ini! Dalam minggu ini, anda telah melakukan ",
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.black)),
                                      TextSpan(
                                          text: checkcount.toString(),
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold)),
                                      TextSpan(
                                          text:
                                              " sesi Saat Teduh! Mari lakukan lebih lagi Besok!",
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.black)),
                                    ]
                                  : [
                                      TextSpan(
                                          text:
                                              "Mari melakukan absen pada hari ini untuk merekam hasil Saat Teduh anda! Dalam minggu ini, anda telah melakukan ",
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.black)),
                                      TextSpan(
                                          text: checkcount.toString(),
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold)),
                                      TextSpan(
                                          text: " sesi Saat Teduh!",
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.black)),
                                    ]),
                        )),
                    Center(
                      child: Container(
                        alignment: AlignmentDirectional.center,

                        padding: EdgeInsets.all(20),
                        // tempat absen visual
                        //TODO REPLACE ICON WITH DATA FROM DB
                        child: Column(
                          children: [
                            Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                // top
                                children: [
                                  Container(
                                      child: Column(
                                    children: [Text("Sen."), iconsearcher(1)],
                                  )),
                                  Container(
                                      child: Column(
                                    children: [Text("Sel."), iconsearcher(2)],
                                  )),
                                  Container(
                                      child: Column(
                                    children: [Text("Rab."), iconsearcher(3)],
                                  )),
                                  Container(
                                      child: Column(
                                    children: [Text("Kam."), iconsearcher(4)],
                                  )),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                // bottom
                                children: [
                                  Container(
                                      child: Column(
                                    children: [Text("Jum."), iconsearcher(5)],
                                  )),
                                  Container(
                                      child: Column(
                                    children: [Text("Sab."), iconsearcher(6)],
                                  )),
                                  Container(
                                      child: Column(
                                    children: [Text("Min."), iconsearcher(7)],
                                  )),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ) //
                    ),
                SizedBox(height: 24.0),
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Container(
                      padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                      decoration: BoxDecoration(
                        color: widget.checkined
                            ? Colors.grey[600]
                            : Colors.lightGreen,
                        borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      ),
                      child: Text(
                        widget.checkined ? "Checked In" : "Check In!",
                        style: TextStyle(color: Colors.white, fontSize: 18.0),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  onTap: widget.checkined
                      ? () {}
                      : () {
                          final sbarnoticeabsen = SnackBar(
                            duration: Duration(seconds: 10),
                            content: const Text(
                                "Mulai Absen dengan melakukan saat teduh pribadi terlebih dahulu!"),
                            action: SnackBarAction(
                              label: 'OK',
                              onPressed: () => ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar(),
                            ),
                          );
                          ScaffoldMessenger.of(context)
                              .showSnackBar(sbarnoticeabsen);
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NewNotesinitPage(
                                        isnewabsen: true,
                                        leaderstatus: leadstatus,
                                      )),
                            ).then((value) {
                              setState(() {});
                            });
                          });
                        },
                ),
                SizedBox(height: 24.0),
              ],
            ),
          ),
          Positioned(
            //close button

            right: 0.0,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Align(
                alignment: Alignment.topRight,
                child: CircleAvatar(
                  radius: 14.0,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.close, color: Colors.red),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
