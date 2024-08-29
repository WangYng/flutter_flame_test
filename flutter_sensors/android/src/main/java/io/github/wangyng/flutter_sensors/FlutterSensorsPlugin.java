package io.github.wangyng.flutter_sensors;

import android.content.Context;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;

import androidx.annotation.NonNull;

import java.util.HashMap;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;

public class FlutterSensorsPlugin implements FlutterPlugin, FlutterSensorsApi, SensorEventListener {

    private FlutterSensorsEventSink accelerometerEventStream;
    private SensorManager sensorManager;
    private Sensor sensor;
    private static final int samplingPeriod = 200000;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        FlutterSensorsApi.setup(binding, this, binding.getApplicationContext());
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        FlutterSensorsApi.setup(binding, null, null);
    }

    @Override
    public void setAccelerometerEventStream(Context context, FlutterSensorsEventSink accelerometerEventStream) {
        this.accelerometerEventStream = accelerometerEventStream;
    }

    @Override
    public void register(Context context) {
        if (sensorManager == null) {
            sensorManager = (SensorManager) context.getSystemService(Context.SENSOR_SERVICE);
        }

        if (sensor == null) {
            sensor = sensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER);
        }

        if (sensorManager != null && sensor != null) {
            sensorManager.registerListener(this, sensor, samplingPeriod);
        }
    }

    @Override
    public void unregister(Context context) {
        if (sensorManager != null && sensor != null) {
            sensorManager.unregisterListener(this);
            sensorManager = null;
            sensor = null;
        }
    }

    @Override
    public void onSensorChanged(SensorEvent sensorEvent) {
        if (this.accelerometerEventStream != null && this.accelerometerEventStream.event != null) {
            Map<String, Object> event = new HashMap<>();
            event.put("x", sensorEvent.values[0]);
            event.put("y", sensorEvent.values[1]);
            event.put("z", sensorEvent.values[2]);
            this.accelerometerEventStream.event.success(event);
        }
    }

    @Override
    public void onAccuracyChanged(Sensor sensor, int i) {
        // noop
    }
}
