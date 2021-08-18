package com.example.flutter_foregroundservice

import io.flutter.embedding.android.FlutterActivity
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

class Receiver:BroadcastReceiver() {
    override fun onReceive(context: Context?, intent: Intent?) {
        if(intent?.action.equals(Intent.ACTION_BOOT_COMPLETED)){
            val serviceIntent = Intent(context,bootservice::class.java)
            context?.startService(serviceIntent)
        }
        val activityIntent = Intent(context,MainActivity::class.java)
        activityIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        context?.startActivity(activityIntent)
    }
}