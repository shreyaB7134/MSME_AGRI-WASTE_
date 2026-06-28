// ============================================================
// AGRICYCLE — Intake Scan Screen
// Single-file Material 3 Flutter app. No external packages.
// ============================================================

import 'dart:async';
import 'package:flutter/material.dart';

// ─────────────────────────────────────────────
// BRAND TOKENS
// ─────────────────────────────────────────────
const _kPrimary    = Color(0xFF1E5128); // deep forest green
const _kPrimaryLt  = Color(0xFF2E7D3A); // lighter green for accents
const _kOnPrimary  = Color(0xFFF4F7F5); // near-white text on green
const _kCanvas     = Color(0xFFF4F7F5); // background canvas
const _kSurface    = Color(0xFFFFFFFF); // card surface
const _kBorder     = Color(0xFF1E5128); // viewfinder border
const _kMuted      = Color(0xFF8A9E8D); // muted body text
const _kResult     = Color(0xFF14391C); // result text (dark green)
const _kResultBg   = Color(0xFFE6F4EA); // result badge background
const _kDivider    = Color(0xFFCFE3D2); // subtle divider

void main() {
  runApp(const AgriCycleApp());
}

// ─────────────────────────────────────────────
// ROOT APPLICATION
// ─────────────────────────────────────────────
class AgriCycleApp extends StatelessWidget {
  const AgriCycleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgriCycle — Intake Scan',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(),
      home: const IntakeScanScreen(),
    );
  }

  ThemeData _buildTheme() {
    final base = ColorScheme.fromSeed(
      seedColor: _kPrimary,
      brightness: Brightness.light,
      primary: _kPrimary,
      onPrimary: _kOnPrimary,
      surface: _kSurface,
      onSurface: _kResult,
      background: _kCanvas,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: base,
      scaffoldBackgroundColor: _kCanvas,
      // ── Typography ──────────────────────────────────────────
      textTheme: const TextTheme(
        displaySmall: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
          color: _kPrimary,
        ),
        headlineSmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: _kPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
          color: _kResult,
        ),
        bodyMedium: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: _kMuted,
          height: 1.6,
        ),
        labelLarge: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.6,
          color: _kOnPrimary,
        ),
      ),
      // ── ElevatedButton ──────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _kPrimary,
          foregroundColor: _kOnPrimary,
          elevation: 4,
          shadowColor: _kPrimary.withOpacity(0.40),
          minimumSize: const Size.fromHeight(56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
      ),
      // ── Card ────────────────────────────────────────────────
      cardTheme: CardThemeData(
        color: _kSurface,
        elevation: 2,
        shadowColor: _kPrimary.withOpacity(0.12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      // ── AppBar ──────────────────────────────────────────────
      appBarTheme: const AppBarTheme(
        backgroundColor: _kPrimary,
        foregroundColor: _kOnPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: _kOnPrimary,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// INTAKE SCAN SCREEN — Stateful root widget
// ─────────────────────────────────────────────
class IntakeScanScreen extends StatefulWidget {
  const IntakeScanScreen({super.key});

  @override
  State<IntakeScanScreen> createState() => _IntakeScanScreenState();
}

// Enum for tracking scan lifecycle
enum _ScanState { idle, scanning, complete }

class _IntakeScanScreenState extends State<IntakeScanScreen>
    with SingleTickerProviderStateMixin {
  _ScanState _scanState = _ScanState.idle;
  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;

  // ── Exact result payload ──────────────────────────────────
  static const String _kResultPayload =
      '✅ BATCH ANALYSIS COMPLETE\n'
      'Material Group: Rice Paddy Straw\n'
      'Estimated Weight: 480 KG\n'
      'Moisture Level: 12.4% (Optimal Calibration Range)';

  @override
  void initState() {
    super.initState();
    // Pulse animation for the viewfinder border when idle/scanning
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _pulseAnim = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  // ── Simulate the AI scan (2-second timer) ────────────────
  void _triggerScan() {
    if (_scanState != _ScanState.idle) return;
    setState(() => _scanState = _ScanState.scanning);

    Timer(const Duration(seconds: 2), () {
      if (mounted) setState(() => _scanState = _ScanState.complete);
    });
  }

  // ── Reset to idle ────────────────────────────────────────
  void _resetScan() {
    setState(() => _scanState = _ScanState.idle);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ── AppBar ────────────────────────────────────────────
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(10),
          child: _AgriLeafIcon(),
        ),
        title: const Text('AgriCycle'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Chip(
              label: const Text(
                'BETA',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: _kPrimary,
                  letterSpacing: 1.2,
                ),
              ),
              backgroundColor: _kOnPrimary,
              side: BorderSide.none,
              padding: const EdgeInsets.symmetric(horizontal: 4),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings',
            onPressed: () {},
          ),
        ],
      ),

      // ── Body ──────────────────────────────────────────────
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Hero title ─────────────────────────────────
              _SectionHeader(
                icon: Icons.document_scanner_rounded,
                title: 'Intake Scan',
                subtitle: 'AI-powered biomass analysis at the farm gate',
              ),

              const SizedBox(height: 24),

              // ── 1. VIEWFINDER CARD ─────────────────────────
              _ViewfinderCard(
                scanState: _scanState,
                pulseAnim: _pulseAnim,
              ),

              const SizedBox(height: 28),

              // ── Session meta strip ─────────────────────────
              _MetaStrip(scanState: _scanState),

              const SizedBox(height: 28),

              // ── 2. SCAN BUTTON ─────────────────────────────
              _ScanButton(
                scanState: _scanState,
                onScan: _triggerScan,
                onReset: _resetScan,
              ),

              const SizedBox(height: 24),

              // ── 3. DYNAMIC DATA VIEW ───────────────────────
              _DataViewContainer(
                scanState: _scanState,
                resultPayload: _kResultPayload,
              ),

              const SizedBox(height: 28),

              // ── Telemetry footer ───────────────────────────
              if (_scanState == _ScanState.complete)
                _TelemetryFooter(),
            ],
          ),
        ),
      ),

      // ── Bottom nav strip ──────────────────────────────────
      bottomNavigationBar: _BottomNav(),
    );
  }
}

