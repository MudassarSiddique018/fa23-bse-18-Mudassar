import 'package:flutter/material.dart';

void main() {
  runApp(MyPortfolioApp());
}

class MyPortfolioApp extends StatefulWidget {
  @override
  _MyPortfolioAppState createState() => _MyPortfolioAppState();
}

class _MyPortfolioAppState extends State<MyPortfolioApp> {
  // Track current style mode
  String currentStyle = "Classic";

  // Your personal data
  final String name = "Mudassar Siddique";
  final String role = "Flutter Developer | UI Designer";
  final String email = "mmudassarmsiddique@gmail.com";
  final String phone = "0301-4505751";
  final String address = "Vehari, Pakistan";

  // Different images for styles
  final Map<String, String> styleImages = {
    "Classic": "assets/mudassar1.png", // your image 1
    "Modern": "assets/mudassar2.png",  // optional 2nd image
    "Creative": "assets/mudassar3.png", // optional 3rd image
  };

  // Different theme colors for each style
  final Map<String, Color> styleColors = {
    "Classic": Colors.teal,
    "Modern": Colors.deepPurple,
    "Creative": Colors.orange,
  };

  // Switch style
  void changeStyle(String style) {
    setState(() {
      currentStyle = style;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color themeColor = styleColors[currentStyle]!;
    final String image = styleImages[currentStyle]!;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: themeColor.withOpacity(0.08),
        appBar: AppBar(
          backgroundColor: themeColor,
          title: Text("My Portfolio ($currentStyle Style)"),
          centerTitle: true,
        ),
        body: Center(
          child: Card(
            elevation: 14,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            shadowColor: themeColor,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    themeColor.withOpacity(0.2),
                    Colors.white,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ===== Top Title =====
                  const Text(
                    "Professional CV",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ===== Profile Image =====
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage(image),
                  ),
                  const SizedBox(height: 20),

                  // ===== Name =====
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: themeColor,
                    ),
                  ),

                  // ===== Role =====
                  Text(
                    role,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Divider(color: themeColor, thickness: 1),

                  // ===== Contact Info =====
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.email, color: themeColor),
                      const SizedBox(width: 8),
                      Text(email),
                    ],
                  ),
                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.phone, color: themeColor),
                      const SizedBox(width: 8),
                      Text(phone),
                    ],
                  ),
                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.location_on, color: themeColor),
                      const SizedBox(width: 8),
                      Text(address),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

        // ===== Floating Action Buttons =====
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton.extended(
              heroTag: "classic",
              backgroundColor: Colors.teal,
              icon: const Icon(Icons.style),
              label: const Text("Classic"),
              onPressed: () => changeStyle("Classic"),
            ),
            const SizedBox(height: 12),

            FloatingActionButton.extended(
              heroTag: "modern",
              backgroundColor: Colors.deepPurple,
              icon: const Icon(Icons.auto_awesome),
              label: const Text("Modern"),
              onPressed: () => changeStyle("Modern"),
            ),
            const SizedBox(height: 12),

            FloatingActionButton.extended(
              heroTag: "creative",
              backgroundColor: Colors.orange,
              icon: const Icon(Icons.brush),
              label: const Text("Creative"),
              onPressed: () => changeStyle("Creative"),
            ),
          ],
        ),
      ),
    );
  }
}
