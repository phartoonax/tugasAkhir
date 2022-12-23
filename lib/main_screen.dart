import 'package:flutter/material.dart';
import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:intl/intl.dart';
import 'alarm_screen.dart';
import 'leaderspage.dart';
import 'new_notes_init.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'notes_detail.dart';

const String SERVER_URL = "https://eu-api.backendless.com";
const String APPLICATION_ID = "A5B771C1-B135-1146-FFC2-204701E95500";
const String ANDROID_API_KEY = "0CCFCDB3-0974-43B5-BD23-61FA6745C4A3";
const String IOS_API_KEY = "140898C0-D6DC-459E-A62E-20FF3A644653";
const String JS_API_KEY = "D4EF9175-2546-4B17-9038-14A77F5186F5";

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

String namas = "";
String ids = "";
List<Map> listnote = List<Map>.empty(growable: true);

List _items = [];

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
      }
      DataQueryBuilder searchnotes = DataQueryBuilder()
        ..whereClause = "ownerId = '$currentUserObjectId'"
        ..sortBy = ["created DESC"];
      // ..related = ["start_alkitab", "end_alkitab"]
      // ..relationsDepth = 1;

      // ignore: unused_local_variable
      Future<List<Map?>?> inititem = Backendless.data
          .of('Catatan_Sate')
          .find(searchnotes)
          .then((foundnotes) {
        listnote.clear();
        listnote.addAll(foundnotes!.cast<Map>());
        notesstatus = true;
        // print("Notes found for user: " + listnote.toString());
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
      ),
      AlarmScreen(),
      null,
      LeadersPage(
        leaderStatus: leadstatus,
      ),
      AlarmScreen(),
    ];
    return Scaffold(
      body: RefreshIndicator(
          onRefresh: loadnotes,
          child: Container(child: screens[_selectedIndex])),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => NewNotesinitPage(
                        leaderstatus: leadstatus,
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
  final bool statusnotesload;
  const ContentMain({
    Key? key,
    required this.id,
    required this.name,
    required this.notes,
    required this.statusnotesload,
  }) : super(key: key);

  @override
  State<ContentMain> createState() => _ContentMainState();
}

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
                    child: widget.name == ""
                        ? Center(
                            child: SizedBox(
                              width: 30,
                              height: 30,
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : Text(
                            'Good Day, ' + widget.name + '!',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 28,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                  ),
                  Container(
                    //lang switcher
                    padding: EdgeInsets.only(
                      top: 5.0,
                    ),
                    child: SwitchExample(),
                  ),
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
                      onPressed: () {},
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
            "-" +
            _items[akhir]["ayat"].toString());
      } else {
        return Text(_items[awal]["kitab_singkat"] +
            " " +
            _items[awal]["pasal"].toString() +
            ":" +
            _items[awal]["ayat"].toString() +
            "-" +
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
          "-" +
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
              child: ListTile(
                leading: Icon(
                  Icons.description,
                ),
                title: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(widget.notes![index]['judul_catatan']),
                ),
                subtitle: readrangechecker(widget.notes![index]['idstartkitab'],
                    widget.notes![index]['idendkitab']),
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
                                idrecommend: widget.notes![index],
                                datenote: formattedDate,
                                leaderstatus: leadstatus,
                              )),
                    ).then((value) {
                      setState(() {});
                    });
                  });
                },
              ),
            );
          },
        );
      }
    }
  }
}
