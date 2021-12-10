package com.example.upwork_android_watch;

import android.content.ContextWrapper;
import android.content.Intent;
import android.content.IntentFilter;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.os.BatteryManager;
import android.os.Build.VERSION;
import android.os.Build.VERSION_CODES;
import android.os.Bundle;
import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity
  extends FlutterActivity
  implements SensorEventListener {

  private static final String CHANNEL = "samples.flutter.dev/heartRate";

  // Heart rate
  private SensorManager sensorManager2;
  public static float mems_data[] = new float[] { 0, 0, 0, 0, 0 };
  private int heartRate;
  Sensor sensor2;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    sensorManager2 = (SensorManager) this.getSystemService(SENSOR_SERVICE);
    sensor2 = sensorManager2.getDefaultSensor(Sensor.TYPE_HEART_RATE);
    sensorManager2.registerListener(
      this,
      sensor2,
      SensorManager.SENSOR_DELAY_GAME
    );
  }

  @Override
  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
    super.configureFlutterEngine(flutterEngine);
    new MethodChannel(
      flutterEngine.getDartExecutor().getBinaryMessenger(),
      CHANNEL
    )
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

  @Override
  protected void onDestroy() {
    super.onDestroy();
    unRegisterSensor();
  }

  @Override
  protected void onResume() {
    // TODO Auto-generated method stub
    super.onResume();
    sensorManager2.registerListener(
      this,
      sensor2,
      SensorManager.SENSOR_DELAY_GAME
    );
  }

  @Override
  protected void onStop() {
    // TODO Auto-generated method stub
    super.onStop();
    unRegisterSensor();
  }

  protected void unRegisterSensor() {
    if (sensorManager2 != null) {
      sensorManager2.unregisterListener(this);
    }
  }

  private int getHeartRate() {
    return heartRate;
  }

  @Override
  public void onSensorChanged(SensorEvent event) {
    switch (event.sensor.getType()) {
      case Sensor.TYPE_HEART_RATE:
        mems_data[0] = event.values[0];
        heartRate = (int) mems_data[0];
    }
  }

  @Override
  public void onAccuracyChanged(Sensor sensor, int accuracy) {}
}
