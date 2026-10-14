import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import 'progress/progress_screen.dart';
import 'home/home_screen.dart';
import 'community/community_screen.dart';
import 'support/support_screen.dart';
import 'profile/profile_screen.dart';
import 'tracker/check_in_screen.dart';
import 'widgets/sos_panic_dialog.dart';
import 'widgets/tracker_selection_drawer.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen>
    with SingleTickerProviderStateMixin {
  // Navigation slot index mapping:
  // Slot 1 (Far Left): Progress -> Index 0
  // Slot 2 (Middle Left): Today -> Index 1 (Default)
  // Slot 3 (Center): Accommodates Overlapping FAB
  // Slot 4 (Middle Right): Community -> Index 2
  // Slot 5 (Far Right): Support -> Index 3
  int _activeTabIndex = 1;

  bool _isMenuOpen = false;
  late AnimationController _menuController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _rotationAnimation;

  final List<Widget> _screens = const [
    ProgressScreen(),
    HomeScreen(),
    CommunityScreen(),
    SupportScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _menuController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _menuController,
      curve: Curves.easeOutBack,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _menuController,
      curve: Curves.easeOut,
    );
    _rotationAnimation = Tween<double>(begin: 0.0, end: 0.125).animate(
      CurvedAnimation(parent: _menuController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _menuController.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
      if (_isMenuOpen) {
        _menuController.forward();
      } else {
        _menuController.reverse();
      }
    });
  }

  void _closeMenu() {
    if (_isMenuOpen) {
      setState(() {
        _isMenuOpen = false;
        _menuController.reverse();
      });
    }
  }

  void _handleMenuAction(String action) {
    _closeMenu();
    switch (action) {
      case 'Thoughts':
      case 'Feelings':
      case 'Trigger':
      case 'Quick Journal':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CheckInScreen()),
        );
        break;
      case 'Cravings':
        SosPanicSheet.show(context);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    const double barHeight = 62.0;
    final totalBarHeight = barHeight + bottomPadding;
    const double fabSize = 56.0;

    return Scaffold(
      backgroundColor: AppColors.softSurfaceGray, // Soft Surface Gray (#F8FAFC)
      drawer: const TrackerSelectionDrawer(),
      // 1. Top App Bar (Progress, Community, and Support screens render their own specialized Top App Bar)
      appBar: (_activeTabIndex == 0 || _activeTabIndex == 2 || _activeTabIndex == 3)
          ? null
          : PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: AppBar(
          backgroundColor: AppColors.primaryBlue, // Primary Blue (#0C3C60)
          elevation: 0,
          leadingWidth: 64,
          leading: Builder(
            builder: (barCtx) => Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Center(
                // App Logo button opening Tracker Selection Drawer
                child: GestureDetector(
                  onTap: () => Scaffold.of(barCtx).openDrawer(),
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.asset(
                      'icon.png',
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.spa_rounded,
                        color: AppColors.accentCyan,
                        size: 22,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          centerTitle: true,
          title: const Text(
            'Your recovery journey companion',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 14.5,
              letterSpacing: -0.2,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                // Profile avatar/icon placeholder (circular)
                child: GestureDetector(
                  onTap: () {
                    _closeMenu();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ProfileScreen()),
                    );
                  },
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.accentCyan,
                        width: 1.8,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x1A000000),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      // 2. Main content area + Custom Bottom Nav + FAB + Overlapping Menu
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          // Main Content Area
          Positioned.fill(
            child: IndexedStack(
              index: _activeTabIndex,
              children: _screens,
            ),
          ),

          // Modal backdrop scrim (active when center menu is open)
          if (_isMenuOpen)
            Positioned.fill(
              child: GestureDetector(
                onTap: _closeMenu,
                behavior: HitTestBehavior.opaque,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.35),
                  ),
                ),
              ),
            ),

          // 4. Center Popup Menu (Triggered by FAB)
          if (_isMenuOpen)
            Positioned(
              bottom: totalBarHeight + 24,
              left: 0,
              right: 0,
              child: Center(
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  alignment: Alignment.bottomCenter,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      width: 270,
                      decoration: BoxDecoration(
                        color: AppColors.baseWhite, // Base White (#FFFFFF)
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.borderLightGray.withValues(alpha: 0.8),
                          width: 1.2,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x240C3C60),
                            blurRadius: 28,
                            spreadRadius: 2,
                            offset: Offset(0, -6),
                          ),
                          BoxShadow(
                            color: Color(0x0F0C3C60),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildPopupMenuItem(
                              icon: Icons.lightbulb_outline_rounded,
                              label: 'Thoughts',
                              onTap: () => _handleMenuAction('Thoughts'),
                            ),
                            _buildMenuDivider(),
                            _buildPopupMenuItem(
                              icon: Icons.waves_rounded,
                              label: 'Cravings',
                              onTap: () => _handleMenuAction('Cravings'),
                            ),
                            _buildMenuDivider(),
                            _buildPopupMenuItem(
                              icon: Icons.flag_outlined,
                              label: 'Trigger',
                              onTap: () => _handleMenuAction('Trigger'),
                            ),
                            _buildMenuDivider(),
                            _buildPopupMenuItem(
                              icon: Icons.favorite_border_rounded,
                              label: 'Feelings',
                              onTap: () => _handleMenuAction('Feelings'),
                            ),
                            _buildMenuDivider(),
                            _buildPopupMenuItem(
                              icon: Icons.edit_note_rounded,
                              label: 'Quick Journal',
                              onTap: () => _handleMenuAction('Quick Journal'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // 2. Custom Bottom Navigation Bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: totalBarHeight,
              padding: EdgeInsets.only(bottom: bottomPadding),
              decoration: const BoxDecoration(
                color: AppColors.baseWhite, // Base White (#FFFFFF)
                border: Border(
                  top: BorderSide(
                    color: Color(0xFFE2E8F0),
                    width: 1.2,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x0C0C3C60),
                    blurRadius: 16,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Slot 1: Progress
                  Expanded(
                    child: _buildNavSlot(
                      slotIndex: 0,
                      label: 'Progress',
                      icon: Icons.insights_rounded,
                    ),
                  ),
                  // Slot 2: Today
                  Expanded(
                    child: _buildNavSlot(
                      slotIndex: 1,
                      label: 'Today',
                      icon: Icons.dashboard_rounded,
                    ),
                  ),
                  // Slot 3: Empty center gap to accommodate the overlapping FAB
                  const SizedBox(width: 68),
                  // Slot 4: Community
                  Expanded(
                    child: _buildNavSlot(
                      slotIndex: 2,
                      label: 'Community',
                      icon: Icons.groups_rounded,
                    ),
                  ),
                  // Slot 5: Support
                  Expanded(
                    child: _buildNavSlot(
                      slotIndex: 3,
                      label: 'Support',
                      icon: Icons.health_and_safety_rounded,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 3. Center Floating Action Button (FAB)
          // Positioned absolutely in the bottom center, breaking the top boundary
          // of the bottom navigation bar so it overlaps the main content area slightly.
          Positioned(
            left: 0,
            right: 0,
            bottom: totalBarHeight - (fabSize / 2),
            child: Center(
              child: GestureDetector(
                onTap: _toggleMenu,
                child: Container(
                  width: fabSize,
                  height: fabSize,
                  decoration: BoxDecoration(
                    color: AppColors.accentCyan, // Accent Cyan (#31C1D7)
                    shape: BoxShape.circle,
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x5531C1D7),
                        blurRadius: 16,
                        spreadRadius: 2,
                        offset: Offset(0, 4),
                      ),
                      BoxShadow(
                        color: Color(0x180C3C60),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: RotationTransition(
                      turns: _rotationAnimation,
                      child: const Icon(
                        Icons.add_rounded,
                        color: Colors.white, // Pure white "+" symbol
                        size: 32,
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

  Widget _buildNavSlot({
    required int slotIndex,
    required String label,
    required IconData icon,
  }) {
    final isSelected = _activeTabIndex == slotIndex;
    final color = isSelected ? AppColors.accentCyan : AppColors.slateText;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          _closeMenu();
          setState(() => _activeTabIndex = slotIndex);
        },
        splashColor: AppColors.accentCyan.withValues(alpha: 0.1),
        highlightColor: Colors.transparent,
        child: SizedBox(
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: color,
                size: 23,
              ),
              const SizedBox(height: 3),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: color,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 2),
              // Subtle active indicator dot
              Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.accentCyan : Colors.transparent,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPopupMenuItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: AppColors.accentCyan.withValues(alpha: 0.12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
          child: Row(
            children: [
              Icon(
                icon,
                color: AppColors.accentCyan, // Accent Cyan (#31C1D7)
                size: 22,
              ),
              const SizedBox(width: 14),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.slateText, // Slate Text (#334155)
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuDivider() {
    return Divider(
      height: 1,
      thickness: 0.8,
      color: AppColors.borderLightGray.withValues(alpha: 0.4),
      indent: 16,
      endIndent: 16,
    );
  }
}
