import 'package:flutter/material.dart';

class HOmePage extends StatelessWidget {
  const HOmePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Center(child: Text('Authentication SuccessFully'))],
      ),
    );
  }
}
