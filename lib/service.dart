import 'package:flutter/material.dart';
import 'package:foreground_service/foreground_service.dart';

void startService() async {
  // service is live?
  if (!(await ForegroundService.foregroundServiceIsStarted())) {

    // foreground service time period seconds
    await ForegroundService.setServiceIntervalSeconds(1);

    // foreground service notification setting
    await ForegroundService.notification.startEditMode();
    ForegroundService.notification
        .setTitle("service執行中");
    await ForegroundService.notification.finishEditMode();

    // foreground service run function
    await ForegroundService.startForegroundService(foregroundServiceFunction);
    await ForegroundService.getWakeLock();
  }

  if (!ForegroundService.isIsolateCommunicationSetup) {
    //open app , receive message
    await ForegroundService.setupIsolateCommunication((data) {
      debugPrint("Isolate main received: $data");
    });
  }
}

void foregroundServiceFunction() {
  debugPrint("The current time is: ${DateTime.now()}");

  //notification message
  ForegroundService.notification.setText("The time was: ${DateTime.now()}");

  //isolate message
  ForegroundService.sendToPort("message from background isolate");
}