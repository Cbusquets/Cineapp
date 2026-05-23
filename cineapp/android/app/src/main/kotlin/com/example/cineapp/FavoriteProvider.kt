package com.example.cineapp

import android.content.ContentProvider
import android.content.ContentValues
import android.content.UriMatcher
import android.database.Cursor
import android.database.MatrixCursor
import android.net.Uri
import android.util.Log

class FavoriteProvider : ContentProvider() {

    companion object {
        const val AUTHORITY = "com.example.cineapp.provider"
        const val PATH_FAVORITES = "favorites"
        val CONTENT_URI: Uri = Uri.parse("content://$AUTHORITY/$PATH_FAVORITES")
        private const val FAVORITES = 1
        private val uriMatcher = UriMatcher(UriMatcher.NO_MATCH).apply {
            addURI(AUTHORITY, PATH_FAVORITES, FAVORITES)
        }
    }

    override fun onCreate(): Boolean {
        Log.d("FavoriteProvider", "ContentProvider iniciado")
        return true
    }

    override fun query(
        uri: Uri, projection: Array<String>?, selection: String?,
        selectionArgs: Array<String>?, sortOrder: String?
    ): Cursor {
        val cursor = MatrixCursor(arrayOf("id", "title", "rating"))
        if (uriMatcher.match(uri) == FAVORITES) {
            cursor.addRow(arrayOf(1, "Ejemplo favorito", 8.5))
        }
        return cursor
    }

    override fun getType(uri: Uri): String =
        "vnd.android.cursor.dir/vnd.$AUTHORITY.$PATH_FAVORITES"

    override fun insert(uri: Uri, values: ContentValues?): Uri? = null
    override fun delete(uri: Uri, selection: String?, selectionArgs: Array<String>?): Int = 0
    override fun update(uri: Uri, values: ContentValues?, selection: String?, selectionArgs: Array<String>?): Int = 0
}