import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const SmartLitterApp());
}

// ============================================================
// APP
// ============================================================

class SmartLitterApp extends StatefulWidget {
  const SmartLitterApp({super.key});

  @override
  State<SmartLitterApp> createState() => _SmartLitterAppState();
}

class _SmartLitterAppState extends State<SmartLitterApp> {
  ThemeMode themeMode = ThemeMode.light;
  bool useKg = true;

  bool weightAlerts = true;
  bool litterAlerts = true;
  bool odourAlerts = true;

  List<CatProfile> cats = [
    CatProfile(
      name: 'Kujza',
      weightKg: 4.8,
      visitsToday: 3,
      lastVisit: '3:15 PM',
      emoji: '🐱',
      weightHistoryKg: [
        4.9,
        4.9,
        4.85,
        4.85,
        4.8,
        4.8,
        4.8,
      ],
      recentVisits: [
        CatVisit(time: '3:15 PM', weightKg: 4.8),
        CatVisit(time: '11:24 AM', weightKg: 4.8),
        CatVisit(time: '7:42 AM', weightKg: 4.9),
      ],
    ),
    CatProfile(
      name: 'Zeusu',
      weightKg: 5.2,
      visitsToday: 2,
      lastVisit: '1:42 PM',
      emoji: '😺',
      weightHistoryKg: [
        5.1,
        5.1,
        5.15,
        5.2,
        5.2,
        5.2,
        5.2,
      ],
      recentVisits: [
        CatVisit(time: '1:42 PM', weightKg: 5.2),
        CatVisit(time: '8:18 AM', weightKg: 5.2),
      ],
    ),
    CatProfile(
      name: 'Okja',
      weightKg: 4.5,
      visitsToday: 4,
      lastVisit: '2:37 PM',
      emoji: '🐈',
      weightHistoryKg: [
        4.55,
        4.55,
        4.5,
        4.5,
        4.5,
        4.5,
        4.5,
      ],
      recentVisits: [
        CatVisit(time: '2:37 PM', weightKg: 4.5),
        CatVisit(time: '12:15 PM', weightKg: 4.5),
        CatVisit(time: '8:03 AM', weightKg: 4.5),
        CatVisit(time: '5:50 AM', weightKg: 4.5),
      ],
    ),
  ];

  void changeTheme(ThemeMode newTheme) {
    setState(() {
      themeMode = newTheme;
    });
  }

  void changeWeightUnit(bool value) {
    setState(() {
      useKg = value;
    });
  }

  void updateAlerts({
    bool? weight,
    bool? litter,
    bool? odour,
  }) {
    setState(() {
      if (weight != null) weightAlerts = weight;
      if (litter != null) litterAlerts = litter;
      if (odour != null) odourAlerts = odour;
    });
  }

  void updateCat(int index, CatProfile updatedCat) {
    setState(() {
      cats[index] = updatedCat;
    });
  }

  void addCat(CatProfile newCat) {
    setState(() {
      cats.add(newCat);
    });
  }

  void deleteCat(int index) {
    setState(() {
      cats.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Litter Mat',
      themeMode: themeMode,

      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        textTheme: GoogleFonts.nunitoTextTheme(),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFD9B8FF),
          brightness: Brightness.light,
        ),
      ),

      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        textTheme: GoogleFonts.nunitoTextTheme(
          ThemeData.dark().textTheme,
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFD9B8FF),
          brightness: Brightness.dark,
        ),
      ),

      home: MainNavigationPage(
        cats: cats,
        useKg: useKg,
        themeMode: themeMode,
        weightAlerts: weightAlerts,
        litterAlerts: litterAlerts,
        odourAlerts: odourAlerts,
        onThemeChanged: changeTheme,
        onWeightUnitChanged: changeWeightUnit,
        onAlertsChanged: updateAlerts,
        onCatUpdated: updateCat,
        onCatAdded: addCat,
        onCatDeleted: deleteCat,
      ),
    );
  }
}

// ============================================================
// CAT VISIT MODEL
// ============================================================

class CatVisit {
  final String time;
  final double weightKg;

  CatVisit({
    required this.time,
    required this.weightKg,
  });
}

// ============================================================
// CAT PROFILE MODEL
// ============================================================

class CatProfile {
  final String name;
  final double weightKg;
  final int visitsToday;
  final String lastVisit;
  final String emoji;

  final DateTime? birthday;
  final String sex;
  final bool isSpayedNeutered;

  final double? normalWeightMinKg;
  final double? normalWeightMaxKg;

  final bool rfidPaired;
  final String? rfidTagId;

  final String notes;

  final List<double> weightHistoryKg;
  final List<CatVisit> recentVisits;

  CatProfile({
    required this.name,
    required this.weightKg,
    required this.visitsToday,
    required this.lastVisit,
    required this.emoji,
    this.birthday,
    this.sex = 'Unknown',
    this.isSpayedNeutered = false,
    this.normalWeightMinKg,
    this.normalWeightMaxKg,
    this.rfidPaired = false,
    this.rfidTagId,
    this.notes = '',
    this.weightHistoryKg = const [],
    this.recentVisits = const [],
  });

  int? get age {
    if (birthday == null) return null;

    final today = DateTime.now();

    int years = today.year - birthday!.year;

    if (today.month < birthday!.month ||
        (today.month == birthday!.month &&
            today.day < birthday!.day)) {
      years--;
    }

    return years;
  }

