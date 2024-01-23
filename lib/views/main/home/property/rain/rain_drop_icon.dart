import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_seringueiro/services/weather_api_service.dart';
import 'package:flutter_seringueiro/views/main/home/property/rain/rain_bloc.dart';
import 'package:flutter_seringueiro/views/main/home/property/rain/rain_event.dart';
import 'package:flutter_seringueiro/views/main/home/property/rain/rain_state.dart';
import 'package:flutter_svg/svg.dart';

class RainDropIcon extends StatelessWidget {
  final String propertyId;

  RainDropIcon({Key? key, required this.propertyId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RainBloc>(
      create: (context) => RainBloc(
          firestore: FirebaseFirestore.instance,
          weatherApiService:
              WeatherApiService(apiKey: dotenv.env['OPENWEATHER_API_KEY']!))
        ..add(LoadRainData(propertyId: propertyId)),
      child: BlocBuilder<RainBloc, RainState>(
        builder: (context, state) {
          if (state is RainChartDataLoaded) {
            // Calcule a quantidade total de chuva aqui, se necessário
            double totalRainAmount =
                state.chartData.fold(0, (sum, data) => sum + data.rainAmount);

            return Container(
              width: 40,
              height: 40,
              child: SvgPicture.asset(
                'assets/seringueira.svg', height: 100, width: 100,
                // Especifique a largura e altura conforme necessário
              ),
            );
          } else if (state is RainLoading) {
            return CircularProgressIndicator();
          } else {
            // Tratar outros estados como erro ou estado inicial
            return Container();
          }
        },
      ),
    );
  }
}
