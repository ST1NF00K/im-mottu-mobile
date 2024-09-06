package com.mottu.marvel

import android.net.ConnectivityManager
import android.net.Network
import android.net.NetworkCapabilities
import android.os.Build

class Connectivity(val connectivityManager: ConnectivityManager) {

    companion object {
        const val CONNECTIVITY_NONE = "none"
        const val CONNECTIVITY_WIFI = "wifi"
        const val CONNECTIVITY_MOBILE = "mobile"
        const val CONNECTIVITY_OTHER = "other"
    }

    fun getNetworkTypes(): List<String> {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val network = connectivityManager.activeNetwork
            if (network != null) {
                getCapabilitiesFromNetwork(network)
            } else {
                listOf(CONNECTIVITY_NONE)
            }
        } else {
            getNetworkTypesLegacy()
        }
    }

    internal fun getCapabilitiesFromNetwork(network: Network): List<String> {
        val capabilities = connectivityManager.getNetworkCapabilities(network)
        return if (capabilities != null) {
            getCapabilitiesList(capabilities)
        } else {
            listOf(CONNECTIVITY_NONE)
        }
    }

    internal fun getCapabilitiesList(capabilities: NetworkCapabilities): List<String> {
        val types = mutableListOf<String>()
        if (!capabilities.hasCapability(NetworkCapabilities.NET_CAPABILITY_INTERNET)) {
            types.add(CONNECTIVITY_NONE)
            return types
        }
        if (capabilities.hasTransport(NetworkCapabilities.TRANSPORT_WIFI)) {
            types.add(CONNECTIVITY_WIFI)
        }
        if (capabilities.hasTransport(NetworkCapabilities.TRANSPORT_CELLULAR)) {
            types.add(CONNECTIVITY_MOBILE)
        }
        if (types.isEmpty()) {
            types.add(CONNECTIVITY_OTHER)
        }
        return types
    }

    @Suppress("DEPRECATION")
    private fun getNetworkTypesLegacy(): List<String> {
        val info = connectivityManager.activeNetworkInfo
        val types = mutableListOf<String>()
        if (info == null || !info.isConnected) {
            types.add(CONNECTIVITY_NONE)
            return types
        }
        when (info.type) {
            ConnectivityManager.TYPE_WIFI -> types.add(CONNECTIVITY_WIFI)
            ConnectivityManager.TYPE_MOBILE -> types.add(CONNECTIVITY_MOBILE)
            else -> types.add(CONNECTIVITY_OTHER)
        }
        return types
    }
}
