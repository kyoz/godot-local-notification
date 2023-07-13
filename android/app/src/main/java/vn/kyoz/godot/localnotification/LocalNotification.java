package vn.kyoz.godot.localnotification;

import android.Manifest;
import android.app.Activity;
import android.app.AlarmManager;
import android.app.PendingIntent;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Build;
import android.provider.Settings;
import android.util.Log;
import android.view.View;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.collection.ArraySet;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import org.godotengine.godot.Godot;
import org.godotengine.godot.plugin.GodotPlugin;
import org.godotengine.godot.plugin.SignalInfo;
import org.godotengine.godot.plugin.UsedByGodot;

import java.util.Calendar;
import java.util.Set;

public class LocalNotification extends GodotPlugin {
    private static final String TAG = "GodotLocalNotification";
    private static final int REQUEST_CODE = 6969;
    private static Activity activity;

    public LocalNotification(Godot godot) {
        super(godot);
    }

    @NonNull
    @Override
    public String getPluginName() {
        return getClass().getSimpleName();
    }

    @Nullable
    @Override
    public View onMainCreate(Activity pActivity) {
        activity = pActivity;
        return super.onMainCreate(activity);
    }

    @Override
    public void onMainRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        super.onMainRequestPermissionsResult(requestCode, permissions, grantResults);

        if (requestCode == REQUEST_CODE) {
            for (int i = 0; i < permissions.length; i++) {
                String permission = permissions[i];

                if (permission.equals(Manifest.permission.POST_NOTIFICATIONS)) {
                    emitSignal("permission_request_completed");
                    break;
                }
            }
        }
    }

    @NonNull
    @Override
    public Set<SignalInfo> getPluginSignals() {
        Set<SignalInfo> signals = new ArraySet<>();

        signals.add(new SignalInfo("error", String.class));
        signals.add(new SignalInfo("permission_request_completed"));

        return signals;
    }

    @Override
    public void onMainActivityResult(int requestCode, int resultCode, Intent data) {
        super.onMainActivityResult(requestCode, resultCode, data);
        Log.d(TAG, String.valueOf(requestCode));
    }

    @UsedByGodot
    public boolean isPermissionGranted() {
        Log.d(TAG, "isPermissionGranted()");

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            return ContextCompat.checkSelfPermission(activity.getApplicationContext(),
                    Manifest.permission.POST_NOTIFICATIONS) == PackageManager.PERMISSION_GRANTED;
        } else {
            return true;
        }
    }


    @UsedByGodot
    public void requestPermission() {
        Log.d(TAG, "requestPermission()");

        if (isPermissionGranted()) {
            emitSignal("permission_request_completed");
            return;
        }

        ActivityCompat.requestPermissions(activity, new String[]{Manifest.permission.POST_NOTIFICATIONS}, REQUEST_CODE);
    }

    @UsedByGodot
    public void openAppSetting() {
        Log.d(TAG, "openAppSetting()");

        try {
            Intent intent = new Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS);
            Uri uri = Uri.fromParts("package", activity.getPackageName(), null);
            intent.setData(uri);
            activity.startActivity(intent);
        } catch (Error e) {
            Log.e(TAG, e.getMessage());
        }
    }

    @UsedByGodot
    public void show(String title, String message, int interval, int tag) {
        Log.d(TAG, "show(" + title + "," + message + "," + Integer.toString(interval) + "," + Integer.toString(tag) + ")");

        if (interval <= 0) {
            return;
        }

        PendingIntent sender = getPendingIntent(title, message, tag);

        Calendar calendar = Calendar.getInstance();
        calendar.setTimeInMillis(System.currentTimeMillis());
        calendar.add(Calendar.SECOND, interval);

        AlarmManager am = (AlarmManager) activity.getSystemService(getActivity().ALARM_SERVICE);
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.KITKAT) {
            am.set(AlarmManager.RTC_WAKEUP, calendar.getTimeInMillis(), sender);
        } else {
            am.set(AlarmManager.RTC_WAKEUP, calendar.getTimeInMillis(), sender);
        }
    }

    @UsedByGodot
    public void showRepeating(String title, String message, int interval, int repeat_interval, int tag) {
        Log.d(TAG, "showRepeating(" + title + "," + message + "," + Integer.toString(interval) +
                "," + Integer.toString(repeat_interval) + "," + Integer.toString(tag) + ")");

        if (interval <= 0) {
            return;
        }

        PendingIntent sender = getPendingIntent(title, message, tag);

        Calendar calendar = Calendar.getInstance();
        calendar.setTimeInMillis(System.currentTimeMillis());
        calendar.add(Calendar.SECOND, interval);

        AlarmManager am = (AlarmManager) getActivity().getSystemService(getActivity().ALARM_SERVICE);

        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.KITKAT) {
            am.setRepeating(AlarmManager.RTC_WAKEUP, calendar.getTimeInMillis(), repeat_interval * 1000, sender);
        } else {
            am.setInexactRepeating(AlarmManager.RTC_WAKEUP, calendar.getTimeInMillis(), repeat_interval * 1000, sender);
        }
    }

    @UsedByGodot
    public void cancel(int tag) {
        Log.d(TAG, "cancel(" + Integer.toString(tag) + ")");

        AlarmManager am = (AlarmManager) activity.getSystemService(getActivity().ALARM_SERVICE);
        PendingIntent sender = getPendingIntent("", "", tag);
        am.cancel(sender);
    }

    private PendingIntent getPendingIntent(String title, String message, int tag) {
        Intent i = new Intent(activity.getApplicationContext(), LocalNotificationReceiver.class);
        i.putExtra("title", title);
        i.putExtra("message", message);
        i.putExtra("notification_id", tag);
        PendingIntent sender = PendingIntent.getBroadcast(getActivity(), tag, i, PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE);
        return sender;
    }
}
