// ============================================================
// AGRICYCLE — Full Application
// Single-file Material 3 Flutter app. No external packages.
// Screens: Splash → Login → Main Shell (Dashboard / Intake
//          Scan / Analytics / Profile)
// ============================================================

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ─────────────────────────────────────────────────────────────
// BRAND TOKENS  (shared across entire app)
// ─────────────────────────────────────────────────────────────
const _kPrimary   = Color(0xFF1E5128); // deep forest green
const _kPrimaryLt = Color(0xFF2E7D3A); // lighter accent green
const _kPrimaryDk = Color(0xFF143D1C); // darker shade (splash / login)
const _kOnPrimary = Color(0xFFF4F7F5); // near-white on green
const _kCanvas    = Color(0xFFF4F7F5); // background canvas
const _kSurface   = Color(0xFFFFFFFF); // card surface
const _kBorder    = Color(0xFF1E5128); // viewfinder border
const _kMuted     = Color(0xFF8A9E8D); // muted body text
const _kResult    = Color(0xFF14391C); // dark green text
const _kResultBg  = Color(0xFFE6F4EA); // result badge bg
const _kDivider   = Color(0xFFCFE3D2); // subtle divider
const _kAmber     = Color(0xFFF9A825); // earnings / wallet accent
const _kBlue      = Color(0xFF1565C0); // buyer gateway accent

// ─────────────────────────────────────────────────────────────
// ENTRY POINT
// ─────────────────────────────────────────────────────────────
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const AgriCycleApp());
}

// ─────────────────────────────────────────────────────────────
// ROOT APPLICATION
// ─────────────────────────────────────────────────────────────
class AgriCycleApp extends StatelessWidget {
  const AgriCycleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgriCycle',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(),
      initialRoute: '/',
      routes: {
        '/': (_) => const SplashScreen(),
        '/login': (_) => const LoginScreen(),
        '/home': (_) => const MainShell(),
      },
    );
  }

  ThemeData _buildTheme() {
    final cs = ColorScheme.fromSeed(
      seedColor: _kPrimary,
      brightness: Brightness.light,
      primary: _kPrimary,
      onPrimary: _kOnPrimary,
      surface: _kSurface,
      onSurface: _kResult,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: cs,
      scaffoldBackgroundColor: _kCanvas,
      textTheme: const TextTheme(
        displaySmall: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, letterSpacing: -0.5, color: _kPrimary),
        headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: _kPrimary),
        titleMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.2, color: _kResult),
        bodyMedium: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: _kMuted, height: 1.6),
        labelLarge: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, letterSpacing: 0.6, color: _kOnPrimary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _kPrimary,
          foregroundColor: _kOnPrimary,
          elevation: 4,
          shadowColor: _kPrimary.withOpacity(0.40),
          minimumSize: const Size.fromHeight(56),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
      ),
      cardTheme: CardThemeData(
        color: _kSurface,
        elevation: 2,
        shadowColor: _kPrimary.withOpacity(0.12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _kOnPrimary.withOpacity(0.08),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _kOnPrimary, width: 1.5),
        ),
        hintStyle: TextStyle(color: _kOnPrimary.withOpacity(0.55), fontSize: 14),
        labelStyle: TextStyle(color: _kOnPrimary.withOpacity(0.75)),
        prefixIconColor: _kOnPrimary.withOpacity(0.70),
        suffixIconColor: _kOnPrimary.withOpacity(0.70),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: _kPrimary,
        foregroundColor: _kOnPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: _kOnPrimary, letterSpacing: 0.3),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════
