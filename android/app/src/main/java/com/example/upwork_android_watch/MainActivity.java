package com.example.upwork_android_watch;

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import android.content.ContextWrapper;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.BatteryManager;
import android.os.Build.VERSION;
import android.os.Build.VERSION_CODES;
import android.os.Bundle;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;


public class MainActivity extends FlutterActivity {
  private static final String CHANNEL = "samples.flutter.dev/heartRate";

  // Heart rate
  private SensorManager sensorManager2;
  public static float mems_data[] = new float[]{0, 0, 0, 0, 0};
  private int heartRate;
  Sensor sensor2;

  @Override
  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
  super.configureFlutterEngine(flutterEngine);
    new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
        .setMethodCallHandler(
          (call, result) -> {
            // Note: this method is invoked on the main thread.
            if (call.method.equals("getHeartRate")) {
              int heartRateLevel = getHeartRate();

              if (heartRateLevel != -1) {
                result.success(heartRateLevel);
              } else {
                result.error("UNAVAILABLE", "Battery level not available.", null);
              }
            } else {
              result.notImplemented();
            }
          }

        );
  }

  private int getHeartRate() {
    int heartRateLevel = 10;
    // if (VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
    //   BatteryManager batteryManager = (BatteryManager) getSystemService(BATTERY_SERVICE);
    //   heartRateLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY);
    // } else {
    //   Intent intent = new ContextWrapper(getApplicationContext()).
    //       registerReceiver(null, new IntentFilter(Intent.ACTION_BATTERY_CHANGED));
    //   heartRateLevel = (intent.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100) /
    //       intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1);
    // }


    return heartRateLevel;
  }

}