// ─────────────────────────────────────────────
// SECTION HEADER
// ─────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _SectionHeader({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: _kPrimary.withOpacity(0.10),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: _kPrimary, size: 26),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.displaySmall),
              const SizedBox(height: 3),
              Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// 1. VIEWFINDER CARD
// ─────────────────────────────────────────────
class _ViewfinderCard extends StatelessWidget {
  final _ScanState scanState;
  final Animation<double> pulseAnim;

  const _ViewfinderCard({
    required this.scanState,
    required this.pulseAnim,
  });

  Color get _borderColor {
    switch (scanState) {
      case _ScanState.idle:
        return _kBorder;
      case _ScanState.scanning:
        return const Color(0xFF2E7D3A);
      case _ScanState.complete:
        return const Color(0xFF43A047);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Container(
        height: 260,
        decoration: BoxDecoration(
          // Subtle mesh gradient background
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              _kPrimary.withOpacity(0.04),
              _kCanvas,
              _kPrimaryLt.withOpacity(0.06),
            ],
          ),
        ),
        child: Stack(
          children: [
            // ── Background grid pattern ─────────────────────
            const _GridPattern(),

            // ── Center viewfinder ───────────────────────────
            Center(
              child: AnimatedBuilder(
                animation: pulseAnim,
                builder: (_, __) {
                  final opacity = scanState == _ScanState.complete
                      ? 1.0
                      : scanState == _ScanState.scanning
                          ? pulseAnim.value
                          : 0.85;
                  return Opacity(
                    opacity: opacity,
                    child: _ViewfinderBox(
                      scanState: scanState,
                      borderColor: _borderColor,
                    ),
                  );
                },
              ),
            ),

            // ── Status badge ────────────────────────────────
            Positioned(
              top: 14,
              right: 14,
              child: _StatusPill(scanState: scanState),
            ),

            // ── Bottom label ─────────────────────────────────
            Positioned(
              bottom: 14,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  scanState == _ScanState.complete
                      ? 'ANALYSIS COMPLETE'
                      : scanState == _ScanState.scanning
                          ? 'SCANNING…'
                          : 'ALIGN BIOMASS IN FRAME',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2.0,
                    color: _borderColor.withOpacity(0.7),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// VIEWFINDER BOX (dashed border + camera icon)
// ─────────────────────────────────────────────
class _ViewfinderBox extends StatelessWidget {
  final _ScanState scanState;
  final Color borderColor;

  const _ViewfinderBox({
    required this.scanState,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      height: 180,
      child: CustomPaint(
        painter: _DashedBorderPainter(color: borderColor, strokeWidth: 2.8),
        child: Stack(
          children: [
            // Corner brackets
            ..._buildCorners(borderColor),
            // Center content
            Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: scanState == _ScanState.complete
                    ? Icon(
                        Icons.check_circle_rounded,
                        key: const ValueKey('check'),
                        color: const Color(0xFF43A047),
                        size: 72,
                      )
                    : scanState == _ScanState.scanning
                        ? const SizedBox(
                            key: ValueKey('scan_progress'),
                            width: 64,
                            height: 64,
                            child: CircularProgressIndicator(
                              strokeWidth: 3.5,
                              color: _kPrimaryLt,
                            ),
                          )
                        : Icon(
                            Icons.camera_enhance_rounded,
                            key: const ValueKey('camera'),
                            color: _kPrimary,
                            size: 72,
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCorners(Color color) {
    const size = 22.0;
    const thick = 3.0;
    final paint = color;

    Widget corner({
      required AlignmentGeometry alignment,
      required bool top,
      required bool left,
    }) {
      return Align(
        alignment: alignment,
        child: SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: _CornerPainter(
              color: paint,
              thickness: thick,
              top: top,
              left: left,
            ),
          ),
        ),
      );
    }

    return [
      corner(alignment: Alignment.topLeft, top: true, left: true),
      corner(alignment: Alignment.topRight, top: true, left: false),
      corner(alignment: Alignment.bottomLeft, top: false, left: true),
      corner(alignment: Alignment.bottomRight, top: false, left: false),
    ];
  }
}

// ─────────────────────────────────────────────
// CUSTOM PAINTER — Dashed border
// ─────────────────────────────────────────────
class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  const _DashedBorderPainter({required this.color, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.45)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    const dashLen = 8.0;
    const gapLen = 6.0;
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(12));
    final path = Path()..addRRect(rrect);

    final metric = path.computeMetrics().first;
    double distance = 0;
    while (distance < metric.length) {
      canvas.drawPath(
        metric.extractPath(distance, distance + dashLen),
        paint,
      );
      distance += dashLen + gapLen;
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter old) =>
      old.color != color || old.strokeWidth != strokeWidth;
}

// ─────────────────────────────────────────────
// CUSTOM PAINTER — Corner L-brackets
// ─────────────────────────────────────────────
class _CornerPainter extends CustomPainter {
  final Color color;
  final double thickness;
  final bool top;
  final bool left;

  const _CornerPainter({
    required this.color,
    required this.thickness,
    required this.top,
    required this.left,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final double x0 = left ? 0 : size.width;
    final double y0 = top ? 0 : size.height;
    final double xEnd = left ? size.width : 0;
    final double yEnd = top ? size.height : 0;

    canvas.drawLine(Offset(x0, y0), Offset(xEnd, y0), paint); // horizontal
    canvas.drawLine(Offset(x0, y0), Offset(x0, yEnd), paint); // vertical
  }

  @override
  bool shouldRepaint(_CornerPainter old) => false;
}

// ─────────────────────────────────────────────
// CUSTOM PAINTER — Background grid
// ─────────────────────────────────────────────
class _GridPattern extends StatelessWidget {
  const _GridPattern();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _GridPainter(),
      child: const SizedBox.expand(),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = _kPrimary.withOpacity(0.05)
      ..strokeWidth = 1;

    const step = 28.0;
    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_GridPainter old) => false;
}

// ─────────────────────────────────────────────
// STATUS PILL
// ─────────────────────────────────────────────
class _StatusPill extends StatelessWidget {
  final _ScanState scanState;

  const _StatusPill({required this.scanState});

  @override
  Widget build(BuildContext context) {
    final (label, bg, fg) = switch (scanState) {
      _ScanState.idle     => ('● STANDBY',     const Color(0xFFFFF3E0), const Color(0xFFF57C00)),
      _ScanState.scanning => ('● ACTIVE',      const Color(0xFFE3F2FD), const Color(0xFF1565C0)),
      _ScanState.complete => ('● VERIFIED',    const Color(0xFFE8F5E9), const Color(0xFF2E7D32)),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.8,
          color: fg,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// META STRIP (session info)
// ─────────────────────────────────────────────
class _MetaStrip extends StatelessWidget {
  final _ScanState scanState;

  const _MetaStrip({required this.scanState});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: _kPrimary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _kDivider),
      ),
      child: Row(
        children: [
          _MetaItem(
            icon: Icons.memory_rounded,
            label: 'Edge Node',
            value: 'AGC-NODE-07',
          ),
          _VertDivider(),
          _MetaItem(
            icon: Icons.grain_rounded,
            label: 'Batch ID',
            value: '#BT-20240628',
          ),
          _VertDivider(),
          _MetaItem(
            icon: Icons.cloud_sync_rounded,
            label: 'Sync',
            value: scanState == _ScanState.complete ? 'Uploaded' : 'Pending',
            valueColor: scanState == _ScanState.complete
                ? const Color(0xFF2E7D32)
                : _kMuted,
          ),
        ],
      ),
    );
  }
}

class _MetaItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _MetaItem({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 16, color: _kMuted),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
              color: _kMuted,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: valueColor ?? _kResult,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _VertDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 36,
      color: _kDivider,
      margin: const EdgeInsets.symmetric(horizontal: 8),
    );
  }
}

// ─────────────────────────────────────────────
// 2. SCAN BUTTON
// ─────────────────────────────────────────────
class _ScanButton extends StatelessWidget {
  final _ScanState scanState;
  final VoidCallback onScan;
  final VoidCallback onReset;

  const _ScanButton({
    required this.scanState,
    required this.onScan,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, anim) =>
          FadeTransition(opacity: anim, child: ScaleTransition(scale: anim, child: child)),
      child: switch (scanState) {
        // ── IDLE: primary action button ─────────────────────
        _ScanState.idle => ElevatedButton.icon(
            key: const ValueKey('btn_idle'),
            onPressed: onScan,
            icon: const Icon(Icons.radar_rounded, size: 22),
            label: const Text('Simulate AI Edge Scan'),
          ),

        // ── SCANNING: loading state ─────────────────────────
        _ScanState.scanning => ElevatedButton(
            key: const ValueKey('btn_scanning'),
            onPressed: null, // disabled while scanning
            style: ElevatedButton.styleFrom(
              backgroundColor: _kPrimary.withOpacity(0.75),
              disabledBackgroundColor: _kPrimary.withOpacity(0.75),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.8,
                    color: _kOnPrimary,
                  ),
                ),
                const SizedBox(width: 14),
                Text(
                  'Analyzing Biomass…',
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(color: _kOnPrimary.withOpacity(0.9)),
                ),
              ],
            ),
          ),

        // ── COMPLETE: reset / re-scan button ─────────────────
        _ScanState.complete => ElevatedButton.icon(
            key: const ValueKey('btn_complete'),
            onPressed: onReset,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D3A),
            ),
            icon: const Icon(Icons.refresh_rounded, size: 22),
            label: const Text('Scan New Batch'),
          ),
      },
    );
  }
}

