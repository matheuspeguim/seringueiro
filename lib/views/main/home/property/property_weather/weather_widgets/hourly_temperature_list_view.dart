import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_seringueiro/common/models/weather/weather_response.dart';
import 'package:flutter_seringueiro/common/models/weather/hourly_weather.dart';

class HourlyTemperatureListView extends StatefulWidget {
  final WeatherResponse weather;

  HourlyTemperatureListView({Key? key, required this.weather})
      : super(key: key);

  @override
  _HourlyTemperatureListViewState createState() =>
      _HourlyTemperatureListViewState();
}

class _HourlyTemperatureListViewState extends State<HourlyTemperatureListView> {
  final ScrollController _scrollController = ScrollController();
  Timer? _inactivityTimer;
  late List<int> _coldestIntervalIndexes;

  @override
  void initState() {
    super.initState();
    _coldestIntervalIndexes = _findColdestInterval(widget.weather.hourly);
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _scrollToColdestInterval());
    _scrollController.addListener(_handleUserScroll);
  }

  List<int> _findColdestInterval(List<HourlyWeather> hourlyWeather) {
    final now = DateTime.now();
    final currentHour = now.hour;
    final today = now.day;

    List<HourlyWeather> relevantHours;
    if (currentHour <= 6) {
      // Se a hora atual é até 6h da manhã, considere as horas de hoje como relevantes
      relevantHours = hourlyWeather.where((weather) {
        final weatherDate =
            DateTime.fromMillisecondsSinceEpoch(weather.dt * 1000);
        return weatherDate.day == today && weatherDate.hour >= currentHour;
      }).toList();
    } else {
      // Caso contrário, considere as primeiras horas de amanhã
      final tomorrow = DateTime(now.year, now.month, now.day + 1).day;
      relevantHours = hourlyWeather.where((weather) {
        final weatherDate =
            DateTime.fromMillisecondsSinceEpoch(weather.dt * 1000);
        return weatherDate.day == tomorrow && weatherDate.hour <= 6;
      }).toList();
    }

    // Inicialize com um intervalo inválido se não houver horas suficientes
    int bestStartIndex = -1;
    double lowestAvgTemp = double.infinity;
    // Garante que haja pelo menos 5 horas relevantes para formar um intervalo
    if (relevantHours.length >= 5) {
      for (int i = 0; i <= relevantHours.length - 5; i++) {
        double avgTemp = relevantHours
                .sublist(i, i + 5)
                .fold(0, (sum, item) => sum + item.temp.toInt()) /
            5;
        if (avgTemp < lowestAvgTemp) {
          bestStartIndex = i;
          lowestAvgTemp = avgTemp;
        }
      }
    }

    // Se um intervalo válido foi encontrado, ajusta os índices baseado na lista original
    if (bestStartIndex != -1) {
      int originalStartIndex =
          hourlyWeather.indexOf(relevantHours[bestStartIndex]);
      return [originalStartIndex, originalStartIndex + 4];
    } else {
      // Retorna uma lista vazia se nenhum intervalo válido foi encontrado
      return [];
    }
  }

  void _scrollToColdestInterval() {
    // Verifica se há intervalos calculados
    if (_coldestIntervalIndexes.isEmpty) return;

    // Calcula a posição de scroll de forma segura
    double position = 0.0;
    if (widget.weather.hourly.length > _coldestIntervalIndexes[1]) {
      position = (_coldestIntervalIndexes[0]) *
          60.0; // Assumindo 60.0 como largura de cada item
    }

    // Anima somente se a posição calculada for válida
    if (position >= 0 &&
        position <= _scrollController.position.maxScrollExtent) {
      _scrollController.animateTo(
        position,
        duration: Duration(seconds: 2),
        curve: Curves.easeInOut,
      );
    }
  }

  void _handleUserScroll() {
    if (_scrollController.position.userScrollDirection !=
        ScrollDirection.idle) {
      HapticFeedback.selectionClick();
      _restartInactivityTimer();
    }
  }

  void _restartInactivityTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(Duration(seconds: 2), () {
      if (!_scrollController.position.isScrollingNotifier.value) {
        _scrollToColdestInterval();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _inactivityTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              'Melhor período para Sangria',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: widget.weather.hourly.length,
              itemBuilder: (context, index) {
                final hourly = widget.weather.hourly[index];
                final bool isWithinColdestInterval =
                    index >= _coldestIntervalIndexes[0] &&
                        index <= _coldestIntervalIndexes[1];
                return Container(
                  width: 60,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${hourly.temp.toStringAsFixed(1)}°C',
                          style: TextStyle(
                              fontWeight: isWithinColdestInterval
                                  ? FontWeight.bold
                                  : null,
                              color: isWithinColdestInterval
                                  ? Colors.blue.shade700
                                  : null)),
                      Text(
                        '${DateTime.fromMillisecondsSinceEpoch(hourly.dt * 1000).hour}:00',
                        style: TextStyle(
                            color: isWithinColdestInterval
                                ? Colors.blue.shade700
                                : null),
                      ),
                      Text('|',
                          style: TextStyle(
                              color: isWithinColdestInterval
                                  ? Colors.blue.shade700
                                  : null)),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
