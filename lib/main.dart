import 'package:flutter/material.dart';
import 'package:xml/xml.dart';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Montserrat',
      ),
      home: const WeatherScreen(),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String _selectedCity = 'islamabad';
  String _weatherDescription = 'Select a city to see the weather';
  String _temperature = '';

  final String xmlData = '''
  <weatherdata>
    <location>
      <name>islamabad</name>
      <country>IT</country>
      <location altitude="0" latitude="44.34" longitude="10.99"/>
    </location>
    <forecast>
      <time from="2022-08-30T15:00:00" to="2022-08-30T16:00:00">
        <symbol number="500" name="light rain" var="10d"/>
        <temperature unit="kelvin" value="296.34" min="296.34" max="298.24"/>
        <humidity value="50" unit="%"/>
      </time>
    </forecast>
  </weatherdata>
  ''';

  void _parseWeatherData() {
    try {
      final document = XmlDocument.parse(xmlData);
      final forecast = document.findAllElements('time').first;

      final tempElement = forecast.findElements('temperature').first;
      final tempKelvin = double.parse(tempElement.getAttribute('value')!);
      final tempCelsius = (tempKelvin - 273.15).toStringAsFixed(1);

      final weatherElement = forecast.findElements('symbol').first;
      final description = weatherElement.getAttribute('name')!;

      setState(() {
        _temperature = '$tempCelsius °C';
        _weatherDescription = description;
      });
    } catch (e) {
      setState(() {
        _weatherDescription = 'Error parsing weather data';
        _temperature = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2193b0), Color(0xFF6dd5ed)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Weather App',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.3),
                      offset: const Offset(2, 2),
                      blurRadius: 4,
                    )
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: const Offset(0, 4),
                      blurRadius: 10,
                    )
                  ],
                ),
                child: DropdownButton<String>(
                  value: _selectedCity,
                  underline: Container(),
                  isExpanded: true,
                  items: const [
                    DropdownMenuItem(value: 'islamabad', child: Text('Islamabad')),
                    DropdownMenuItem(value: 'Karachi', child: Text('Karachi')),
                    DropdownMenuItem(value: 'Lahore', child: Text('Lahore')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedCity = value!;
                      _parseWeatherData();
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: const Offset(0, 4),
                      blurRadius: 10,
                    )
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Weather in $_selectedCity:',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Condition: $_weatherDescription',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Temperature: $_temperature',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
