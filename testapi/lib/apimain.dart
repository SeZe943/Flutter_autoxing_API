import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
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
  String? _gelencevap;

  Future<void> _incrementCounter() async{
  String adres ="http://10.3.0.92:8090/chassis/moves";
  Response cevap = await http.get(Uri.parse(adres));
//en üst {} bununla başlıyorsa maptir
// [] bununla başlıyorsa list tir.
  if (cevap.statusCode ==200) {
    List gelenJson = jsonDecode(cevap.body);
    _gelencevap = gelenJson[1]["state"].toString();
  }
  else
    _gelencevap = "baglantida sorun olustu";

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
           backgroundColor: Theme.of(context).colorScheme.inversePrimary,
       title: Text(widget.title),
      ),
      body:ListView(
       children: <Widget>[
         const Text(
           'gelen cevap:',
         ),
         Text(
           '$_gelencevap',
          style: Theme.of(context).textTheme.headlineMedium,

         ),
       ],
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), 
    );
  }
}
