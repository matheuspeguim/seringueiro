package com.example.flutter_seringueiro

data class PontoDeSangria(
    val id: Int,
    val timestamp: Long,
    val latitude: Double,
    val longitude: Double,
    val duracao: Int,
    val sangriaId: String
) {
    fun toMap(): Map<String, Any> {
        return mapOf(
            "id" to id,
            "timestamp" to timestamp,
            "latitude" to latitude,
            "longitude" to longitude,
            "duracao" to duracao,
            "sangriaId" to sangriaId
        )
    }
}