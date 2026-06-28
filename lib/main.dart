// ============================================================
// AGRICYCLE — Digital Platform for Converting Agricultural Waste
// into Rural Micro-enterprises (MSME Innovation Initiative)
// Architecture: Single-file Material 3 Flutter implementation.
// Mentors: Sireesha Chittepu (Vasavi College of Engineering)
// Team: Shreya Burra, Sudugu Akshitha Reddy, Sanjana Dharanikota,
//       Amrutha Varshini, Shiva Sai, Sareddy Nihal Reddy
// ============================================================

import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';

// ─────────────────────────────────────────────────────────────
// 1. HARDWARE DEPENDENCIES & GLOBAL ENGINE
// ─────────────────────────────────────────────────────────────
List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  try {
    cameras = await availableCameras();
  } catch (e) {
    debugPrint('Hardware Camera initialization error: $e');
  }

  runApp(const AgriCycleApp());
}

// ─────────────────────────────────────────────────────────────
// BRAND THEME TOKENS & COLOR PALETTE
// ─────────────────────────────────────────────────────────────
const Color _kPrimary     = Color(0xFF1E5128); // Forest Green Brand Token
const Color _kPrimaryLt   = Color(0xFF2E7D3A);
const Color _kPrimaryDk   = Color(0xFF143D1C);
const Color _kOnPrimary   = Color(0xFFF4F7F5);
const Color _kCanvas      = Color(0xFFF4F7F5); // Off-white canvas
const Color _kSurface     = Color(0xFFFFFFFF);
const Color _kMuted       = Color(0xFF6B7E6F);
const Color _kTextDark    = Color(0xFF112A16);
const Color _kBorder      = Color(0x1F1E5128); // Thin transparent border
const Color _kAmber       = Color(0xFFF9A825);
const Color _kBlue        = Color(0xFF1565C0);
const Color _kEmeraldBg   = Color(0xFFE6F4EA);

