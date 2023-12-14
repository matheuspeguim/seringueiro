import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_seringueiro/views/main/home/property/sangria.dart';
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
    final box = await Hive.openBox('sangriaBox'); // Nome do Hive Box

    String key = 'sangria_${DateTime.now().millisecondsSinceEpoch}';
    await box.put(key, sangria);
  }

  Future<Sangria> getSangria(String key) async {
    final box = await Hive.openBox('sangriaBox'); // Nome do Hive Box
    final sangria = await box.get(key) as Sangria;
    return sangria;
  }

//SONCRONIZAÇÃO
  Future<void> verificarConexaoESincronizarSeNecessario() async {
    var conectividade = await Connectivity().checkConnectivity();
    if (conectividade != ConnectivityResult.none) {
      // Obtenha o propertyId de alguma forma (ajuste conforme sua lógica)
      String propertyId = "SEU_PROPERTY_ID";
      await _sincronizarComFirestore(propertyId);
    }
  }

  Future<void> _sincronizarComFirestore(String propertyId) async {
    var keys = _sangriasLocalCache.keys;
    for (var key in keys) {
      var sangriaMap = _sangriasLocalCache.get(key);
      Sangria sangria = Sangria.fromMap(sangriaMap);

      // Envie cada sangria para o Firestore, dentro da coleção 'properties', no documento específico
      await FirebaseFirestore.instance
          .collection('properties')
          .doc(propertyId)
          .collection('sangrias')
          .add(sangria.toMap());

      // Após sincronização bem-sucedida, remova a sangria do cache local
      await _sangriasLocalCache.delete(key);
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

class SangriaAdapter extends TypeAdapter<Sangria> {
  @override
  final int typeId = 2;

  @override
  Sangria read(BinaryReader reader) {
    var momento = DateTime.fromMillisecondsSinceEpoch(reader.readInt());
    var duracaoTotal = Duration(milliseconds: reader.readInt());
    var tabela = reader.readString();
    var usuarioId = reader.readString();
    var condicoesClimaticas = Map<String, dynamic>.from(reader.readMap());
    var pontos = reader.readList().cast<PontoDeSangria>();

    return Sangria(
      momento: momento,
      duracaoTotal: duracaoTotal,
      tabela: tabela,
      usuarioId: usuarioId,
      condicoesClimaticas: condicoesClimaticas,
      pontos: pontos,
    );
  }

  @override
  void write(BinaryWriter writer, Sangria obj) {
    writer.writeInt(obj.momento.millisecondsSinceEpoch);
    writer.writeInt(obj.duracaoTotal.inMilliseconds);
    writer.writeString(obj.tabela);
    writer.writeString(obj.usuarioId);
    writer.writeMap(obj.condicoesClimaticas);
    writer.writeList(obj.pontos);
  }
}

class PontoDeSangriaAdapter extends TypeAdapter<PontoDeSangria> {
  @override
  final int typeId = 3;

  @override
  PontoDeSangria read(BinaryReader reader) {
    var id = reader.readInt();
    var timestamp = DateTime.fromMillisecondsSinceEpoch(reader.readInt());
    var latitude = reader.readDouble();
    var longitude = reader.readDouble();
    var duracao = reader.readInt();

    return PontoDeSangria(
      id: id,
      timestamp: timestamp,
      localizacao: LatLng(latitude, longitude),
      duracao: duracao,
    );
  }

  @override
  void write(BinaryWriter writer, PontoDeSangria obj) {
    writer.writeInt(obj.id);
    writer.writeInt(obj.timestamp.millisecondsSinceEpoch);
    writer.writeDouble(obj.localizacao.latitude);
    writer.writeDouble(obj.localizacao.longitude);
    writer.writeInt(obj.duracao);
  }
}

class WeatherDataAdapter extends TypeAdapter<Map<String, dynamic>> {
  @override
  final int typeId = 4; // Escolha um ID único para este tipo de adaptador

  @override
  Map<String, dynamic> read(BinaryReader reader) {
    return Map<String, dynamic>.from(reader.readMap());
  }

  @override
  void write(BinaryWriter writer, Map<String, dynamic> obj) {
    writer.writeMap(obj);
  }
}
