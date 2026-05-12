import 'package:flutter/material.dart';

import '../models/bmi_calculator.dart';
import '../utils/theme.dart';
import 'result_page.dart';

class InputPage extends StatefulWidget {
  final VoidCallback onThemeToggle;
  final bool isDarkMode;

  const InputPage({
    required this.onThemeToggle,
    required this.isDarkMode,
    super.key,
  });

  @override
  State<InputPage> createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  final _nameController = TextEditingController();

  // ── BMI Standard ───────────────────────────────────────────────────────────
  String _standard = BmiStandard.international;
  bool get _isMetric => _standard == BmiStandard.international;

  // ── Metric values (International) ──────────────────────────────────────────
  double _heightCm = 165;
  double _weightKg = 60;

  // ── Imperial values (American) ─────────────────────────────────────────────
  // Height stored as total inches (39 in = 3'3" … 87 in = 7'3")
  double _heightIn = 65; // 5'5"
  double _weightLbs = 132;

  // ── Other inputs ───────────────────────────────────────────────────────────
  String _gender = 'Laki-laki';
  String _ageCategory = 'Dewasa';

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  String _fmtInches(double totalInches) {
    final ft = totalInches.toInt() ~/ 12;
    final inches = totalInches.toInt() % 12;
    return "$ft' $inches\"";
  }

