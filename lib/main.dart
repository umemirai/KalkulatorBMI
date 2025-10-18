import 'package:flutter/material.dart';

void main() {
  runApp(const KalkulatorBMIApp());
}

class KalkulatorBMIApp extends StatelessWidget {
  const KalkulatorBMIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Kalkulator BMI - Kemenkes RI",
      debugShowCheckedModeBanner: false,
      home: KalkulatorBMIScreen(),
    );
  }
}

class KalkulatorBMIScreen extends StatefulWidget {
  const KalkulatorBMIScreen({super.key});

  @override
  State<KalkulatorBMIScreen> createState() => _KalkulatorBMIScreenState();
}

class _KalkulatorBMIScreenState extends State<KalkulatorBMIScreen> {
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();

  double? _bmiResult;
  String _bmiInterpretation = "";
  String _gender = "Perempuan";

  void _hitungBMI() {
    final double weight = double.tryParse(_weightController.text) ?? 0;
    final double heightInCM = double.tryParse(_heightController.text) ?? 0;

    if (weight > 0 && heightInCM > 0) {
      final double heightInM = heightInCM / 100;
      final double bmi = weight / (heightInM * heightInM);

      setState(() {
        _bmiResult = bmi;
        // Standar Kemenkes RI (dibedakan gender)
        if (_gender == "Laki-laki") {
          if (bmi < 18.5) {
            _bmiInterpretation = "Kekurangan berat badan";
          } else if (bmi < 25) {
            _bmiInterpretation = "Berat badan ideal";
          } else if (bmi < 27) {
            _bmiInterpretation = "Kelebihan berat badan";
          } else {
            _bmiInterpretation = "Obesitas";
          }
        } else {
          if (bmi < 17) {
            _bmiInterpretation = "Kekurangan berat badan";
          } else if (bmi < 24) {
            _bmiInterpretation = "Berat badan ideal";
          } else if (bmi < 27) {
            _bmiInterpretation = "Kelebihan berat badan";
          } else {
            _bmiInterpretation = "Obesitas";
          }
        }
      });
    } else {
      setState(() {
        _bmiResult = null;
        _bmiInterpretation = "Masukkan data dengan benar!";
      });
    }
  }

  void _resetForm() {
    setState(() {
      _weightController.clear();
      _heightController.clear();
      _bmiResult = null;
      _bmiInterpretation = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            const Text(
              "Kalkulator BMI",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.pink,
              ),
            ),
            const SizedBox(height: 30),

            // --- Pilihan Gender ---
            Text(
              "Pilih Jenis Kelamin",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _genderOption("Laki-laki",
                    "https://cdn-icons-png.flaticon.com/512/2922/2922506.png"),
                _genderOption("Perempuan",
                    "https://cdn-icons-png.flaticon.com/512/2922/2922561.png"),
              ],
            ),
            const SizedBox(height: 40),

            _buildInputField("Tinggi (cm)", _heightController),
            const SizedBox(height: 20),
            _buildInputField("Berat (kg)", _weightController),
            const SizedBox(height: 40),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _hitungBMI,
                  icon: const Icon(Icons.calculate, color: Colors.white,),
                  label: const Text(
                    "Hitung BMI",
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink.shade700,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 16),
                  ),
                ),
                const SizedBox(width: 20),
                OutlinedButton.icon(
                  onPressed: _resetForm,
                  icon: const Icon(Icons.refresh),
                  label: const Text("Reset"),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 16),
                    side: BorderSide(color: Colors.pink.shade700, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    foregroundColor: Colors.pink.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),

            // 
            if (_bmiResult != null)
              Column(
                children: [
                  Text(
                    "BMI Anda:",
                    style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _bmiResult!.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _bmiInterpretation,
                    style: TextStyle(
                      fontSize: 20,
                      color: _getBMIColor(_bmiInterpretation),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Color _getBMIColor(String kategori) {
    switch (kategori) {
      case "Kekurangan berat badan":
        return Colors.orange;
      case "Berat badan ideal":
        return Colors.green;
      case "Kelebihan berat badan":
        return Colors.amber;
      case "Obesitas":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildInputField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$label*", style: const TextStyle(fontSize: 14)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 8),
            border: UnderlineInputBorder(),
          ),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _genderOption(String label, String imageUrl) {
    bool isSelected = _gender == label;
    return GestureDetector(
      onTap: () => setState(() => _gender = label),
      child: Column(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor: isSelected ? Colors.pink[100] : Colors.grey[200],
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Image.network(imageUrl, width: 50),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: isSelected ? Colors.pink.shade700 : Colors.grey[700],
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
