package com.example.carsharing_app

import android.Manifest
import android.bluetooth.le.ScanResult
import android.content.pm.PackageManager
import android.os.Handler
import android.util.Log
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat
import com.roboart.mobokeylibrary.MKDevice
import com.roboart.mobokeylibrary.MKResponseListener.ConnectionResponseListener
import com.roboart.mobokeylibrary.MKResponseListener.OperationsResponseListener
import com.roboart.mobokeylibrary.MKResponseListener.RssiResponseListner
import com.roboart.mobokeylibrary.MKResponseListener.ScanResponseListner
import com.roboart.mobokeylibrary.ScanMoboKey
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity(), ConnectionResponseListener, ScanResponseListner, OperationsResponseListener, RssiResponseListner {

    private val CHANNEL = "sample.flutter.dev/EasyDrive"
    
    lateinit var  obj: MKDevice
    lateinit var scanMoboKey: ScanMoboKey

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        obj = MKDevice(this@MainActivity)
        scanMoboKey = ScanMoboKey(this@MainActivity)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if(call.method == "sync_car"){
                sync_car()
            }
            if(call.method == "power_on"){
                power_on()
            }
        }
    }
    private fun sync_car() {
        obj.initListner(this@MainActivity, this@MainActivity, this@MainActivity, this@MainActivity)
            try {
                scanMoboKey.ScanMKDevice(15000, "MoboKey")
            } catch (e: Exception) {
                print("SOME FAILURE")
            }

    }
    private fun power_on(){
        try {
            obj.MKPowerOn()
        }catch (e: Exception){
            print("SOME FAILURE")
        }
    }
    override fun ConnectionResponse(responseCode: Int, withdDevice: String?) {
        when (responseCode) {
            0 -> runOnUiThread {
                val handler = Handler()
                handler.postDelayed({
                    Log.i("dis", "Device Dissconected")

                }, 3000)
                Log.i("Connection status: ", "Disconnected")
            }
            1 -> runOnUiThread {
                Log.i("Connection status: ", "Connecting")
                obj.MKCheckMasterKeyForConnection("1010")
            }
            2 -> runOnUiThread {
                Log.i("Connection status: ", "Connected")
                obj.RegisterRssi()
            }
        }
    }

    override fun ScanResponse(response: Int, scanResultList: List<ScanResult>) {
        Log.i("Scan Response: ", response.toString() + "")
        if (response == 1) //Device Found Feedback
        {
            Log.i("Scan Result: ", "Success on scan response")
        } else if (response == 0) {
            Log.i("Scan Result: ", "Error on sync")
        }
    }

    override fun OperationsResponse(response: Int) {
        runOnUiThread {
            when (response) {
                0 -> {
                    Log.i("RK status: ", "Invalid")
                }
                1 -> {
                    Log.i("RK status: ", "Valid")
                }
                2 -> Log.i("MK status: ", "Invalid")
                3 -> {
                    Log.i("MK status: ", "Valid")
                    obj.MKStatus()
                }
                4 -> Log.i("RK Change: ", "Valid")
                5 -> Log.i("RK Change: ", "Invalid")
                6 -> Log.i("MK Change: ", "Valid")
                7 -> Log.i("MK Change: ", "Invalid")
                8 -> Log.i("Operation: ", "Locked")
                9 -> Log.i("Operation: ", "Unlocked")
                10 -> Log.i("Operation: ", "Engine Kill On")
                11 -> Log.i("Operation: ", "Engine Kill Off")
                12 -> Log.i("Operation: ", "Acc on")
                13 -> Log.i("Operation: ", "Acc off")
                14 -> Log.i("Operation: ", "Power on")
                15 -> Log.i("Operation: ", "Power off")
                16 -> Log.i("Operation: ", "Start")
                17 -> Log.i("Operation: ", "Push Power On")
                18 -> Log.i("Operation: ", "Push Power Off")
                19 -> Log.i("Operation: ", "Timer Changed")
                21 -> Log.i("Operation: ", "AutoLock On")
                22 -> Log.i("Operation: ", "AutoLock Off")
                23 -> Log.i("Operation: ", "Security On")
                24 -> Log.i("Operation: ", "Security Off")
                25 -> Log.i("Operation: ", "Push Start Car")
                26 -> Log.i("Operation: ", "Self Start Car")
                27 -> Log.i("Operation: ", "ProxLU On")
                28 -> Log.i("Operation: ", "ProxLU Off")
                29 -> Log.i("Operation: ", "ProxSS Car")
                30 -> Log.i("Operation: ", "ProxSS Car")
            }
        }
    }

    override fun RssiResponse(rssi: Int) {
        Log.d("rssi", "RssiResponse: $rssi")
    }
}

