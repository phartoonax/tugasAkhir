// ignore_for_file: dead_code, unused_local_variable

import 'package:flutter/material.dart';

const List<Text> options = <Text>[
  Text('Notes'),
  Text('Attendence'),
];

var leadscreens = [
  NotesScreen(),
  AttendanceScreen(),
];

class LeadersPage extends StatefulWidget {
  const LeadersPage({Key? key, required this.leaderStatus}) : super(key: key);
  final bool leaderStatus;
  @override
  State<LeadersPage> createState() => _LeadersPageState();
}

class _LeadersPageState extends State<LeadersPage> {
  @override
  Widget build(BuildContext context) {
    int selc = 0;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height - 106,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 10, right: 10, bottom: 20),
                  child: Text(
                    widget.leaderStatus
                        ? 'Here is your Disciples'
                        : 'Your Leader Status: ',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Spacer(),
                widget.leaderStatus
                    ? ToggleTextBtnsFb1(
                        texts: options,
                        selected: (i) {
                          print(i);

                          setState(() {
                            selc = i;
                          });
                        },
                      )
                    : Spacer(),
                leadscreens[selc]
              ],
            ),
          ),
        ),
      ),
    );
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
  const NotesScreen({Key? key}) : super(key: key);

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  @override
  Widget build(BuildContext context) {
    //TODO: FUTURE BUILDER THIS
    return Container(
      //below the button, the actual list
      decoration: BoxDecoration(
          border: Border.all(
            color: Color(0xFFA8775B),
          ),
          borderRadius: BorderRadius.all(Radius.circular(7))),
      height: MediaQuery.of(context).size.height - 160 - 59,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: 7,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Card(
            child: ExpansionTile(
                leading: Icon(
                  Icons.person,
                ),
                title: Text('Jeremy Martin'),
                subtitle: Text('kejadian 1:1'),
                children: <Widget>[
                  ListView.builder(
                      itemCount: 3,
                      padding: EdgeInsets.zero,
                      physics: ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (BuildContext cont, int indx) {
                        return Card(
                          child: ListTile(
                            leading: Icon(Icons.description),
                            title: Text('19 maret 2022'),
                            subtitle: Text('maju tak gentar'),
                            onTap: () {},
                          ),
                        );
                      })
                ]),
          );
        },
      ),
    );
  }
}

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({Key? key}) : super(key: key);

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
