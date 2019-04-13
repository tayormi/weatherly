import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:weatherly/app.dart';
import 'package:weatherly/repositories/repositories.dart';
import 'package:http/http.dart' as http;

void main() {
  final WeatherRepository weatherRepository = WeatherRepository(
    weatherApiClient: WeatherApiClient(
      httpClient: http.Client()
    )
  );

  BlocSupervisor().delegate = SimpleBlocDelegate();
  runApp(App(weatherRepository: weatherRepository));
} 