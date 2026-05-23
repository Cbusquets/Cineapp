package com.example.cineapp

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.net.ConnectivityManager
import android.net.NetworkCapabilities
import android.util.Log

class NetworkReceiver : BroadcastReceiver() {

    override fun onReceive(context: Context, intent: Intent) {
        if (isConnected(context)) {
            Log.d("NetworkReceiver", "Conexión restaurada — sincronizando...")
            val serviceIntent = Intent(context, FavoriteSyncService::class.java)
            context.startService(serviceIntent)
        } else {
            Log.d("NetworkReceiver", "Sin conexión a internet")
        }
    }

    private fun isConnected(context: Context): Boolean {
        val cm = context.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
        val network = cm.activeNetwork ?: return false
        val capabilities = cm.getNetworkCapabilities(network) ?: return false
        return capabilities.hasCapability(NetworkCapabilities.NET_CAPABILITY_INTERNET)
    }
}