  void _calculate() {
    final double weight = _isMetric ? _weightKg : _weightLbs;
    final double height = _isMetric ? _heightCm : _heightIn;

    final calculator = BmiCalculator(
      weight: weight,
      height: height,
      standard: _standard,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResultPage(
          nama: _nameController.text.trim().isEmpty
              ? 'User'
              : _nameController.text.trim(),
          calculator: calculator,
          gender: _gender,
          ageCategory: _ageCategory,
        ),
      ),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalkulator BMI'),
        actions: [
          IconButton(
            icon: Icon(
              widget.isDarkMode
                  ? Icons.light_mode_rounded
                  : Icons.dark_mode_rounded,
            ),
            tooltip: widget.isDarkMode ? 'Mode Terang' : 'Mode Gelap',
            onPressed: widget.onThemeToggle,
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Standard Toggle ──────────────────────────────────────────────
            _StandardToggle(
              selected: _standard,
              isDark: isDark,
              onChanged: (value) => setState(() => _standard = value),
            ),
            const SizedBox(height: 20),

            // ── Name ─────────────────────────────────────────────────────────
            _SectionCard(
              child: TextField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Nama',
                  hintText: 'Masukkan nama Anda',
                  prefixIcon: Icon(Icons.person_outline_rounded),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 14),

            // ── Height ───────────────────────────────────────────────────────
            _SliderCard(
              icon: Icons.straighten_rounded,
              label: 'Tinggi Badan',
              displayValue: _isMetric
                  ? '${_heightCm.toInt()} cm'
                  : _fmtInches(_heightIn),
              slider: _isMetric
                  ? Slider(
                      value: _heightCm,
                      min: 100,
                      max: 220,
                      divisions: 120,
                      label: '${_heightCm.toInt()} cm',
                      onChanged: (v) => setState(() => _heightCm = v),
                    )
                  : Slider(
                      value: _heightIn,
                      min: 39,
                      max: 87,
                      divisions: 48,
                      label: _fmtInches(_heightIn),
                      onChanged: (v) => setState(() => _heightIn = v),
                    ),
            ),
            const SizedBox(height: 14),

            // ── Weight ───────────────────────────────────────────────────────
            _SliderCard(
              icon: Icons.monitor_weight_outlined,
              label: 'Berat Badan',
              displayValue: _isMetric
                  ? '${_weightKg.toInt()} kg'
                  : '${_weightLbs.toInt()} lbs',
              slider: _isMetric
                  ? Slider(
                      value: _weightKg,
                      min: 30,
                      max: 150,
                      divisions: 120,
                      label: '${_weightKg.toInt()} kg',
                      onChanged: (v) => setState(() => _weightKg = v),
                    )
                  : Slider(
                      value: _weightLbs,
                      min: 66,
                      max: 330,
                      divisions: 264,
                      label: '${_weightLbs.toInt()} lbs',
                      onChanged: (v) => setState(() => _weightLbs = v),
                    ),
            ),
            const SizedBox(height: 14),

            // ── Age Category ─────────────────────────────────────────────────
            _SectionCard(
              child: DropdownButtonFormField<String>(
                initialValue: _ageCategory,
                decoration: const InputDecoration(
                  labelText: 'Kategori Usia',
                  prefixIcon: Icon(Icons.cake_outlined),
                  border: InputBorder.none,
                ),
                items: ['Anak-anak', 'Remaja', 'Dewasa']
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => setState(() => _ageCategory = v!),
              ),
            ),
            const SizedBox(height: 14),

            // ── Gender ───────────────────────────────────────────────────────
            _GenderSelector(
              selected: _gender,
              isDark: isDark,
              onChanged: (g) => setState(() => _gender = g),
            ),
            const SizedBox(height: 32),

            // ── Calculate Button ─────────────────────────────────────────────
            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: _calculate,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.calculate_rounded, size: 20),
                    SizedBox(width: 10),
                    Text('HITUNG BMI'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

/// Animated pill toggle that switches between International and American BMI
/// standards.
class _StandardToggle extends StatelessWidget {
  final String selected;
  final bool isDark;
  final ValueChanged<String> onChanged;

  const _StandardToggle({
    required this.selected,
    required this.isDark,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
        ),
      ),
      child: Row(
        children: [
          _option(
            context: context,
            value: BmiStandard.international,
            flag: '🌍',
            label: 'Internasional',
            unit: 'kg / cm',
          ),
          _option(
            context: context,
            value: BmiStandard.american,
            flag: '🇺🇸',
            label: 'Amerika',
            unit: 'lbs / ft',
          ),
        ],
      ),
    );
  }

  Widget _option({
    required BuildContext context,
    required String value,
    required String flag,
    required String label,
    required String unit,
  }) {
    final isSelected = selected == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Text(flag, style: const TextStyle(fontSize: 20)),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isSelected
                      ? Colors.white
                      : (isDark ? Colors.white54 : Colors.black54),
                ),
              ),
              Text(
                unit,
                style: TextStyle(
                  fontSize: 11,
                  color: isSelected
                      ? Colors.white70
                      : (isDark ? Colors.white38 : Colors.black38),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Generic card wrapper that adds consistent padding and card styling.
class _SectionCard extends StatelessWidget {
  final Widget child;

  const _SectionCard({required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: child,
      ),
    );
  }
}

/// Card that shows an icon + label, a value badge, and a slider below.
class _SliderCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String displayValue;
  final Widget slider;

  const _SliderCard({
    required this.icon,
    required this.label,
    required this.displayValue,
    required this.slider,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: AppTheme.primary),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: AppTheme.primaryDim,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  displayValue,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primary,
                  ),
                ),
              ),
            ],
          ),
          slider,
        ],
      ),
    );
  }
}

/// Two-option gender selector rendered as tappable icon cards.
class _GenderSelector extends StatelessWidget {
  final String selected;
  final bool isDark;
  final ValueChanged<String> onChanged;

  const _GenderSelector({
    required this.selected,
    required this.isDark,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Jenis Kelamin',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _genderOption(
                context: context,
                value: 'Laki-laki',
                icon: Icons.male_rounded,
                color: Colors.blue,
              ),
              const SizedBox(width: 12),
              _genderOption(
                context: context,
                value: 'Perempuan',
                icon: Icons.female_rounded,
                color: Colors.pinkAccent,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _genderOption({
    required BuildContext context,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    final isSelected = selected == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? color.withValues(alpha: 0.12) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? color : (isDark ? AppTheme.darkBorder : AppTheme.lightBorder),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 30,
                color: isSelected ? color : (isDark ? Colors.white38 : Colors.black38),
              ),
              const SizedBox(height: 6),
              Text(
                value,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
                  color: isSelected ? color : (isDark ? Colors.white54 : Colors.black54),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