// ─────────────────────────────────────────────────────────────
// ROOT APP CONFIGURATION
// ─────────────────────────────────────────────────────────────
class AgriCycleApp extends StatelessWidget {
  const AgriCycleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agri Cycle',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _kPrimary,
          brightness: Brightness.light,
          primary: _kPrimary,
          onPrimary: _kOnPrimary,
          surface: _kSurface,
          onSurface: _kTextDark,
        ),
        scaffoldBackgroundColor: _kCanvas,
        cardTheme: CardThemeData(
          color: _kSurface,
          elevation: 3,
          shadowColor: _kPrimary.withOpacity(0.08),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: _kBorder, width: 1),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: _kPrimary,
          foregroundColor: _kOnPrimary,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: _kOnPrimary,
            letterSpacing: 0.4,
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => const SplashScreen(),
        '/login': (_) => const LoginScreen(),
        '/home': (_) => const MainShell(),
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────
// 2. ENTRANCE GATEWAY: SPLASH SCREEN
// ─────────────────────────────────────────────────────────────
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _pulseAnim = Tween<double>(begin: 0.92, end: 1.08).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );

    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    });
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kPrimary,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_kPrimaryDk, _kPrimary, _kPrimaryLt],
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ScaleTransition(
                    scale: _pulseAnim,
                    child: Container(
                      width: 104,
                      height: 104,
                      decoration: BoxDecoration(
                        color: _kOnPrimary.withOpacity(0.12),
                        shape: BoxShape.circle,
                        border: Border.all(color: _kOnPrimary.withOpacity(0.3), width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          )
                        ],
                      ),
                      child: const Icon(Icons.eco_rounded, size: 56, color: _kOnPrimary),
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'Agri Cycle',
                    style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.w900,
                      color: _kOnPrimary,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      'DIGITAL PLATFORM FOR CONVERTING AGRI-WASTE INTO RURAL MICRO-ENTERPRISES',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: _kOnPrimary.withOpacity(0.8),
                        letterSpacing: 1.2,
                        height: 1.4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),
                  SizedBox(
                    width: 32,
                    height: 32,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: _kOnPrimary.withOpacity(0.85),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 28,
              left: 0,
              right: 0,
              child: Text(
                'MSME Innovation Initiative  •  Vasavi College of Engineering',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  color: _kOnPrimary.withOpacity(0.5),
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// 2. ENTRANCE GATEWAY: LOGIN SCREEN
// ─────────────────────────────────────────────────────────────
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _inputCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  int _selectedRole = 0; // 0: Collection Center / Farmer Hub, 1: Industrial Buyer
  bool _isVerifying = false;

  @override
  void dispose() {
    _inputCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleAuthenticate() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isVerifying = true);
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() => _isVerifying = false);
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kCanvas,
      body: Stack(
        children: [
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Container(
                          width: 76,
                          height: 76,
                          decoration: BoxDecoration(
                            color: _kPrimary.withOpacity(0.1),
                            shape: BoxShape.circle,
                            border: Border.all(color: _kPrimary.withOpacity(0.2), width: 1.5),
                          ),
                          child: const Icon(Icons.eco_rounded, size: 40, color: _kPrimary),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Agri Cycle Portal',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: _kTextDark,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Rural Agri-Waste Valorization & Marketplace Platform',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, color: _kMuted, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 32),

                      // Role Selection Chips
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: _kPrimary.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: _kBorder),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: _RoleChip(
                                title: 'Farmer / SHG Hub',
                                icon: Icons.agriculture_rounded,
                                isSelected: _selectedRole == 0,
                                onTap: () => setState(() => _selectedRole = 0),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: _RoleChip(
                                title: 'Industrial Buyer',
                                icon: Icons.factory_rounded,
                                isSelected: _selectedRole == 1,
                                onTap: () => setState(() => _selectedRole = 1),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Credentials Card
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'ACCOUNT AUTHENTICATION',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: _kMuted,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _inputCtrl,
                                style: const TextStyle(fontSize: 14, color: _kTextDark),
                                decoration: InputDecoration(
                                  labelText: 'Phone Number / Aadhar / Udyam ID',
                                  hintText: 'e.g. 9868 6056 7427',
                                  prefixIcon: const Icon(Icons.person_outline_rounded, color: _kPrimary),
                                  filled: true,
                                  fillColor: _kCanvas,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                validator: (v) =>
                                    (v == null || v.trim().isEmpty) ? 'Please enter your login credential' : null,
                              ),
                              const SizedBox(height: 14),
                              TextFormField(
                                controller: _passCtrl,
                                obscureText: true,
                                style: const TextStyle(fontSize: 14, color: _kTextDark),
                                decoration: InputDecoration(
                                  labelText: 'Security Passcode',
                                  hintText: '••••••••',
                                  prefixIcon: const Icon(Icons.lock_outline_rounded, color: _kPrimary),
                                  filled: true,
                                  fillColor: _kCanvas,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                validator: (v) =>
                                    (v == null || v.length < 4) ? 'Passcode must be at least 4 characters' : null,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Authenticate Button
                      Container(
                        height: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: const LinearGradient(
                            colors: [_kPrimaryDk, _kPrimary, _kPrimaryLt],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: _kPrimary.withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: _handleAuthenticate,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Authenticate Session',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: _kOnPrimary,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward_rounded, color: _kOnPrimary, size: 20),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Verification Overlay
          if (_isVerifying)
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  color: _kPrimaryDk.withOpacity(0.65),
                  child: Center(
                    child: Card(
                      color: _kSurface,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 28),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(color: _kPrimary, strokeWidth: 3.5),
                            SizedBox(height: 20),
                            Text(
                              'Verifying Credentials...',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: _kTextDark,
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              'Syncing offline ledger with cloud matching engine',
                              style: TextStyle(fontSize: 12, color: _kMuted),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _RoleChip extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleChip({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? _kPrimary : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: isSelected ? _kOnPrimary : _kMuted),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? _kOnPrimary : _kMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// 3. WORKSPACE INTEGRATION & 4-TAB NAVIGATION SHELL
// ─────────────────────────────────────────────────────────────
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    DashboardTab(),
    IntakeScanScreen(),
    AnalyticsTab(),
    ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
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
          selectedIndex: _currentIndex,
          height: 68,
          onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.dashboard_outlined),
              selectedIcon: Icon(Icons.dashboard_rounded, color: _kPrimary),
              label: 'Dashboard',
            ),
            NavigationDestination(
              icon: Icon(Icons.camera_enhance_outlined),
              selectedIcon: Icon(Icons.camera_enhance_rounded, color: _kPrimary),
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
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// TAB 1: DASHBOARD & B2B MARKETPLACE MODULE
// ─────────────────────────────────────────────────────────────
class DashboardTab extends StatefulWidget {
  const DashboardTab({super.key});

  @override
  State<DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends State<DashboardTab> {
  bool _showMarketplace = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_showMarketplace ? 'B2B Waste Marketplace' : 'Agri Cycle Dashboard'),
        actions: [
          if (_showMarketplace)
            IconButton(
              icon: const Icon(Icons.grid_view_rounded),
              tooltip: 'Switch to Main Dashboard',
              onPressed: () => setState(() => _showMarketplace = false),
            )
          else
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              onPressed: () {},
            ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _showMarketplace
            ? _B2BMarketplaceView(onBack: () => setState(() => _showMarketplace = false))
            : _DashboardMainView(onOpenMarketplace: () => setState(() => _showMarketplace = true)),
      ),
    );
  }
}

class _DashboardMainView extends StatelessWidget {
  final VoidCallback onOpenMarketplace;

  const _DashboardMainView({required this.onOpenMarketplace});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Greeting Header Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: _kPrimary.withOpacity(0.12),
                    child: const Icon(Icons.agriculture_rounded, color: _kPrimary, size: 28),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome, Vasavi SHG Collection Hub!',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: _kTextDark,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Rural Collection Center #02 • Offline Mode Active',
                          style: TextStyle(fontSize: 11, color: _kMuted),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Ecosystem Metrics & Revenue Tracking
          const Text(
            'WASTE VALORIZATION & REVENUE METRICS',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: _kMuted, letterSpacing: 1.2),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _MetricCard(
                  title: 'Total Biomass Traded',
                  value: '1,420 Tons',
                  change: 'Prevented Stubble Burning',
                  icon: Icons.scale_rounded,
                  color: _kPrimary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MetricCard(
                  title: 'Micro-enterprise Rev.',
                  value: '₹4.82 Lakhs',
                  change: 'Direct Farmer Payouts',
                  icon: Icons.account_balance_wallet_rounded,
                  color: _kAmber,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Monthly Tonnage & Revenue Graph Visualizer
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Biomass Collection & Valuation Trend',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: _kTextDark),
                      ),
                      Text('2026 Season', style: TextStyle(fontSize: 11, color: _kMuted, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: const [
                        _BarVisualizer(heightFactor: 0.4, label: 'Jan'),
                        _BarVisualizer(heightFactor: 0.6, label: 'Feb'),
                        _BarVisualizer(heightFactor: 0.5, label: 'Mar'),
                        _BarVisualizer(heightFactor: 0.8, label: 'Apr'),
                        _BarVisualizer(heightFactor: 0.7, label: 'May'),
                        _BarVisualizer(heightFactor: 0.95, label: 'Jun', isHighlight: true),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Gateway Portal Cards
          const Text(
            'OPERATIONAL GATEWAY PORTALS',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: _kMuted, letterSpacing: 1.2),
          ),
          const SizedBox(height: 12),

          _GatewayCard(
            title: 'Collection Center / Farmer Hub',
            subtitle: 'Catalog raw agri-waste, conduct quality checks & log weighing data',
            icon: Icons.agriculture_rounded,
            badgeText: 'HYBRID OFFLINE MODE ACTIVE',
            color: _kPrimary,
            onTap: () {},
          ),
          const SizedBox(height: 14),

          _GatewayCard(
            title: 'Industrial Buyer Gateway',
            subtitle: 'Access ML matching engine, view waste listings & place bulk supply bids',
            icon: Icons.factory_rounded,
            badgeText: 'B2B MARKETPLACE LIVE',
            color: _kBlue,
            onTap: onOpenMarketplace,
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String change;
  final IconData icon;
  final Color color;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.change,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 12),
            Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: color)),
            const SizedBox(height: 4),
            Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: _kTextDark)),
            const SizedBox(height: 2),
            Text(change, style: const TextStyle(fontSize: 10, color: _kMuted)),
          ],
        ),
      ),
    );
  }
}

class _BarVisualizer extends StatelessWidget {
  final double heightFactor;
  final String label;
  final bool isHighlight;

  const _BarVisualizer({
    required this.heightFactor,
    required this.label,
    this.isHighlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          height: 50 * heightFactor,
          width: 18,
          decoration: BoxDecoration(
            color: isHighlight ? _kPrimary : _kPrimary.withOpacity(0.25),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 10, color: _kMuted, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _GatewayCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String badgeText;
  final Color color;
  final VoidCallback onTap;

  const _GatewayCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.badgeText,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withOpacity(0.2), width: 1.5),
          ),
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: color, size: 26),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: color)),
                        const SizedBox(height: 2),
                        Text(subtitle, style: const TextStyle(fontSize: 11, color: _kMuted, height: 1.3)),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right_rounded, color: color.withOpacity(0.7)),
                ],
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  badgeText,
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: color, letterSpacing: 0.8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── B2B Marketplace Module ─────────────────────────────────────
class _B2BMarketplaceView extends StatelessWidget {
  final VoidCallback onBack;

