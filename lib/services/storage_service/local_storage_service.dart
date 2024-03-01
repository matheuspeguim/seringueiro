import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_seringueiro/models/activity_point.dart';
import 'package:flutter_seringueiro/models/field_activity.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LocalStorageService {
  static final LocalStorageService _instance = LocalStorageService._internal();

  factory LocalStorageService() {
    return _instance;
  }

  LocalStorageService._internal();

  late Box _fieldActivitiesLocalCache;

  Future<void> init() async {
    _fieldActivitiesLocalCache = await Hive.openBox('fieldActivitysLocalCache');
  }

  Future<void> saveFieldActivity(FieldActivity fieldActivity) async {
    if (!_fieldActivitiesLocalCache.isOpen) {
      await init();
    }
    await _fieldActivitiesLocalCache.put(
        fieldActivity.id, fieldActivity.toMap());
  }

  Future<void> deleteFieldActivity(String fieldActivityId) async {
    if (!_fieldActivitiesLocalCache.isOpen) {
      await init();
    }
    await _fieldActivitiesLocalCache.delete(fieldActivityId);
  }

  Future<FieldActivity> getfieldActivity(String key) async {
    final fieldActivityMap = await _fieldActivitiesLocalCache.get(key);
    if (fieldActivityMap == null) {
      throw Exception("fieldActivity não encontrada para a chave: $key");
    }
    return FieldActivity.fromMap(fieldActivityMap as Map<String, dynamic>);
  }

  Future<void> verificarConexaoESincronizarSeNecessario() async {
    var conectividade = await Connectivity().checkConnectivity();
    if (conectividade != ConnectivityResult.none) {
      await _sincronizarComFirestore();
    }
  }

  Future<void> _sincronizarComFirestore() async {
    var keys = _fieldActivitiesLocalCache.keys;
    for (var key in keys) {
      var data = _fieldActivitiesLocalCache.get(key);
      if (data is Map<String, dynamic>) {
        var fieldActivity = FieldActivity.fromMap(data);
        if (fieldActivity.finalizada) {
          await FirebaseFirestore.instance
              .collection('properties')
              .doc(fieldActivity.propertyId)
              .collection('fieldActivitys')
              .add(fieldActivity.toMap());
          await _fieldActivitiesLocalCache.delete(key);
        }
      }
    }
  }

  Future<void> listarfieldActivitysSalvas() async {
    final keys = _fieldActivitiesLocalCache.keys;
    print('Listando todas as fieldActivitys salvas localmente:');
    for (var key in keys) {
      var fieldActivityMap = _fieldActivitiesLocalCache.get(key);
      print('fieldActivity [$key]: $fieldActivityMap');
    }
  }
}

//ADAPTADORES
class TimestampAdapter extends TypeAdapter<Timestamp> {
  @override
  final typeId = 1;

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

class FieldActivityAdapter extends TypeAdapter<FieldActivity> {
  @override
  final typeId = 2;

  @override
  FieldActivity read(BinaryReader reader) {
    var id = reader.readString();
    var inicio = DateTime.fromMillisecondsSinceEpoch(reader.readInt());
    var fim = DateTime.fromMicrosecondsSinceEpoch(reader.readInt());
    var tabela = reader.readString();
    var atividade = reader.readString();
    var usuarioUid = reader.readString();
    var propertyId = reader.readString();
    var finalizada = reader.readBool();
    var condicoesClimaticas = Map<String, dynamic>.from(reader.readMap());

    return FieldActivity(
      id: id,
      inicio: inicio,
      fim: fim,
      tabela: tabela,
      atividade: atividade,
      usuarioUid: usuarioUid,
      propertyId: propertyId,
      finalizada: finalizada,
      condicoesClimaticas: condicoesClimaticas,
    );
  }

  @override
  void write(BinaryWriter writer, FieldActivity obj) {
    writer.writeInt(obj.inicio.millisecondsSinceEpoch);
    writer.writeInt(obj.fim.millisecondsSinceEpoch);
    writer.writeString(obj.tabela);
    writer.writeString(obj.atividade);
    writer.writeString(obj.usuarioUid);
    writer.writeString(obj.propertyId);
    writer.writeMap(obj.condicoesClimaticas);
    writer.writeBool(obj.finalizada);
  }
}

class ActivityPointAdapter extends TypeAdapter<ActivityPoint> {
  @override
  final typeId = 3;

  @override
  ActivityPoint read(BinaryReader reader) {
    var id = reader.readString();
    var momento = DateTime.fromMillisecondsSinceEpoch(reader.readInt());
    var latitude = reader.readDouble();
    var longitude = reader.readDouble();
    var fieldActivityId = reader.readString();

    return ActivityPoint(
      id: id,
      momento: momento,
      latitude: latitude,
      longitude: longitude,
      fieldActivityId: fieldActivityId,
    );
  }

  @override
  void write(BinaryWriter writer, ActivityPoint obj) {
    writer.writeString(obj.id);
    writer.writeInt(obj.momento.millisecondsSinceEpoch);
    writer.writeDouble(obj.latitude);
    writer.writeDouble(obj.longitude);
    writer.writeString(obj.fieldActivityId);
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
