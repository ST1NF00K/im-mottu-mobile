package com.mottu.marvel

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.net.ConnectivityManager
import android.net.Network
import android.net.NetworkCapabilities
import android.os.Build
import android.os.Handler
import android.os.Looper
import io.flutter.plugin.common.EventChannel
import java.util.*

class ConnectivityBroadcastReceiver(
    private val context: Context,
    private val connectivity: Connectivity
) : BroadcastReceiver(), EventChannel.StreamHandler {

    private var events: EventChannel.EventSink? = null
    private val mainHandler = Handler(Looper.getMainLooper())
    private var networkCallback: ConnectivityManager.NetworkCallback? = null

    companion object {
        const val CONNECTIVITY_ACTION = "android.net.conn.CONNECTIVITY_CHANGE"
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
        this.events = events
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            networkCallback = object : ConnectivityManager.NetworkCallback() {
                override fun onAvailable(network: Network) {
                    sendEvent(connectivity.getCapabilitiesFromNetwork(network))
                }

                override fun onCapabilitiesChanged(network: Network, networkCapabilities: NetworkCapabilities) {
                    sendEvent(connectivity.getCapabilitiesList(networkCapabilities))
                }

                override fun onLost(network: Network) {
                    sendCurrentStatusWithDelay()
                }
            }
            connectivity.connectivityManager.registerDefaultNetworkCallback(networkCallback!!)
        } else {
            context.registerReceiver(this, IntentFilter(CONNECTIVITY_ACTION))
        }
        sendEvent(connectivity.getNetworkTypes())
    }

    override fun onCancel(arguments: Any?) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            networkCallback?.let {
                connectivity.connectivityManager.unregisterNetworkCallback(it)
                networkCallback = null
            }
        } else {
            try {
                context.unregisterReceiver(this)
            } catch (e: Exception) {
            }
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        events?.success(connectivity.getNetworkTypes())
    }

    private fun sendEvent(networkTypes: List<String>) {
        val runnable = Runnable { events?.success(networkTypes) }
        mainHandler.post(runnable)
    }

    private fun sendCurrentStatusWithDelay() {
        val runnable = Runnable { events?.success(connectivity.getNetworkTypes()) }
        mainHandler.postDelayed(runnable, 500)
    }
}