// ① SPLASH SCREEN
// ═════════════════════════════════════════════════════════════
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _fadeAnim  = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
    _scaleAnim = Tween<double>(begin: 0.80, end: 1.0)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack));
    _ctrl.forward();

    // Navigate to Login after 2.5 s
    Timer(const Duration(milliseconds: 2500), () {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
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
            // Decorative circles
            Positioned(top: -80, right: -60, child: _DecorCircle(size: 260, opacity: 0.06)),
            Positioned(bottom: -40, left: -80, child: _DecorCircle(size: 300, opacity: 0.05)),
            Positioned(top: 200, left: -100, child: _DecorCircle(size: 220, opacity: 0.04)),
            // Center content
            Center(
              child: FadeTransition(
                opacity: _fadeAnim,
                child: ScaleTransition(
                  scale: _scaleAnim,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Logo placeholder
                      Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          color: _kOnPrimary.withOpacity(0.10),
                          shape: BoxShape.circle,
                          border: Border.all(color: _kOnPrimary.withOpacity(0.25), width: 2),
                        ),
                        child: const Icon(Icons.eco_rounded, size: 60, color: _kOnPrimary),
                      ),
                      const SizedBox(height: 28),
                      const Text(
                        'AgriCycle',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w800,
                          color: _kOnPrimary,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Closing the Agri-Waste Loop',
                        style: TextStyle(
                          fontSize: 14,
                          color: _kOnPrimary.withOpacity(0.70),
                          letterSpacing: 0.5,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 56),
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: _kOnPrimary.withOpacity(0.60),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Version tag
            Positioned(
              bottom: 32,
              left: 0,
              right: 0,
              child: Text(
                'v2.4.1-beta  •  MSME Agri-Waste Initiative',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: _kOnPrimary.withOpacity(0.40), letterSpacing: 0.4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DecorCircle extends StatelessWidget {
  final double size;
  final double opacity;
  const _DecorCircle({required this.size, required this.opacity});
  @override
  Widget build(BuildContext context) => Container(
    width: size, height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.white.withOpacity(opacity),
    ),
  );
}

// ═════════════════════════════════════════════════════════════
// ② LOGIN SCREEN
// ═════════════════════════════════════════════════════════════
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _userCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscurePass = true;
  bool _isLoading = false;

  late AnimationController _slideCtrl;
  late Animation<Offset> _slideAnim;
  late Animation<double>  _fadeAnim;

  @override
  void initState() {
    super.initState();
    _slideCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero)
        .animate(CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOutCubic));
    _fadeAnim  = CurvedAnimation(parent: _slideCtrl, curve: Curves.easeIn);
    _slideCtrl.forward();
  }

  @override
  void dispose() {
    _slideCtrl.dispose();
    _userCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (mounted) Navigator.of(context).pushReplacementNamed('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kPrimary,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [_kPrimaryDk, _kPrimary],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
            child: SlideTransition(
              position: _slideAnim,
              child: FadeTransition(
                opacity: _fadeAnim,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 32),
                      // Logo
                      Center(
                        child: Container(
                          width: 80, height: 80,
                          decoration: BoxDecoration(
                            color: _kOnPrimary.withOpacity(0.10),
                            shape: BoxShape.circle,
                            border: Border.all(color: _kOnPrimary.withOpacity(0.20), width: 1.5),
                          ),
                          child: const Icon(Icons.eco_rounded, size: 42, color: _kOnPrimary),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Center(
                        child: Text('AgriCycle', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: _kOnPrimary, letterSpacing: 0.8)),
                      ),
                      const SizedBox(height: 6),
                      Center(
                        child: Text('Sign in to your account', style: TextStyle(fontSize: 13, color: _kOnPrimary.withOpacity(0.65))),
                      ),
                      const SizedBox(height: 48),

                      // ── Role selector chips ───────────────────
                      _RoleChips(),
                      const SizedBox(height: 32),

                      // ── Username ──────────────────────────────
                      TextFormField(
                        controller: _userCtrl,
                        style: const TextStyle(color: _kOnPrimary, fontSize: 15),
                        decoration: const InputDecoration(
                          labelText: 'Username',
                          hintText: 'e.g. farmer_ravi',
                          prefixIcon: Icon(Icons.person_outline_rounded),
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter a username' : null,
                      ),
                      const SizedBox(height: 16),

                      // ── Password ──────────────────────────────
                      TextFormField(
                        controller: _passCtrl,
                        obscureText: _obscurePass,
                        style: const TextStyle(color: _kOnPrimary, fontSize: 15),
                        decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: '••••••••',
                          prefixIcon: const Icon(Icons.lock_outline_rounded),
                          suffixIcon: IconButton(
                            icon: Icon(_obscurePass ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                            onPressed: () => setState(() => _obscurePass = !_obscurePass),
                          ),
                        ),
                        validator: (v) => (v == null || v.length < 4) ? 'Password too short' : null,
                      ),

                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: Text('Forgot Password?', style: TextStyle(color: _kOnPrimary.withOpacity(0.70), fontSize: 12)),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // ── Login button ──────────────────────────
                      SizedBox(
                        height: 56,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _kOnPrimary,
                            foregroundColor: _kPrimary,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          onPressed: _isLoading ? null : _login,
                          child: _isLoading
                              ? const SizedBox(
                                  width: 24, height: 24,
                                  child: CircularProgressIndicator(strokeWidth: 2.5, color: _kPrimary),
                                )
                              : const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.login_rounded, size: 20),
                                    SizedBox(width: 10),
                                    Text('Sign In', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                                  ],
                                ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ── Register link ─────────────────────────
                      Center(
                        child: TextButton(
                          onPressed: () {},
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(fontSize: 13, color: _kOnPrimary.withOpacity(0.65)),
                              children: const [
                                TextSpan(text: "Don't have an account? "),
                                TextSpan(text: 'Register', style: TextStyle(color: _kOnPrimary, fontWeight: FontWeight.w700, decoration: TextDecoration.underline)),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // ── Government badge ──────────────────────
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: _kOnPrimary.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: _kOnPrimary.withOpacity(0.12)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.verified_rounded, color: _kAmber, size: 20),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Registered under MSME Agri-Waste Initiative, Govt. of Telangana',
                                style: TextStyle(fontSize: 11, color: _kOnPrimary.withOpacity(0.65), height: 1.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Role selector (Farmer / Industrial Buyer) on Login ───────
class _RoleChips extends StatefulWidget {
  @override
  State<_RoleChips> createState() => _RoleChipsState();
}

class _RoleChipsState extends State<_RoleChips> {
  int _selected = 0;
  static const _roles = ['Farmer / SHG Hub', 'Industrial Buyer'];
  static const _icons = [Icons.agriculture_rounded, Icons.factory_rounded];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(_roles.length, (i) {
        final sel = i == _selected;
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _selected = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: EdgeInsets.only(right: i == 0 ? 8 : 0, left: i == 1 ? 8 : 0),
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: sel ? _kOnPrimary.withOpacity(0.15) : Colors.transparent,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: _kOnPrimary.withOpacity(sel ? 0.50 : 0.20), width: 1.5),
              ),
              child: Column(
                children: [
                  Icon(_icons[i], color: sel ? _kOnPrimary : _kOnPrimary.withOpacity(0.45), size: 22),
                  const SizedBox(height: 6),
                  Text(
                    _roles[i],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: sel ? FontWeight.w700 : FontWeight.w400,
                      color: sel ? _kOnPrimary : _kOnPrimary.withOpacity(0.55),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

// ═════════════════════════════════════════════════════════════
// ③ MAIN SHELL (4-tab scaffold)
// ═════════════════════════════════════════════════════════════
class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _tab = 0;

  static const _labels = ['Dashboard', 'Intake Scan', 'Analytics', 'Profile'];
  static const _icons = [
    Icons.dashboard_outlined,
    Icons.document_scanner_outlined,
    Icons.bar_chart_outlined,
    Icons.account_circle_outlined,
  ];
  static const _selectedIcons = [
    Icons.dashboard_rounded,
    Icons.document_scanner_rounded,
    Icons.bar_chart_rounded,
    Icons.account_circle_rounded,
  ];

  final _tabs = const [
    DashboardTab(),
    IntakeScanScreen(),
    AnalyticsTab(),
    ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _tab, children: _tabs),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: _kSurface,
          boxShadow: [BoxShadow(color: _kPrimary.withOpacity(0.08), blurRadius: 16, offset: const Offset(0, -4))],
        ),
        child: NavigationBar(
          backgroundColor: _kSurface,
          indicatorColor: _kPrimary.withOpacity(0.12),
          selectedIndex: _tab,
          height: 68,
          onDestinationSelected: (i) => setState(() => _tab = i),
          destinations: List.generate(4, (i) => NavigationDestination(
            icon: Icon(_icons[i]),
            selectedIcon: Icon(_selectedIcons[i], color: _kPrimary),
            label: _labels[i],
          )),
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════
// ④ DASHBOARD TAB  — role-based entry cards + B2B marketplace
// ═════════════════════════════════════════════════════════════
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
        leading: const Padding(padding: EdgeInsets.all(10), child: _AgriLeafIcon()),
        title: const Text('AgriCycle'),
        actions: [
          if (_showMarketplace)
            IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              tooltip: 'Back to Dashboard',
              onPressed: () => setState(() => _showMarketplace = false),
            )
          else ...[
            IconButton(icon: const Icon(Icons.notifications_outlined), onPressed: () {}),
            const SizedBox(width: 4),
          ],
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        transitionBuilder: (child, anim) => FadeTransition(
          opacity: anim,
          child: SlideTransition(
            position: Tween<Offset>(begin: const Offset(0.04, 0), end: Offset.zero).animate(anim),
            child: child,
          ),
        ),
        child: _showMarketplace
            ? const _B2BMarketplaceView(key: ValueKey('market'))
            : _DashboardHomeView(
                key: const ValueKey('home'),
                onBuyerTap: () => setState(() => _showMarketplace = true),
              ),
      ),
    );
  }
}

// ── Dashboard Home ────────────────────────────────────────────
class _DashboardHomeView extends StatelessWidget {
  final VoidCallback onBuyerTap;
  const _DashboardHomeView({super.key, required this.onBuyerTap});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Greeting
          _DashGreeting(),
          const SizedBox(height: 24),

          // Summary KPI row
          _KpiRow(),
          const SizedBox(height: 28),

          // Section label
          _Label('Select Your Role'),
          const SizedBox(height: 14),

          // ── Farmer / SHG Hub card ────────────────────────
          _RoleEntryCard(
            title: 'Farmer / SHG Hub',
            subtitle: 'Log new batches, track pickups & check earnings',
            icon: Icons.agriculture_rounded,
            accentColor: _kPrimary,
            badgeText: '🌾 ACTIVE HUB',
            badgeBg: _kResultBg,
            badgeFg: _kPrimary,
            stats: const [('Batches This Month', '14'), ('Pending Pickup', '3'), ('Revenue (₹)', '28,450')],
            onTap: () {},
          ),
          const SizedBox(height: 16),

          // ── Industrial Buyer Gateway card ────────────────
          _RoleEntryCard(
            title: 'Industrial Buyer Gateway',
            subtitle: 'Browse live residue listings, place bids & secure supply',
            icon: Icons.factory_rounded,
            accentColor: _kBlue,
            badgeText: '🏭 B2B PORTAL',
            badgeBg: const Color(0xFFE3F2FD),
            badgeFg: _kBlue,
            stats: const [('Active Listings', '38'), ('Open Bids', '7'), ('Avg. Price/Ton', '₹4,200')],
            onTap: onBuyerTap,
          ),
          const SizedBox(height: 28),

          // Recent activity
          _Label('Recent Activity'),
          const SizedBox(height: 14),
          _RecentActivity(),
        ],
      ),
    );
  }
}

class _DashGreeting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: _kPrimary.withOpacity(0.12),
          child: const Text('V', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: _kPrimary)),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Good morning, Vasavi SHG 👋',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: _kResult)),
              Text('Hyderabad Node  •  Last sync: 2 min ago',
                  style: TextStyle(fontSize: 11, color: _kMuted)),
            ],
          ),
        ),
      ],
    );
  }
}

