package com.example.try_notification_2;

import android.app.ActionBar;
import android.app.NotificationManager;
import android.content.Context;
import android.media.Ringtone;
import android.media.RingtoneManager;
import android.net.Uri;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

import android.os.Bundle;
import android.view.WindowManager.LayoutParams;
import io.flutter.plugins.GeneratedPluginRegistrant;

import static androidx.core.app.ServiceCompat.stopForeground;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "samples.flutter.dev/ringtone";
    private int NOTIFICATION = 546;
    private NotificationManager notificationManager;

    @Override
    protected void onStart() {
        super.onStart();

    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        getWindow().addFlags(LayoutParams.FLAG_SECURE);
//        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL).setMethodCallHandler(
//                (call, result) -> {
//                    result.success(getRingtone());
//                }
//        );
    }

//    private String getRingtone(){
//        Uri uri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_RINGTONE);
//        return uri.getPath();
//    }
}
