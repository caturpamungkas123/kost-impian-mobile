import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../explore/presentation/pages/explore_page.dart';
import '../widgets/auth_tab_switcher.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/role_selector.dart';
import '../widgets/social_auth_buttons.dart';

/// Layar Login & Register KosanKu — satu halaman dengan tab switcher,
/// sesuai Stitch `Login & Register KosanKu`
/// (projects/3380788847386773914/screens/4b718f437af4415383111b6d55a5433a).
///
/// Alur prd.md §4 langkah 2: registrasi email+password + pilih peran,
/// verifikasi email, login, lupa password. UI-first: tanpa BLoC/backend,
/// state lokal (tab, peran, visibility password) via StatefulWidget.
class AuthPage extends StatefulWidget {
  const AuthPage({super.key, this.initialIsLogin = false});

  static const loginRoute = '/login';
  static const registerRoute = '/register';

  final bool initialIsLogin;

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  late bool _isLogin = widget.initialIsLogin;
  AuthRole _role = AuthRole.seeker;
  bool _obscurePassword = true;
  bool _rememberMe = true;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String get _ctaLabel {
    final role = _role.title;
    return _isLogin ? 'Masuk ke Akun ($role)' : 'Daftar Sebagai $role';
  }

  /// Validasi lokal UI-first (belum ke backend):
  /// semua field wajib diisi + tipe data diperiksa.
  String? _required(String? value, String field) {
    if (value == null || value.trim().isEmpty) {
      return '$field wajib diisi';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    final empty = _required(value, 'Email');
    if (empty != null) return empty;
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(value!.trim())) {
      return 'Format email tidak valid';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    final empty = _required(value, 'Nomor WhatsApp');
    if (empty != null) return empty;
    final digits = value!.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 9 || digits.length > 15) {
      return 'Nomor WhatsApp tidak valid';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    final empty = _required(value, 'Kata sandi');
    if (empty != null) return empty;
    if (value!.length < 8) {
      return 'Kata sandi minimal 8 karakter';
    }
    return null;
  }

  void _switchTab(bool isLogin) {
    setState(() => _isLogin = isLogin);
    // Bersihkan error validasi mode sebelumnya.
    _formKey.currentState?.reset();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    // Sementara (UI-first): login valid langsung ke Explore.
    // Nanti diganti AuthBloc (verifikasi ke backend + simpan JWT).
    if (_isLogin && mounted) {
      context.go(ExplorePage.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isLight = Theme.of(context).brightness == Brightness.light;
    final muted =
        isLight ? AppColors.textSecondary : AppColors.darkTextSecondary;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.gutter,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.lg),
              Text('Selamat Datang\ndi KosanKu', style: AppTypography.h2),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Satu akun untuk cari hunian idaman atau kelola bisnis kos Anda dengan mudah.',
                style: AppTypography.bodyMd.copyWith(color: muted),
              ),
              const SizedBox(height: AppSpacing.lg),
              AuthTabSwitcher(
                isLogin: _isLogin,
                onChanged: _switchTab,
              ),
              const SizedBox(height: AppSpacing.lg),
              RoleSelector(
                selected: _role,
                onChanged: (r) => setState(() => _role = r),
              ),
              const SizedBox(height: AppSpacing.lg),
              Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!_isLogin) ...[
                      AuthTextField(
                        label: 'Nama Lengkap',
                        hint: 'Contoh: Rian Pratama',
                        prefixIcon: FontAwesomeIcons.user,
                        controller: _nameController,
                        textInputAction: TextInputAction.next,
                        validator: (v) => _required(v, 'Nama Lengkap'),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      AuthTextField(
                        label: 'Nomor WhatsApp Aktif',
                        hint: '0812-3456-7890',
                        prefixIcon: FontAwesomeIcons.phone,
                        keyboardType: TextInputType.phone,
                        controller: _phoneController,
                        textInputAction: TextInputAction.next,
                        validator: _validatePhone,
                      ),
                      const SizedBox(height: AppSpacing.md),
                    ],
                    AuthTextField(
                      label: 'Alamat Email',
                      hint: 'nama@email.com',
                      prefixIcon: FontAwesomeIcons.envelope,
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailController,
                      textInputAction: TextInputAction.next,
                      validator: _validateEmail,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            'Kata Sandi',
                            style: AppTypography.labelSm.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        if (_isLogin)
                          GestureDetector(
                            onTap: () {},
                            child: Text(
                              'Lupa Password?',
                              style: AppTypography.labelSm.copyWith(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: muted,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    AuthTextField(
                      hint: 'Minimal 8 karakter',
                      prefixIcon: FontAwesomeIcons.lock,
                      obscureText: _obscurePassword,
                      controller: _passwordController,
                      textInputAction: TextInputAction.done,
                      validator: _validatePassword,
                      suffix: IconButton(
                        onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                        icon: FaIcon(
                          _obscurePassword
                              ? FontAwesomeIcons.eye
                              : FontAwesomeIcons.eyeSlash,
                          size: 16,
                          color: muted,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: Checkbox(
                      value: _rememberMe,
                      onChanged: (v) => setState(
                        () => _rememberMe = v ?? false,
                      ),
                      shape: const CircleBorder(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Ingat akun di perangkat ini',
                    style: AppTypography.labelSm.copyWith(color: muted),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    shape: const RoundedRectangleBorder(
                      borderRadius: AppRadius.radiusFull,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _ctaLabel,
                        style: AppTypography.ctaLabel.copyWith(
                          color: scheme.onPrimary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 28,
                        height: 28,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: scheme.onPrimary.withValues(alpha: 0.2),
                        ),
                        child: FaIcon(
                          FontAwesomeIcons.arrowRight,
                          size: 12,
                          color: scheme.onPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              const SocialAuthButtons(),
              if (!_isLogin) ...[
                const SizedBox(height: AppSpacing.lg),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: AppTypography.labelSm.copyWith(
                      fontSize: 11,
                      color: muted,
                    ),
                    children: [
                      const TextSpan(
                        text: 'Dengan mendaftar, Anda menyetujui ',
                      ),
                      TextSpan(
                        text: 'Ketentuan Layanan',
                        style: TextStyle(
                          color: scheme.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const TextSpan(text: ' & '),
                      TextSpan(
                        text: 'Kebijakan Privasi',
                        style: TextStyle(
                          color: scheme.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const TextSpan(text: ' KosanKu.'),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FaIcon(
                      FontAwesomeIcons.solidCircleCheck,
                      size: 13,
                      color: isLight
                          ? AppColors.success
                          : AppColors.darkSuccess,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Tautan verifikasi email akan dikirim setelah pendaftaran.',
                      style: AppTypography.labelSm.copyWith(
                        fontSize: 10,
                        color: muted,
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: AppSpacing.xl),
              Center(
                child: Container(
                  width: 128,
                  height: 4,
                  decoration: BoxDecoration(
                    color: muted.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(9999),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
          ),
        ),
      ),
    );
  }
}
