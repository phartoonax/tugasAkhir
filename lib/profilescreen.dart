import 'package:MannaGo/loginpage.dart';
import 'package:MannaGo/splash.dart';
import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttericon/modern_pictograms_icons.dart';

import 'main_screen.dart';

class profilePage extends StatefulWidget {
  const profilePage({super.key, required this.userprofile});
  final Map userprofile;
  @override
  State<profilePage> createState() => _profilePageState();
}

class _profilePageState extends State<profilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Container(
            height: 250,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.topRight,
                  padding: EdgeInsets.only(right: 15),
                  child: IconButton(
                      onPressed: () {
                        Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => editProfile(
                                        userprofile: widget.userprofile)))
                            .then((value) {
                          setState(() {});
                        });
                      },
                      icon: Icon(ModernPictograms.edit)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: Colors.white70,
                      minRadius: 60.0,
                      child: CircleAvatar(
                        radius: 50.0,
                        child: Icon(
                          (widget.userprofile['sex'] == "M")
                              ? ModernPictograms.user
                              : ModernPictograms.user_woman,
                          size: 50.sm,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text(
                    'Nama',
                    style: TextStyle(
                      color: Colors.deepOrange,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    widget.userprofile['name'],
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                Divider(),
                ListTile(
                  title: Text(
                    'Email',
                    style: TextStyle(
                      color: Colors.deepOrange,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    widget.userprofile['email'],
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                Divider(),
                ListTile(
                  title: Text(
                    'Jenis Kelamin',
                    style: TextStyle(
                      color: Colors.deepOrange,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    (widget.userprofile['sex'] == "M")
                        ? "Laki-Laki"
                        : "Perempuan",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: ElevatedButton(
                      onPressed: () {
                        Backendless.userService.logout();
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => LoginPage(
                                      title: "login",
                                    )),
                            (Route<dynamic> route) => false);
                      },
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.fromLTRB(40, 15, 40, 15),
                          backgroundColor: Colors.red),
                      child: Text(
                        "Log Out",
                        style: TextStyle(fontSize: 22, color: Colors.white),
                      )),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class editProfile extends StatefulWidget {
  const editProfile({super.key, required this.userprofile});
  final Map userprofile;
  @override
  State<editProfile> createState() => _editProfileState();
}

final _formKey = GlobalKey<FormState>();
String? onerror;
TextEditingController editnama = TextEditingController();
TextEditingController email = TextEditingController();
TextEditingController passwordController = TextEditingController();
List<DropdownMenuItem> kelamin = [
  DropdownMenuItem(child: Text("Laki-Laki"), value: "M"),
  DropdownMenuItem(child: Text("Perempuan"), value: "F")
];
String dropdown = "";

class _editProfileState extends State<editProfile> {
  @override
  Widget build(BuildContext context) {
    dropdown = widget.userprofile["sex"];
    editnama.text = widget.userprofile["name"];
    email.text = widget.userprofile["email"];

    return Scaffold(
        body: SingleChildScrollView(
      child: SizedBox(
        height: 0.85.sh,
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 80.h,
              ),
              Container(
                padding: EdgeInsets.only(bottom: 20),
                child: Text("Edit Profile",
                    style: Theme.of(context).textTheme.headlineLarge),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Form(
                    child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                              width: 0.1,
                            ),
                            borderRadius: BorderRadius.circular(8)),
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 8.0),
                        child: Column(
                          children: [
                            Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.symmetric(horizontal: 15.w),
                                child: Text("Nama", textAlign: TextAlign.left)),
                            TextFormField(
                              controller: editnama,
                              maxLines: 1,
                              decoration: InputDecoration(
                                hintText:
                                    'Masukan Nama Pengguna yang dinginkan',
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.symmetric(horizontal: 15.w),
                                child:
                                    Text("Email", textAlign: TextAlign.left)),
                            TextFormField(
                              controller: email,
                              enabled: false,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "email tidak bisa kosong";
                                } else {
                                  value = value.trim();
                                  return EmailValidator.validate(value)
                                      ? null
                                      : "tolong berikan email yang benar";
                                }
                              },
                              maxLines: 1,
                              decoration: InputDecoration(
                                hintText: 'Masukan Email',
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                fillColor: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.symmetric(horizontal: 15.w),
                                child: Text("Jenis Kelamin",
                                    textAlign: TextAlign.left)),
                            DropdownButtonFormField(
                                items: kelamin,
                                value: dropdown,
                                onChanged: (value) {
                                  dropdown = value.toString();
                                }),
                            SizedBox(
                              height: 15,
                            ),
                            Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.symmetric(horizontal: 15.w),
                                child: Text(
                                    "Untuk Memperbaharui data, Mohon masukan Password",
                                    textAlign: TextAlign.left)),
                            PasswordInput(
                                hintText: "Masukan password anda",
                                textEditingController: passwordController,
                                onerror: onerror),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          FocusManager.instance.primaryFocus?.unfocus();

                          if (_formKey.currentState!.validate()) {
                            BackendlessUser updateuser;

                            Backendless.userService
                                .login(email.text, passwordController.text)
                                .then((value) {
                              updateuser = value!;
                              Backendless.userService
                                  .getCurrentUser()
                                  .then((value) {
                                final sbarnoticeabsen = SnackBar(
                                  duration: Duration(seconds: 5),
                                  content: Text(
                                      "Sedang Menyimpan Profil... Mohon Tunggu"),
                                  action: SnackBarAction(
                                    label: 'OK',
                                    onPressed: () =>
                                        ScaffoldMessenger.of(context)
                                            .hideCurrentSnackBar(),
                                  ),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(sbarnoticeabsen);
                                updateuser.setProperty("name", editnama.text);
                                updateuser.setProperty("sex", dropdown);
                                Backendless.userService
                                    .update(updateuser)
                                    .then((reguser) {
                                  Backendless.userService.login(
                                      email.text, passwordController.text);
                                  Map saveduser = {
                                    "name": reguser?.getProperty("name"),
                                    "email": reguser?.getProperty("email"),
                                    "sex": reguser?.getProperty("sex")
                                  };
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) => LoginPage(
                                                title: "login",
                                              )),
                                      (Route<dynamic> route) => false);
                                }).catchError((onError, stackTrace) {
                                  print(
                                      "There has been an error outside: $onError");
                                  PlatformException platformException = onError;
                                  print("Server reported an error outside.");
                                  print(
                                      "Exception code: ${platformException.code}");
                                  print(
                                      "Exception details: ${platformException.details}");
                                  print("Stacktrace: $stackTrace");
                                  onerror = "Mohon Cek kembali data anda";
                                  final sbarnoticeabsen = SnackBar(
                                    duration: Duration(seconds: 10),
                                    content: Text(
                                        "telah terjadi sebuah error. ${platformException.details}"),
                                    action: SnackBarAction(
                                      label: 'OK',
                                      onPressed: () =>
                                          ScaffoldMessenger.of(context)
                                              .hideCurrentSnackBar(),
                                    ),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(sbarnoticeabsen);
                                }, test: (e) => e is PlatformException);
                              });
                            }).catchError((onError, stackTrace) {
                              print(
                                  "There has been an error outside: $onError");
                              PlatformException platformException = onError;
                              print("Server reported an error outside.");
                              print(
                                  "Exception code: ${platformException.code}");
                              print(
                                  "Exception details: ${platformException.details}");
                              print("Stacktrace: $stackTrace");
                              onerror = "Mohon Cek kembali data anda";
                              final sbarnoticeabsen = SnackBar(
                                duration: Duration(seconds: 10),
                                content: Text(
                                    "telah terjadi sebuah error. ${platformException.details}"),
                                action: SnackBarAction(
                                  label: 'OK',
                                  onPressed: () => ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar(),
                                ),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(sbarnoticeabsen);
                            }, test: (e) => e is PlatformException);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.fromLTRB(40, 15, 40, 15),
                        ),
                        child: const Text(
                          'Simpan Profile',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: Center(
                          child: TextButton(
                            onPressed: () => showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text('Apakah Anda Yakin?'),
                                content: const Text(
                                    'Mengganti Password anda akan mengeluarkan anda dari aplikasi, dan email untuk mengganti password anda akan dikirimkan ke email yang telah terdaftar dalam aplikasi ini. Apakah anda ingin melanjutkan mengganti Password?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'Tidak'),
                                    child: const Text('Tidak'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Backendless.userService.logout();
                                      Backendless.userService
                                          .restorePassword(email.text)
                                          .then((value) {
                                        {
                                          final sbarnoticeabsen = SnackBar(
                                            duration: Duration(seconds: 5),
                                            content: const Text(
                                                "Silahkan cek email anda untuk mengubah password anda!"),
                                            action: SnackBarAction(
                                              label: 'OK',
                                              onPressed: () =>
                                                  ScaffoldMessenger.of(context)
                                                      .hideCurrentSnackBar(),
                                            ),
                                          );
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(sbarnoticeabsen);
                                          Navigator.of(context)
                                              .pushAndRemoveUntil(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          LoginPage(
                                                            title: "login",
                                                          )),
                                                  (Route<dynamic> route) =>
                                                      false);
                                        }
                                      });
                                    },
                                    child: const Text('Ya'),
                                  ),
                                ],
                              ),
                            ),
                            child: const Text('Ganti Password'),
                          ),
                        ),
                      )
                    ],
                  ),
                )),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}

class PasswordInput extends StatefulWidget {
  final String hintText;
  final TextEditingController textEditingController;
  final String? onerror;

  const PasswordInput(
      {required this.textEditingController,
      required this.hintText,
      Key? key,
      this.onerror})
      : super(key: key);

  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool pwdVisibility = false;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.textEditingController,
      obscureText: !pwdVisibility,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.lock),
        hintText: widget.hintText,
        errorText: widget.onerror,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        suffixIcon: InkWell(
          onTap: () => setState(
            () => pwdVisibility = !pwdVisibility,
          ),
          child: Icon(
            pwdVisibility
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: Colors.grey.shade400,
            size: 18,
          ),
        ),
      ),
      validator: (val) {
        if (val!.isEmpty) {
          return 'password tidak boleh kosong';
        }
        return null;
      },
    );
  }
}
