import 'package:flutter/material.dart';
import 'package:provider_practive/layout/default_layout.dart';
import 'package:provider_practive/screen/state_provider_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: "Home Screen",
      body: ListView(
        children: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => StateProviderScreen(),
              ),
            ),
            child: Text("State Provider Screen"),
          ),
        ],
      ),
    );
  }
}
