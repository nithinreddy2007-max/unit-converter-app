import 'package:flutter/material.dart';

void main() {
  runApp(const UnitConverterApp());
}

class UnitConverterApp extends StatelessWidget {
  const UnitConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Unit Converter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const UnitConverterHome(),
    );
  }
}

class UnitConverterHome extends StatefulWidget {
  const UnitConverterHome({super.key});

  @override
  State<UnitConverterHome> createState() => _UnitConverterHomeState();
}

class _UnitConverterHomeState extends State<UnitConverterHome> {
  final TextEditingController valueController = TextEditingController();

  String category = 'Length';
  String fromUnit = 'Meter';
  String toUnit = 'Kilometer';
  String result = '0';

  final Map<String, List<String>> units = {
    'Length': [
      'Meter',
      'Kilometer',
      'Centimeter',
      'Millimeter',
      'Mile',
      'Foot',
      'Inch',
    ],
    'Weight': [
      'Kilogram',
      'Gram',
      'Milligram',
      'Pound',
      'Ounce',
    ],
    'Temperature': [
      'Celsius',
      'Fahrenheit',
      'Kelvin',
    ],
    'Time': [
      'Second',
      'Minute',
      'Hour',
      'Day',
    ],
    'Volume': [
      'Liter',
      'Milliliter',
      'Gallon',
    ],
  };

  double convert(double value, String from, String to) {
    if (from == to) return value;

    if (category == 'Length') {
      final meter = {
        'Meter': 1.0,
        'Kilometer': 1000.0,
        'Centimeter': 0.01,
        'Millimeter': 0.001,
        'Mile': 1609.344,
        'Foot': 0.3048,
        'Inch': 0.0254,
      };

      return value * meter![from]! / meter[to]!;
    }

    if (category == 'Weight') {
      final kg = {
        'Kilogram': 1.0,
        'Gram': 0.001,
        'Milligram': 0.000001,
        'Pound': 0.453592,
        'Ounce': 0.0283495,
      };

      return value * kg![from]! / kg[to]!;
    }

    if (category == 'Temperature') {
      double celsius;

      if (from == 'Celsius') {
        celsius = value;
      } else if (from == 'Fahrenheit') {
        celsius = (value - 32) * 5 / 9;
      } else {
        celsius = value - 273.15;
      }

      if (to == 'Celsius') return celsius;
      if (to == 'Fahrenheit') return celsius * 9 / 5 + 32;
      return celsius + 273.15;
    }

    if (category == 'Time') {
      final seconds = {
        'Second': 1.0,
        'Minute': 60.0,
        'Hour': 3600.0,
        'Day': 86400.0,
      };

      return value * seconds![from]! / seconds[to]!;
    }

    if (category == 'Volume') {
      final liters = {
        'Liter': 1.0,
        'Milliliter': 0.001,
        'Gallon': 3.78541,
      };

      return value * liters![from]! / liters[to]!;
    }

    return value;
  }

  void calculate() {
    final value = double.tryParse(valueController.text);

    if (value == null) {
      setState(() {
        result = 'Enter a valid number';
      });
      return;
    }

    final converted = convert(value, fromUnit, toUnit);

    setState(() {
      result = converted.toStringAsFixed(4);
    });
  }

  void changeCategory(String newCategory) {
    setState(() {
      category = newCategory;
      fromUnit = units[newCategory]!.first;
      toUnit = units[newCategory]!.length > 1
          ? units[newCategory]![1]
          : units[newCategory]!.first;
      result = '0';
    });
  }

  @override
  Widget build(BuildContext context) {
    final availableUnits = units[category]!;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Unit Converter',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            const SizedBox(height: 10),

            const Icon(
              Icons.calculate,
              size: 70,
              color: Colors.blue,
            ),

            const SizedBox(height: 10),

            const Text(
              'Convert Units Easily',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 25),

            DropdownButtonFormField<String>(
              value: category,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.category),
              ),
              items: units.keys.map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  changeCategory(value);
                }
              },
            ),

            const SizedBox(height: 20),

            TextField(
              controller: valueController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Enter Value',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.numbers),
              ),
            ),

            const SizedBox(height: 20),

            DropdownButtonFormField<String>(
              value: fromUnit,
              decoration: const InputDecoration(
                labelText: 'From',
                border: OutlineInputBorder(),
              ),
              items: availableUnits.map((unit) {
                return DropdownMenuItem(
                  value: unit,
                  child: Text(unit),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    fromUnit = value;
                  });
                }
              },
            ),

            const SizedBox(height: 15),

            const Icon(Icons.arrow_downward),

            const SizedBox(height: 15),

            DropdownButtonFormField<String>(
              value: toUnit,
              decoration: const InputDecoration(
                labelText: 'To',
                border: OutlineInputBorder(),
              ),
              items: availableUnits.map((unit) {
                return DropdownMenuItem(
                  value: unit,
                  child: Text(unit),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    toUnit = value;
                  });
                }
              },
            ),

            const SizedBox(height: 25),

            ElevatedButton.icon(
              onPressed: calculate,
              icon: const Icon(Icons.sync),
              label: const Text(
                'CONVERT',
                style: TextStyle(fontSize: 18),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),

            const SizedBox(height: 30),

            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20),

                child: Column(
                  children: [
                    const Text(
                      'RESULT',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      result,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      toUnit,
                      style: const TextStyle(fontSize: 18),
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