class _KpiRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(child: _KpiCard(label: 'Total Batches', value: '142', icon: Icons.layers_rounded, color: _kPrimary)),
        SizedBox(width: 12),
        Expanded(child: _KpiCard(label: 'Revenue (₹)', value: '2.4L', icon: Icons.account_balance_wallet_rounded, color: _kAmber)),
        SizedBox(width: 12),
        Expanded(child: _KpiCard(label: 'CO₂ Saved', value: '8.1T', icon: Icons.eco_rounded, color: _kPrimaryLt)),
      ],
    );
  }
}

class _KpiCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  const _KpiCard({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _kSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _kDivider),
        boxShadow: [BoxShadow(color: color.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, 3))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: color)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 9, color: _kMuted, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
        ],
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);
  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: _kMuted, letterSpacing: 1.0),
  );
}

class _RoleEntryCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final String badgeText;
  final Color badgeBg;
  final Color badgeFg;
  final List<(String, String)> stats;
  final VoidCallback onTap;

  const _RoleEntryCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
    required this.badgeText,
    required this.badgeBg,
    required this.badgeFg,
    required this.stats,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: _kSurface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: accentColor.withOpacity(0.18), width: 1.5),
          boxShadow: [BoxShadow(color: accentColor.withOpacity(0.07), blurRadius: 14, offset: const Offset(0, 4))],
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [accentColor.withOpacity(0.08), Colors.transparent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 52, height: 52,
                    decoration: BoxDecoration(color: accentColor.withOpacity(0.12), borderRadius: BorderRadius.circular(14)),
                    child: Icon(icon, color: accentColor, size: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: accentColor)),
                        const SizedBox(height: 4),
                        Text(subtitle, style: const TextStyle(fontSize: 11, color: _kMuted, height: 1.4)),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right_rounded, color: accentColor.withOpacity(0.60)),
                ],
              ),
            ),
            const Divider(color: _kDivider, height: 1),
            // Stats row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              child: Row(
                children: stats.map((s) => Expanded(
                  child: Column(
                    children: [
                      Text(s.$2, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: accentColor)),
                      const SizedBox(height: 3),
                      Text(s.$1, textAlign: TextAlign.center, style: const TextStyle(fontSize: 9, color: _kMuted, letterSpacing: 0.3)),
                    ],
                  ),
                )).toList(),
              ),
            ),
            // Badge
            Padding(
              padding: const EdgeInsets.only(left: 18, right: 18, bottom: 14),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(color: badgeBg, borderRadius: BorderRadius.circular(20)),
                  child: Text(badgeText, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: badgeFg, letterSpacing: 0.5)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecentActivity extends StatelessWidget {
  static const _items = [
    (Icons.check_circle_rounded, '480 KG Rice Straw scanned', 'Today, 11:32 AM', Color(0xFF43A047)),
    (Icons.local_shipping_rounded, 'Pickup confirmed by Green Fuels Ltd.', 'Today, 09:15 AM', _kPrimary),
    (Icons.account_balance_wallet_rounded, '₹1,920 credited to wallet', 'Yesterday', _kAmber),
    (Icons.pending_actions_rounded, 'Batch #BT-20240627 awaiting pickup', 'Yesterday', _kMuted),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: _kSurface, borderRadius: BorderRadius.circular(16), border: Border.all(color: _kDivider)),
      child: Column(
        children: List.generate(_items.length, (i) {
          final item = _items[i];
          return Column(
            children: [
              ListTile(
                leading: CircleAvatar(radius: 18, backgroundColor: item.$4.withOpacity(0.12), child: Icon(item.$1, color: item.$4, size: 18)),
                title: Text(item.$2, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _kResult)),
                subtitle: Text(item.$3, style: const TextStyle(fontSize: 11, color: _kMuted)),
                trailing: const Icon(Icons.chevron_right_rounded, color: _kMuted, size: 18),
              ),
              if (i < _items.length - 1) const Divider(color: _kDivider, indent: 56, height: 1),
            ],
          );
        }),
      ),
    );
  }
}