  CatProfile copyWith({
    String? name,
    double? weightKg,
    int? visitsToday,
    String? lastVisit,
    String? emoji,
    DateTime? birthday,
    String? sex,
    bool? isSpayedNeutered,
    double? normalWeightMinKg,
    double? normalWeightMaxKg,
    bool? rfidPaired,
    String? rfidTagId,
    String? notes,
    List<double>? weightHistoryKg,
    List<CatVisit>? recentVisits,
  }) {
    return CatProfile(
      name: name ?? this.name,
      weightKg: weightKg ?? this.weightKg,
      visitsToday: visitsToday ?? this.visitsToday,
      lastVisit: lastVisit ?? this.lastVisit,
      emoji: emoji ?? this.emoji,
      birthday: birthday ?? this.birthday,
      sex: sex ?? this.sex,
      isSpayedNeutered:
          isSpayedNeutered ?? this.isSpayedNeutered,
      normalWeightMinKg:
          normalWeightMinKg ?? this.normalWeightMinKg,
      normalWeightMaxKg:
          normalWeightMaxKg ?? this.normalWeightMaxKg,
      rfidPaired: rfidPaired ?? this.rfidPaired,
      rfidTagId: rfidTagId ?? this.rfidTagId,
      notes: notes ?? this.notes,
      weightHistoryKg:
          weightHistoryKg ?? this.weightHistoryKg,
      recentVisits: recentVisits ?? this.recentVisits,
    );
  }
}

// ============================================================
// MAIN NAVIGATION
// ============================================================

class MainNavigationPage extends StatefulWidget {
  final List<CatProfile> cats;
  final bool useKg;
  final ThemeMode themeMode;

  final bool weightAlerts;
  final bool litterAlerts;
  final bool odourAlerts;

  final ValueChanged<ThemeMode> onThemeChanged;
  final ValueChanged<bool> onWeightUnitChanged;

  final void Function({
    bool? weight,
    bool? litter,
    bool? odour,
  }) onAlertsChanged;

  final void Function(
    int index,
    CatProfile updatedCat,
  ) onCatUpdated;

  final ValueChanged<CatProfile> onCatAdded;
  final ValueChanged<int> onCatDeleted;

  const MainNavigationPage({
    super.key,
    required this.cats,
    required this.useKg,
    required this.themeMode,
    required this.weightAlerts,
    required this.litterAlerts,
    required this.odourAlerts,
    required this.onThemeChanged,
    required this.onWeightUnitChanged,
    required this.onAlertsChanged,
    required this.onCatUpdated,
    required this.onCatAdded,
    required this.onCatDeleted,
  });

  @override
  State<MainNavigationPage> createState() =>
      _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int selectedIndex = 0;

