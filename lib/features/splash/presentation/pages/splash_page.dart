import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/di.dart';
import '../../../../core/routing/routes.dart';
import '../cubit/splash_cubit.dart';
import '../cubit/splash_state.dart';
import '../widgets/splash_app_mark.dart';
import '../widgets/splash_background.dart';
import '../widgets/splash_glass_card.dart';
import '../widgets/splash_glow_blobs.dart';
import '../widgets/splash_progress.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _scale = Tween<double>(begin: 0.96, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _controller.forward();
  }




  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  String _statusText(SplashStatus status) {
    switch (status) {
      case SplashStatus.checkingAppState:
        return 'Anwendungsstatus wird geprüft…';
      case SplashStatus.initializing:
        return 'Anwendung wird initialisiert…';
      case SplashStatus.initCompleted:
        return 'Initialisierung abgeschlossen';
      case SplashStatus.alreadyInitialized:
        return 'Anwendung ist bereit';
    }
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (_) => getIt<SplashCubit>()..start(),
      child: BlocListener<SplashCubit, SplashState>(
        listener: (context, state) {
          final done = state.status == SplashStatus.initCompleted ||
              state.status == SplashStatus.alreadyInitialized;

          if (done) {
            context.go(Routes.home);
          }
        },
        child: Scaffold(
          body: Stack(
            fit: StackFit.expand,
            children: [
              const SplashBackground(),
              const SplashGlowBlobs(),

              SafeArea(
                child: Center(
                  child: FadeTransition(
                    opacity: _fade,
                    child: ScaleTransition(
                      scale: _scale,
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 420),
                          child: SplashGlassCard(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SplashAppMark(),
                                const SizedBox(height: 18),
                                Text(
                                  'SBF Trainer',
                                  style: theme.textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: -0.3,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Sportbootführerschein • Binnen & See',
                                  textAlign: TextAlign.center,
                                  style:
                                  theme.textTheme.bodyMedium?.copyWith(
                                    color:
                                    Colors.white.withValues(alpha: 0.85),
                                  ),
                                ),
                                const SizedBox(height: 22),
                                const SplashProgress(),
                                const SizedBox(height: 14),

                                /// 👇 THIS IS THE IMPORTANT PART
                                BlocBuilder<SplashCubit, SplashState>(
                                  builder: (context, state) {
                                    return Text(
                                      _statusText(state.status),
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                        color: Colors.white
                                            .withValues(alpha: 0.75),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              Positioned(
                left: 0,
                right: 0,
                bottom: 18,
                child: Text(
                  'Powered by Flutter',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.55),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
