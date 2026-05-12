import 'package:flutter/material.dart';
import 'result_page.dart';

class InputPage extends StatefulWidget {
  final VoidCallback onThemeToggle;
  final bool isDarkMode;

const InputPage({required this.onThemeToggle, required this.isDarkMode, super.key});

  @override
  State<InputPage> createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  final _nameController = TextEditingController();
  double _weight = 60;
  double _height = 165;
  String _gender = 'Laki-laki';
  String _category = 'Dewasa'; // Default kategori kembali ke Dewasa

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kalkulator BMI"),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: widget.onThemeToggle, // Fungsi ganti tema dari main.dart
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Nama", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 25),
            _labelValue("Tinggi Badan", "${_height.toInt()} cm"),
            Slider(value: _height, min: 100, max: 220, onChanged: (v) => setState(() => _height = v)),
            const SizedBox(height: 20),
            _labelValue("Berat Badan", "${_weight.toInt()} kg"),
            Slider(value: _weight, min: 30, max: 150, onChanged: (v) => setState(() => _weight = v)),
            const SizedBox(height: 25),
            
            // MENGEMBALIKAN DROPDOWN KATEGORI
            DropdownButtonFormField<String>(
              // ignore: deprecated_member_use
              value: _category,
              decoration: const InputDecoration(labelText: "Kategori Usia", border: OutlineInputBorder()),
              items: ['Anak-anak', 'Remaja', 'Dewasa'].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (v) => setState(() => _category = v!),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                _chip("Laki-laki"), const SizedBox(width: 10),
                _chip("Perempuan"),
              ],
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  final bmi = _weight / ((_height / 100) * (_height / 100));
                  Navigator.push(context, MaterialPageRoute(builder: (c) => ResultPage(
                    nama: _nameController.text.isEmpty ? "User" : _nameController.text,
                    bmi: bmi, gender: _gender, kategori: _category,
                  )));
                },
                child: const Text("HITUNG"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _labelValue(String t, String v) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [Text(t), Text(v, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))],
  );

  Widget _chip(String l) => ChoiceChip(
    label: Text(l), selected: _gender == l, onSelected: (s) => setState(() => _gender = l),
  );
}