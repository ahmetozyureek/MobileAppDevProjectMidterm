import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hava Durumu',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WeatherPage(),
    );
  }
}

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  String city = "Adana"; // Şehir Adana oldu!
  String apiKey = "BURAYA_SENIN_API_KEY"; // Buraya kendi OpenWeatherMap API key'ini koyman lazım
  double? temperature;
  String? description;
  String? iconCode;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  Future<void> fetchWeather() async {
    final url = Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric&lang=tr");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        temperature = data['main']['temp'];
        description = data['weather'][0]['description'];
        iconCode = data['weather'][0]['icon'];
        isLoading = false;
      });
    } else {
      throw Exception('Hava durumu verisi alınamadı.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hava Durumu - Adana'),
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    city,
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  if (iconCode != null)
                    Image.network(
                      "https://openweathermap.org/img/wn/$iconCode@2x.png",
                    ),
                  Text(
                    "${temperature?.toStringAsFixed(1)}°C",
                    style: const TextStyle(fontSize: 48),
                  ),
                  Text(
                    description?.toUpperCase() ?? '',
                    style: const TextStyle(fontSize: 24),
                  ),
                ],
              ),
      ),
    );
  }
}