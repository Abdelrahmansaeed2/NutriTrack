import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/app_vectors.dart';
import '../cubits/physical_metrics_cubit.dart';
import '../cubits/physical_metrics_state.dart';
import '../widgets/page_transitions.dart';
import 'activity_goal_screen.dart'; // Next screen in flow

class PhysicalMetricsScreen extends StatelessWidget {
  const PhysicalMetricsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PhysicalMetricsCubit(),
      child: const PhysicalMetricsView(),
    );
  }
}

class PhysicalMetricsView extends StatefulWidget {
  const PhysicalMetricsView({super.key});

  @override
  State<PhysicalMetricsView> createState() => _PhysicalMetricsViewState();
}

class _PhysicalMetricsViewState extends State<PhysicalMetricsView> {
  final TextEditingController _ageController = TextEditingController(text: "30");
  final TextEditingController _currentWeightController = TextEditingController(text: "75.5");
  final TextEditingController _targetWeightController = TextEditingController(text: "70.0");

  @override
  void dispose() {
    _ageController.dispose();
    _currentWeightController.dispose();
    _targetWeightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      // Header Section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Let's establish your baseline to personalize your nutrition.",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF3C4A42),
                              ),
                            ),
                            const SizedBox(height: 24),
                            // Stepper
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    _buildStepIndicator(isActive: true),
                                    const SizedBox(width: 8),
                                    _buildStepIndicator(isActive: false),
                                    const SizedBox(width: 8),
                                    _buildStepIndicator(isActive: false),
                                    const SizedBox(width: 8),
                                    _buildStepIndicator(isActive: false),
                                  ],
                                ),
                                const Text(
                                  "STEP 1 OF 4",
                                  style: TextStyle(
                                    fontFamily: 'JetBrains Mono',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF3C4A42),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      // Form Content
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: BlocBuilder<PhysicalMetricsCubit, PhysicalMetricsState>(
                            builder: (context, state) {
                              return Column(
                                children: [
                                  _buildGenderCard(context, state),
                                  const SizedBox(height: 16),
                                  _buildAgeCard(context, state),
                                  const SizedBox(height: 16),
                                  _buildHeightCard(context, state),
                                  const SizedBox(height: 16),
                                  _buildWeightGrid(context, state),
                                  const SizedBox(height: 24),
                                ],
                              );
                            },
                          ),
                        ),
                      ),

                      // Fixed Bottom Action
                      Container(
                        width: double.infinity,
                        color: const Color(0xFFF8F9FF),
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                        child: BlocBuilder<PhysicalMetricsCubit, PhysicalMetricsState>(
                          builder: (context, state) {
                            return ElevatedButton(
                              onPressed: state.isNextEnabled
                                  ? () {
                                      context.go('/onboarding/activity');
                                    }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF10B981),
                                disabledBackgroundColor: const Color(0xFF10B981).withValues(alpha: 0.5),
                                foregroundColor: const Color(0xFFFFFFFF),
                                minimumSize: const Size.fromHeight(56),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ).copyWith(
                                // Match shadow precisely from Traceability table when enabled
                                shadowColor: WidgetStateProperty.resolveWith((states) {
                                  if (states.contains(WidgetState.disabled)) return Colors.transparent;
                                  return const Color(0xFF000000).withValues(alpha: 0.1);
                                }),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Next Step",
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  SvgPicture.string(
                                    AppVectors.icon_12,
                                    width: 16,
                                    height: 16,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStepIndicator({required bool isActive}) {
    return Container(
      width: 41,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF10B981) : const Color(0xFFD9E3F6),
        borderRadius: BorderRadius.circular(9999),
      ),
    );
  }

  Widget _buildCardContainer({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEFF4FF), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D1F2937),
            offset: Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildCardHeader(String title, String iconVector, double iconWidth, double iconHeight) {
    return Row(
      children: [
        SizedBox(
          width: 18, // Fixed width for alignment if needed
          child: Center(
            child: SvgPicture.string(
              iconVector,
              width: iconWidth,
              height: iconHeight,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF121C2A),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderCard(BuildContext context, PhysicalMetricsState state) {
    return _buildCardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardHeader("Biological Sex", AppVectors.icon_5, 17, 20),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildGenderButton(
                  context,
                  title: "Male",
                  iconVector: AppVectors.icon_6,
                  iconWidth: 16,
                  iconHeight: 16,
                  isSelected: state.selectedGender == Gender.male,
                  onTap: () => context.read<PhysicalMetricsCubit>().selectGender(Gender.male),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildGenderButton(
                  context,
                  title: "Female",
                  iconVector: AppVectors.icon_7,
                  iconWidth: 11,
                  iconHeight: 17,
                  isSelected: state.selectedGender == Gender.female,
                  onTap: () => context.read<PhysicalMetricsCubit>().selectGender(Gender.female),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGenderButton(
    BuildContext context, {
    required String title,
    required String iconVector,
    required double iconWidth,
    required double iconHeight,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEFF4FF) : const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF10B981) : const Color(0xFFD9E3F6),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.string(
              iconVector,
              width: iconWidth,
              height: iconHeight,
              colorFilter: ColorFilter.mode(
                isSelected ? const Color(0xFF10B981) : const Color(0xFF3C4A42),
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isSelected ? const Color(0xFF10B981) : const Color(0xFF3C4A42),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAgeCard(BuildContext context, PhysicalMetricsState state) {
    return _buildCardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardHeader("Age", AppVectors.icon_8, 18, 20),
          const SizedBox(height: 16),
          Container(
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _ageController,
                    keyboardType: TextInputType.number,
                    onChanged: (val) => context.read<PhysicalMetricsCubit>().updateAge(val),
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF121C2A),
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                const Text(
                  "YRS",
                  style: TextStyle(
                    fontFamily: 'JetBrains Mono',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF3C4A42),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeightCard(BuildContext context, PhysicalMetricsState state) {
    return _buildCardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildCardHeader("Height", AppVectors.icon_9, 8, 18),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    state.heightCm.round().toString(),
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF121C2A),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    "cm",
                    style: TextStyle(
                      fontFamily: 'JetBrains Mono',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF3C4A42),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 4,
              activeTrackColor: const Color(0xFF10B981),
              inactiveTrackColor: const Color(0xFFD9E3F6),
              thumbColor: const Color(0xFF10B981),
              overlayColor: const Color(0xFF10B981).withValues(alpha: 0.1),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
            ),
            child: Slider(
              value: state.heightCm,
              min: 100,
              max: 250,
              onChanged: (val) => context.read<PhysicalMetricsCubit>().updateHeight(val),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeightGrid(BuildContext context, PhysicalMetricsState state) {
    return Row(
      children: [
        Expanded(
          child: _buildWeightInput(
            title: "Weight",
            iconVector: AppVectors.icon_10,
            iconWidth: 18,
            iconHeight: 18,
            controller: _currentWeightController,
            onChanged: (val) => context.read<PhysicalMetricsCubit>().updateCurrentWeight(val),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildWeightInput(
            title: "Target",
            iconVector: AppVectors.icon_11,
            iconWidth: 15,
            iconHeight: 17,
            controller: _targetWeightController,
            onChanged: (val) => context.read<PhysicalMetricsCubit>().updateTargetWeight(val),
          ),
        ),
      ],
    );
  }

  Widget _buildWeightInput({
    required String title,
    required String iconVector,
    required double iconWidth,
    required double iconHeight,
    required TextEditingController controller,
    required ValueChanged<String> onChanged,
  }) {
    return _buildCardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardHeader(title, iconVector, iconWidth, iconHeight),
          const SizedBox(height: 16),
          Container(
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    onChanged: onChanged,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF121C2A),
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                const Text(
                  "kg",
                  style: TextStyle(
                    fontFamily: 'JetBrains Mono',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF3C4A42),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