// ── B2B Marketplace View ─────────────────────────────────────
class _B2BMarketplaceView extends StatelessWidget {
  const _B2BMarketplaceView({super.key});

  static const _listings = [
    _Listing('Rice Paddy Straw', 'Karimnagar, Telangana', '1,200 KG', '₹3,800/ton', '14', Color(0xFF43A047), '🌾'),
    _Listing('Sugarcane Bagasse', 'Nalgonda, Telangana', '800 KG', '₹5,200/ton', '6', Color(0xFF1565C0), '🍬'),
    _Listing('Wheat Stubble', 'Warangal, Telangana', '600 KG', '₹2,900/ton', '22', Color(0xFFF57C00), '🌾'),
    _Listing('Cotton Stalks', 'Adilabad, Telangana', '2,000 KG', '₹4,100/ton', '9', Color(0xFF7B1FA2), '🌿'),
    _Listing('Groundnut Shells', 'Mahbubnagar, Telangana', '450 KG', '₹6,500/ton', '3', Color(0xFF00838F), '🥜'),
    _Listing('Corn Cobs', 'Khammam, Telangana', '900 KG', '₹3,200/ton', '18', Color(0xFF558B2F), '🌽'),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header banner
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [_kBlue, Color(0xFF1976D2)]),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), shape: BoxShape.circle),
                  child: const Icon(Icons.storefront_rounded, color: Colors.white, size: 26),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('B2B Residue Marketplace', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white)),
                      SizedBox(height: 3),
                      Text('38 active listings  •  7 open bids', style: TextStyle(fontSize: 11, color: Colors.white70)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['All Types', 'Rice Straw', 'Bagasse', 'Cotton', 'Groundnut']
                  .asMap()
                  .entries
                  .map((e) => Padding(
                        padding: EdgeInsets.only(right: 8, left: e.key == 0 ? 0 : 0),
                        child: FilterChip(
                          label: Text(e.value, style: TextStyle(fontSize: 12, color: e.key == 0 ? _kOnPrimary : _kResult, fontWeight: FontWeight.w600)),
                          selected: e.key == 0,
                          backgroundColor: _kSurface,
                          selectedColor: _kBlue,
                          side: BorderSide(color: e.key == 0 ? _kBlue : _kDivider),
                          onSelected: (_) {},
                        ),
                      ))
                  .toList(),
            ),
          ),
          const SizedBox(height: 16),

          // Listings
          ..._listings.map((l) => Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: _ListingCard(listing: l),
          )),
        ],
      ),
    );
  }
}

class _Listing {
  final String crop;
  final String location;
  final String quantity;
  final String price;
  final String bidsLeft;
  final Color color;
  final String emoji;
  const _Listing(this.crop, this.location, this.quantity, this.price, this.bidsLeft, this.color, this.emoji);
}

