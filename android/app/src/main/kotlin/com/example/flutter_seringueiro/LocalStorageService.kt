package com.example.flutter_seringueiro

import android.content.Context
import android.database.sqlite.SQLiteDatabase
import android.database.sqlite.SQLiteOpenHelper
import android.content.ContentValues

class LocalStorageService(private val context: Context) {
    private val dbHelper = SangriaDbHelper(context)

    fun inserirPonto(ponto: PontoDeSangria) {
        val db = dbHelper.writableDatabase

        val values = ContentValues().apply {
            put("timestamp", ponto.timestamp)
            put("latitude", ponto.latitude)
            put("longitude", ponto.longitude)
            put("duracao", ponto.duracao)
            put("sangriaId", ponto.sangriaId)
        }

        db.insert("PontosDeSangria", null, values)
        db.close()
    }

    fun deletarPontos(sangriaId: String) {
        val db = dbHelper.writableDatabase
        db.delete("PontosDeSangria", "sangriaId = ?", arrayOf(sangriaId))
        db.close()
    }

    fun recuperarPontos(sangriaId: String): List<PontoDeSangria> {
        val db = dbHelper.readableDatabase
        val pontos = mutableListOf<PontoDeSangria>()

        val cursor = db.query(
            "PontosDeSangria", // Tabela
            null, // Colunas (null seleciona todas as colunas)
            "sangriaId = ?", // Critérios de seleção
            arrayOf(sangriaId), // Valores dos critérios de seleção
            null, // groupBy
            null, // having
            null  // orderBy
    )

    with(cursor) {
        while (moveToNext()) {
            val ponto = PontoDeSangria(
                id = getInt(getColumnIndexOrThrow("id")),
                timestamp = getLong(getColumnIndexOrThrow("timestamp")),
                latitude = getDouble(getColumnIndexOrThrow("latitude")),
                longitude = getDouble(getColumnIndexOrThrow("longitude")),
                duracao = getInt(getColumnIndexOrThrow("duracao")),
                sangriaId = getString(getColumnIndexOrThrow("sangriaId"))
            )
            pontos.add(ponto)
        }
    }
    cursor.close()
    db.close()

    return pontos
}

}



class SangriaDbHelper(context: Context) : SQLiteOpenHelper(context, "SangriaDatabase.db", null, 1) {
    override fun onCreate(db: SQLiteDatabase) {
        val createTableStatement = """
            CREATE TABLE IF NOT EXISTS PontosDeSangria (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                timestamp INTEGER,
                latitude REAL,
                longitude REAL,
                duracao INTEGER,
                sangriaId TEXT
            )
        """.trimIndent()

        db.execSQL(createTableStatement)
    }

    override fun onUpgrade(db: SQLiteDatabase, oldVersion: Int, newVersion: Int) {
        db.execSQL("DROP TABLE IF EXISTS PontosDeSangria")
        onCreate(db)
    }
}


