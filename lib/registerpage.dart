import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'loginpage.dart';
import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  var rememberValue = false;
  late final TextEditingController emailController = TextEditingController();
  late final TextEditingController usernameController = TextEditingController();
  late final TextEditingController passwordController = TextEditingController();
  late final TextEditingController confimationController =
      TextEditingController();
  String? onerror;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: SizedBox(
          height: 0.85.sh,
          width: 1.sw,
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  height: 60,
                ),
                Text(
                  'Silahkan Mendaftar',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 36.sm,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
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
                            TextFormField(
                              controller: emailController,
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
                            TextFormField(
                              controller: usernameController,
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
                            PasswordInput(
                                hintText: "Masukan Kata Sandi",
                                textEditingController: passwordController,
                                onerror: onerror),
                            const SizedBox(
                              height: 5,
                            ),
                            PasswordInput(
                                hintText: "Konfirmasi Kata Sandi",
                                textEditingController: confimationController,
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
                            BackendlessUser newuser = BackendlessUser()
                              ..email = emailController.text
                              ..password = passwordController.text;
                            Backendless.userService
                                .register(newuser)
                                .then((reguser) {
                              reguser!
                                  .setProperty("name", usernameController.text);
                              Backendless.userService
                                  .update(reguser)
                                  .then((user) {});
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      "Email Konfirmasi telah kami kirimkan ke alamat Email anda. Silahkan Konfirmasi terlebih dahulu melalui Email!"),
                                  action: SnackBarAction(
                                    label: 'OK',
                                    onPressed: () =>
                                        ScaffoldMessenger.of(context)
                                            .hideCurrentSnackBar(),
                                  ),
                                ),
                              );
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const LoginPage(title: 'Login UI'),
                                ),
                              );
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
                          'Daftar',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Sudah Mempunyai Akun? '),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const LoginPage(title: 'Login UI'),
                                ),
                              );
                            },
                            child: const Text('Masuk Disini'),
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ),
      ),
    );
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
          return 'Password Tidak boleh Kosong';
        }
        return null;
      },
    );
  }
}
