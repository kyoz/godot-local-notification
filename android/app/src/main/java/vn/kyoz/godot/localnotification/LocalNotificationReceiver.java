// Migrate from https://github.com/DrMoriarty/godot-local-notification

package vn.kyoz.godot.localnotification;

import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.NotificationChannel;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;

import androidx.core.app.NotificationCompat;

import android.util.Log;
import android.media.RingtoneManager;

public class LocalNotificationReceiver extends BroadcastReceiver {
    private static final String TAG = "GodotLNReceiver";
    public static final String NOTIFICATION_CHANNEL_ID = "10001";

    @Override
    public void onReceive(Context context, Intent intent) {
        String title = intent.getStringExtra("title");
        String message = intent.getStringExtra("message");
        int notificationId = intent.getIntExtra("notification_id", 0);

        Log.i(TAG, "Received notification: " + message);

        NotificationManager manager = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);

        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
            int importance = NotificationManager.IMPORTANCE_HIGH;
            NotificationChannel notificationChannel = new NotificationChannel(NOTIFICATION_CHANNEL_ID, "GODOT_LOCAL_NOTIFICATION", importance);
            notificationChannel.setShowBadge(true);
            manager.createNotificationChannel(notificationChannel);
        }

        Class appClass = null;

        try {
            appClass = Class.forName("com.godot.game.GodotApp");
        } catch (ClassNotFoundException e) {
            Log.e(TAG, e.getMessage());
            return;
        }

        Intent intent2 = new Intent(context, appClass);
        intent2.setFlags(Intent.FLAG_ACTIVITY_REORDER_TO_FRONT | Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
        PendingIntent pendingIntent = PendingIntent.getActivity(context, 0, intent2, PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE);


        NotificationCompat.Builder builder = new NotificationCompat.Builder(context, NOTIFICATION_CHANNEL_ID);

        int iconID = context.getResources().getIdentifier("icon", "mipmap", context.getPackageName());
        int notificationIconID = context.getResources().getIdentifier("notification_icon", "mipmap", context.getPackageName());
        Bitmap largeIcon = BitmapFactory.decodeResource(context.getResources(), iconID);

        if (notificationIconID <= 0)
            builder.setSmallIcon(iconID);
        else
            builder.setSmallIcon(notificationIconID);
        builder.setLargeIcon(largeIcon);
        builder.setBadgeIconType(NotificationCompat.BADGE_ICON_LARGE);

        int colorID = context.getResources()
                .getIdentifier("notification_color", "color", context.getPackageName());

        if (colorID <= 0)
            builder.setColor(Color.BLACK);
        else
            builder.setColor(context.getResources().getColor(colorID));

        builder.setShowWhen(false);
        builder.setContentTitle(title);
        builder.setContentText(message);

        builder.setTicker(message);
        builder.setAutoCancel(true);
        builder.setDefaults(Notification.DEFAULT_ALL);
        builder.setColorized(true);

        builder.setContentIntent(pendingIntent);
        builder.setNumber(1);
        builder.setSound(RingtoneManager.getDefaultUri(RingtoneManager.TYPE_RINGTONE));
        builder.setPriority(NotificationCompat.PRIORITY_HIGH);

        Notification notification = builder.build();
        notification.sound = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_RINGTONE);

        manager.notify(notificationId, notification);
    }
}