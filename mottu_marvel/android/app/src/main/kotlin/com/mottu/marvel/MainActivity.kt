package com.mottu.marvel

import android.content.Context
import android.net.ConnectivityManager
import io.flutter.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.mottu.marvel/connectivity"
    private lateinit var connectivity: Connectivity

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val connectivityManager = getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
        connectivity = Connectivity(connectivityManager)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getConnectivityStatus") {
                val status = getConnectivityStatus()
                Log.d("ConnectivityStatus", "Status de conectividade: $status")

                result.success(status)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun getConnectivityStatus(): String {
        val networkTypes = connectivity.getNetworkTypes()
        return if (networkTypes.isEmpty()) {
            "none"
        } else {
            networkTypes.joinToString(", ")
        }
    }
}
