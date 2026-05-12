import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  final String nama, gender, kategori;
  final double bmi;

  const ResultPage({required this.nama, required this.bmi, required this.gender, required this.kategori, super.key});

  @override
  Widget build(BuildContext context) {
    // Penentuan warna berdasarkan hasil BMI
    Color statusColor = bmi < 18.5 ? Colors.blue : bmi < 25 ? Colors.green : bmi < 30 ? Colors.orange : Colors.red;
    String statusText = bmi < 18.5 ? "Kurus" : bmi < 25 ? "Normal" : bmi < 30 ? "Overweight" : "Obesitas";

    return Scaffold(
      appBar: AppBar(title: const Text("Hasil")),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            Text(nama, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            Text("$gender | $kategori", style: TextStyle(color: Theme.of(context).hintColor)),
            const SizedBox(height: 30),
            Text(bmi.toStringAsFixed(1), style: TextStyle(fontSize: 80, fontWeight: FontWeight.bold, color: statusColor)),
            Text(statusText, style: TextStyle(fontSize: 24, color: statusColor)),
            const SizedBox(height: 40),
            
            // GAUGE BAR ALA HALODOC
            Row(
              children: [
                _bar(Colors.blue), _bar(Colors.green), _bar(Colors.orange), _bar(Colors.red),
              ],
            ),
            Align(
              alignment: Alignment(
                // Kita hitung rasionya dulu, lalu baru di-clamp rasionya antara 0.0 - 1.0
                ((((bmi - 15) / (40 - 15)).clamp(0.0, 1.0)) * 2) - 1, 
                0,
              ),
              child: const Icon(Icons.arrow_drop_up, size: 35),
            ),
            const SizedBox(height: 30),
            
            // SARAN KESEHATAN
            Container(
              padding: const EdgeInsets.all(15),
              // ignore: deprecated_member_use
              decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
              child: Text(
                statusText == "Normal" ? "Luar biasa! Pertahankan berat badan ideal Anda." : "Perhatikan pola makan Anda dan konsultasikan ke dokter jika perlu.",
                textAlign: TextAlign.center,
              ),
            ),
            const Spacer(),
            ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text("Kembali")),
          ],
        ),
      ),
    );
  }

  Widget _bar(Color c) => Expanded(child: Container(height: 10, color: c, margin: const EdgeInsets.symmetric(horizontal: 1)));
}