import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const SmartLitterApp());
}


// ================= APP =================

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
    ),
    CatProfile(
      name: 'Zeusu',
      weightKg: 5.2,
      visitsToday: 2,
      lastVisit: '1:42 PM',
      emoji: '😺',
    ),
    CatProfile(
      name: 'Okja',
      weightKg: 4.5,
      visitsToday: 4,
      lastVisit: '2:37 PM',
      emoji: '🐈',
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
      ),
    );
  }
}


// ================= CAT MODEL =================

class CatProfile {
  final String name;
  final double weightKg;
  final int visitsToday;
  final String lastVisit;
  final String emoji;

  CatProfile({
    required this.name,
    required this.weightKg,
    required this.visitsToday,
    required this.lastVisit,
    required this.emoji,
  });

  CatProfile copyWith({
    String? name,
    double? weightKg,
    int? visitsToday,
    String? lastVisit,
    String? emoji,
  }) {
    return CatProfile(
      name: name ?? this.name,
      weightKg: weightKg ?? this.weightKg,
      visitsToday: visitsToday ?? this.visitsToday,
      lastVisit: lastVisit ?? this.lastVisit,
      emoji: emoji ?? this.emoji,
    );
  }
}


// ================= MAIN NAVIGATION =================

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
  });

  @override
  State<MainNavigationPage> createState() =>
      _MainNavigationPageState();
}

