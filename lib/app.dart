import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:weatherly/repositories/repositories.dart';
import 'package:weatherly/ui/pages/weather.dart';
import 'package:weatherly/utils/uidata.dart';

class SimpleBlocDelegate extends BlocDelegate {
  @override
  onTransition(Transition transition) {
    super.onTransition(transition);
    print(transition);
  }

  @override
  void onError(Object error, StackTrace stacktrace) {
    super.onError(error, stacktrace);
    print(error);
  }
}
class App extends StatelessWidget {
  final WeatherRepository weatherRepository;

  App({Key key, @required this.weatherRepository})
    : assert(weatherRepository != null),
      super(key: key);

  Widget build(BuildContext context) {
    return MaterialApp(
      title: UIData.app_title,
      debugShowCheckedModeBanner: false,
      home: Weather(
        weatherRepository: weatherRepository,
        
      ),
    );
  }
}