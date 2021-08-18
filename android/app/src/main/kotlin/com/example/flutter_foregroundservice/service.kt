package com.example.flutter_foregroundservice

import io.flutter.embedding.android.FlutterActivity
import android.app.Service
import android.content.Intent
import android.os.IBinder

class bootservice: Service() {
    override fun onBind(intent: Intent?): IBinder? {
        return null
    }
}