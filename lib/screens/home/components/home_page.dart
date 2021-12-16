import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Create a Scaffold
    return Scaffold(
      // Create a AppBar
      appBar: AppBar(
        // Create a title
        title: const Text("Home"),
      ),
      // Create a body
      body: const Center(
        // Create a Text Widget
        child: Text("Home Page"),
      ),
    );
  }
}