class _MainNavigationPageState
    extends State<MainNavigationPage> {
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
          onCatUpdated: widget.onCatUpdated,
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
          onWeightUnitChanged:
              widget.onWeightUnitChanged,
          onAlertsChanged: widget.onAlertsChanged,
          onCatUpdated: widget.onCatUpdated,
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


// ================= HOME PAGE =================

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

    double pounds = kg * 2.20462;

    return '${pounds.toStringAsFixed(1)} lb';
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
        padding:
            const EdgeInsets.fromLTRB(18, 10, 18, 24),

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
                  padding: const EdgeInsets.only(
                    bottom: 14,
                  ),

                  child: CatCard(
                    name: cat.name,
                    weight:
                        formatWeight(cat.weightKg),
                    visits:
                        '${cat.visitsToday} visits today',
                    lastVisit:
                        'Last visit: ${cat.lastVisit}',
                    accentColor:
                        accentColors[index %
                            accentColors.length],
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
                color:
                    Theme.of(context).cardColor,

                borderRadius:
                    BorderRadius.circular(24),

                boxShadow: [
                  BoxShadow(
                    color: Colors.black
                        .withValues(alpha: 0.05),
                    blurRadius: 14,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),

              child: Row(
                children: [

                  Container(
                    width: 58,
                    height: 58,

                    decoration: BoxDecoration(
                      color:
                          const Color(0xFFE6F7EC),
                      borderRadius:
                          BorderRadius.circular(18),
                    ),

                    child: const Icon(
                      Icons.air_rounded,
                      size: 32,
                      color: Color(0xFF4A9565),
                    ),
                  ),

                  const SizedBox(width: 16),

                  const Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [

                        Text(
                          'Air Quality',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight:
                                FontWeight.w800,
                          ),
                        ),

                        SizedBox(height: 5),

                        Text(
                          'Normal',
                          style: TextStyle(
                            fontSize: 17,
                            color:
                                Color(0xFF4A9565),
                            fontWeight:
                                FontWeight.w700,
                          ),
                        ),

                        SizedBox(height: 3),

                        Text(
                          'Sensor reading: 500',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Icon(
                    Icons.check_circle_rounded,
                    color: Color(0xFF4A9565),
                    size: 30,
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


// ================= CATS PAGE =================

class CatsPage extends StatelessWidget {
  final List<CatProfile> cats;
  final bool useKg;

  final void Function(
    int index,
    CatProfile updatedCat,
  ) onCatUpdated;

  const CatsPage({
    super.key,
    required this.cats,
    required this.useKg,
    required this.onCatUpdated,
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
        title: const Text(
          'My Cats',
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
      ),

      body: ListView.separated(
        padding: const EdgeInsets.all(18),

        itemCount: cats.length,

        separatorBuilder: (_, __) =>
            const SizedBox(height: 14),

        itemBuilder: (context, index) {
          final cat = cats[index];

          return InkWell(
            borderRadius: BorderRadius.circular(24),

            onTap: () {
              Navigator.push(
                context,

                MaterialPageRoute(
                  builder: (_) => EditCatPage(
                    cat: cat,

                    onSave: (updatedCat) {
                      onCatUpdated(
                        index,
                        updatedCat,
                      );
                    },
                  ),
                ),
              );
            },

            child: CatCard(
              name: cat.name,
              weight:
                  formatWeight(cat.weightKg),
              visits:
                  '${cat.visitsToday} visits today',
              lastVisit:
                  'Last visit: ${cat.lastVisit}',
              accentColor:
                  const Color(0xFFE8D7FF),
              catEmoji: cat.emoji,
            ),
          );
        },
      ),
    );
  }
}


// ================= ALERTS PAGE =================

class AlertsPage extends StatelessWidget {
  const AlertsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Alerts',
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
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


// ================= SETTINGS PAGE =================

class SettingsPage extends StatelessWidget {
  final List<CatProfile> cats;

  final bool useKg;
  final ThemeMode themeMode;

  final bool weightAlerts;
  final bool litterAlerts;
  final bool odourAlerts;

  final ValueChanged<ThemeMode> onThemeChanged;

  final ValueChanged<bool>
      onWeightUnitChanged;

  final void Function({
    bool? weight,
    bool? litter,
    bool? odour,
  }) onAlertsChanged;

  final void Function(
    int index,
    CatProfile updatedCat,
  ) onCatUpdated;

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
        padding:
            const EdgeInsets.fromLTRB(18, 10, 18, 30),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

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
                          onCatUpdated:
                              onCatUpdated,
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
              icon:
                  Icons.notifications_rounded,
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
                  subtitle:
                      'Device Wi-Fi setup',
                  trailingText:
                      'Not connected',
                  onTap: () {},
                ),

                const SettingsDivider(),

                SettingsTile(
                  icon: Icons.sensors_outlined,
                  title: 'Device Status',
                  subtitle:
                      'Litter mat connection',
                  trailingText:
                      'Offline',
                  onTap: () {},
                ),
              ],
            ),

            const SizedBox(height: 24),

            const SettingsSectionTitle(
              title: 'App',
              icon:
                  Icons.phone_android_rounded,
            ),

            const SizedBox(height: 10),

            SettingsCard(
              children: [

                SettingsTile(
                  icon:
                      Icons.straighten_rounded,
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
                          child: Padding(
                            padding:
                                const EdgeInsets.all(
                              20,
                            ),

                            child: Column(
                              mainAxisSize:
                                  MainAxisSize.min,
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,

                              children: [

                                const Text(
                                  'Weight Units',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight:
                                        FontWeight
                                            .w800,
                                  ),
                                ),

                                const SizedBox(
                                  height: 15,
                                ),

                                ListTile(
                                  title:
                                      const Text(
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
                                  title:
                                      const Text(
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
                          ),
                        );
                      },
                    );
                  },
                ),

                const SettingsDivider(),

                SettingsTile(
                  icon:
                      Icons.palette_outlined,
                  title: 'Appearance',
                  subtitle:
                      'Choose your app theme',

                  trailingText:
                      themeMode ==
                              ThemeMode.light
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
                          child: Padding(
                            padding:
                                const EdgeInsets.all(
                              20,
                            ),

                            child: Column(
                              mainAxisSize:
                                  MainAxisSize.min,
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,

                              children: [

                                const Text(
                                  'Appearance',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight:
                                        FontWeight
                                            .w800,
                                  ),
                                ),

                                const SizedBox(
                                  height: 15,
                                ),

                                ListTile(
                                  leading: const Icon(
                                    Icons
                                        .light_mode_outlined,
                                  ),
                                  title:
                                      const Text(
                                    'Light',
                                  ),

                                  trailing:
                                      themeMode ==
                                              ThemeMode
                                                  .light
                                          ? const Icon(
                                              Icons
                                                  .check_rounded,
                                            )
                                          : null,

                                  onTap: () {
                                    onThemeChanged(
                                      ThemeMode
                                          .light,
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
                                      const Text(
                                    'Dark',
                                  ),

                                  trailing:
                                      themeMode ==
                                              ThemeMode
                                                  .dark
                                          ? const Icon(
                                              Icons
                                                  .check_rounded,
                                            )
                                          : null,

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
                                  title:
                                      const Text(
                                    'Use device setting',
                                  ),

                                  trailing:
                                      themeMode ==
                                              ThemeMode
                                                  .system
                                          ? const Icon(
                                              Icons
                                                  .check_rounded,
                                            )
                                          : null,

                                  onTap: () {
                                    onThemeChanged(
                                      ThemeMode
                                          .system,
                                    );

                                    Navigator.pop(
                                      context,
                                    );
                                  },
                                ),
                              ],
                            ),
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


// ================= ALERT SETTINGS =================

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

    weightAlerts =
        widget.weightAlerts;

    litterAlerts =
        widget.litterAlerts;

    odourAlerts =
        widget.odourAlerts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Alert Settings'),
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


// ================= CAT PROFILES SETTINGS =================

class CatProfilesSettingsPage
    extends StatelessWidget {
  final List<CatProfile> cats;

  final void Function(
    int index,
    CatProfile updatedCat,
  ) onCatUpdated;

  const CatProfilesSettingsPage({
    super.key,
    required this.cats,
    required this.onCatUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Cat Profiles'),
      ),

      body: ListView.separated(
        padding: const EdgeInsets.all(18),

        itemCount: cats.length,

        separatorBuilder: (_, __) =>
            const Divider(),

        itemBuilder: (context, index) {
          final cat = cats[index];

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

            subtitle: const Text(
              'Tap to edit profile',
            ),

            trailing:
                const Icon(Icons.chevron_right),

            onTap: () {
              Navigator.push(
                context,

                MaterialPageRoute(
                  builder: (_) =>
                      EditCatPage(
                    cat: cat,

                    onSave: (updatedCat) {
                      onCatUpdated(
                        index,
                        updatedCat,
                      );
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


// ================= EDIT CAT PAGE =================

class EditCatPage extends StatefulWidget {
  final CatProfile cat;
  final ValueChanged<CatProfile> onSave;

  const EditCatPage({
    super.key,
    required this.cat,
    required this.onSave,
  });

  @override
  State<EditCatPage> createState() =>
      _EditCatPageState();
}

class _EditCatPageState
    extends State<EditCatPage> {
  late TextEditingController nameController;

  @override
  void initState() {
    super.initState();

    nameController =
        TextEditingController(
      text: widget.cat.name,
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Edit Cat'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            Text(
              widget.cat.emoji,
              style:
                  const TextStyle(fontSize: 80),
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

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,

              child: FilledButton(
                onPressed: () {
                  final updatedCat =
                      widget.cat.copyWith(
                    name:
                        nameController.text.trim(),
                  );

                  widget.onSave(updatedCat);

                  Navigator.pop(context);
                },

                child:
                    const Text('Save Changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// ================= CAT CARD =================

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
        color:
            Theme.of(context).cardColor,

        borderRadius:
            BorderRadius.circular(24),

        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withValues(
              alpha: 0.05,
            ),
            blurRadius: 14,
            offset:
                const Offset(0, 5),
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
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 7),

                Row(
                  children: [
                    const Icon(
                      Icons
                          .monitor_weight_outlined,
                      size: 17,
                    ),

                    const SizedBox(width: 5),

                    Text(weight),
                  ],
                ),

                const SizedBox(height: 3),

                Row(
                  children: [
                    const Icon(
                      Icons.pets_outlined,
                      size: 17,
                    ),

                    const SizedBox(width: 5),

                    Text(visits),
                  ],
                ),

                const SizedBox(height: 3),

                Row(
                  children: [
                    const Icon(
                      Icons.schedule,
                      size: 17,
                    ),

                    const SizedBox(width: 5),

                    Text(lastVisit),
                  ],
                ),
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


// ================= SETTINGS HELPERS =================

class SettingsSectionTitle
    extends StatelessWidget {
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
          size: 20,
          color:
              const Color(0xFF8D6AAE),
        ),

        const SizedBox(width: 8),

        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight:
                FontWeight.w800,
            color:
                Color(0xFF8D6AAE),
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
        color:
            Theme.of(context).cardColor,

        borderRadius:
            BorderRadius.circular(22),

        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withValues(
              alpha: 0.04,
            ),
            blurRadius: 12,
            offset:
                const Offset(0, 4),
          ),
        ],
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
    return InkWell(
      borderRadius:
          BorderRadius.circular(22),

      onTap: onTap,

      child: Padding(
        padding:
            const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 15,
        ),

        child: Row(
          children: [

            Container(
              width: 46,
              height: 46,

              decoration: BoxDecoration(
                color:
                    const Color(0xFFF3E7FF),

                borderRadius:
                    BorderRadius.circular(15),
              ),

              child: Icon(
                icon,
                color:
                    const Color(0xFF8D6AAE),
                size: 24,
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
                    style:
                        const TextStyle(
                      fontSize: 16,
                      fontWeight:
                          FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    subtitle,
                    style:
                        const TextStyle(
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            if (trailingText != null) ...[
              Text(
                trailingText!,
                style:
                    const TextStyle(
                  fontSize: 14,
                  color:
                      Color(0xFF8D6AAE),
                  fontWeight:
                      FontWeight.w700,
                ),
              ),

              const SizedBox(width: 6),
            ],

            const Icon(
              Icons.chevron_right_rounded,
            ),
          ],
        ),
      ),
    );
  }
}


class SettingsDivider extends StatelessWidget {
  const SettingsDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding:
          EdgeInsets.only(left: 76),

      child: Divider(
        height: 1,
        thickness: 0.7,
      ),
    );
  }
}