  void changePage(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  List<Widget> get pages => [
        HomePage(
          cats: widget.cats,
          useKg: widget.useKg,
        ),

        CatsPage(
          cats: widget.cats,
          useKg: widget.useKg,
        ),

        const AlertsPage(),

        SettingsPage(
          cats: widget.cats,
          useKg: widget.useKg,
          themeMode: widget.themeMode,
          weightAlerts: widget.weightAlerts,
          litterAlerts: widget.litterAlerts,
          odourAlerts: widget.odourAlerts,
          onThemeChanged: widget.onThemeChanged,
          onWeightUnitChanged: widget.onWeightUnitChanged,
          onAlertsChanged: widget.onAlertsChanged,
          onCatUpdated: widget.onCatUpdated,
          onCatAdded: widget.onCatAdded,
          onCatDeleted: widget.onCatDeleted,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedIndex],

      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: changePage,

        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),

          NavigationDestination(
            icon: Icon(Icons.pets_outlined),
            selectedIcon: Icon(Icons.pets),
            label: 'Cats',
          ),

          NavigationDestination(
            icon: Icon(Icons.notifications_none),
            selectedIcon: Icon(Icons.notifications),
            label: 'Alerts',
          ),

          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

// ============================================================
// HOME PAGE
// ============================================================

class HomePage extends StatelessWidget {
  final List<CatProfile> cats;
  final bool useKg;

  const HomePage({
    super.key,
    required this.cats,
    required this.useKg,
  });

  String formatWeight(double kg) {
    if (useKg) {
      return '${kg.toStringAsFixed(1)} kg';
    }

    return '${(kg * 2.20462).toStringAsFixed(1)} lb';
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor:
          Theme.of(context).brightness == Brightness.light
              ? const Color(0xFFFFF8FD)
              : colors.surface,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,

        title: const Text(
          'Smart Litter Mat',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 23,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 24),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),

              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFF0D9FF),
                    Color(0xFFFFEAF5),
                  ],
                ),
                borderRadius: BorderRadius.circular(26),
              ),

              child: const Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [
                        Text(
                          'Good afternoon! 🐾',
                          style: TextStyle(
                            fontSize: 27,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF3F3349),
                          ),
                        ),

                        SizedBox(height: 6),

                        Text(
                          'Everything looks good today.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF594D61),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Text(
                    '🐱',
                    style: TextStyle(
                      fontSize: 54,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            const Text(
              'Your Cats',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 14),

            if (cats.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: Text(
                    'No cats added yet 🐾',
                  ),
                ),
              ),

            ...List.generate(
              cats.length,
              (index) {
                final cat = cats[index];

                const accentColors = [
                  Color(0xFFE8D7FF),
                  Color(0xFFD9F0FF),
                  Color(0xFFFFE0EB),
                ];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),

                  child: CatCard(
                    name: cat.name,
                    weight: formatWeight(cat.weightKg),
                    visits:
                        '${cat.visitsToday} visits today',
                    lastVisit:
                        'Last visit: ${cat.lastVisit}',
                    accentColor:
                        accentColors[
                            index % accentColors.length],
                    catEmoji: cat.emoji,
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            const Text(
              'Litter Box Status',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 14),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(24),

                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 14,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),

              child: const Row(
                children: [
                  Icon(
                    Icons.air_rounded,
                    size: 38,
                    color: Color(0xFF4A9565),
                  ),

                  SizedBox(width: 16),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [
                        Text(
                          'Air Quality',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),

                        SizedBox(height: 5),

                        Text(
                          'Normal',
                          style: TextStyle(
                            color: Color(0xFF4A9565),
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        Text(
                          'Sensor reading: 500',
                        ),
                      ],
                    ),
                  ),

                  Icon(
                    Icons.check_circle_rounded,
                    color: Color(0xFF4A9565),
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

// ============================================================
// CATS PAGE
// ============================================================

class CatsPage extends StatelessWidget {
  final List<CatProfile> cats;
  final bool useKg;

  const CatsPage({
    super.key,
    required this.cats,
    required this.useKg,
  });

  String formatWeight(double kg) {
    if (useKg) {
      return '${kg.toStringAsFixed(1)} kg';
    }

    return '${(kg * 2.20462).toStringAsFixed(1)} lb';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,

        title: const Text(
          'My Cats',
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
      ),

      body: cats.isEmpty
          ? const Center(
              child: Text(
                'No cats added yet 🐾',
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(18),
              itemCount: cats.length,

              separatorBuilder: (_, __) =>
                  const SizedBox(height: 14),

              itemBuilder: (context, index) {
                final cat = cats[index];

                const accentColors = [
                  Color(0xFFE8D7FF),
                  Color(0xFFD9F0FF),
                  Color(0xFFFFE0EB),
                ];

                return InkWell(
                  borderRadius: BorderRadius.circular(24),

                  onTap: () {
                    Navigator.push(
                      context,

                      MaterialPageRoute(
                        builder: (_) => CatDashboardPage(
                          cat: cat,
                          useKg: useKg,
                        ),
                      ),
                    );
                  },

                  child: CatCard(
                    name: cat.name,
                    weight: formatWeight(cat.weightKg),
                    visits:
                        '${cat.visitsToday} visits today',
                    lastVisit:
                        'Last visit: ${cat.lastVisit}',
                    accentColor:
                        accentColors[
                            index % accentColors.length],
                    catEmoji: cat.emoji,
                  ),
                );
              },
            ),
    );
  }
}

// ============================================================
// CAT DASHBOARD
// ============================================================

class CatDashboardPage extends StatelessWidget {
  final CatProfile cat;
  final bool useKg;

  const CatDashboardPage({
    super.key,
    required this.cat,
    required this.useKg,
  });

  double convertWeight(double kg) {
    return useKg ? kg : kg * 2.20462;
  }

  String formatWeight(double kg) {
    final value = convertWeight(kg);

    return '${value.toStringAsFixed(1)} ${useKg ? 'kg' : 'lb'}';
  }

  double get weightChangeKg {
    if (cat.weightHistoryKg.length < 2) {
      return 0;
    }

    return cat.weightHistoryKg.last -
        cat.weightHistoryKg.first;
  }

  String get weightChangeText {
    final converted = useKg
        ? weightChangeKg
        : weightChangeKg * 2.20462;

    if (converted.abs() < 0.01) {
      return 'No change';
    }

    final symbol = converted > 0 ? '+' : '';

    return '$symbol${converted.toStringAsFixed(1)} ${useKg ? 'kg' : 'lb'}';
  }

  @override
  Widget build(BuildContext context) {
    final normalWeight =
        cat.normalWeightMinKg == null ||
                cat.normalWeightMaxKg == null ||
                (cat.weightKg >= cat.normalWeightMinKg! &&
                    cat.weightKg <=
                        cat.normalWeightMaxKg!);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          cat.name,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          18,
          8,
          18,
          30,
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Center(
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,

                    decoration: BoxDecoration(
                      color: const Color(0xFFF3E7FF),
                      borderRadius:
                          BorderRadius.circular(30),
                    ),

                    child: Center(
                      child: Text(
                        cat.emoji,
                        style: const TextStyle(
                          fontSize: 55,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    cat.name,
                    style: const TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 5),

                  const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        size: 18,
                        color: Color(0xFF4A9565),
                      ),

                      SizedBox(width: 5),

                      Text(
                        'Everything looks normal',
                        style: TextStyle(
                          color: Color(0xFF4A9565),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            Row(
              children: [
                Expanded(
                  child: DashboardMetricCard(
                    icon:
                        Icons.monitor_weight_outlined,
                    title: 'Weight',
                    value:
                        formatWeight(cat.weightKg),
                    subtitle: weightChangeText,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: DashboardMetricCard(
                    icon: Icons.pets_outlined,
                    title: 'Visits Today',
                    value:
                        '${cat.visitsToday}',
                    subtitle: 'Normal activity',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),

              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius:
                    BorderRadius.circular(22),
              ),

              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,

                    decoration: BoxDecoration(
                      color:
                          const Color(0xFFFFEAF5),
                      borderRadius:
                          BorderRadius.circular(16),
                    ),

                    child: const Icon(
                      Icons.schedule_rounded,
                      color: Color(0xFF9A6581),
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [
                        const Text(
                          'Last Litter Box Use',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        const SizedBox(height: 3),

                        Text(
                          cat.lastVisit,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            const DashboardSectionTitle(
              title: 'Weight Trend',
            ),

            const SizedBox(height: 12),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),

              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius:
                    BorderRadius.circular(22),
              ),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,

                    children: [
                      Text(
                        formatWeight(cat.weightKg),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      Text(
                        weightChangeText,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF8D6AAE),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    height: 150,

                    child: cat.weightHistoryKg.isEmpty
                        ? const Center(
                            child: Text(
                              'No weight history yet',
                            ),
                          )
                        : WeightTrendChart(
                            weights: cat.weightHistoryKg
                                .map(convertWeight)
                                .toList(),
                          ),
                  ),

                  const SizedBox(height: 8),

                  const Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,

                    children: [
                      Text('Mon'),
                      Text('Tue'),
                      Text('Wed'),
                      Text('Thu'),
                      Text('Fri'),
                      Text('Sat'),
                      Text('Sun'),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            const DashboardSectionTitle(
              title: 'Health & Activity',
            ),

            const SizedBox(height: 12),

            HealthStatusTile(
              icon: Icons.monitor_weight_outlined,
              title: 'Weight',
              status:
                  normalWeight ? 'Normal' : 'Check',
              description: normalWeight
                  ? 'Within normal range'
                  : 'Outside normal weight range',
            ),

            const SizedBox(height: 10),

            HealthStatusTile(
              icon: Icons.pets_outlined,
              title: 'Litter Use',
              status: 'Normal',
              description:
                  '${cat.visitsToday} visits today',
            ),

            const SizedBox(height: 10),

            const HealthStatusTile(
              icon: Icons.insights_rounded,
              title: 'Frequency',
              status: 'Normal',
              description:
                  'No unusual changes detected',
            ),

            const SizedBox(height: 10),

            const HealthStatusTile(
              icon: Icons.air_rounded,
              title: 'Odour',
              status: 'Normal',
              description:
                  'Air quality looks normal',
            ),

            const SizedBox(height: 28),

            const DashboardSectionTitle(
              title: 'Recent Visits',
            ),

            const SizedBox(height: 12),

            if (cat.recentVisits.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius:
                      BorderRadius.circular(22),
                ),

                child: const Text(
                  'No visits recorded yet.',
                ),
              ),

            if (cat.recentVisits.isNotEmpty)
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius:
                      BorderRadius.circular(22),
                ),

                child: Column(
                  children: List.generate(
                    cat.recentVisits.length,
                    (index) {
                      final visit =
                          cat.recentVisits[index];

                      return Column(
                        children: [
                          ListTile(
                            leading: Container(
                              width: 44,
                              height: 44,

                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFFF3E7FF,
                                ),
                                borderRadius:
                                    BorderRadius.circular(
                                  14,
                                ),
                              ),

                              child: const Icon(
                                Icons.pets_rounded,
                                color:
                                    Color(0xFF8D6AAE),
                              ),
                            ),

                            title: Text(
                              visit.time,
                              style: const TextStyle(
                                fontWeight:
                                    FontWeight.w800,
                              ),
                            ),

                            subtitle:
                                const Text(
                              'Litter box visit',
                            ),

                            trailing: Text(
                              formatWeight(
                                visit.weightKg,
                              ),
                              style: const TextStyle(
                                fontWeight:
                                    FontWeight.w700,
                              ),
                            ),
                          ),

                          if (index !=
                              cat.recentVisits.length -
                                  1)
                            const Divider(
                              height: 1,
                              indent: 70,
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// WEIGHT TREND GRAPH
// ============================================================

class WeightTrendChart extends StatelessWidget {
  final List<double> weights;

  const WeightTrendChart({
    super.key,
    required this.weights,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: WeightTrendPainter(
        weights: weights,
        lineColor:
            const Color(0xFF9B76C1),
        gridColor:
            Theme.of(context).dividerColor,
      ),
      child: Container(),
    );
  }
}

class WeightTrendPainter extends CustomPainter {
  final List<double> weights;
  final Color lineColor;
  final Color gridColor;

  WeightTrendPainter({
    required this.weights,
    required this.lineColor,
    required this.gridColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (weights.length < 2) return;

    final gridPaint = Paint()
      ..color = gridColor.withOpacity(0.3)
      ..strokeWidth = 1;

    for (int i = 0; i < 4; i++) {
      final y = size.height * i / 3;

      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        gridPaint,
      );
    }

    double minValue =
        weights.reduce((a, b) => a < b ? a : b);

    double maxValue =
        weights.reduce((a, b) => a > b ? a : b);

    if ((maxValue - minValue).abs() < 0.01) {
      minValue -= 0.1;
      maxValue += 0.1;
    }

    final path = Path();

    for (int i = 0; i < weights.length; i++) {
      final x =
          size.width * i / (weights.length - 1);

      final normalized =
          (weights[i] - minValue) /
              (maxValue - minValue);

      final y =
          size.height -
              (normalized * size.height * 0.75) -
              size.height * 0.125;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(
      path,
      linePaint,
    );

    final dotPaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.fill;

    for (int i = 0; i < weights.length; i++) {
      final x =
          size.width * i / (weights.length - 1);

      final normalized =
          (weights[i] - minValue) /
              (maxValue - minValue);

      final y =
          size.height -
              (normalized * size.height * 0.75) -
              size.height * 0.125;

      canvas.drawCircle(
        Offset(x, y),
        4,
        dotPaint,
      );
    }
  }

  @override
  bool shouldRepaint(
    covariant WeightTrendPainter oldDelegate,
  ) {
    return true;
  }
}

// ============================================================
// DASHBOARD HELPERS
// ============================================================

class DashboardMetricCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String subtitle;

  const DashboardMetricCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(17),

      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(22),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Icon(
            icon,
            color: const Color(0xFF8D6AAE),
          ),

          const SizedBox(height: 10),

          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 3),

          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF8D6AAE),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardSectionTitle extends StatelessWidget {
  final String title;

  const DashboardSectionTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 21,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class HealthStatusTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String status;
  final String description;

  const HealthStatusTile({
    super.key,
    required this.icon,
    required this.title,
    required this.status,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
      ),

      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,

            decoration: BoxDecoration(
              color: const Color(0xFFE6F7EC),
              borderRadius:
                  BorderRadius.circular(15),
            ),

            child: Icon(
              icon,
              color: const Color(0xFF4A9565),
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          Row(
            children: [
              const Icon(
                Icons.check_circle_rounded,
                color: Color(0xFF4A9565),
                size: 18,
              ),

              const SizedBox(width: 4),

              Text(
                status,
                style: const TextStyle(
                  color: Color(0xFF4A9565),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ============================================================
// ALERTS PAGE
// ============================================================

class AlertsPage extends StatelessWidget {
  const AlertsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,

        title: const Text(
          'Alerts',
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
      ),

      body: const Center(
        child: Text(
          'No alerts right now 🐾',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

// ============================================================
// SETTINGS PAGE
// ============================================================

class SettingsPage extends StatelessWidget {
  final List<CatProfile> cats;

  final bool useKg;
  final ThemeMode themeMode;

  final bool weightAlerts;
  final bool litterAlerts;
  final bool odourAlerts;

  final ValueChanged<ThemeMode> onThemeChanged;
  final ValueChanged<bool> onWeightUnitChanged;

  final void Function({
    bool? weight,
    bool? litter,
    bool? odour,
  }) onAlertsChanged;

  final void Function(
    int index,
    CatProfile updatedCat,
  ) onCatUpdated;

  final ValueChanged<CatProfile> onCatAdded;
  final ValueChanged<int> onCatDeleted;

  const SettingsPage({
    super.key,
    required this.cats,
    required this.useKg,
    required this.themeMode,
    required this.weightAlerts,
    required this.litterAlerts,
    required this.odourAlerts,
    required this.onThemeChanged,
    required this.onWeightUnitChanged,
    required this.onAlertsChanged,
    required this.onCatUpdated,
    required this.onCatAdded,
    required this.onCatDeleted,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,

        title: const Text(
          'Settings',
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          18,
          10,
          18,
          30,
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const SettingsSectionTitle(
              title: 'Cats',
              icon: Icons.pets_rounded,
            ),

            const SizedBox(height: 10),

            SettingsCard(
              children: [
                SettingsTile(
                  icon:
                      Icons.account_circle_outlined,
                  title: 'Cat Profiles',
                  subtitle:
                      'Add, remove, or edit cats',

                  onTap: () {
                    Navigator.push(
                      context,

                      MaterialPageRoute(
                        builder: (_) =>
                            CatProfilesSettingsPage(
                          cats: cats,
                          useKg: useKg,
                          onCatUpdated:
                              onCatUpdated,
                          onCatAdded:
                              onCatAdded,
                          onCatDeleted:
                              onCatDeleted,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),

            const SettingsSectionTitle(
              title: 'Notifications',
              icon: Icons.notifications_rounded,
            ),

            const SizedBox(height: 10),

            SettingsCard(
              children: [
                SettingsTile(
                  icon: Icons
                      .notifications_active_outlined,
                  title: 'Alert Settings',
                  subtitle:
                      'Choose which alerts you receive',

                  onTap: () {
                    Navigator.push(
                      context,

                      MaterialPageRoute(
                        builder: (_) =>
                            AlertSettingsPage(
                          weightAlerts:
                              weightAlerts,
                          litterAlerts:
                              litterAlerts,
                          odourAlerts:
                              odourAlerts,
                          onAlertsChanged:
                              onAlertsChanged,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),

            const SettingsSectionTitle(
              title: 'Device',
              icon: Icons.memory_rounded,
            ),

            const SizedBox(height: 10),

            SettingsCard(
              children: [
                SettingsTile(
                  icon: Icons.wifi_rounded,
                  title: 'Wi-Fi',
                  subtitle: 'Device Wi-Fi setup',
                  trailingText: 'Not connected',
                  onTap: () {},
                ),

                const SettingsDivider(),

                SettingsTile(
                  icon: Icons.sensors_outlined,
                  title: 'Device Status',
                  subtitle:
                      'Litter mat connection',
                  trailingText: 'Offline',
                  onTap: () {},
                ),
              ],
            ),

            const SizedBox(height: 24),

            const SettingsSectionTitle(
              title: 'App',
              icon: Icons.phone_android_rounded,
            ),

            const SizedBox(height: 10),

            SettingsCard(
              children: [
                SettingsTile(
                  icon: Icons.straighten_rounded,
                  title: 'Weight Units',
                  subtitle:
                      'Choose kilograms or pounds',
                  trailingText:
                      useKg ? 'kg' : 'lb',

                  onTap: () {
                    showModalBottomSheet(
                      context: context,

                      builder: (context) {
                        return SafeArea(
                          child: Column(
                            mainAxisSize:
                                MainAxisSize.min,

                            children: [
                              const SizedBox(
                                height: 12,
                              ),

                              const Text(
                                'Weight Units',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight:
                                      FontWeight.w800,
                                ),
                              ),

                              ListTile(
                                title: const Text(
                                  'Kilograms (kg)',
                                ),

                                trailing: useKg
                                    ? const Icon(
                                        Icons
                                            .check_rounded,
                                      )
                                    : null,

                                onTap: () {
                                  onWeightUnitChanged(
                                    true,
                                  );

                                  Navigator.pop(
                                    context,
                                  );
                                },
                              ),

                              ListTile(
                                title: const Text(
                                  'Pounds (lb)',
                                ),

                                trailing: !useKg
                                    ? const Icon(
                                        Icons
                                            .check_rounded,
                                      )
                                    : null,

                                onTap: () {
                                  onWeightUnitChanged(
                                    false,
                                  );

                                  Navigator.pop(
                                    context,
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),

                const SettingsDivider(),

                SettingsTile(
                  icon: Icons.palette_outlined,
                  title: 'Appearance',
                  subtitle:
                      'Choose your app theme',

                  trailingText:
                      themeMode == ThemeMode.light
                          ? 'Light'
                          : themeMode ==
                                  ThemeMode.dark
                              ? 'Dark'
                              : 'System',

                  onTap: () {
                    showModalBottomSheet(
                      context: context,

                      builder: (context) {
                        return SafeArea(
                          child: Column(
                            mainAxisSize:
                                MainAxisSize.min,

                            children: [
                              const SizedBox(
                                height: 12,
                              ),

                              const Text(
                                'Appearance',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight:
                                      FontWeight.w800,
                                ),
                              ),

                              ListTile(
                                leading: const Icon(
                                  Icons
                                      .light_mode_outlined,
                                ),

                                title:
                                    const Text('Light'),

                                onTap: () {
                                  onThemeChanged(
                                    ThemeMode.light,
                                  );

                                  Navigator.pop(
                                    context,
                                  );
                                },
                              ),

                              ListTile(
                                leading: const Icon(
                                  Icons
                                      .dark_mode_outlined,
                                ),

                                title:
                                    const Text('Dark'),

                                onTap: () {
                                  onThemeChanged(
                                    ThemeMode.dark,
                                  );

                                  Navigator.pop(
                                    context,
                                  );
                                },
                              ),

                              ListTile(
                                leading: const Icon(
                                  Icons
                                      .phone_android_rounded,
                                ),

                                title: const Text(
                                  'Use device setting',
                                ),

                                onTap: () {
                                  onThemeChanged(
                                    ThemeMode.system,
                                  );

                                  Navigator.pop(
                                    context,
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// ALERT SETTINGS
// ============================================================

class AlertSettingsPage extends StatefulWidget {
  final bool weightAlerts;
  final bool litterAlerts;
  final bool odourAlerts;

  final void Function({
    bool? weight,
    bool? litter,
    bool? odour,
  }) onAlertsChanged;

  const AlertSettingsPage({
    super.key,
    required this.weightAlerts,
    required this.litterAlerts,
    required this.odourAlerts,
    required this.onAlertsChanged,
  });

  @override
  State<AlertSettingsPage> createState() =>
      _AlertSettingsPageState();
}

class _AlertSettingsPageState
    extends State<AlertSettingsPage> {
  late bool weightAlerts;
  late bool litterAlerts;
  late bool odourAlerts;

  @override
  void initState() {
    super.initState();

    weightAlerts = widget.weightAlerts;
    litterAlerts = widget.litterAlerts;
    odourAlerts = widget.odourAlerts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Alert Settings',
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(18),

        children: [
          SwitchListTile(
            title:
                const Text('Weight alerts'),

            subtitle: const Text(
              'Notify me about unusual weight changes',
            ),

            value: weightAlerts,

            onChanged: (value) {
              setState(() {
                weightAlerts = value;
              });

              widget.onAlertsChanged(
                weight: value,
              );
            },
          ),

          SwitchListTile(
            title:
                const Text('Litter use alerts'),

            subtitle: const Text(
              'Notify me about unusual litter box activity',
            ),

            value: litterAlerts,

            onChanged: (value) {
              setState(() {
                litterAlerts = value;
              });

              widget.onAlertsChanged(
                litter: value,
              );
            },
          ),

          SwitchListTile(
            title:
                const Text('Odour alerts'),

            subtitle: const Text(
              'Notify me when air or odour readings are high',
            ),

            value: odourAlerts,

            onChanged: (value) {
              setState(() {
                odourAlerts = value;
              });

              widget.onAlertsChanged(
                odour: value,
              );
            },
          ),
        ],
      ),
    );
  }
}

// ============================================================
// CAT PROFILE SETTINGS
// ============================================================

class CatProfilesSettingsPage extends StatefulWidget {
  final List<CatProfile> cats;
  final bool useKg;

  final void Function(
    int index,
    CatProfile updatedCat,
  ) onCatUpdated;

  final ValueChanged<CatProfile> onCatAdded;
  final ValueChanged<int> onCatDeleted;

  const CatProfilesSettingsPage({
    super.key,
    required this.cats,
    required this.useKg,
    required this.onCatUpdated,
    required this.onCatAdded,
    required this.onCatDeleted,
  });

  @override
  State<CatProfilesSettingsPage> createState() =>
      _CatProfilesSettingsPageState();
}

class _CatProfilesSettingsPageState
    extends State<CatProfilesSettingsPage> {
  void addCat() {
    final newCat = CatProfile(
      name: '',
      weightKg: 0,
      visitsToday: 0,
      lastVisit: 'No visits yet',
      emoji: '🐱',
    );

    Navigator.push(
      context,

      MaterialPageRoute(
        builder: (_) => EditCatPage(
          cat: newCat,
          useKg: widget.useKg,

          onSave: (updatedCat) {
            widget.onCatAdded(updatedCat);

            setState(() {});
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cat Profiles',
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
      ),

      floatingActionButton:
          FloatingActionButton.extended(
        onPressed: addCat,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Cat'),
      ),

      body: ListView.separated(
        padding: const EdgeInsets.all(18),
        itemCount: widget.cats.length,

        separatorBuilder: (_, __) =>
            const Divider(),

        itemBuilder: (context, index) {
          final cat = widget.cats[index];

          return ListTile(
            leading: Text(
              cat.emoji,
              style:
                  const TextStyle(fontSize: 34),
            ),

            title: Text(
              cat.name,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),

            subtitle:
                const Text('Tap to edit profile'),

            trailing:
                const Icon(Icons.chevron_right),

            onTap: () {
              Navigator.push(
                context,

                MaterialPageRoute(
                  builder: (_) => EditCatPage(
                    cat: cat,
                    useKg: widget.useKg,

                    onSave: (updatedCat) {
                      widget.onCatUpdated(
                        index,
                        updatedCat,
                      );

                      setState(() {});
                    },

                    onDelete: () {
                      widget.onCatDeleted(index);

                      setState(() {});
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// ============================================================
// EDIT CAT PAGE
// ============================================================

class EditCatPage extends StatefulWidget {
  final CatProfile cat;
  final bool useKg;

  final ValueChanged<CatProfile> onSave;
  final VoidCallback? onDelete;

  const EditCatPage({
    super.key,
    required this.cat,
    required this.useKg,
    required this.onSave,
    this.onDelete,
  });

  @override
  State<EditCatPage> createState() =>
      _EditCatPageState();
}

class _EditCatPageState extends State<EditCatPage> {
  late TextEditingController nameController;
  late TextEditingController weightController;
  late TextEditingController minWeightController;
  late TextEditingController maxWeightController;
  late TextEditingController notesController;

  late String selectedEmoji;
  late String selectedSex;
  late bool isSpayedNeutered;
  late bool rfidPaired;

  DateTime? birthday;

  final List<String> emojis = [
    '🐱',
    '😺',
    '😸',
    '😻',
    '😽',
    '🐈',
    '🐈‍⬛',
    '🐾',
    '🌸',
    '⭐',
    '👑',
    '🎀',
    '🌙',
    '☀️',
    '💜',
    '🩷',
    '💙',
    '💚',
  ];

  String get weightUnit =>
      widget.useKg ? 'kg' : 'lb';

  double weightForDisplay(double kg) {
    return widget.useKg
        ? kg
        : kg * 2.20462;
  }

  double weightToKg(double value) {
    return widget.useKg
        ? value
        : value / 2.20462;
  }

  @override
  void initState() {
    super.initState();

    nameController =
        TextEditingController(
      text: widget.cat.name,
    );

    weightController =
        TextEditingController(
      text: widget.cat.weightKg == 0
          ? ''
          : weightForDisplay(
              widget.cat.weightKg,
            ).toStringAsFixed(1),
    );

    minWeightController =
        TextEditingController(
      text:
          widget.cat.normalWeightMinKg ==
                  null
              ? ''
              : weightForDisplay(
                  widget.cat
                      .normalWeightMinKg!,
                ).toStringAsFixed(1),
    );

    maxWeightController =
        TextEditingController(
      text:
          widget.cat.normalWeightMaxKg ==
                  null
              ? ''
              : weightForDisplay(
                  widget.cat
                      .normalWeightMaxKg!,
                ).toStringAsFixed(1),
    );

    notesController =
        TextEditingController(
      text: widget.cat.notes,
    );

    selectedEmoji = widget.cat.emoji;
    selectedSex = widget.cat.sex;

    isSpayedNeutered =
        widget.cat.isSpayedNeutered;

    rfidPaired =
        widget.cat.rfidPaired;

    birthday = widget.cat.birthday;
  }

  @override
  void dispose() {
    nameController.dispose();
    weightController.dispose();
    minWeightController.dispose();
    maxWeightController.dispose();
    notesController.dispose();

    super.dispose();
  }

  Future<void> chooseBirthday() async {
    final pickedDate =
        await showDatePicker(
      context: context,

      initialDate: birthday ??
          DateTime(
            DateTime.now().year - 5,
          ),

      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        birthday = pickedDate;
      });
    }
  }

  int? calculateAge() {
    if (birthday == null) return null;

    final today = DateTime.now();

    int years =
        today.year - birthday!.year;

    if (today.month < birthday!.month ||
        (today.month == birthday!.month &&
            today.day < birthday!.day)) {
      years--;
    }

    return years;
  }

  void showEmojiPicker() {
    showModalBottomSheet(
      context: context,

      builder: (context) {
        return SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.all(20),

            child: Wrap(
              spacing: 12,
              runSpacing: 12,

              children: emojis.map((emoji) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      selectedEmoji = emoji;
                    });

                    Navigator.pop(context);
                  },

                  child: Container(
                    width: 58,
                    height: 58,

                    alignment: Alignment.center,

                    child: Text(
                      emoji,
                      style: const TextStyle(
                        fontSize: 30,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  void showSexPicker() {
    showModalBottomSheet(
      context: context,

      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize:
                MainAxisSize.min,

            children: [
              for (final sex
                  in ['Female', 'Male', 'Unknown'])
                ListTile(
                  title: Text(sex),

                  onTap: () {
                    setState(() {
                      selectedSex = sex;
                    });

                    Navigator.pop(context);
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  void mockPairRfidTag() {
    setState(() {
      rfidPaired = true;
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          'Demo: RFID tag paired successfully',
        ),
      ),
    );
  }

  void saveProfile() {
    final enteredWeight =
        double.tryParse(
      weightController.text,
    );

    final enteredMin =
        double.tryParse(
      minWeightController.text,
    );

    final enteredMax =
        double.tryParse(
      maxWeightController.text,
    );

    final name =
        nameController.text.trim();

    if (name.isEmpty) {
      return;
    }

    final updatedCat =
        widget.cat.copyWith(
      name: name,
      emoji: selectedEmoji,
      birthday: birthday,
      sex: selectedSex,
      isSpayedNeutered:
          isSpayedNeutered,

      weightKg: enteredWeight != null
          ? weightToKg(enteredWeight)
          : widget.cat.weightKg,

      normalWeightMinKg:
          enteredMin != null
              ? weightToKg(enteredMin)
              : null,

      normalWeightMaxKg:
          enteredMax != null
              ? weightToKg(enteredMax)
              : null,

      rfidPaired: rfidPaired,

      rfidTagId: rfidPaired
          ? widget.cat.rfidTagId ??
              'DEMO_TAG'
          : null,

      notes:
          notesController.text.trim(),
    );

    widget.onSave(updatedCat);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final age = calculateAge();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.cat.name.isEmpty
              ? 'Add Cat'
              : 'Edit Cat',
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            GestureDetector(
              onTap: showEmojiPicker,

              child: Text(
                selectedEmoji,
                style: const TextStyle(
                  fontSize: 80,
                ),
              ),
            ),

            const Text(
              'Tap to change',
            ),

            const SizedBox(height: 24),

            TextField(
              controller: nameController,

              decoration:
                  const InputDecoration(
                labelText: 'Cat name',
                border:
                    OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 18),

            ListTile(
              title:
                  const Text('Birthday'),

              subtitle: Text(
                birthday == null
                    ? 'Not set'
                    : '${birthday!.month}/${birthday!.day}/${birthday!.year}',
              ),

              onTap: chooseBirthday,
            ),

            if (age != null)
              Text(
                'Age: $age years',
              ),

            ListTile(
              title: const Text('Sex'),
              trailing: Text(selectedSex),
              onTap: showSexPicker,
            ),

            SwitchListTile(
              title: const Text(
                'Spayed / Neutered',
              ),

              value: isSpayedNeutered,

              onChanged: (value) {
                setState(() {
                  isSpayedNeutered =
                      value;
                });
              },
            ),

            TextField(
              controller:
                  weightController,

              keyboardType:
                  const TextInputType
                      .numberWithOptions(
                decimal: true,
              ),

              decoration:
                  InputDecoration(
                labelText:
                    'Current weight ($weightUnit)',
                border:
                    const OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 18),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller:
                        minWeightController,

                    keyboardType:
                        const TextInputType
                            .numberWithOptions(
                      decimal: true,
                    ),

                    decoration:
                        InputDecoration(
                      labelText: 'Minimum',
                      suffixText:
                          weightUnit,
                      border:
                          const OutlineInputBorder(),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: TextField(
                    controller:
                        maxWeightController,

                    keyboardType:
                        const TextInputType
                            .numberWithOptions(
                      decimal: true,
                    ),

                    decoration:
                        InputDecoration(
                      labelText: 'Maximum',
                      suffixText:
                          weightUnit,
                      border:
                          const OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            ListTile(
              title: const Text(
                'RFID Collar Tag',
              ),

              subtitle: Text(
                rfidPaired
                    ? 'Tag paired'
                    : 'No tag paired',
              ),

              trailing:
                  FilledButton.tonal(
                onPressed:
                    mockPairRfidTag,

                child: Text(
                  rfidPaired
                      ? 'Replace'
                      : 'Pair',
                ),
              ),
            ),

            const SizedBox(height: 18),

            TextField(
              controller:
                  notesController,

              maxLines: 4,

              decoration:
                  const InputDecoration(
                labelText: 'Notes',
                border:
                    OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,

              child: FilledButton(
                onPressed: saveProfile,

                child: Text(
                  widget.cat.name.isEmpty
                      ? 'Add Cat'
                      : 'Save Profile',
                ),
              ),
            ),

            if (widget.onDelete != null) ...[
              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,

                child:
                    OutlinedButton.icon(
                  icon: const Icon(
                    Icons.delete_outline,
                  ),

                  label:
                      const Text('Delete Cat'),

                  onPressed: () {
                    showDialog(
                      context: context,

                      builder: (context) {
                        return AlertDialog(
                          title:
                              const Text(
                            'Delete Cat?',
                          ),

                          content: Text(
                            'Are you sure you want to delete ${widget.cat.name}?',
                          ),

                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(
                                  context,
                                );
                              },

                              child:
                                  const Text(
                                'Cancel',
                              ),
                            ),

                            FilledButton(
                              onPressed: () {
                                Navigator.pop(
                                  context,
                                );

                                widget
                                    .onDelete!();

                                Navigator.pop(
                                  context,
                                );
                              },

                              child:
                                  const Text(
                                'Delete',
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ============================================================
// CAT CARD
// ============================================================

class CatCard extends StatelessWidget {
  final String name;
  final String weight;
  final String visits;
  final String lastVisit;
  final Color accentColor;
  final String catEmoji;

  const CatCard({
    super.key,
    required this.name,
    required this.weight,
    required this.visits,
    required this.lastVisit,
    required this.accentColor,
    required this.catEmoji,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,

            decoration: BoxDecoration(
              color: accentColor,
              borderRadius:
                  BorderRadius.circular(20),
            ),

            child: Center(
              child: Text(
                catEmoji,
                style: const TextStyle(
                  fontSize: 34,
                ),
              ),
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Text(
                  name,

                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 6),

                Text(weight),
                Text(visits),
                Text(lastVisit),
              ],
            ),
          ),

          const Icon(
            Icons.chevron_right_rounded,
          ),
        ],
      ),
    );
  }
}

// ============================================================
// SETTINGS HELPERS
// ============================================================

class SettingsSectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;

  const SettingsSectionTitle({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: const Color(0xFF8D6AAE),
        ),

        const SizedBox(width: 8),

        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Color(0xFF8D6AAE),
          ),
        ),
      ],
    );
  }
}

class SettingsCard extends StatelessWidget {
  final List<Widget> children;

  const SettingsCard({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(22),
      ),

      child: Column(
        children: children,
      ),
    );
  }
}

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? trailingText;
  final VoidCallback onTap;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.trailingText,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: const Color(0xFF8D6AAE),
      ),

      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w800,
        ),
      ),

      subtitle: Text(subtitle),

      trailing: Row(
        mainAxisSize: MainAxisSize.min,

        children: [
          if (trailingText != null)
            Text(
              trailingText!,
              style: const TextStyle(
                color: Color(0xFF8D6AAE),
              ),
            ),

          const Icon(
            Icons.chevron_right,
          ),
        ],
      ),

      onTap: onTap,
    );
  }
}

class SettingsDivider extends StatelessWidget {
  const SettingsDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      indent: 70,
    );
  }
}