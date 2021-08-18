import 'package:flutter/material.dart';
import 'package:foreground_service/foreground_service.dart';
import 'package:flutter_foregroundservice/service.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  String textMessage = "Hello world!!";

  void _touchServiceOnOff() async {
    final fgsIsRunning = await ForegroundService.foregroundServiceIsStarted();
    String appMessage;

    if (fgsIsRunning) {
      //stop service
      await ForegroundService.stopForegroundService();
      appMessage = "Stopped foreground service.";
    } else {
      //start service
      startService();
      appMessage = "Started foreground service.";
    }

    setState(() {
      textMessage = appMessage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(textMessage)
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _touchServiceOnOff,
        tooltip: 'service start/stop',
        child: const Icon(Icons.cached),
      ),
    );
  }
}
