import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/sobriety_provider.dart';

class RewardsDashboard extends StatefulWidget {
  const RewardsDashboard({super.key});

  @override
  State<RewardsDashboard> createState() => _RewardsDashboardState();
}

class _RewardsDashboardState extends State<RewardsDashboard> {
  int _selectedTab = 0; // 0: Opportunities, 1: My Applications

  final List<Map<String, dynamic>> _grants = const [
    {
      'title': 'Small Business Capital',
      'amount': 'Up to ₦500k',
      'category': 'Entrepreneurship',
      'tagColor': AppColors.primaryBlue,
      'description':
          'Seed micro-capital for entrepreneurs in recovery starting trade, retail, or service businesses.',
      'criteria': 'Verified 90-Day Milestone Certification & Business Brief.',
    },
    {
      'title': 'Tech Empowerment',
      'amount': 'Workstation Grant',
      'category': 'Technology',
      'tagColor': AppColors.accentCyan,
      'description':
          'Equips aspiring developers, designers, and digital creators with modern laptops and remote tools.',
      'criteria': 'Active participation in peer community & tech course enrollment.',
    },
    {
      'title': 'Education Fund',
      'amount': 'Full Tuition Assistance',
      'category': 'Academic',
      'tagColor': AppColors.warning,
      'description':
          'Direct tuition sponsorship for accredited vocational diplomas, certifications, and university courses.',
      'criteria': 'Valid admission letter & academic commitment pledge.',
    },
    {
      'title': 'Artisan & Trade Starter',
      'amount': 'Toolkits & Equipment',
      'category': 'Vocational',
      'tagColor': AppColors.success,
      'description':
          'Professional tools and starter kits for carpentry, plumbing, automotive repair, and tailoring.',
      'criteria': 'Apprenticeship completion or vocational school verification.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final sobriety = context.watch<SobrietyProvider>();

    return Scaffold(
      backgroundColor: AppColors.softSurfaceGray,
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar
            _buildTopAppBar(context),

            // Top Segmented Tabs: "Opportunities" & "My Applications"
            _buildTabs(sobriety),

            // Tab Content
            Expanded(
              child: _selectedTab == 0
                  ? _buildOpportunitiesList(context, sobriety)
                  : _buildApplicationsList(sobriety),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: AppColors.slateText,
              size: 24,
            ),
            splashRadius: 22,
          ),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reformed Rewards',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryBlue,
                    letterSpacing: -0.3,
                  ),
                ),
                Text(
                  'Administrative Grants & Capital Allocation',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.slateMuted,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.accentCyan.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.accentCyan.withValues(alpha: 0.35),
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.verified_rounded,
                  color: AppColors.accentCyan,
                  size: 15,
                ),
                SizedBox(width: 4),
                Text(
                  'Verified',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.accentCyan,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildTabs(SobrietyProvider sobriety) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFE2E8F0),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedTab = 0),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: _selectedTab == 0
                      ? AppColors.baseWhite
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: _selectedTab == 0
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    'Opportunities',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight:
                          _selectedTab == 0 ? FontWeight.w800 : FontWeight.w600,
                      color: _selectedTab == 0
                          ? AppColors.primaryBlue
                          : AppColors.slateMuted,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedTab = 1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: _selectedTab == 1
                      ? AppColors.baseWhite
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: _selectedTab == 1
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'My Applications',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: _selectedTab == 1
                            ? FontWeight.w800
                            : FontWeight.w600,
                        color: _selectedTab == 1
                            ? AppColors.primaryBlue
                            : AppColors.slateMuted,
                      ),
                    ),
                    if (sobriety.rewardApplications.isNotEmpty) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${sobriety.rewardApplications.length}',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Tab 1: Opportunities List
  Widget _buildOpportunitiesList(
      BuildContext context, SobrietyProvider sobriety) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
      itemCount: _grants.length,
      separatorBuilder: (_, index) => const SizedBox(height: 16),
      itemBuilder: (ctx, index) {
        final grant = _grants[index];
        return Container(
          decoration: BoxDecoration(
            color: AppColors.baseWhite,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.borderLightGray),
            boxShadow: const [
              BoxShadow(
                color: Color(0x060C3C60),
                blurRadius: 10,
                offset: Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top tag & amount row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: (grant['tagColor'] as Color).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      grant['category'] as String,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: grant['tagColor'] as Color,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      grant['amount'] as String,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primaryBlue,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Title
              Text(
                grant['title'] as String,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: AppColors.slateText,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 6),

              // Description
              Text(
                grant['description'] as String,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.slateMuted,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 12),

              // Eligibility criteria pill
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.softSurfaceGray,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.borderLightGray),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline_rounded,
                      size: 16,
                      color: AppColors.slateMuted,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Eligibility: ${grant['criteria']}',
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: AppColors.slateMuted,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // "Apply Now" button
              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  onPressed: () => _showApplicationModal(
                    context,
                    sobriety,
                    grant['title'] as String,
                    grant['amount'] as String,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Apply Now',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Tab 2: My Applications List
  Widget _buildApplicationsList(SobrietyProvider sobriety) {
    final applications = sobriety.rewardApplications;

    if (applications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.assignment_outlined,
              size: 48,
              color: AppColors.slateMuted,
            ),
            const SizedBox(height: 12),
            const Text(
              'No applications submitted yet',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.primaryBlue,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Explore available grants in the Opportunities tab.',
              style: TextStyle(fontSize: 13, color: AppColors.slateMuted),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => setState(() => _selectedTab = 0),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('View Opportunities'),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
      itemCount: applications.length,
      separatorBuilder: (_, index) => const SizedBox(height: 12),
      itemBuilder: (ctx, index) {
        final app = applications[index];
        final badgeColor = _getStatusColor(app.status);

        return Container(
          decoration: BoxDecoration(
            color: AppColors.baseWhite,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderLightGray),
            boxShadow: const [
              BoxShadow(
                color: Color(0x040C3C60),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.business_center_rounded,
                  color: AppColors.primaryBlue,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      app.grantTitle,
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w800,
                        color: AppColors.slateText,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${app.amount} · ${app.submissionDate}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.slateMuted,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Status Badge inheriting standard codebase alert colors
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: badgeColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: badgeColor.withValues(alpha: 0.4)),
                ),
                child: Text(
                  app.status,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: badgeColor,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Approved':
        return AppColors.success;
      case 'Under Review':
        return AppColors.accentCyan;
      case 'Pending':
      default:
        return AppColors.warning;
    }
  }

  // Application submission modal
  void _showApplicationModal(
    BuildContext context,
    SobrietyProvider sobriety,
    String grantTitle,
    String grantAmount,
  ) {
    final proposalController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(sheetCtx).viewInsets.bottom,
          ),
          child: Material(
            color: AppColors.baseWhite,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.borderLightGray,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Apply for $grantTitle',
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(sheetCtx),
                        icon: const Icon(Icons.close_rounded,
                            color: AppColors.slateMuted),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Allocation Amount: $grantAmount · Offline-first locally recorded',
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: AppColors.slateMuted,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Project / Proposal Summary',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.slateText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: AppColors.softSurfaceGray,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.borderLightGray),
                    ),
                    child: TextField(
                      controller: proposalController,
                      maxLines: 3,
                      style: const TextStyle(
                        fontSize: 13.5,
                        color: AppColors.slateText,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText:
                            'Describe your plan, venture, or program of study...',
                        hintStyle: TextStyle(
                          fontSize: 13,
                          color: AppColors.slateMuted,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        sobriety.submitRewardApplication(
                          grantTitle: grantTitle,
                          amount: grantAmount,
                        );
                        Navigator.pop(sheetCtx);
                        setState(() => _selectedTab = 1);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: AppColors.primaryBlue,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            content: Text(
                              'Application for $grantTitle submitted successfully! Tracking under My Applications.',
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Submit Application',
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
