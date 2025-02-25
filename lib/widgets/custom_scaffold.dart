import 'package:flutter/material.dart';

class CustomScaffold extends StatelessWidget {
  const CustomScaffold({super.key, this.child, this.showAppBar = false});
  final Widget? child;
  final bool showAppBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          showAppBar
              ? AppBar(
                iconTheme: const IconThemeData(color: Colors.white),
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context); // Handle back navigation
                },
              ),
              )
              : null,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Image.asset(
            'assets/images/new1.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity, // ✅ Scales image properly
          ),

          SafeArea(child: child!),
        ],
      ),
    );
  }
}
