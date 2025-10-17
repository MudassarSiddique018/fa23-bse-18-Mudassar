import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.black,
        textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.white)),
      ),
      home: const CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String expression = "";
  String result = "0";

  void _onButtonClick(String value) {
    setState(() {
      if (value == "C") {
        expression = "";
        result = "0";
      } else if (value == "=") {
        try {
          Parser p = Parser();
          Expression exp = p.parse(expression);
          ContextModel cm = ContextModel();
          double eval = exp.evaluate(EvaluationType.REAL, cm);

          // remove trailing .0
          result = eval.toStringAsFixed(eval.truncateToDouble() == eval ? 0 : 2);
        } catch (e) {
          result = "Error";
        }
      } else {
        expression += value;
      }
    });
  }

  Widget _buildButton(String text, {Color color = Colors.grey}) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(8),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            padding: const EdgeInsets.all(22),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () => _onButtonClick(text),
          child: Text(
            text,
            style: const TextStyle(fontSize: 24, color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Calculator"),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Text(
              expression,
              style: const TextStyle(fontSize: 32, color: Colors.white70),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Text(
              result,
              style: const TextStyle(fontSize: 48, color: Colors.white),
            ),
          ),
          const Divider(color: Colors.white54),
          Column(
            children: [
              Row(children: [
                _buildButton("7"),
                _buildButton("8"),
                _buildButton("9"),
                _buildButton("/", color: Colors.orange),
              ]),
              Row(children: [
                _buildButton("4"),
                _buildButton("5"),
                _buildButton("6"),
                _buildButton("*", color: Colors.orange),
              ]),
              Row(children: [
                _buildButton("1"),
                _buildButton("2"),
                _buildButton("3"),
                _buildButton("-", color: Colors.orange),
              ]),
              Row(children: [
                _buildButton("0"),
                _buildButton("."),
                _buildButton("C", color: Colors.redAccent),
                _buildButton("+", color: Colors.orange),
              ]),
              Row(children: [
                _buildButton("=", color: Colors.green),
              ]),
            ],
          ),
        ],
      ),
    );
  }
}
