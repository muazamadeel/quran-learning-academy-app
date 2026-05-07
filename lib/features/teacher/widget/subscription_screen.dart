import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quran_learning_app/core/navigation/app_router.dart';
import 'package:quran_learning_app/core/theme/app_theme.dart';
import 'package:quran_learning_app/models/student/student_model.dart';
import 'package:quran_learning_app/provider/student/subscription_provider.dart';

class SubscriptionScreen extends ConsumerWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(subscriptionProvider);
    final notifier = ref.read(subscriptionProvider.notifier);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.white),
          onPressed: () => context.go(AppRoutes.studentDashboard),
        ),
        title: Text(
          'Choose a Plan',
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.w600,
            fontSize: width * 0.045,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_outlined,
              color: AppColors.white,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: AppColors.primaryGreen,
            child: Container(
              height: 24,
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                width * 0.04,
                height * 0.01,
                width * 0.04,
                height * 0.12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(width, height),
                  SizedBox(height: height * 0.02),
                  ...state.plans.map(
                    (plan) => _buildPlanCard(
                      plan,
                      plan.id == state.selectedPlanId,
                      () => notifier.selectPlan(plan.id),
                      width,
                      height,
                    ),
                  ),
                  SizedBox(height: height * 0.015),
                  _buildDisclaimerText(width),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: _buildSubscribeButton(
        context,
        state,
        notifier,
        width,
        height,
      ),
    );
  }

  Widget _buildHeader(double width, double height) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.05,
        vertical: height * 0.02,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primaryGreen, AppColors.lightGreen],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.workspace_premium,
            color: AppColors.lightGold,
            size: width * 0.1,
          ),
          SizedBox(height: height * 0.008),
          Text(
            'Unlock Full Access',
            style: TextStyle(
              color: AppColors.white,
              fontSize: width * 0.048,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: height * 0.005),
          Text(
            'Choose the right plan for your family. Cancel anytime. Auto-renews monthly.',
            style: TextStyle(color: Colors.white70, fontSize: width * 0.031),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard(
    SubscriptionPlanModel plan,
    bool isSelected,
    VoidCallback onSelect,
    double width,
    double height,
  ) {
    return GestureDetector(
      onTap: onSelect,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.only(bottom: height * 0.015),
        padding: EdgeInsets.all(width * 0.04),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primaryGreen : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? AppColors.primaryGreen.withValues(alpha: 0.15)
                  : Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (plan.isPopular)
                        Container(
                          margin: EdgeInsets.only(bottom: height * 0.006),
                          padding: EdgeInsets.symmetric(
                            horizontal: width * 0.025,
                            vertical: width * 0.01,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.gold,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '⭐ Most Popular',
                            style: TextStyle(
                              fontSize: width * 0.027,
                              color: AppColors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      Text(
                        plan.title,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: width * 0.042,
                          color: AppColors.textDark,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '\$${plan.price.toInt()}',
                            style: TextStyle(
                              fontSize: width * 0.055,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primaryGreen,
                            ),
                          ),
                          TextSpan(
                            text: '/mo',
                            style: TextStyle(
                              fontSize: width * 0.032,
                              color: AppColors.textGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(width: width * 0.025),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: width * 0.055,
                  height: width * 0.055,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? AppColors.primaryGreen
                        : Colors.transparent,
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primaryGreen
                          : AppColors.textLight,
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? Icon(
                          Icons.check,
                          color: AppColors.white,
                          size: width * 0.035,
                        )
                      : null,
                ),
              ],
            ),
            SizedBox(height: height * 0.012),
            Divider(height: 1, color: AppColors.textLight.withValues(alpha: 0.5)),
            SizedBox(height: height * 0.012),
            ...plan.features.map(
              (feature) => Padding(
                padding: EdgeInsets.only(bottom: height * 0.006),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: AppColors.primaryGreen,
                      size: width * 0.04,
                    ),
                    SizedBox(width: width * 0.025),
                    Text(
                      feature,
                      style: TextStyle(
                        fontSize: width * 0.033,
                        color: AppColors.textDark,
                      ),
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

  Widget _buildDisclaimerText(double width) {
    return Text(
      'Subscription pricing is clearly shown above. Plans auto-renew monthly. Cancel anytime via Google Play. By subscribing you agree to our Terms & Conditions and Privacy Policy.',
      style: TextStyle(fontSize: width * 0.028, color: AppColors.textGrey),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildSubscribeButton(
    BuildContext context,
    SubscriptionState state,
    SubscriptionNotifier notifier,
    double width,
    double height,
  ) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        width * 0.04,
        height * 0.015,
        width * 0.04,
        height * 0.035,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: height * 0.065,
        child: ElevatedButton(
          onPressed: state.isSubscribing
              ? null
              : () async {
                  await notifier.subscribe();
                  if (context.mounted) {
                    _showSuccessDialog(context, state, width);
                  }
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryGreen,
            foregroundColor: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            elevation: 0,
          ),
          child: state.isSubscribing
              ? const SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(
                    color: AppColors.white,
                    strokeWidth: 2.5,
                  ),
                )
              : Text(
                  state.selectedPlan != null
                      ? 'Subscribe — \$${state.selectedPlan!.price.toInt()}/month'
                      : 'Select a Plan',
                  style: TextStyle(
                    fontSize: width * 0.04,
                    fontWeight: FontWeight.w700,
                  ),
                ),
        ),
      ),
    );
  }

  void _showSuccessDialog(
    BuildContext context,
    SubscriptionState state,
    double width,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: width * 0.1,
              backgroundColor: AppColors.gold.withValues(alpha: 0.1),
              child: Icon(
                Icons.workspace_premium,
                color: AppColors.gold,
                size: width * 0.12,
              ),
            ),
            SizedBox(height: width * 0.04),
            Text(
              'Subscribed!',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: width * 0.048,
                color: AppColors.textDark,
              ),
            ),
            SizedBox(height: width * 0.02),
            Text(
              'You are now on the ${state.selectedPlan?.title ?? ''} plan. Start booking classes!',
              style: TextStyle(
                fontSize: width * 0.033,
                color: AppColors.textGrey,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: width * 0.05),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  context.go(AppRoutes.teacherList);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(vertical: width * 0.035),
                ),
                child: Text(
                  'Find a Teacher',
                  style: TextStyle(
                    fontSize: width * 0.038,
                    fontWeight: FontWeight.w600,
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

