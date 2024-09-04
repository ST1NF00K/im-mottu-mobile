package com.example.mottu_marvel

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.net.ConnectivityManager
import android.net.NetworkInfo
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.EventChannel
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.mottu.marvel/connectivity"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        EventChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setStreamHandler(
            object : EventChannel.StreamHandler {
                private var connectivityReceiver: BroadcastReceiver? = null

                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    connectivityReceiver = createConnectivityReceiver(events)
                    registerReceiver(
                        connectivityReceiver, IntentFilter(ConnectivityManager.CONNECTIVITY_ACTION)
                    )
                }

                override fun onCancel(arguments: Any?) {
                    unregisterReceiver(connectivityReceiver)
                    connectivityReceiver = null
                }

                private fun createConnectivityReceiver(events: EventChannel.EventSink?): BroadcastReceiver {
                    return object : BroadcastReceiver() {
                        override fun onReceive(context: Context?, intent: Intent?) {
                            val cm = context?.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
                            val activeNetwork: NetworkInfo? = cm.activeNetworkInfo
                            if (activeNetwork != null && activeNetwork.isConnected) {
                                events?.success(true)
                            } else {
                                events?.success(false) 
                            }
                        }
                    }
                }
            }
        )
    }
}
