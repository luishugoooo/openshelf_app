import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const FScaffold(child: Center(child: CircularProgressIndicator()));
  }
}
