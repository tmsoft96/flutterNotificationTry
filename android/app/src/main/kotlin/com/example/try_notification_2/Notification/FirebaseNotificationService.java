package com.example.try_notification_2.Notification;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Intent;
import android.media.RingtoneManager;
import android.net.Uri;
import android.os.Build;
import android.util.Log;

import androidx.annotation.RequiresApi;
import androidx.core.app.NotificationCompat;

import com.example.try_notification_2.MainActivity;
import com.example.try_notification_2.R;
import com.google.firebase.messaging.FirebaseMessagingService;
import com.google.firebase.messaging.RemoteMessage;

import org.jetbrains.annotations.NotNull;

public class FirebaseNotificationService extends FirebaseMessagingService {
    public FirebaseNotificationService() {
    }

    @RequiresApi(api = Build.VERSION_CODES.M)
    @Override
    public void onMessageReceived(@NotNull RemoteMessage remoteMessage) {
        super.onMessageReceived(remoteMessage);

        String notificationTitle = remoteMessage.getNotification().getTitle();
        String notificationBody = remoteMessage.getNotification().getBody();
        Log.d("notification___________", notificationBody);

        //setting the notification sound
        Uri defaultSound = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_RINGTONE);

        Intent tryIntent = new Intent(this, MainActivity.class);
        tryIntent.setAction(Intent.ACTION_ANSWER);
        PendingIntent pendingIntent = PendingIntent.getBroadcast(this, 0, tryIntent, 0);

        NotificationCompat.Builder mBuilder = new NotificationCompat.Builder(this)
                .setSmallIcon(R.drawable.app_icon)
                .setContentTitle(notificationTitle)
                .setContentText(notificationBody)
                .setDefaults(Notification.DEFAULT_SOUND|Notification.DEFAULT_LIGHTS|Notification.DEFAULT_VIBRATE)
                .addAction(R.drawable.app_icon, "Click me", pendingIntent)
//                .setSound(defaultSound)
                .setChannelId("notification")

                .setAutoCancel(true);


        //Sending the user to the activity they click
//        Intent intent = new Intent(this, PublicNotificationActivity.class);

//        PendingIntent pendingIntent = PendingIntent.getActivity(
//                this,
//                0,
//                intent,
//                PendingIntent.FLAG_UPDATE_CURRENT
//        );

//        mBuilder.setContentIntent(pendingIntent);


        //Creating a random unique notification id & Setting Notification ID
        int mNotificationId = (int) System.currentTimeMillis();
        //Get an instance of the notification service
        NotificationManager  notificationManager = getSystemService(NotificationManager.class);
        // Since android Oreo notification channel is needed.
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
//            String channelId = getString(R.string.default_notification_channel_id);
//            int importance = NotificationManager.IMPORTANCE_HIGH;
//            NotificationChannel channel = new NotificationChannel(channelId,  "Channel human readable title", importance);
//            channel.setSound(defaultSound, null);
//
////            channel.setDescription(description);
//            // Register the channel with the system; you can't change the importance
//            // or other notification behaviors after this
//            notificationManager.createNotificationChannel(channel);
//        }
        notificationManager.notify(mNotificationId, mBuilder.build());
    }
}