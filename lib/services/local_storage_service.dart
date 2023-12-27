import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_seringueiro/views/main/home/property/sangria/sangria.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LocalStorageService {
  static final LocalStorageService _instance = LocalStorageService._internal();

  factory LocalStorageService() {
    return _instance;
  }

  LocalStorageService._internal();

  late Box _sangriasLocalCache;

  Future<void> init() async {
    _sangriasLocalCache = await Hive.openBox('sangriasLocalCache');
  }

  Future<void> saveSangria(Sangria sangria) async {
    if (!_sangriasLocalCache.isOpen) {
      await init();
    }
    await _sangriasLocalCache.put(sangria.id, sangria.toMap());
  }

  Future<void> deleteSangria(String sangriaId) async {
    if (!_sangriasLocalCache.isOpen) {
      await init();
    }
    await _sangriasLocalCache.delete(sangriaId);
  }

  Future<Sangria> getSangria(String key) async {
    final sangriaMap = await _sangriasLocalCache.get(key);
    if (sangriaMap == null) {
      throw Exception("Sangria não encontrada para a chave: $key");
    }
    return Sangria.fromMap(sangriaMap as Map<String, dynamic>);
  }

  Future<void> verificarConexaoESincronizarSeNecessario() async {
    var conectividade = await Connectivity().checkConnectivity();
    if (conectividade != ConnectivityResult.none) {
      await _sincronizarComFirestore();
    }
  }

  Future<void> _sincronizarComFirestore() async {
    var keys = _sangriasLocalCache.keys;
    for (var key in keys) {
      var data = _sangriasLocalCache.get(key);
      if (data is Map<String, dynamic>) {
        var sangria = Sangria.fromMap(data);
        if (sangria.finalizada) {
          await FirebaseFirestore.instance
              .collection('properties')
              .doc(sangria.propertyId)
              .collection('sangrias')
              .add(sangria.toMap());
          await _sangriasLocalCache.delete(key);
        }
      }
    }
  }

  Future<void> listarSangriasSalvas() async {
    final keys = _sangriasLocalCache.keys;
    print('Listando todas as sangrias salvas localmente:');
    for (var key in keys) {
      var sangriaMap = _sangriasLocalCache.get(key);
      print('Sangria [$key]: $sangriaMap');
    }
  }
}

//ADAPTADORES
class TimestampAdapter extends TypeAdapter<Timestamp> {
  @override
  final typeId = 1; // Escolha um ID único para este tipo de adaptador

  @override
  Timestamp read(BinaryReader reader) {
    var timestampAsInt = reader.read();
    return Timestamp.fromMillisecondsSinceEpoch(timestampAsInt);
  }

  @override
  void write(BinaryWriter writer, Timestamp obj) {
    writer.write(obj.millisecondsSinceEpoch);
  }
}

class DurationAdapter extends TypeAdapter<Duration> {
  @override
  final typeId = 5; // Escolha um ID que não seja usado por outros TypeAdapters

  @override
  Duration read(BinaryReader reader) {
    return Duration(milliseconds: reader.readInt());
  }

  @override
  void write(BinaryWriter writer, Duration obj) {
    writer.writeInt(obj.inMilliseconds);
  }
}

class SangriaAdapter extends TypeAdapter<Sangria> {
  @override
  final typeId = 2;

  @override
  Sangria read(BinaryReader reader) {
    var id = reader.readString();
    var momento = DateTime.fromMillisecondsSinceEpoch(reader.readInt());
    var duracaoTotal = Duration(milliseconds: reader.readInt());
    var tabela = reader.readString();
    var usuarioId = reader.readString();
    var propertyId = reader.readString();
    var finalizada = reader.readBool();
    var condicoesClimaticas = Map<String, dynamic>.from(reader.readMap());
    var pontos = reader.readList().cast<PontoDeSangria>();

    return Sangria(
      id: id,
      momento: momento,
      duracaoTotal: duracaoTotal,
      tabela: tabela,
      usuarioId: usuarioId,
      propertyId: propertyId,
      finalizada: finalizada,
      condicoesClimaticas: condicoesClimaticas,
      pontos: pontos,
    );
  }

  @override
  void write(BinaryWriter writer, Sangria obj) {
    writer.writeString(obj.id);
    writer.writeInt(obj.momento.millisecondsSinceEpoch);
    writer.writeInt(obj.duracaoTotal.inMilliseconds);
    writer.writeString(obj.tabela);
    writer.writeString(obj.usuarioId);
    writer.writeString(obj.propertyId);
    writer.writeMap(obj.condicoesClimaticas);
    writer.writeBool(obj.finalizada);
    writer.writeList(obj.pontos);
  }
}

class PontoDeSangriaAdapter extends TypeAdapter<PontoDeSangria> {
  @override
  final typeId = 3;

  @override
  PontoDeSangria read(BinaryReader reader) {
    var id = reader.readInt();
    var timestamp = DateTime.fromMillisecondsSinceEpoch(reader.readInt());
    var latitude = reader.readDouble();
    var longitude = reader.readDouble();
    var duracao = reader.readInt();
    var sangriaId = reader.readString(); // Adicionando leitura do sangriaId

    return PontoDeSangria(
      id: id,
      timestamp: timestamp,
      localizacao: LatLng(latitude, longitude),
      duracao: duracao,
      sangriaId: sangriaId, // Atribuindo o sangriaId lido
    );
  }

  @override
  void write(BinaryWriter writer, PontoDeSangria obj) {
    writer.writeInt(obj.id);
    writer.writeInt(obj.timestamp.millisecondsSinceEpoch);
    writer.writeDouble(obj.localizacao.latitude);
    writer.writeDouble(obj.localizacao.longitude);
    writer.writeInt(obj.duracao);
    writer.writeString(obj.sangriaId); // Escrevendo o sangriaId
  }
}

class WeatherDataAdapter extends TypeAdapter<Map<String, dynamic>> {
  @override
  final typeId = 4; // Escolha um ID único para este tipo de adaptador

  @override
  Map<String, dynamic> read(BinaryReader reader) {
    return Map<String, dynamic>.from(reader.readMap());
  }

  @override
  void write(BinaryWriter writer, Map<String, dynamic> obj) {
    writer.writeMap(obj);
  }
}

class GeoPointAdapter extends TypeAdapter<GeoPoint> {
  @override
  final typeId = 6; // Certifique-se de que este ID é único

  @override
  GeoPoint read(BinaryReader reader) {
    var lat = reader.readDouble();
    var lng = reader.readDouble();
    return GeoPoint(lat, lng);
  }

  @override
  void write(BinaryWriter writer, GeoPoint obj) {
    writer.writeDouble(obj.latitude);
    writer.writeDouble(obj.longitude);
  }
}
