# flutter foreground service

Flutter背景服務(for Android) --關掉app依然會繼續跑在背景！！--

使用套件：[foreground_service](https://pub.dev/packages/foreground_service/versions/2.0.1)

## Step 1 設定 Android權限：

添加權限及service至AndroidManifest.xml

    <manifest ...
        <uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
        <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED" />
        <application ...
            <receiver android:name=".Receiver">
               <intent-filter>
                   <action android:name="android.intent.action.BOOT_COMPLETED" />
                   <category android:name="android.intent.category.HOME" />
    
               </intent-filter>
           </receiver>
        </application>
    </manifest>

## Step 2 添加 Android 原生碼：

在 android/app/src/main/kotlin/com/example/flutter_foregroundservice 建立 BroadcastReceiver.kt ＆ service.kt

BroadcastReceiver.kt

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

service.kt

    import android.app.Service
    import android.content.Intent
    import android.os.IBinder
    
    class bootservice: Service() {
        override fun onBind(intent: Intent?): IBinder? {
            return null
        }
    }

## Step 3 加入 service notify 圖片：

**重要:添加 android/app/src/main/res/drawable-mdpi/org_thebus_foregroundserviceplugin_notificationicon.png 圖片，否則會報錯

## Step 4 添加庫至 pubspec.yaml ：

pubspec.yaml

    foreground_service: ^2.0.1+1

## Step 5 dart 程式碼 ：
    
開始 foreground service

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

foreground service 要執行的function

    void foregroundServiceFunction() {
        debugPrint("The current time is: ${DateTime.now()}");
        
        //notification message
        ForegroundService.notification.setText("The time was: ${DateTime.now()}");
        
        //isolate message
        ForegroundService.sendToPort("message from background isolate");
    }

關閉 foreground service

    await ForegroundService.stopForegroundService();
    