import 'package:equatable/equatable.dart';

abstract class RainState extends Equatable {
  @override
  List<Object> get props => [];
}

class RainInitial extends RainState {}

class RainLoading extends RainState {}

class RainRecordSaved extends RainState {}

class RainRecordSaveError extends RainState {
  final String message;

  RainRecordSaveError(this.message);

  @override
  List<Object> get props => [message];
}

class RainChartDataLoaded extends RainState {
  final List<RainChartData> chartData;

  RainChartDataLoaded({required this.chartData});

  @override
  List<Object> get props => [chartData];
}

// Você pode definir uma classe para representar os dados no gráfico
class RainChartData {
  final DateTime date;
  final int rainAmount;

  RainChartData({required this.date, required this.rainAmount});
}
