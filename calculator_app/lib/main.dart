// E:\calculator_app\lib\main.dart
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
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: Colors.black),
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
  String userInput = '';
  String result = '0';

  final List<String> buttons = [
    'C', 'DEL', '%', '/',
    '7', '8', '9', '*',
    '4', '5', '6', '-',
    '1', '2', '3', '+',
    '0', '.', '='
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Display area
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                alignment: Alignment.bottomRight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      reverse: true,
                      child: Text(
                        userInput,
                        style: const TextStyle(fontSize: 30, color: Colors.white70),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      result,
                      style: const TextStyle(fontSize: 48, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),

            // Buttons
            Container(
              padding: const EdgeInsets.all(12),
              child: GridView.builder(
                shrinkWrap: true,
                itemCount: buttons.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 1.05),
                itemBuilder: (context, index) {
                  final btn = buttons[index];
                  return ElevatedButton(
                    onPressed: () => _onPressed(btn),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isOperator(btn) ? const Color(0xFFFFB74D) : const Color(0xFF2B2F36),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: EdgeInsets.zero,
                    ),
                    child: Center(child: Text(btn, style: TextStyle(fontSize: 22, color: _isOperator(btn) ? Colors.black : Colors.white))),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isOperator(String x) {
    return x == '/' || x == '*' || x == '-' || x == '+' || x == '=' || x == '%';
  }

  void _onPressed(String btn) {
    setState(() {
      if (btn == 'C') {
        userInput = '';
        result = '0';
        return;
      }

      if (btn == 'DEL') {
        if (userInput.isNotEmpty) userInput = userInput.substring(0, userInput.length - 1);
        return;
      }

      if (btn == '=') {
        _calculate();
        return;
      }

      // Prevent two operators in a row (allow minus at start)
      if (_isOperator(btn)) {
        if (userInput.isEmpty) {
          if (btn == '-') {
            userInput += btn; // allow negative start
          }
          // otherwise ignore leading operator
          return;
        }
        final last = userInput[userInput.length - 1];
        if (_isOperator(last)) {
          // replace last operator with new one (except % — handle differently)
          // If user pressed '%' after an operator, ignore it
          if (btn == '%') return;
          userInput = userInput.substring(0, userInput.length - 1) + btn;
          return;
        }
      }

      // Normal append
      userInput += btn;
    });
  }

  void _calculate() {
    try {
      if (userInput.isEmpty) return;

      String expr = userInput;

      // Replace any unicode operator characters (safe-guard)
      expr = expr.replaceAll('×', '*').replaceAll('÷', '/');

      // Remove trailing operator if any
      if (expr.isNotEmpty && _isOperator(expr[expr.length - 1])) {
        expr = expr.substring(0, expr.length - 1);
      }
      if (expr.isEmpty) return;

      // Convert percentages: "50%" => "(50/100)"
      expr = expr.replaceAllMapped(RegExp(r'(\d+(\.\d+)?)%'), (m) => '(${m[1]}/100)');

      // Prevent accidental leading zeros issues like '00' etc (parser handles this, but keep it simple)

      // Parse and evaluate
      Parser p = Parser();
      Expression parsed = p.parse(expr);
      ContextModel cm = ContextModel();
      double eval = parsed.evaluate(EvaluationType.REAL, cm);

      // Format result: remove trailing .0 and limit decimals
      String out;
      if (