class _ListingCard extends StatelessWidget {
  final _Listing listing;
  const _ListingCard({required this.listing});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _kSurface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: listing.color.withOpacity(0.20), width: 1.5),
        boxShadow: [BoxShadow(color: listing.color.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 3))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                // Emoji avatar
                Container(
                  width: 48, height: 48,
                  decoration: BoxDecoration(color: listing.color.withOpacity(0.10), borderRadius: BorderRadius.circular(12)),
                  child: Center(child: Text(listing.emoji, style: const TextStyle(fontSize: 24))),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(listing.crop, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: listing.color)),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Icon(Icons.location_on_rounded, size: 12, color: _kMuted),
                          const SizedBox(width: 3),
                          Text(listing.location, style: const TextStyle(fontSize: 11, color: _kMuted)),
                        ],
                      ),
                    ],
                  ),
                ),
                // Price badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(color: listing.color.withOpacity(0.10), borderRadius: BorderRadius.circular(10)),
                  child: Text(listing.price, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: listing.color)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(color: _kDivider, height: 1),
            const SizedBox(height: 12),
            Row(
              children: [
                _ListingMeta(icon: Icons.scale_rounded, label: listing.quantity),
                const SizedBox(width: 16),
                _ListingMeta(icon: Icons.gavel_rounded, label: '${listing.bidsLeft} bids'),
                const Spacer(),
                SizedBox(
                  height: 36,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: listing.color,
                      minimumSize: Size.zero,
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Place Bid', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ListingMeta extends StatelessWidget {
  final IconData icon;
  final String label;
  const _ListingMeta({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 13, color: _kMuted),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: _kMuted, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

// ═════════════════════════════════════════════════════════════
// ⑤ INTAKE SCAN SCREEN  (UNCHANGED from original)
// ═════════════════════════════════════════════════════════════
class IntakeScanScreen extends StatefulWidget {
  const IntakeScanScreen({super.key});

  @override
  State<IntakeScanScreen> createState() => _IntakeScanScreenState();
}

enum _ScanState { idle, scanning, complete }

class _IntakeScanScreenState extends State<IntakeScanScreen>
    with SingleTickerProviderStateMixin {
  _ScanState _scanState = _ScanState.idle;
  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;

  static const String _kResultPayload =
      '✅ BATCH ANALYSIS COMPLETE\n'
      'Material Group: Rice Paddy Straw\n'
      'Estimated Weight: 480 KG\n'
      'Moisture Level: 12.4% (Optimal Calibration Range)';

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400))..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.6, end: 1.0).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  void _triggerScan() {
    if (_scanState != _ScanState.idle) return;
    setState(() => _scanState = _ScanState.scanning);
    Timer(const Duration(seconds: 2), () { if (mounted) setState(() => _scanState = _ScanState.complete); });
  }

  void _resetScan() => setState(() => _scanState = _ScanState.idle);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Padding(padding: EdgeInsets.all(10), child: _AgriLeafIcon()),
        title: const Text('AgriCycle'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Chip(
              label: const Text('BETA', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: _kPrimary, letterSpacing: 1.2)),
              backgroundColor: _kOnPrimary,
              side: BorderSide.none,
              padding: const EdgeInsets.symmetric(horizontal: 4),
            ),
          ),
          IconButton(icon: const Icon(Icons.settings_outlined), tooltip: 'Settings', onPressed: () {}),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _SectionHeader(icon: Icons.document_scanner_rounded, title: 'Intake Scan', subtitle: 'AI-powered biomass analysis at the farm gate'),
              const SizedBox(height: 24),
              _ViewfinderCard(scanState: _scanState, pulseAnim: _pulseAnim),
              const SizedBox(height: 28),
              _MetaStrip(scanState: _scanState),
              const SizedBox(height: 28),
              _ScanButton(scanState: _scanState, onScan: _triggerScan, onReset: _resetScan),
              const SizedBox(height: 24),
              _DataViewContainer(scanState: _scanState, resultPayload: _kResultPayload),
              const SizedBox(height: 28),
              if (_scanState == _ScanState.complete) _TelemetryFooter(),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Section Header ────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const _SectionHeader({required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48, height: 48,
          decoration: BoxDecoration(color: _kPrimary.withOpacity(0.10), borderRadius: BorderRadius.circular(14)),
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

// ── Viewfinder Card ───────────────────────────────────────────
class _ViewfinderCard extends StatelessWidget {
  final _ScanState scanState;
  final Animation<double> pulseAnim;
  const _ViewfinderCard({required this.scanState, required this.pulseAnim});

  Color get _borderColor {
    switch (scanState) {
      case _ScanState.idle:     return _kBorder;
      case _ScanState.scanning: return const Color(0xFF2E7D3A);
      case _ScanState.complete: return const Color(0xFF43A047);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Container(
        height: 260,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [_kPrimary.withOpacity(0.04), _kCanvas, _kPrimaryLt.withOpacity(0.06)],
          ),
        ),
        child: Stack(
          children: [
            const _GridPattern(),
            Center(
              child: AnimatedBuilder(
                animation: pulseAnim,
                builder: (_, __) {
                  final opacity = scanState == _ScanState.complete ? 1.0 : scanState == _ScanState.scanning ? pulseAnim.value : 0.85;
                  return Opacity(opacity: opacity, child: _ViewfinderBox(scanState: scanState, borderColor: _borderColor));
                },
              ),
            ),
            Positioned(top: 14, right: 14, child: _StatusPill(scanState: scanState)),
            Positioned(
              bottom: 14, left: 0, right: 0,
              child: Center(
                child: Text(
                  scanState == _ScanState.complete ? 'ANALYSIS COMPLETE' : scanState == _ScanState.scanning ? 'SCANNING…' : 'ALIGN BIOMASS IN FRAME',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 2.0, color: _borderColor.withOpacity(0.7)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Viewfinder Box ────────────────────────────────────────────
class _ViewfinderBox extends StatelessWidget {
  final _ScanState scanState;
  final Color borderColor;
  const _ViewfinderBox({required this.scanState, required this.borderColor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180, height: 180,
      child: CustomPaint(
        painter: _DashedBorderPainter(color: borderColor, strokeWidth: 2.8),
        child: Stack(
          children: [
            ..._buildCorners(borderColor),
            Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: scanState == _ScanState.complete
                    ? const Icon(Icons.check_circle_rounded, key: ValueKey('check'), color: Color(0xFF43A047), size: 72)
                    : scanState == _ScanState.scanning
                        ? const SizedBox(key: ValueKey('scan_progress'), width: 64, height: 64, child: CircularProgressIndicator(strokeWidth: 3.5, color: _kPrimaryLt))
                        : const Icon(Icons.camera_enhance_rounded, key: ValueKey('camera'), color: _kPrimary, size: 72),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCorners(Color color) {
    Widget corner({required AlignmentGeometry alignment, required bool top, required bool left}) {
      return Align(
        alignment: alignment,
        child: SizedBox(width: 22, height: 22, child: CustomPaint(painter: _CornerPainter(color: color, thickness: 3.0, top: top, left: left))),
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

// ── Custom Painters ───────────────────────────────────────────
class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  const _DashedBorderPainter({required this.color, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color.withOpacity(0.45)..strokeWidth = strokeWidth..style = PaintingStyle.stroke;
    const dashLen = 8.0; const gapLen = 6.0;
    final rrect = RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.width, size.height), const Radius.circular(12));
    final metric = (Path()..addRRect(rrect)).computeMetrics().first;
    double d = 0;
    while (d < metric.length) { canvas.drawPath(metric.extractPath(d, d + dashLen), paint); d += dashLen + gapLen; }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter old) => old.color != color || old.strokeWidth != strokeWidth;
}

class _CornerPainter extends CustomPainter {
  final Color color; final double thickness; final bool top; final bool left;
  const _CornerPainter({required this.color, required this.thickness, required this.top, required this.left});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..strokeWidth = thickness..strokeCap = StrokeCap.round..style = PaintingStyle.stroke;
    final x0 = left ? 0.0 : size.width; final y0 = top ? 0.0 : size.height;
    canvas.drawLine(Offset(x0, y0), Offset(left ? size.width : 0, y0), paint);
    canvas.drawLine(Offset(x0, y0), Offset(x0, top ? size.height : 0), paint);
  }

  @override
  bool shouldRepaint(_CornerPainter old) => false;
}

class _GridPattern extends StatelessWidget {
  const _GridPattern();
  @override
  Widget build(BuildContext context) => CustomPaint(painter: _GridPainter(), child: const SizedBox.expand());
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = _kPrimary.withOpacity(0.05)..strokeWidth = 1;
    const step = 28.0;
    for (double x = 0; x <= size.width; x += step) canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    for (double y = 0; y <= size.height; y += step) canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
  }
  @override
  bool shouldRepaint(_GridPainter old) => false;
}

// ── Status Pill ───────────────────────────────────────────────
class _StatusPill extends StatelessWidget {
  final _ScanState scanState;
  const _StatusPill({required this.scanState});

  @override
  Widget build(BuildContext context) {
    final (label, bg, fg) = switch (scanState) {
      _ScanState.idle     => ('● STANDBY',  const Color(0xFFFFF3E0), const Color(0xFFF57C00)),
      _ScanState.scanning => ('● ACTIVE',   const Color(0xFFE3F2FD), const Color(0xFF1565C0)),
      _ScanState.complete => ('● VERIFIED', const Color(0xFFE8F5E9), const Color(0xFF2E7D32)),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 6, offset: const Offset(0, 2))]),
      child: Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.8, color: fg)),
    );
  }
}

// ── Meta Strip ────────────────────────────────────────────────
class _MetaStrip extends StatelessWidget {
  final _ScanState scanState;
  const _MetaStrip({required this.scanState});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(color: _kPrimary.withOpacity(0.05), borderRadius: BorderRadius.circular(12), border: Border.all(color: _kDivider)),
      child: Row(
        children: [
          _MetaItem(icon: Icons.memory_rounded, label: 'Edge Node', value: 'AGC-NODE-07'),
          _VertDivider(),
          _MetaItem(icon: Icons.grain_rounded, label: 'Batch ID', value: '#BT-20240628'),
          _VertDivider(),
          _MetaItem(icon: Icons.cloud_sync_rounded, label: 'Sync',
              value: scanState == _ScanState.complete ? 'Uploaded' : 'Pending',
              valueColor: scanState == _ScanState.complete ? const Color(0xFF2E7D32) : _kMuted),
        ],
      ),
    );
  }
}

class _MetaItem extends StatelessWidget {
  final IconData icon; final String label; final String value; final Color? valueColor;
  const _MetaItem({required this.icon, required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(children: [
        Icon(icon, size: 16, color: _kMuted),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600, letterSpacing: 0.8, color: _kMuted)),
        const SizedBox(height: 2),
        Text(value, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: valueColor ?? _kResult), overflow: TextOverflow.ellipsis),
      ]),
    );
  }
}

class _VertDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(width: 1, height: 36, color: _kDivider, margin: const EdgeInsets.symmetric(horizontal: 8));
}

// ── Scan Button ───────────────────────────────────────────────
class _ScanButton extends StatelessWidget {
  final _ScanState scanState; final VoidCallback onScan; final VoidCallback onReset;
  const _ScanButton({required this.scanState, required this.onScan, required this.onReset});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, anim) => FadeTransition(opacity: anim, child: ScaleTransition(scale: anim, child: child)),
      child: switch (scanState) {
        _ScanState.idle => ElevatedButton.icon(key: const ValueKey('btn_idle'), onPressed: onScan, icon: const Icon(Icons.radar_rounded, size: 22), label: const Text('Simulate AI Edge Scan')),
        _ScanState.scanning => ElevatedButton(
          key: const ValueKey('btn_scanning'), onPressed: null,
          style: ElevatedButton.styleFrom(backgroundColor: _kPrimary.withOpacity(0.75), disabledBackgroundColor: _kPrimary.withOpacity(0.75)),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.8, color: _kOnPrimary)),
            const SizedBox(width: 14),
            Text('Analyzing Biomass…', style: Theme.of(context).textTheme.labelLarge?.copyWith(color: _kOnPrimary.withOpacity(0.9))),
          ]),
        ),
        _ScanState.complete => ElevatedButton.icon(
          key: const ValueKey('btn_complete'), onPressed: onReset,
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2E7D3A)),
          icon: const Icon(Icons.refresh_rounded, size: 22), label: const Text('Scan New Batch'),
        ),
      },
    );
  }
}

