import 'package:flutter/material.dart';

import '../models/bmi_calculator.dart';
import '../utils/theme.dart';

class ResultPage extends StatefulWidget {
  final String nama;
  final String gender;
  final String ageCategory;
  final BmiCalculator calculator;

  const ResultPage({
    required this.nama,
    required this.calculator,
    required this.gender,
    required this.ageCategory,
    super.key,
  });

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnim;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _scaleAnim =
        CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ── Derived values ─────────────────────────────────────────────────────────

  double get _bmi => widget.calculator.bmi;
  String get _category => widget.calculator.category;
  Color get _statusColor => AppTheme.categoryColor(_category);
  bool get _isAmerican =>
      widget.calculator.standard == BmiStandard.american;

  /// Maps [bmi] in the range 15–40 to a 0.0–1.0 position along the gauge bar.
  double get _gaugePosition =>
      ((_bmi - 15.0) / (40.0 - 15.0)).clamp(0.0, 1.0);

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil BMI'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnim,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Profile card ───────────────────────────────────────────────
              _buildProfileCard(isDark),
              const SizedBox(height: 16),

              // ── BMI score card ─────────────────────────────────────────────
              _buildScoreCard(isDark),
              const SizedBox(height: 16),

              // ── Gauge card ─────────────────────────────────────────────────
              _buildGaugeCard(isDark),
              const SizedBox(height: 16),

              // ── Advice card ────────────────────────────────────────────────
              _buildAdviceCard(isDark),
              const SizedBox(height: 32),

              // ── Back button ────────────────────────────────────────────────
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.refresh_rounded, size: 20),
                      SizedBox(width: 10),
                      Text('HITUNG ULANG'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Card builders ──────────────────────────────────────────────────────────

  Widget _buildProfileCard(bool isDark) {
    return _CardShell(
      isDark: isDark,
      child: Row(
        children: [
          // Avatar
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: _statusColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              widget.gender == 'Laki-laki'
                  ? Icons.male_rounded
                  : Icons.female_rounded,
              color: _statusColor,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.nama,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${widget.gender} · ${widget.ageCategory}',
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.white54 : Colors.black54,
                  ),
                ),
                Text(
                  _isAmerican ? 'Standar Amerika (lbs / ft)' : 'Standar Internasional (kg / cm)',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreCard(bool isDark) {
    return _CardShell(
      isDark: isDark,
      child: Column(
        children: [
          Text(
            'Indeks Massa Tubuh',
            style: TextStyle(
              fontSize: 13,
              color: isDark ? Colors.white54 : Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          ScaleTransition(
            scale: _scaleAnim,
            child: Text(
              _bmi.toStringAsFixed(1),
              style: TextStyle(
                fontSize: 96,
                fontWeight: FontWeight.w900,
                color: _statusColor,
                height: 1,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
            decoration: BoxDecoration(
              color: _statusColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Text(
              _category,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: _statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGaugeCard(bool isDark) {
    return _CardShell(
      isDark: isDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Rentang BMI',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
          ),
          const SizedBox(height: 16),

          // Colour bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Row(
              children: [
                // Proportional widths based on actual BMI ranges (15–40):
                //   Kurus:      15–18.5 = 3.5  → flex 7
                //   Normal:     18.5–25 = 6.5  → flex 13
                //   Overweight: 25–30   = 5    → flex 10
                //   Obese:      30–40   = 10   → flex 20
                _gaugeSegment(AppTheme.underweight, 7),
                _gaugeSegment(AppTheme.normal, 13),
                _gaugeSegment(AppTheme.overweight, 10),
                _gaugeSegment(AppTheme.obese, 20),
              ],
            ),
          ),

          // Pointer
          LayoutBuilder(
            builder: (ctx, constraints) {
              const arrowWidth = 24.0;
              final leftPos =
                  (_gaugePosition * constraints.maxWidth - arrowWidth / 2)
                      .clamp(0.0, constraints.maxWidth - arrowWidth);
              return Stack(
                children: [
                  const SizedBox(height: 24, width: double.infinity),
                  Positioned(
                    left: leftPos,
                    child: Icon(
                      Icons.arrow_drop_up_rounded,
                      size: arrowWidth + 4,
                      color: _statusColor,
                    ),
                  ),
                ],
              );
            },
          ),

          // Labels row
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _GaugeLabel('Kurus', AppTheme.underweight),
              _GaugeLabel('Normal', AppTheme.normal),
              _GaugeLabel('Overweight', AppTheme.overweight),
              _GaugeLabel('Obesitas', AppTheme.obese),
            ],
          ),
          const SizedBox(height: 4),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _RangeText('<18.5'),
              _RangeText('18.5'),
              _RangeText('25'),
              _RangeText('≥30'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAdviceCard(bool isDark) {
    return _CardShell(
      isDark: isDark,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _statusColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.health_and_safety_rounded,
              color: _statusColor,
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Saran Kesehatan',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                ),
                const SizedBox(height: 6),
                Text(
                  widget.calculator.advice,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.6,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _gaugeSegment(Color color, int flex) {
    return Expanded(
      flex: flex,
      child: Container(height: 12, color: color),
    );
  }
}

// ── Reusable helper widgets ───────────────────────────────────────────────────

/// Provides consistent card styling (background, border, padding, radius).
class _CardShell extends StatelessWidget {
  final bool isDark;
  final Widget child;

  const _CardShell({required this.isDark, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
        ),
      ),
      child: child,
    );
  }
}

class _GaugeLabel extends StatelessWidget {
  final String text;
  final Color color;

  const _GaugeLabel(this.text, this.color);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: color,
      ),
    );
  }
}

class _RangeText extends StatelessWidget {
  final String text;

  const _RangeText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 10, color: Colors.grey),
    );
  }
}
