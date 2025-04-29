import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WeatherScreen(),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Map<String, dynamic>? weatherData;
  bool isLoading = true;
  String apiKey = '197aa56abb0df306e280e163e0297374'; // API anahtarınızı buraya ekleyin

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  Future<void> fetchWeather() async {
    final city = 'Adana';
    final url =
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric&lang=tr';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          weatherData = jsonData;
          isLoading = false;
        });
      } else {
        print('API HATASI: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('HATA: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[100], // Açık mavi arkaplan
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : weatherData == null
            ? const Center(child: Text('Hava durumu verisi alınamadı.'))
            : Stack(
          children: [
            // Sol Ortada Adana Haritası
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/images/adana.png',  // Lokalden Adana haritası
                    width: 350,
                    height: 500,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            // Hava Durumu Bilgisi Ortada
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      weatherData!['name'],
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${weatherData!['main']['temp'].toString()} °C',
                      style: const TextStyle(
                        fontSize: 28,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      weatherData!['weather'][0]['description'],
                      style: const TextStyle(
                        fontSize: 22,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Hava durumu ikonu
                    Image.network(
                      'https://openweathermap.org/img/wn/${weatherData!['weather'][0]['icon']}@2x.png',
                      width: 100,
                      height: 100,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