// ── Data View Container ───────────────────────────────────────
class _DataViewContainer extends StatelessWidget {
  final _ScanState scanState; final String resultPayload;
  const _DataViewContainer({required this.scanState, required this.resultPayload});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: scanState == _ScanState.complete ? _kResultBg : _kSurface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: scanState == _ScanState.complete ? const Color(0xFF81C784) : _kDivider, width: 1.5),
        boxShadow: [BoxShadow(color: scanState == _ScanState.complete ? _kPrimary.withOpacity(0.12) : Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      padding: const EdgeInsets.all(20),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 450),
        transitionBuilder: (child, anim) => FadeTransition(opacity: anim, child: SlideTransition(
          position: Tween<Offset>(begin: const Offset(0, 0.05), end: Offset.zero).animate(anim), child: child)),
        child: scanState == _ScanState.complete
            ? _ResultView(key: const ValueKey('result'), payload: resultPayload)
            : _PlaceholderView(key: const ValueKey('placeholder'), isScanning: scanState == _ScanState.scanning),
      ),
    );
  }
}

class _PlaceholderView extends StatelessWidget {
  final bool isScanning;
  const _PlaceholderView({super.key, required this.isScanning});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Icon(isScanning ? Icons.sensors_rounded : Icons.sensors_off_rounded, size: 18, color: _kMuted),
        const SizedBox(width: 8),
        const Text('SYSTEM STATUS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.6, color: _kMuted)),
      ]),
      const SizedBox(height: 14),
      Text('System status: Awaiting hardware telemetry…', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic)),
      const SizedBox(height: 16),
      _SkeletonBar(width: double.infinity, opacity: 0.18),
      const SizedBox(height: 8),
      _SkeletonBar(width: 200, opacity: 0.12),
      const SizedBox(height: 8),
      _SkeletonBar(width: 150, opacity: 0.09),
    ]);
  }
}

class _SkeletonBar extends StatelessWidget {
  final double width; final double opacity;
  const _SkeletonBar({required this.width, required this.opacity});
  @override
  Widget build(BuildContext context) => Container(
    width: width, height: 10,
    decoration: BoxDecoration(color: _kPrimary.withOpacity(opacity), borderRadius: BorderRadius.circular(6)),
  );
}

class _ResultView extends StatelessWidget {
  final String payload;
  const _ResultView({super.key, required this.payload});

