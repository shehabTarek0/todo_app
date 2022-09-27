import 'package:flutter/material.dart';
import 'package:todo_app/shared/components/components.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  var formKey = GlobalKey<FormState>();
  var email = TextEditingController();
  var pass = TextEditingController();
  bool isPass = false;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'You have pushed the button this many times:',
                ),
                Text(
                  '$_counter',
                  style: Theme.of(context).textTheme.headline4,
                ),
                defaultTextFormField(
                  controller: email,
                  inputType: TextInputType.emailAddress,
                  text: 'email',
                  validator: (value) {
                    if (value.toString().isEmpty) {
                      return 'error';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                defaultTextFormField(
                  controller: pass,
                  isPassword: isPass,
                  suffix: isPass
                      ? const Icon(Icons.visibility)
                      : const Icon(Icons.visibility_off),
                  onPressedSuffix: () {
                    setState(() {
                      isPass = !isPass;
                    });
                  },
                  inputType: TextInputType.visiblePassword,
                  text: 'password',
                  validator: (value) {
                    if (value.toString().isEmpty) {
                      return 'error';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                defaultButton(
                  text: 'login',
                  onPress: (() {
                    if (formKey.currentState!.validate()) {
                      print(email.text);
                    }
                  }),
                  width: 200,
                  backgroundColor: Colors.black,
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
