import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:weatherly/blocs/weather_bloc.dart';
import 'package:weatherly/repositories/repositories.dart';
import 'package:weatherly/ui/pages/city_selection.dart';
import 'package:weatherly/ui/pages/widgets/widgets.dart';
import 'package:weatherly/utils/uidata.dart';

class Weather extends StatefulWidget {
  final WeatherRepository weatherRepository;

  Weather({Key key, @required this.weatherRepository})
      : assert(weatherRepository != null),
        super(key: key);
  @override
  State<Weather> createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {
  WeatherBloc _weatherBloc;
  Completer<void> _refreshCompleter;


  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();
    _weatherBloc = WeatherBloc(weatherRepository: widget.weatherRepository);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: Text(UIData.app_title),
        backgroundColor: Colors.green,
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              final city = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CitySelection(),
                ),
              );
              if (city != null) {
                _weatherBloc.dispatch(FetchWeather(city: city));
              }
            },
          )
        ],
      ),
      body: Center(
        child: BlocBuilder(
          bloc: _weatherBloc,
          builder: (_, WeatherState state){
            if(state is WeatherEmpty){
              return Center(child: Text('Please enter a location', style: TextStyle(color: Colors.white)));
            }
            if(state is WeatherLoading) {
              return Center(child: CircularProgressIndicator(backgroundColor: Colors.green,),);
            }
            if(state is WeatherLoaded) {
              final weather = state.weather;
              _refreshCompleter?.complete();
              _refreshCompleter = Completer();
              return RefreshIndicator(
                onRefresh: () {
                  _weatherBloc.dispatch(
                    RefreshWeather(city: state.weather.location),
                  );
                  return _refreshCompleter.future;
                },
                  child: ListView(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 100.0),
                      child: Center(
                        child: Location(location: weather.location),
                      ),
                    ),
                    Center(
                      child: LastUpdated(dateTime: weather.lastUpdated),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 50.0),
                      child: Center(
                        child: CombinedWeatherTemperature(
                          weather: weather,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            if (state is WeatherError) {
              return Text(
                'Something went wrong!',
                style: TextStyle(color: Colors.red),
              );
            }
          },
        ),
      ),
      
    );
  }
  @override
  void dispose() {
    _weatherBloc.dispose();
    super.dispose();
  }
}