// ─────────────────────────────────────────────
// 3. DYNAMIC DATA VIEW CONTAINER
// ─────────────────────────────────────────────
class _DataViewContainer extends StatelessWidget {
  final _ScanState scanState;
  final String resultPayload;

  const _DataViewContainer({
    required this.scanState,
    required this.resultPayload,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: scanState == _ScanState.complete ? _kResultBg : _kSurface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: scanState == _ScanState.complete
              ? const Color(0xFF81C784)
              : _kDivider,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: scanState == _ScanState.complete
                ? _kPrimary.withOpacity(0.12)
                : Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 450),
        transitionBuilder: (child, anim) =>
            FadeTransition(opacity: anim, child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.05),
                end: Offset.zero,
              ).animate(anim),
              child: child,
            )),
        child: scanState == _ScanState.complete
            ? _ResultView(key: const ValueKey('result'), payload: resultPayload)
            : _PlaceholderView(
                key: const ValueKey('placeholder'),
                isScanning: scanState == _ScanState.scanning,
              ),
      ),
    );
  }
}

// ── Placeholder (idle / scanning) ──────────────────────────
class _PlaceholderView extends StatelessWidget {
  final bool isScanning;

  const _PlaceholderView({super.key, required this.isScanning});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header row
        Row(
          children: [
            Icon(
              isScanning ? Icons.sensors_rounded : Icons.sensors_off_rounded,
              size: 18,
              color: _kMuted,
            ),
            const SizedBox(width: 8),
            Text(
              'SYSTEM STATUS',
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.6,
                color: _kMuted,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        // Status message
        Text(
          'System status: Awaiting hardware telemetry…',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 16),
        // Skeleton shimmer bars
        _SkeletonBar(width: double.infinity, opacity: 0.18),
        const SizedBox(height: 8),
        _SkeletonBar(width: 200, opacity: 0.12),
        const SizedBox(height: 8),
        _SkeletonBar(width: 150, opacity: 0.09),
      ],
    );
  }
}

