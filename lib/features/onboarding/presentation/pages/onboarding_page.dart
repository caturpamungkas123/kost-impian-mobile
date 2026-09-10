import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/pill_button.dart';
import '../widgets/brand_header.dart';
import '../widgets/onboarding_background.dart';

/// Landing page onboarding — alur prd.md §4 langkah 1:
/// "Pengguna melihat layar onboarding lalu menekan tombol mulai."
///
/// Referensi: Stitch SAAS Kost `Onboarding KosanKu`
/// (projects/3380788847386773914/screens/f9a9927f49dc4a3aa19499d36af1d8db).
/// Styling wajib mengikuti DESIGN.md: Plus Jakarta Sans, full pill CTA,
/// flat (tanpa drop shadow tebal).
class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  static const routeName = '/onboarding';
  static const heroImageUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuBFyuzvees3f7jnnP8zGuoNJVfKwR6K5XekYekdCvyi8Dia61sEGoYeqXG-6Bznv3vz_sCC33ls6zRaPvFoawk-8gFu_2534U5Ko2iqRe9g0NjjB0PuRv5EyZxUoaFnsVxTjPCb-tZhMC6Wc5C3-LOqVFstiGEOgUTDsRfPd83gtY4XjhEnhhePDBvodEoVdJwiV_ZPUSGmx6S797ekyFrW38yWLzCZUY7RkscIFWFmjQsCiJ2Dckyb';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: Stack(
        children: [
          const OnboardingBackground(imageUrl: heroImageUrl),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.gutter,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.sm),
                  const BrandHeader(),
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    'TEMUKAN\nKOS IMPIAN',
                    style: AppTypography.displayHero.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Cari dan kelola sewa kos lebih mudah, cepat, dan terpercaya kapan pun, di mana pun.',
                    textAlign: TextAlign.center,
                    style: AppTypography.bodyMd.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  PillButton(
                    label: 'Mulai Sekarang',
                    trailing: const CircleArrow(),
                    onPressed: () => context.go('/login'),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        style: AppTypography.labelSm.copyWith(
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                        children: [
                          const TextSpan(text: 'Sudah punya akun? '),
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: GestureDetector(
                              onTap: () => context.go('/login'),
                              child: Text(
                                'Masuk',
                                style: AppTypography.labelSm.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
