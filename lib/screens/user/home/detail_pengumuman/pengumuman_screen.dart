import 'package:flutter/material.dart';
import 'package:mobile_ess/widgets/pengumuman_card_widget.dart';

class PengumumanScreen extends StatelessWidget {
  const PengumumanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Pengumuman',
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: List.generate(40, (index) {
            return const PengumumanCardWidget();
          }),
        ),
      ),
    );
  }
}
