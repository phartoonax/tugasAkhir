import 'package:MannaGo/main_screen.dart';
import 'package:MannaGo/profilescreen.dart';
import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:textfield_tags/textfield_tags.dart';

class AddRecommendationScreen extends StatefulWidget {
  const AddRecommendationScreen({super.key});

  @override
  State<AddRecommendationScreen> createState() =>
      _AddRecommendationScreenState();
}

bool loadstatus = false;

class _AddRecommendationScreenState extends State<AddRecommendationScreen> {
  final _formKey = GlobalKey<FormState>();
  List<DropdownMenuItem> tipe = [
    DropdownMenuItem(child: Text("Renungan"), value: 1),
    DropdownMenuItem(child: Text("Lagu"), value: 2)
  ];
  List<String> testing = ["Ren", "Lag"];
  List<Map> tagsgenre = List.empty(growable: true);
  List<bool> checker = List.empty(growable: true);
  int? dropdownind = 1;
  String dropdown = "";
  TextEditingController judulcont = TextEditingController();
  TextEditingController koleksi = TextEditingController();
  TextEditingController artis = TextEditingController();
  TextEditingController url = TextEditingController();

  @override
  initState() {
    super.initState();
    loadsets();
  }

  void loadsets() async {
    Backendless.data.of("Rekomendasi_Genre").find().then((value) {
      value!.forEach((element) {
        tagsgenre.add(element!);
        checker.add(false);
      });
    });
    setState(() {
      loadstatus = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tambah Saran Rekomendasi"),
        leading: BackButton(),
      ),
      body: loadstatus
          ? SingleChildScrollView(
              child: SizedBox(
                height: 0.88.sh,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Container(
                          child: DropdownButtonFormField(
                            value: dropdownind,
                            items: tipe,
                            decoration:
                                InputDecoration(labelText: "Jenis Rekomendasi"),
                            hint: Text("Jenis Rekomendasi"),
                            onChanged: (value) {
                              setState(() {
                                dropdownind = value;
                              });
                            },
                          ),
                        ),
                        (dropdownind == 1)
                            ? Container(
                                child: TextFormField(
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return 'Semua input tidak boleh kosong';
                                    }
                                    return null;
                                  },
                                  controller: judulcont,
                                  decoration: InputDecoration(
                                      labelText: "Judul Renungan"),
                                ),
                              )
                            : Container(
                                child: TextFormField(
                                controller: judulcont,
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return 'Semua input tidak boleh kosong';
                                  }
                                  return null;
                                },
                                decoration:
                                    InputDecoration(labelText: "Judul Lagu"),
                              )),
                        (dropdownind == 1)
                            ? Container(
                                child: TextFormField(
                                controller: koleksi,
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return 'Semua input tidak boleh kosong';
                                  }
                                  return null;
                                },
                                decoration:
                                    InputDecoration(labelText: "Nama Koleksi"),
                              ))
                            : Container(
                                child: TextFormField(
                                controller: koleksi,
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return 'Semua input tidak boleh kosong';
                                  }
                                  return null;
                                },
                                decoration:
                                    InputDecoration(labelText: "Nama Album"),
                              )),
                        (dropdownind == 1)
                            ? Container(
                                child: TextFormField(
                                controller: artis,
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return 'Semua input tidak boleh kosong';
                                  }
                                  return null;
                                },
                                decoration:
                                    InputDecoration(labelText: "Penerbit"),
                              ))
                            : Container(
                                child: TextFormField(
                                controller: artis,
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return 'Semua input tidak boleh kosong';
                                  }
                                  return null;
                                },
                                decoration:
                                    InputDecoration(labelText: "Artist"),
                              )),
                        Container(
                            child: TextFormField(
                          controller: url,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Semua input tidak boleh kosong';
                            }
                            return null;
                          },
                          decoration: InputDecoration(labelText: "Link"),
                        )),
                        Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(left: 15, top: 20),
                            child: Text(
                              "Genre",
                              style: TextStyle(fontSize: 18),
                            )),
                        Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              border: Border.all(width: 1),
                              borderRadius: BorderRadius.circular(10)),
                          margin: EdgeInsets.symmetric(vertical: 5),
                          height: 155.h,
                          child: ListView.builder(
                            itemCount: tagsgenre.length,
                            itemBuilder: (context, index) {
                              return CheckboxListTile(
                                  value: checker[index],
                                  title: Text(tagsgenre[index]["judul_genre"]),
                                  onChanged: (value) => setState(() {
                                        checker[index] = value!;
                                      }));
                            },
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(20),
                          child: Center(
                            child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    Map tobesaved = {
                                      "judul": judulcont.text,
                                      "artis_or_penerbit": artis.text,
                                      "koleksi_or_album": koleksi.text,
                                      "link": url.text,
                                    };
                                    List<String> idgenre =
                                        List.empty(growable: true);
                                    for (int i = 0; i < checker.length; i++) {
                                      if (checker[i] == true) {
                                        idgenre.add(tagsgenre[i]["objectId"]);
                                      }
                                    }
                                    Backendless.data
                                        .of("Recomendation_Inputs")
                                        .save(tobesaved)
                                        .then((simpan) {
                                      Backendless.data
                                          .of("Recomendation_Inputs")
                                          .addRelation(
                                              simpan!['objectId'], "genre",
                                              childrenObjectIds: idgenre)
                                          .then((value) {
                                        final sbarnoticeabsen = SnackBar(
                                          duration: Duration(seconds: 5),
                                          content: Text(
                                              "Sugesti rekomendasi telah ditambahkan. Terima Kasih!"),
                                          action: SnackBarAction(
                                            label: 'OK',
                                            onPressed: () =>
                                                ScaffoldMessenger.of(context)
                                                    .hideCurrentSnackBar(),
                                          ),
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(sbarnoticeabsen);
                                      });
                                    });
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) => MainScreen()),
                                        (Route<dynamic> route) => false);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.fromLTRB(40, 15, 40, 15),
                                ),
                                child: Text(
                                  "Simpan Rekomendasi",
                                  style: TextStyle(
                                      fontSize: 22, color: Colors.white),
                                )),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          : Container(
              height: 0.8.sh,
              child: Center(
                child: Column(children: <Widget>[
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text('Loading Options...'),
                  ),
                ]),
              ),
            ),
    );
  }
}