  @override
  Widget build(BuildContext context) {
    final lines = payload.split('\n');
    final headline = lines.first;
    final details = lines.skip(1).toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(color: _kPrimary.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
        child: Text(headline, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: _kPrimary, letterSpacing: 0.3)),
      ),
      const SizedBox(height: 16),
      ...details.map((line) {
        final parts = line.split(':');
        final label = parts.first.trim();
        final value = parts.length > 1 ? line.substring(label.length + 1).trim() : '';
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(margin: const EdgeInsets.only(top: 3), width: 6, height: 6, decoration: const BoxDecoration(color: _kPrimary, shape: BoxShape.circle)),
            const SizedBox(width: 10),
            Expanded(child: RichText(text: TextSpan(children: [
              TextSpan(text: '$label: ', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _kMuted)),
              TextSpan(text: value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: _kResult)),
            ]))),
          ]),
        );
      }),
      const SizedBox(height: 6),
      _ConfidenceBar(label: 'AI Confidence Score', value: 0.94),
    ]);
  }
}

class _ConfidenceBar extends StatelessWidget {
  final String label; final double value;
  const _ConfidenceBar({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: _kMuted)),
        Text('${(value * 100).toStringAsFixed(0)}%', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: _kPrimary)),
      ]),
      const SizedBox(height: 6),
      ClipRRect(borderRadius: BorderRadius.circular(6), child: LinearProgressIndicator(value: value, minHeight: 8, backgroundColor: _kDivider, color: _kPrimary)),
    ]);
  }
}

// ── Telemetry Footer ──────────────────────────────────────────
class _TelemetryFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Divider(color: _kDivider, thickness: 1),
      const SizedBox(height: 12),
      Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: const [
        _TelChip(icon: Icons.thermostat_rounded, label: 'Temp', value: '28°C'),
        _TelChip(icon: Icons.water_drop_rounded, label: 'Humidity', value: '62%'),
        _TelChip(icon: Icons.speed_rounded, label: 'Throughput', value: '2.1 T/h'),
        _TelChip(icon: Icons.bolt_rounded, label: 'Power', value: '3.4 kW'),
      ]),
      const SizedBox(height: 12),
      const Text('Last synced with cloud: just now  •  v2.4.1-edge',
          textAlign: TextAlign.center, style: TextStyle(fontSize: 10, color: _kMuted, letterSpacing: 0.3)),
    ]);
  }
}

class _TelChip extends StatelessWidget {
  final IconData icon; final String label; final String value;
  const _TelChip({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Icon(icon, size: 18, color: _kPrimaryLt),
      const SizedBox(height: 3),
      Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: _kResult)),
      Text(label, style: const TextStyle(fontSize: 9, color: _kMuted, letterSpacing: 0.5)),
    ]);
  }
}

// ═════════════════════════════════════════════════════════════
// ⑥ ANALYTICS TAB  (placeholder — preserved for next sprint)
// ═════════════════════════════════════════════════════════════
class AnalyticsTab extends StatelessWidget {
  const AnalyticsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: const Padding(padding: EdgeInsets.all(10), child: _AgriLeafIcon()), title: const Text('Analytics')),
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: _kPrimary.withOpacity(0.08), shape: BoxShape.circle),
            child: const Icon(Icons.bar_chart_rounded, size: 56, color: _kPrimary),
          ),
          const SizedBox(height: 20),
          const Text('Analytics Dashboard', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: _kPrimary)),
          const SizedBox(height: 8),
          const Text('Coming in the next sprint.', style: TextStyle(fontSize: 13, color: _kMuted)),
        ]),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════
// ⑦ PROFILE TAB  — enhanced account view
// ═════════════════════════════════════════════════════════════
class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Padding(padding: EdgeInsets.all(10), child: _AgriLeafIcon()),
        title: const Text('My Profile'),
        actions: [IconButton(icon: const Icon(Icons.edit_outlined), onPressed: () {})],
      ),
      backgroundColor: _kCanvas,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // ── Hero header ─────────────────────────────────
            _ProfileHero(),
            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Verification badges ──────────────────
                  _VerificationBadges(),
                  const SizedBox(height: 20),

                  // ── Earnings wallet ──────────────────────
                  _EarningsWallet(),
                  const SizedBox(height: 20),

                  // ── Organisation details ─────────────────
                  _OrgDetails(),
                  const SizedBox(height: 20),

                  // ── Account settings ─────────────────────
                  _AccountSettings(),
                  const SizedBox(height: 32),

                  // ── Logout ───────────────────────────────
                  OutlinedButton.icon(
                    onPressed: () => Navigator.of(context).pushReplacementNamed('/login'),
                    icon: const Icon(Icons.logout_rounded, color: Colors.red),
                    label: const Text('Sign Out', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700)),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(52),
                      side: const BorderSide(color: Colors.red, width: 1.5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileHero extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [_kPrimaryDk, _kPrimary]),
      ),
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 28),
      child: Column(
        children: [
          // Avatar
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 44,
                backgroundColor: _kOnPrimary.withOpacity(0.15),
                child: const Text('V', style: TextStyle(fontSize: 36, fontWeight: FontWeight.w800, color: _kOnPrimary)),
              ),
              Container(
                width: 26, height: 26,
                decoration: BoxDecoration(color: _kAmber, shape: BoxShape.circle, border: Border.all(color: _kPrimary, width: 2)),
                child: const Icon(Icons.verified_rounded, size: 14, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Text('Vasavi Lakshmi', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: _kOnPrimary)),
          const SizedBox(height: 4),
          Text('SHG Coordinator  •  Hyderabad', style: TextStyle(fontSize: 12, color: _kOnPrimary.withOpacity(0.70))),
          const SizedBox(height: 14),
          // Stats row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _HeroStat(value: '142', label: 'Batches'),
              _HeroDot(),
              _HeroStat(value: '38', label: 'Pickups'),
              _HeroDot(),
              _HeroStat(value: '4.9★', label: 'Rating'),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  final String value; final String label;
  const _HeroStat({required this.value, required this.label});
  @override
  Widget build(BuildContext context) => Column(children: [
    Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: _kOnPrimary)),
    Text(label, style: TextStyle(fontSize: 11, color: _kOnPrimary.withOpacity(0.65))),
  ]);
}

class _HeroDot extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    width: 4, height: 4, margin: const EdgeInsets.symmetric(horizontal: 16),
    decoration: BoxDecoration(color: _kOnPrimary.withOpacity(0.40), shape: BoxShape.circle),
  );
}

