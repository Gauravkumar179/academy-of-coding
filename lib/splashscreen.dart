import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:academy_of_coding/home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _bgController; // rotates the sweep gradient
  late final AnimationController _introController; // icon/title entrance
  Timer? _navTimer;

  @override
  void initState() {
    super.initState();

    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _introController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();

    // Navigate after a short moment
    _navTimer = Timer(const Duration(milliseconds: 5000), () {
      if (!mounted) return;
      Get.offAll(
        () => const HomePage(),
        transition: Transition.fadeIn,
        duration: const Duration(milliseconds: 500),
      );
    });
  }

  @override
  void dispose() {
    _bgController.dispose();
    _introController.dispose();
    _navTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: Listenable.merge([_bgController, _introController]),
        builder: (context, _) {
          final angle = _bgController.value * 2 * math.pi;

          // Subtle pulsing for icon glow
          final glowPulse = (math.sin(_introController.value * math.pi) * 10)
              .clamp(0, 10.0);

          return Stack(
            fit: StackFit.expand,
            children: [
              // Base color (dark) for depth
              Container(color: const Color(0xFF0f172a)), // slate-900
              // Rotating sweep gradient background
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: SweepGradient(
                    transform: GradientRotation(angle),
                    colors: const [
                      Color(0xFF0ea5e9), // sky-500
                      Color(0xFF22c55e), // emerald-500
                      Color(0xFFa855f7), // violet-500
                      Color(0xFF0ea5e9),
                    ],
                    stops: const [0.0, 0.5, 0.85, 1.0],
                    center: Alignment.center,
                  ),
                ),
              ),

              // Soft vignette to make foreground pop
              Container(
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    colors: [Colors.transparent, Colors.black87],
                    stops: [0.7, 1.0],
                    radius: 1.0,
                  ),
                ),
              ),

              // Floating particles
              IgnorePointer(
                child: CustomPaint(
                  painter: _ParticlesPainter(progress: _bgController.value),
                ),
              ),

              // Center lockup
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedScale(
                      duration: const Duration(milliseconds: 900),
                      curve: Curves.easeOutBack,
                      scale: Tween(
                        begin: 0.85,
                        end: 1.0,
                      ).evaluate(_introController),
                      child: Container(
                        width: 108,
                        height: 108,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFF0ea5e9), Color(0xFF22c55e)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.10),
                              blurRadius: 16.0 + glowPulse,
                              spreadRadius: 1,
                            ),
                            BoxShadow(
                              color: const Color(0xFF22c55e).withOpacity(0.30),
                              blurRadius: 26.0 + glowPulse,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.code_rounded,
                          size: 56,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Title
                    Opacity(
                      opacity: CurvedAnimation(
                        parent: _introController,
                        curve: const Interval(0.2, 1.0),
                      ).value,
                      child: Transform.translate(
                        offset: Offset(0, (1 - _introController.value) * 10),
                        child: const Text(
                          'Academy of Coding',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.2,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    // Tagline
                    Opacity(
                      opacity: CurvedAnimation(
                        parent: _introController,
                        curve: const Interval(0.4, 1.0),
                      ).value,
                      child: Text(
                        'Learn • Build • Ship',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withOpacity(0.85),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Footer hint
              Positioned(
                bottom: 24,
                left: 0,
                right: 0,
                child: Opacity(
                  opacity: CurvedAnimation(
                    parent: _introController,
                    curve: const Interval(0.55, 1.0),
                  ).value,
                  child: const Text(
                    'Loading...',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ParticlesPainter extends CustomPainter {
  final double progress;
  _ParticlesPainter({required this.progress});

  final List<_Particle> _particles = List.generate(24, (i) {
    final rnd = (i * 73) % 1000;
    return _Particle(
      base: Offset((rnd % 100) / 100, ((rnd ~/ 10) % 100) / 100),
      size: 1.5 + (rnd % 7) / 2.5,
      speed: 0.3 + (rnd % 5) / 10,
    );
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.06);
    for (final p in _particles) {
      final t = (progress * 2 * math.pi) * p.speed;
      final dx = math.sin(t + p.base.dx * 10) * 0.015;
      final dy = math.cos(t + p.base.dy * 10) * 0.015;
      final pos = Offset(
        (p.base.dx + dx).clamp(0.0, 1.0) * size.width,
        (p.base.dy + dy).clamp(0.0, 1.0) * size.height,
      );

      canvas.drawCircle(pos, p.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlesPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class _Particle {
  final Offset base;
  final double size;
  final double speed;
  _Particle({required this.base, required this.size, required this.speed});
}
