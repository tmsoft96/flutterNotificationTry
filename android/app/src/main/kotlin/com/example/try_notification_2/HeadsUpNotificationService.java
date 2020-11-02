package com.example.try_notification_2;
import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.media.AudioAttributes;
import android.media.AudioManager;
import android.net.Uri;
import android.opengl.Visibility;
import android.os.Build;
import android.os.Bundle;
import android.os.IBinder;

import androidx.annotation.Nullable;
import androidx.core.app.NotificationCompat;

import java.util.Objects;
public class HeadsUpNotificationService extends Service {
    private String CHANNEL_ID = "VoipChannel";
    private String CHANNEL_NAME = "Voip Channel";

    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        Bundle data = null;
        if (intent != null && intent.getExtras() != null) {
            data = intent.getBundleExtra(ConstantApp.FCM_DATA_KEY);
        }
        try {
            Intent receiveCallAction = new Intent(getApplicationContext(), HeadsUpNotificationActionReceiver.class);
            receiveCallAction.putExtra(ConstantApp.CALL_RESPONSE_ACTION_KEY, ConstantApp.CALL_RECEIVE_ACTION);
            receiveCallAction.putExtra(ConstantApp.FCM_DATA_KEY, data);
            receiveCallAction.setAction("RECEIVE_CALL");

            Intent cancelCallAction = new Intent(this, HeadsUpNotificationActionReceiver.class);
            cancelCallAction.putExtra(ConstantApp.CALL_RESPONSE_ACTION_KEY, ConstantApp.CALL_CANCEL_ACTION);
            cancelCallAction.putExtra(ConstantApp.FCM_DATA_KEY, data);
            cancelCallAction.setAction("CANCEL_CALL");

            Intent intent1 = new Intent(this, MainActivity.class);
            intent1.setAction(Intent.ACTION_RUN);
            intent1.putExtra("route", "/secondPage");


            PendingIntent receiveCallPendingIntent = PendingIntent.getActivity(this, 0, intent1, PendingIntent.FLAG_CANCEL_CURRENT);
            PendingIntent cancelCallPendingIntent = PendingIntent.getBroadcast(this, 546, cancelCallAction, PendingIntent.FLAG_UPDATE_CURRENT);

            createChannel();
            NotificationCompat.Builder notificationBuilder = null;
            if (data != null) {

            }

            notificationBuilder = new NotificationCompat.Builder(this, CHANNEL_ID)
//                    .setContentText(data.getString("remoteUserName"))
                    .setContentText("Remote User Name")
                    .setContentTitle("Incoming Voice Call")
                    .setSmallIcon(R.drawable.app_icon)
                    .setPriority(NotificationCompat.PRIORITY_HIGH)
                    .setCategory(NotificationCompat.CATEGORY_CALL)
                    .addAction(R.drawable.ic_add_alert_black_24dp, "Receive Call", receiveCallPendingIntent)
                    .addAction(R.drawable.ic_airline_seat_recline_normal_black_24dp, "Cancel call", cancelCallPendingIntent)
                    .setAutoCancel(true)
                    .setSound(Uri.parse("android.resource://" + getApplicationContext().getPackageName() + "/" + R.raw.test))
                    .setFullScreenIntent(receiveCallPendingIntent, true);

            Notification incomingCallNotification = null;
            if (notificationBuilder != null) {
                incomingCallNotification = notificationBuilder.build();
            }

            startForeground(546, incomingCallNotification);


        } catch (Exception e) {
            e.printStackTrace();
        }

        return START_STICKY;
    }

    /*
Create noticiation channel if OS version is greater than or eqaul to Oreo
*/
    public void createChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationChannel channel = new NotificationChannel(CHANNEL_ID, CHANNEL_NAME, NotificationManager.IMPORTANCE_DEFAULT);
            channel.setDescription("Call Notifications");
            channel.setSound(Uri.parse("android.resource://" + getApplicationContext().getPackageName() + "/" + R.raw.test),
                    new AudioAttributes.Builder().setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                            .setLegacyStreamType(AudioManager.STREAM_RING)
                            .setUsage(AudioAttributes.USAGE_VOICE_COMMUNICATION).build());
            channel.setImportance(NotificationManager.IMPORTANCE_HIGH);
            channel.enableVibration(true);
            Objects.requireNonNull(getApplicationContext().getSystemService(NotificationManager.class)).createNotificationChannel(channel);
        }
    }


}