// ── Verification Badges ───────────────────────────────────────
class _VerificationBadges extends StatelessWidget {
  static const _badges = [
    (Icons.verified_rounded, 'Aadhaar Verified', Color(0xFF43A047)),
    (Icons.business_rounded, 'SHG Registered', _kPrimary),
    (Icons.account_balance_rounded, 'Bank Linked', _kBlue),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: _kSurface, borderRadius: BorderRadius.circular(18), border: Border.all(color: _kDivider)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('VERIFICATION STATUS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.5, color: _kMuted)),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _badges.map((b) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(color: b.$3.withOpacity(0.10), borderRadius: BorderRadius.circular(20), border: Border.all(color: b.$3.withOpacity(0.30))),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(b.$1, color: b.$3, size: 14),
                const SizedBox(width: 6),
                Text(b.$2, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: b.$3)),
              ]),
            )).toList(),
          ),
        ],
      ),
    );
  }
}

// ── Earnings Wallet ───────────────────────────────────────────
class _EarningsWallet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF1B4D2E), _kPrimary], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: _kPrimary.withOpacity(0.30), blurRadius: 16, offset: const Offset(0, 6))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(Icons.account_balance_wallet_rounded, color: _kAmber, size: 22),
            const SizedBox(width: 8),
            Text('Active Earnings Wallet', style: TextStyle(fontSize: 13, color: _kOnPrimary.withOpacity(0.80), fontWeight: FontWeight.w600)),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: const Color(0xFF43A047).withOpacity(0.25), borderRadius: BorderRadius.circular(20)),
              child: const Text('● ACTIVE', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: Color(0xFF81C784), letterSpacing: 0.8)),
            ),
          ]),
          const SizedBox(height: 16),
          const Text('₹ 28,450', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: _kOnPrimary)),
          Text('Total Earnings  •  FY 2024–25', style: TextStyle(fontSize: 11, color: _kOnPrimary.withOpacity(0.60))),
          const SizedBox(height: 20),
          Row(children: [
            _WalletStat(label: 'Pending', value: '₹3,200', icon: Icons.pending_rounded),
            Container(width: 1, height: 36, color: _kOnPrimary.withOpacity(0.15), margin: const EdgeInsets.symmetric(horizontal: 20)),
            _WalletStat(label: 'This Month', value: '₹4,800', icon: Icons.trending_up_rounded),
            Container(width: 1, height: 36, color: _kOnPrimary.withOpacity(0.15), margin: const EdgeInsets.symmetric(horizontal: 20)),
            _WalletStat(label: 'Withdrawn', value: '₹20,450', icon: Icons.download_rounded),
          ]),
        ],
      ),
    );
  }
}

class _WalletStat extends StatelessWidget {
  final String label; final String value; final IconData icon;
  const _WalletStat({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Row(children: [
      Icon(icon, size: 12, color: _kOnPrimary.withOpacity(0.60)),
      const SizedBox(width: 4),
      Text(label, style: TextStyle(fontSize: 10, color: _kOnPrimary.withOpacity(0.60))),
    ]),
    const SizedBox(height: 4),
    Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: _kOnPrimary)),
  ]);
}

// ── Organisation Details ──────────────────────────────────────
class _OrgDetails extends StatelessWidget {
  static const _items = [
    (Icons.groups_rounded, 'Organisation', 'Vasavi SHG Hub'),
    (Icons.location_city_rounded, 'Location', 'Hyderabad, Telangana'),
    (Icons.badge_rounded, 'SHG Code', 'TSHG-2023-HYD-0042'),
    (Icons.phone_rounded, 'Contact', '+91 98765 43210'),
    (Icons.alternate_email_rounded, 'Email', 'vasavi.shg@agri.in'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: _kSurface, borderRadius: BorderRadius.circular(18), border: Border.all(color: _kDivider)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: const Text('ORGANISATION DETAILS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.5, color: _kMuted)),
          ),
          ...List.generate(_items.length, (i) {
            final item = _items[i];
            return Column(children: [
              if (i > 0) const Divider(color: _kDivider, height: 1, indent: 56),
              ListTile(
                leading: Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(color: _kPrimary.withOpacity(0.08), borderRadius: BorderRadius.circular(10)),
                  child: Icon(item.$1, color: _kPrimary, size: 18),
                ),
                title: Text(item.$2, style: const TextStyle(fontSize: 11, color: _kMuted, fontWeight: FontWeight.w500)),
                subtitle: Text(item.$3, style: const TextStyle(fontSize: 13, color: _kResult, fontWeight: FontWeight.w700)),
              ),
            ]);
          }),
        ],
      ),
    );
  }
}

// ── Account Settings ──────────────────────────────────────────
class _AccountSettings extends StatelessWidget {
  static const _settings = [
    (Icons.notifications_outlined, 'Notification Preferences', 'Manage alerts & reminders'),
    (Icons.language_rounded, 'Language', 'Telugu / English'),
    (Icons.privacy_tip_outlined, 'Privacy & Data', 'Manage your data'),
    (Icons.help_outline_rounded, 'Help & Support', 'FAQs, contact us'),
    (Icons.info_outline_rounded, 'About AgriCycle', 'v2.4.1-beta'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: _kSurface, borderRadius: BorderRadius.circular(18), border: Border.all(color: _kDivider)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: const Text('ACCOUNT SETTINGS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.5, color: _kMuted)),
          ),
          ...List.generate(_settings.length, (i) {
            final s = _settings[i];
            return Column(children: [
              if (i > 0) const Divider(color: _kDivider, height: 1, indent: 56),
              ListTile(
                leading: Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(color: _kPrimary.withOpacity(0.08), borderRadius: BorderRadius.circular(10)),
                  child: Icon(s.$1, color: _kPrimary, size: 18),
                ),
                title: Text(s.$2, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _kResult)),
                subtitle: Text(s.$3, style: const TextStyle(fontSize: 11, color: _kMuted)),
                trailing: const Icon(Icons.chevron_right_rounded, color: _kMuted),
                onTap: () {},
              ),
            ]);
          }),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════
// SHARED WIDGET — Brand Leaf Icon (AppBar leading)
// ═════════════════════════════════════════════════════════════
class _AgriLeafIcon extends StatelessWidget {
  const _AgriLeafIcon();
  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(color: _kOnPrimary.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
    padding: const EdgeInsets.all(4),
    child: const Icon(Icons.eco_rounded, color: _kOnPrimary, size: 20),
  );
}