  const _B2BMarketplaceView({required this.onBack});

  static const _lots = [
    ('Rice Paddy Straw', 'Warangal Collection Center', '1,200 KG', '₹3,800 / Ton', Icons.grass_rounded),
    ('Sugarcane Bagasse', 'Nalgonda Collection Center', '850 KG', '₹5,100 / Ton', Icons.factory_rounded),
    ('Cotton Stalk Biomass', 'Adilabad Collection Center', '2,400 KG', '₹4,200 / Ton', Icons.eco_rounded),
    ('Groundnut Shell Husks', 'Mahbubnagar Hub', '600 KG', '₹6,400 / Ton', Icons.grain_rounded),
    ('Wheat Stubble', 'Karimnagar Center', '1,500 KG', '₹3,200 / Ton', Icons.landscape_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_rounded, color: _kPrimary),
                onPressed: onBack,
              ),
              const SizedBox(width: 8),
              const Text(
                'ML Waste Matching Engine',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: _kTextDark),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ..._lots.map((lot) => Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _kBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(lot.$5, color: _kBlue, size: 24),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(lot.$1, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: _kTextDark)),
                            const SizedBox(height: 2),
                            Text('${lot.$2} • ${lot.$3}', style: const TextStyle(fontSize: 11, color: _kMuted)),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(lot.$4, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: _kBlue)),
                          const SizedBox(height: 6),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _kBlue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: const Text('Place Bid', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// TAB 2: INTAKE SCAN SCREEN (TENSORFLOW LITE & HARDWARE CAMERA)
// ─────────────────────────────────────────────────────────────
class IntakeScanScreen extends StatefulWidget {
  const IntakeScanScreen({super.key});

  @override
  State<IntakeScanScreen> createState() => _IntakeScanScreenState();
}

class _IntakeScanScreenState extends State<IntakeScanScreen>
    with SingleTickerProviderStateMixin {
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  bool _isScanning = false;
  bool _showMetrics = false;

  late AnimationController _laserController;
  late Animation<double> _laserAnimation;

  @override
  void initState() {
    super.initState();

    _laserController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _laserAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _laserController, curve: Curves.easeInOut),
    );

    _initHardwareCamera();
  }

  Future<void> _initHardwareCamera() async {
    if (cameras.isEmpty) return;

    _cameraController = CameraController(
      cameras.first,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    try {
      await _cameraController!.initialize();
      if (mounted) {
        setState(() => _isCameraInitialized = true);
      }
    } catch (e) {
      debugPrint('Error initializing camera controller: $e');
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _laserController.dispose();
    super.dispose();
  }

  void _triggerTFLiteAnalysis() {
    if (_isScanning) return;

    setState(() {
      _isScanning = true;
      _showMetrics = false;
    });

    _laserController.repeat(reverse: true);

    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        _laserController.stop();
        _laserController.reset();
        setState(() {
          _isScanning = false;
          _showMetrics = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Intake Biomass Scan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Viewfinder Container Card
              Card(
                clipBehavior: Clip.antiAlias,
                child: Container(
                  height: 280,
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Stack(
                    children: [
                      // Camera Feed or Fallback Frame
                      if (_isCameraInitialized && _cameraController != null)
                        Center(child: CameraPreview(_cameraController!))
                      else
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.camera_alt_outlined, size: 48, color: Colors.white.withOpacity(0.4)),
                              const SizedBox(height: 12),
                              Text(
                                cameras.isEmpty ? 'Hardware Lens Simulation Mode' : 'Initializing Lens...',
                                style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 13),
                              ),
                            ],
                          ),
                        ),

                      // Targeting Box Overlay
                      Center(
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: _isScanning ? const Color(0xFF00FF66) : _kOnPrimary.withOpacity(0.5),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),

                      // Laser Scanning Line Overlay
                      if (_isScanning)
                        AnimatedBuilder(
                          animation: _laserAnimation,
                          builder: (context, child) {
                            return Positioned(
                              top: 40 + (_laserAnimation.value * 200),
                              left: 40,
                              right: 40,
                              child: Container(
                                height: 3,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF00FF66),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF00FF66).withOpacity(0.8),
                                      blurRadius: 10,
                                      spreadRadius: 2,
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),

                      Positioned(
                        bottom: 12,
                        left: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: _isScanning ? const Color(0xFF00FF66) : Colors.amber,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                _isScanning ? 'SCANNING' : 'LENS READY',
                                style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // High-Contrast Trigger AI TFLite Analysis Button
              SizedBox(
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: _isScanning ? null : _triggerTFLiteAnalysis,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _kPrimary,
                    foregroundColor: Colors.white,
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  icon: _isScanning
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.radar_rounded, color: Colors.white),
                  label: Text(
                    _isScanning ? 'Running TFLite Inference...' : 'Trigger AI TFLite Analysis',
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Dynamic Metric Results View
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (child, anim) {
                  return FadeTransition(
                    opacity: anim,
                    child: SlideTransition(
                      position: Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(anim),
                      child: child,
                    ),
                  );
                },
                child: _showMetrics
                    ? Card(
                        key: const ValueKey('metrics_active'),
                        color: _kEmeraldBg,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: const BorderSide(color: Color(0xFF81C784), width: 1.5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.check_circle_rounded, color: Color(0xFF2E7D32), size: 22),
                                  SizedBox(width: 8),
                                  Text(
                                    'TensorFlow Lite Inspection Complete',
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF1B4D2E)),
                                  ),
                                ],
                              ),
                              const Divider(height: 24, color: Color(0xFFA5D6A7)),
                              const _MetricRow(label: 'Material Group', value: 'Rice Paddy Straw'),
                              const _MetricRow(label: 'Estimated Weight', value: '480 KG'),
                              const _MetricRow(label: 'Moisture Level', value: '12.4% (Optimal Range)'),
                              const _MetricRow(label: 'Sync Status', value: 'Offline SQLite Stored'),
                              const SizedBox(height: 12),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: const LinearProgressIndicator(
                                  value: 0.96,
                                  minHeight: 8,
                                  color: Color(0xFF2E7D32),
                                  backgroundColor: Color(0xFFC8E6C9),
                                ),
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                'AI Classification Accuracy: 96%',
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF2E7D32)),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Card(
                        key: const ValueKey('metrics_idle'),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: const [
                              Icon(Icons.analytics_outlined, color: _kMuted, size: 32),
                              SizedBox(height: 8),
                              Text(
                                'Awaiting AI Edge Scan Trigger',
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _kMuted),
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  final String label;
  final String value;

  const _MetricRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: Color(0xFF2E7D32), fontWeight: FontWeight.w600)),
          Text(value, style: const TextStyle(fontSize: 13, color: Color(0xFF1B4D2E), fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// TAB 3: ANALYTICS (DATA VISUALIZATION LAYOUT PLACEHOLDER)
// ─────────────────────────────────────────────────────────────
class AnalyticsTab extends StatelessWidget {
  const AnalyticsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Supply Chain Analytics')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _kPrimary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.insights_rounded, size: 48, color: _kPrimary),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Agri-Waste Supply Chain Intelligence',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: _kTextDark),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Analytics dashboard module for carbon offset credits, regional biomass yield forecasting, and transparent pricing indices.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: _kMuted, height: 1.4),
                    ),
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

// ─────────────────────────────────────────────────────────────
// TAB 4: PROFILE (TEAM & PROJECT ACCOUNT MANAGEMENT)
// ─────────────────────────────────────────────────────────────
class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agri Cycle Account Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () => Navigator.of(context).pushReplacementNamed('/login'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Account Header Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: _kPrimary.withOpacity(0.15),
                      child: const Text('V', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: _kPrimary)),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Vasavi SHG Hub', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: _kTextDark)),
                          SizedBox(height: 4),
                          Text('Vasavi College of Engineering MSME Node', style: TextStyle(fontSize: 11, color: _kMuted)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Verification Check-Badges
            const Text(
              'PROJECT VERIFICATION',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: _kMuted, letterSpacing: 1.2),
            ),
            const SizedBox(height: 12),
            Row(
              children: const [
                Expanded(child: _VerificationBadge(title: 'Aadhaar Verified', icon: Icons.verified_user_rounded)),
                SizedBox(width: 12),
                Expanded(child: _VerificationBadge(title: 'Udyam Registered', icon: Icons.account_balance_rounded)),
              ],
            ),
            const SizedBox(height: 24),

            // Emerald Ledger Summary Box
            const Text(
              'VALORIZATION FINANCIAL LEDGER',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: _kMuted, letterSpacing: 1.2),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [_kPrimaryDk, _kPrimary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: _kPrimary.withOpacity(0.25),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Farmer Micro-enterprise Ledger', style: TextStyle(fontSize: 13, color: _kOnPrimary, fontWeight: FontWeight.w600)),
                      Icon(Icons.account_balance_wallet_rounded, color: _kAmber, size: 22),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('₹ 2,84,500', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: _kOnPrimary)),
                  const SizedBox(height: 20),
                  const Divider(color: Colors.white24, height: 1),
                  const SizedBox(height: 16),
                  Row(
                    children: const [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Settled Payouts', style: TextStyle(fontSize: 11, color: Colors.white70)),
                            SizedBox(height: 4),
                            Text('₹ 2,42,000', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: _kOnPrimary)),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Pending Escrow', style: TextStyle(fontSize: 11, color: Colors.white70)),
                            SizedBox(height: 4),
                            Text('₹ 42,500', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: _kAmber)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VerificationBadge extends StatelessWidget {
  final String title;
  final IconData icon;

  const _VerificationBadge({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: _kEmeraldBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFF81C784)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF2E7D32), size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF1B4D2E)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
