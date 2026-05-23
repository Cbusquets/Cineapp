package com.example.cineapp

import android.app.Service
import android.content.Intent
import android.os.IBinder
import android.util.Log

class FavoriteSyncService : Service() {

    override fun onCreate() {
        super.onCreate()
        Log.d("FavoriteSyncService", "Servicio creado")
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        Log.d("FavoriteSyncService", "Sincronizando favoritos...")
        stopSelf()
        return START_NOT_STICKY
    }

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onDestroy() {
        super.onDestroy()
        Log.d("FavoriteSyncService", "Servicio destruido")
    }
}