class _SkeletonBar extends StatelessWidget {
  final double width;
  final double opacity;

  const _SkeletonBar({required this.width, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 10,
      decoration: BoxDecoration(
        color: _kPrimary.withOpacity(opacity),
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}

// ── Result view ────────────────────────────────────────────
class _ResultView extends StatelessWidget {
  final String payload;

  const _ResultView({super.key, required this.payload});

  @override
  Widget build(BuildContext context) {
    final lines = payload.split('\n');
    final headline = lines.first;
    final details = lines.skip(1).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Headline badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: _kPrimary.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            headline,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: _kPrimary,
              letterSpacing: 0.3,
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Detail rows
        ...details.map((line) {
          final parts = line.split(':');
          final label = parts.first.trim();
          final value = parts.length > 1
              ? line.substring(label.length + 1).trim()
              : '';

          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 3),
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: _kPrimary,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '$label: ',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: _kMuted,
                          ),
                        ),
                        TextSpan(
                          text: value,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: _kResult,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),

        const SizedBox(height: 6),

        // Confidence bar
        _ConfidenceBar(label: 'AI Confidence Score', value: 0.94),
      ],
    );
  }
}

class _ConfidenceBar extends StatelessWidget {
  final String label;
  final double value; // 0.0 – 1.0

  const _ConfidenceBar({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: _kMuted,
              ),
            ),
            Text(
              '${(value * 100).toStringAsFixed(0)}%',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: _kPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 8,
            backgroundColor: _kDivider,
            color: _kPrimary,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// TELEMETRY FOOTER (shown only after scan)
// ─────────────────────────────────────────────
class _TelemetryFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(color: _kDivider, thickness: 1),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            _TelChip(icon: Icons.thermostat_rounded, label: 'Temp', value: '28°C'),
            _TelChip(icon: Icons.water_drop_rounded, label: 'Humidity', value: '62%'),
            _TelChip(icon: Icons.speed_rounded, label: 'Throughput', value: '2.1 T/h'),
            _TelChip(icon: Icons.bolt_rounded, label: 'Power', value: '3.4 kW'),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          'Last synced with cloud: just now  •  v2.4.1-edge',
          style: const TextStyle(
            fontSize: 10,
            color: _kMuted,
            letterSpacing: 0.3,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _TelChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _TelChip({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 18, color: _kPrimaryLt),
        const SizedBox(height: 3),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: _kResult,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 9, color: _kMuted, letterSpacing: 0.5),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// BOTTOM NAVIGATION BAR
// ─────────────────────────────────────────────
class _BottomNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _kSurface,
        boxShadow: [
          BoxShadow(
            color: _kPrimary.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: NavigationBar(
        backgroundColor: _kSurface,
        indicatorColor: _kPrimary.withOpacity(0.12),
        selectedIndex: 1,
        height: 68,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard_rounded, color: _kPrimary),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.document_scanner_outlined),
            selectedIcon: Icon(Icons.document_scanner_rounded, color: _kPrimary),
            label: 'Intake Scan',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart_rounded, color: _kPrimary),
            label: 'Analytics',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_circle_outlined),
            selectedIcon: Icon(Icons.account_circle_rounded, color: _kPrimary),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// BRAND LEAF ICON (AppBar leading)
// ─────────────────────────────────────────────
class _AgriLeafIcon extends StatelessWidget {
  const _AgriLeafIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _kOnPrimary.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(4),
      child: const Icon(Icons.eco_rounded, color: _kOnPrimary, size: 20),
    );
  }
}
