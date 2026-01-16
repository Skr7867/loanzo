import 'package:dsa/res/component/round_button.dart';
import 'package:dsa/res/enum/enum.dart';
import 'package:dsa/res/fonts/app_fonts.dart';
import 'package:dsa/res/routes/routes_name.dart';
import 'package:dsa/view/Home/widgets/high_credit_score_widget.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../data/hive/loginResponse/login_response_hive.dart';
import '../../res/color/app_colors.dart';
import '../../res/listitem/list_item.dart';
import '../../viewModels/controllers/Theme/theme_controller.dart';
import '../Logout/log_out_dialog_box.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DashboardMetric selectedMetric = DashboardMetric.conversionRate;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  String _getChartTitle() {
    switch (selectedMetric) {
      case DashboardMetric.conversionRate:
        return 'Conversion Rate - Monthly Trend';
      case DashboardMetric.eligibleCustomers:
        return 'Eligible Customers - Monthly Trend';
      case DashboardMetric.totalEarnings:
        return 'Total Earnings - Monthly Performance';
      default:
        return 'Total Customers - Monthly Growth';
    }
  }

  Color _getMetricColor() {
    switch (selectedMetric) {
      case DashboardMetric.totalCustomers:
        return Colors.blue;
      case DashboardMetric.eligibleCustomers:
        return Colors.green;
      case DashboardMetric.totalEarnings:
        return Colors.orange;
      default:
        return Colors.purple;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildDrawer(context),
      appBar: _buildAppBar(context, size),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 10, left: 15),
              child: ValueListenableBuilder(
                valueListenable: Hive.box<LoginResponseHive>(
                  'userBox',
                ).listenable(),
                builder: (context, box, _) {
                  final user = box.get('user');
                  final name = user?.partner?.name ?? 'Guest';

                  return Text(
                    'Welcome back, $name! 👋',
                    style: TextStyle(
                      fontFamily: AppFonts.opensansRegular,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Grow your loan portfolio and maximize earnings through smart partnerships',
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: AppFonts.opensansRegular,
                  color: AppColors.greyColor,
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
              child: RoundButton(
                height: 40,
                buttonColor: AppColors.blueColor,
                title: 'Add New Customer',
                onPress: () {
                  Get.toNamed(RouteName.customerRegistration);
                },
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isTablet ? 4 : 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: isTablet ? 1.1 : 0.85,
              ),
              delegate: SliverChildListDelegate([
                _infoCard(
                  title: 'TOTAL CUSTOMERS',
                  value: '1,247',
                  change: '+8.2%',
                  subtitle: '89 new this month',
                  icon: Icons.people_outline,
                  iconColor: Colors.blue,
                  metric: DashboardMetric.totalCustomers,
                ),
                _infoCard(
                  title: 'ELIGIBLE CUSTOMERS',
                  value: '856',
                  change: '+12.5%',
                  subtitle: 'CIBIL score >700',
                  icon: Icons.verified_user_outlined,
                  iconColor: Colors.green,
                  metric: DashboardMetric.eligibleCustomers,
                ),
                _infoCard(
                  title: 'CONVERSION RATE',
                  value: '68%',
                  change: '+5.2%',
                  subtitle: 'Approval success',
                  icon: Icons.trending_up,
                  iconColor: Colors.purple,
                  metric: DashboardMetric.conversionRate,
                ),
                _infoCard(
                  title: 'TOTAL EARNINGS',
                  value: '₹2.8L',
                  change: '+15.7%',
                  subtitle: 'Commission earned',
                  icon: Icons.account_balance_wallet_outlined,
                  iconColor: Colors.orange,
                  metric: DashboardMetric.totalEarnings,
                ),
              ]),
            ),
          ),

          // Charts
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: _monthlyTrendChart(isTablet),
                  ),
                  const SizedBox(height: 16),
                  _creditSegmentationChart(isTablet),
                  const SizedBox(height: 16),
                  HighCreditScoreCustomersCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _monthlyTrendChart(bool isTablet) {
    final data = lineChartData();
    final metricColor = _getMetricColor();

    return _cardContainer(
      title: _getChartTitle(),
      child: SizedBox(
        height: isTablet ? 280 : 220,
        child: Padding(
          padding: const EdgeInsets.only(right: 10, top: 16),
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 1,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: AppColors.greyColor.withOpacity(0.4),
                    strokeWidth: 1,
                  );
                },
              ),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 42,
                    getTitlesWidget: (value, meta) {
                      if (selectedMetric == DashboardMetric.totalEarnings) {
                        return Text(
                          '₹${value.toStringAsFixed(1)}L',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 11,
                            fontFamily: AppFonts.opensansRegular,
                          ),
                        );
                      } else if (selectedMetric ==
                          DashboardMetric.conversionRate) {
                        return Text(
                          '${value.toInt()}%',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 11,
                          ),
                        );
                      }
                      return Text(
                        value.toInt().toString(),
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 11,
                        ),
                      );
                    },
                  ),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 28,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      const months = [
                        'Jan',
                        'Feb',
                        'Mar',
                        'Apr',
                        'May',
                        'Jun',
                        'Jul',
                        'Aug',
                        'Sep',
                        'Oct',
                        'Nov',
                        'Dec',
                      ];
                      if (value.toInt() >= 0 && value.toInt() < months.length) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            months[value.toInt()],
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 11,
                              fontFamily: AppFonts.opensansRegular,
                            ),
                          ),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              minX: 0,
              maxX: 10,
              lineTouchData: LineTouchData(
                enabled: true,
                touchTooltipData: LineTouchTooltipData(
                  // tooltipBgColor: metricColor,
                  // tooltipRoundedRadius: 8,
                  getTooltipItems: (List<LineBarSpot> touchedSpots) {
                    return touchedSpots.map((LineBarSpot touchedSpot) {
                      String text = '';
                      if (selectedMetric == DashboardMetric.totalEarnings) {
                        text = '₹${touchedSpot.y.toStringAsFixed(1)}L';
                      } else if (selectedMetric ==
                          DashboardMetric.conversionRate) {
                        text = '${touchedSpot.y.toInt()}%';
                      } else {
                        text = touchedSpot.y.toInt().toString();
                      }
                      return LineTooltipItem(
                        text,
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: AppFonts.opensansRegular,
                        ),
                      );
                    }).toList();
                  },
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: data,
                  isCurved: true,
                  color: metricColor,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) {
                      return FlDotCirclePainter(
                        radius: 4,
                        color: Colors.white,
                        strokeWidth: 2,
                        strokeColor: metricColor,
                      );
                    },
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: [
                        metricColor.withOpacity(0.3),
                        metricColor.withOpacity(0.0),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _creditSegmentationChart(bool isTablet) {
    return _cardContainer(
      title: 'Customer Credit Segmentation',
      child: SizedBox(
        height: isTablet ? 280 : 240,
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: isTablet ? 70 : 40,
                  sections: [
                    PieChartSectionData(
                      value: 45,
                      color: Colors.green,
                      title: '45%',
                      radius: isTablet ? 60 : 40,
                      titleStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    PieChartSectionData(
                      value: 35,
                      color: Colors.blue,
                      title: '35%',
                      radius: isTablet ? 60 : 40,
                      titleStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    PieChartSectionData(
                      value: 15,
                      color: Colors.orange,
                      title: '15%',
                      radius: isTablet ? 60 : 40,
                      titleStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    PieChartSectionData(
                      value: 5,
                      color: Colors.red,
                      title: '5%',
                      radius: isTablet ? 60 : 40,
                      titleStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {});
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _legendItem('Excellent', Colors.green, '562 customers'),
                  const SizedBox(height: 12),
                  _legendItem('Good', Colors.blue, '437 customers'),
                  const SizedBox(height: 12),
                  _legendItem('Average', Colors.orange, '187 customers'),
                  const SizedBox(height: 12),
                  _legendItem('Poor', Colors.red, '61 customers'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _legendItem(String label, Color color, String count) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                count,
                style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _infoCard({
    required String title,
    required String value,
    required String change,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required DashboardMetric metric,
  }) {
    final themeController = Get.find<ThemeController>();
    final isSelected = selectedMetric == metric;
    return Obx(() {
      final bool isDark = themeController.isDarkMode.value;
      return GestureDetector(
        onTap: () {
          setState(() {
            selectedMetric = metric;
            _animationController.reset();
            _animationController.forward();
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.blackColor : AppColors.whiteColor,
            borderRadius: BorderRadius.circular(16),
            border: isSelected
                ? Border.all(color: iconColor, width: 2)
                : Border.all(color: Colors.transparent, width: 2),
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? iconColor.withOpacity(0.2)
                    : Colors.black.withOpacity(0.15),
                blurRadius: isSelected ? 12 : 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: iconColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, color: iconColor, size: 22),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      change,
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        fontFamily: AppFonts.opensansRegular,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 11,
                  color: iconColor,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                  fontFamily: AppFonts.opensansRegular,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                  fontFamily: AppFonts.opensansRegular,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade500,
                  fontFamily: AppFonts.opensansRegular,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _cardContainer({required String title, required Widget child}) {
    final themeController = Get.find<ThemeController>();

    return Obx(() {
      final bool isDark = themeController.isDarkMode.value;
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? AppColors.blackColor : AppColors.whiteColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 4,
                  height: 20,
                  decoration: BoxDecoration(
                    color: _getMetricColor(),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: AppFonts.opensansRegular,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            child,
          ],
        ),
      );
    });
  }

  Widget _buildDrawer(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Drawer(
        backgroundColor: Colors.transparent,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            ValueListenableBuilder(
              valueListenable: Hive.box<LoginResponseHive>(
                'userBox',
              ).listenable(),
              builder: (context, box, _) {
                final user = box.get('user');
                final profile = user?.partner;

                return DrawerHeader(
                  child: ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.person)),
                    title: Text(
                      profile?.name ?? 'Guest User',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: AppFonts.opensansRegular,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                    subtitle: Text(
                      profile?.email ?? '',
                      style: const TextStyle(
                        fontSize: 15,
                        fontFamily: AppFonts.opensansRegular,
                        color: AppColors.greyColor,
                      ),
                    ),
                  ),
                );
              },
            ),

            _buildDrawerItem(
              context,
              icon: Icons.people,
              title: 'Customer',
              onTap: () {
                Get.toNamed(RouteName.getRegisterUser);
              },
            ),
            _buildDrawerItem(
              context,
              icon: Icons.sunny,
              title: 'Theme',
              value: themeController.isDarkMode.value
                  ? 'dark_mode'.tr
                  : 'light_mode'.tr,
              onTap: () {
                Get.bottomSheet(
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Select Theme',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                            fontFamily: AppFonts.opensansRegular,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ListTile(
                          leading: Icon(
                            PhosphorIconsRegular.moon,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                          title: Text(
                            'Dark Mode',
                            style: TextStyle(
                              fontSize: 20,
                              color: Theme.of(
                                context,
                              ).textTheme.bodyLarge?.color,
                              fontFamily: AppFonts.opensansRegular,
                            ),
                          ),
                          onTap: () {
                            if (!themeController.isDarkMode.value) {
                              themeController.switchTheme();
                            }
                            Get.back();
                          },
                        ),
                        ListTile(
                          leading: Icon(
                            PhosphorIconsRegular.sun,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                          title: Text(
                            'Light Mode',
                            style: TextStyle(
                              fontSize: 20,
                              color: Theme.of(
                                context,
                              ).textTheme.bodyLarge?.color,
                              fontFamily: AppFonts.opensansRegular,
                            ),
                          ),
                          onTap: () {
                            if (themeController.isDarkMode.value) {
                              themeController.switchTheme();
                            }
                            Get.back();
                          },
                        ),
                      ],
                    ),
                  ),
                  isScrollControlled: true,
                );
              },
            ),
            _buildDrawerItem(
              context,
              icon: Icons.calculate,
              title: 'EMI Calculators',
              onTap: () {
                Get.toNamed(RouteName.emiCalculators);
              },
            ),
            _buildDrawerItem(
              context,
              icon: Icons.abc_outlined,
              title: 'About',
              onTap: () {},
            ),
            _buildDrawerItem(
              context,
              icon: Icons.logout,
              title: 'Logout',
              isLogout: true,
              onTap: () => showLogoutDialog(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    String? value,
    bool isLogout = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isLogout
            ? AppColors.redColor
            : Theme.of(context).textTheme.bodyLarge?.color,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isLogout
              ? Colors.red
              : Theme.of(context).textTheme.bodyLarge?.color,
          fontSize: 15,
          fontFamily: AppFonts.opensansRegular,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: onTap,
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, Size size) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      toolbarHeight: 70,
      title: Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.menu,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          ),
          _buildProfileAvatar(context),
          SizedBox(width: size.width * 0.02),
          Expanded(child: _buildUserName(context)),
          _buildNotificationIcon(context),
        ],
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          color: AppColors.greyColor.withOpacity(0.4),
          height: 1.0,
        ),
      ),
    );
  }

  Widget _buildProfileAvatar(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(RouteName.profileScreen);
      },
      child: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.blackColor, width: 2),
        ),
        child: ClipOval(child: Icon(Icons.person)),
      ),
    );
  }
}

Widget _buildUserName(BuildContext context) {
  return ValueListenableBuilder(
    valueListenable: Hive.box<LoginResponseHive>('userBox').listenable(),
    builder: (context, box, _) {
      final user = box.get('user');
      final name = user?.partner?.name ?? 'Guest';

      return Text(
        name,
        style: TextStyle(
          fontFamily: AppFonts.helveticaMedium,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).textTheme.bodyLarge?.color,
        ),
        overflow: TextOverflow.ellipsis,
      );
    },
  );
}

Widget _buildNotificationIcon(BuildContext context) {
  return Stack(
    children: [
      IconButton(
        icon: Icon(
          Icons.notifications,
          color: Theme.of(context).textTheme.bodyLarge?.color,
        ),
        onPressed: () => Get.toNamed(RouteName.notificationScreen),
      ),
      Positioned(
        right: 10,
        top: 8,
        child: Container(
          height: 18,
          padding: const EdgeInsets.all(4),
          decoration: const BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '2',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 7,
              ),
            ),
          ),
        ),
      ),
    ],
  );
}
