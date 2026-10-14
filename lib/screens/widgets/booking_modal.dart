import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/sobriety_provider.dart';

class BookingModal {
  static void show(
    BuildContext context, {
    String sessionType = 'default',
    VoidCallback? onBookingConfirmed,
  }) {
    final bool isCertification = sessionType == 'certification';

    final timeOptions = [
      '9:00 AM',
      '10:00 AM',
      '11:00 AM',
      '12:00 PM',
      '2:00 PM',
      '3:00 PM',
      '4:00 PM',
      '5:00 PM',
    ];

    final purposeOptions = isCertification
        ? [
            'Milestone Certification',
            'Sobriety Assessment',
            'Urgent Council',
            'Others (please specify)',
          ]
        : [
            'Urgent Council',
            'Sobriety Assessment',
            'Others (please specify)',
          ];

    // Hide the "Chat" format option for certification, enforcing only "Video" or "Voice"
    final formatOptions = isCertification
        ? ['Video Call', 'Voice Call']
        : ['Video Call', 'Voice Call', 'Chat Session'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) {
        String? selectedFormat;
        String? selectedPurpose = isCertification ? 'Milestone Certification' : null;
        String? selectedTime;
        DateTime? selectedDate;
        final othersCtrl = TextEditingController();

        return StatefulBuilder(
          builder: (modalCtx, setModalState) {
            Widget sectionLabel(String text) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    text,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.slateMuted,
                    ),
                  ),
                );

            Widget styledDropdown<T>({
              required String hint,
              required T? value,
              required List<T> items,
              required String Function(T) display,
              required void Function(T?) onChanged,
            }) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.baseWhite,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.borderLightGray),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<T>(
                    value: value,
                    isExpanded: true,
                    hint: Text(
                      hint,
                      style: const TextStyle(
                        color: AppColors.slateMuted,
                        fontSize: 13.5,
                      ),
                    ),
                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppColors.slateMuted,
                    ),
                    dropdownColor: AppColors.baseWhite,
                    style: const TextStyle(
                      color: AppColors.slateText,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                    ),
                    items: items
                        .map((item) => DropdownMenuItem<T>(
                              value: item,
                              child: Text(display(item)),
                            ))
                        .toList(),
                    onChanged: onChanged,
                  ),
                ),
              );
            }

            Future<void> pickDate() async {
              final now = DateTime.now();
              final picked = await showDatePicker(
                context: modalCtx,
                initialDate: selectedDate ?? now,
                firstDate: now,
                lastDate: now.add(const Duration(days: 90)),
                builder: (ctx, child) => Theme(
                  data: Theme.of(ctx).copyWith(
                    colorScheme: const ColorScheme.light(
                      primary: AppColors.primaryBlue,
                      onPrimary: Colors.white,
                      onSurface: AppColors.slateText,
                    ),
                  ),
                  child: child!,
                ),
              );
              if (picked != null) setModalState(() => selectedDate = picked);
            }

            final dateLabel = selectedDate == null
                ? 'Tap to choose a date'
                : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}';

            return Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(modalCtx).size.height * 0.90,
              ),
              decoration: const BoxDecoration(
                color: AppColors.softSurfaceGray,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                border: Border(
                  top: BorderSide(color: AppColors.borderLightGray, width: 1),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Drag pill
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.borderLightGray,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Modal header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isCertification
                                    ? 'Book Certification Assessment'
                                    : 'Book a 1-on-1 Session',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.slateText,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                isCertification
                                    ? 'Certified specialist evaluation to verify milestone credentials'
                                    : 'Confidential, HIPAA-compliant support',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.slateMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(modalCtx),
                          icon: const Icon(
                            Icons.close_rounded,
                            color: AppColors.slateMuted,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1, color: AppColors.borderLightGray),

                  // Scrollable form body
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 1. Session Format
                          sectionLabel('Session Format'),
                          styledDropdown<String>(
                            hint: 'Choose session format...',
                            value: selectedFormat,
                            items: formatOptions,
                            display: (v) => v,
                            onChanged: (v) =>
                                setModalState(() => selectedFormat = v),
                          ),
                          const SizedBox(height: 18),

                          // 2. Purpose of Meeting
                          sectionLabel('Purpose of Meeting'),
                          styledDropdown<String>(
                            hint: 'Select a purpose...',
                            value: selectedPurpose,
                            items: purposeOptions,
                            display: (v) => v,
                            onChanged: (v) =>
                                setModalState(() => selectedPurpose = v),
                          ),
                          if (selectedPurpose == 'Others (please specify)') ...[
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.baseWhite,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: AppColors.accentCyan
                                      .withValues(alpha: 0.5),
                                ),
                              ),
                              child: TextField(
                                controller: othersCtrl,
                                style: const TextStyle(
                                  color: AppColors.slateText,
                                  fontSize: 13.5,
                                ),
                                cursorColor: AppColors.accentCyan,
                                decoration: const InputDecoration(
                                  hintText:
                                      'Describe the purpose of your session...',
                                  hintStyle: TextStyle(
                                    color: AppColors.slateMuted,
                                    fontSize: 13,
                                  ),
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 10),
                                ),
                                maxLines: 2,
                              ),
                            ),
                          ],
                          const SizedBox(height: 18),

                          // 3. Preferred Date
                          sectionLabel('Preferred Date'),
                          GestureDetector(
                            onTap: pickDate,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 14,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.baseWhite,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: selectedDate != null
                                      ? AppColors.accentCyan
                                      : AppColors.borderLightGray,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_month_rounded,
                                    size: 18,
                                    color: selectedDate != null
                                        ? AppColors.accentCyan
                                        : AppColors.slateMuted,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      dateLabel,
                                      style: TextStyle(
                                        fontSize: 13.5,
                                        fontWeight: selectedDate != null
                                            ? FontWeight.w700
                                            : FontWeight.w400,
                                        color: selectedDate != null
                                            ? AppColors.slateText
                                            : AppColors.slateMuted,
                                      ),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.edit_calendar_outlined,
                                    size: 16,
                                    color: AppColors.slateMuted,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),

                          // 4. Preferred Time
                          sectionLabel('Preferred Time'),
                          styledDropdown<String>(
                            hint: 'Choose a time slot...',
                            value: selectedTime,
                            items: timeOptions,
                            display: (v) => v,
                            onChanged: (v) =>
                                setModalState(() => selectedTime = v),
                          ),
                          const SizedBox(height: 80),
                        ],
                      ),
                    ),
                  ),

                  // Sticky footer
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                    decoration: const BoxDecoration(
                      color: AppColors.softSurfaceGray,
                      border: Border(
                        top: BorderSide(color: AppColors.borderLightGray),
                      ),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          if (selectedFormat == null ||
                              selectedPurpose == null ||
                              selectedDate == null ||
                              selectedTime == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: AppColors.warning,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                content: const Text(
                                  'Please complete all fields before confirming.',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            );
                            return;
                          }

                          // If certification session, pass assessment in provider
                          if (isCertification) {
                            context.read<SobrietyProvider>().passAssessment();
                          }

                          Navigator.pop(modalCtx);
                          onBookingConfirmed?.call();

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: AppColors.primaryBlue,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              content: Row(
                                children: [
                                  const Icon(
                                    Icons.check_circle_rounded,
                                    color: AppColors.accentCyan,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      isCertification
                                          ? 'Certification assessment booked! Clinical specialist assigned.'
                                          : 'Session booked for ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year} at $selectedTime',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accentCyan,
                          foregroundColor: AppColors.primaryBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          isCertification
                              ? 'Confirm Assessment Session'
                              : 'Confirm Confidential Session',
                          style: const TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
