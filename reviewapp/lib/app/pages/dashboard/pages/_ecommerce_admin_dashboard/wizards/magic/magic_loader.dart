import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mon_etatsdeslieux/app/core/static/model_keys.dart';
import 'package:mon_etatsdeslieux/app/providers/providers.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class MagicAnalyzing extends StatelessWidget {
  const MagicAnalyzing({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final wizardState = context.watch<AppThemeProvider>();

    return Scaffold(
      backgroundColor: theme.colorScheme.primaryContainer,
      body: SingleChildScrollView(
        primary: true,
        padding: const EdgeInsets.all(16.0),
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (true || wizardState.loading) ...[
                Text(
                  "Analyse en cours...",
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: theme.colorScheme.onPrimaryContainer,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  "Merci de patienter pendant l'analyse de vos photos...",
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onPrimaryContainer,
                    letterSpacing: -0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                40.height,
                ScanningAnimation(size: 200),
                40.height,
                Text(
                  "L'analyse peut prendre quelques minutes en fonction du nombre de photos et de votre connexion internet.",
                  style: theme.textTheme.bodyMedium?.copyWith(),
                  textAlign: TextAlign.center,
                ),
              ],
              20.height,
            ],
          ).withWidth(context.width()),
        ),
      ),
    );
  }
}

class ScanningAnimation extends StatefulWidget {
  final double size;

  const ScanningAnimation({super.key, this.size = 200});

  @override
  _ScanningAnimationState createState() => _ScanningAnimationState();
}

class _ScanningAnimationState extends State<ScanningAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scanAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    _scanAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _pulseAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.1), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 1.1, end: 1.0), weight: 1),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Cercle pulsé de fond
            ScaleTransition(
              scale: _pulseAnimation,
              child: Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: context.primaryColor.withOpacity(0.1),
                ),
              ),
            ),

            // Icône centrale
            Icon(
              Icons.photo_camera_rounded,
              size: widget.size * 0.4,
              color: context.primaryColor,
            ),

            // Ligne de scanning rotative
            Transform.rotate(
              angle: _scanAnimation.value * 2 * pi,
              child: CustomPaint(
                size: Size(widget.size, widget.size),
                painter: _ScanningPainter(progress: _scanAnimation.value),
              ),
            ),

            // Points orbitaux
            ..._buildOrbitalDots(),
          ],
        );
      },
    );
  }

  List<Widget> _buildOrbitalDots() {
    return List.generate(8, (index) {
      final angle = (index / 8) * 2 * pi + _controller.value * 2 * pi;
      final offset = Offset(
        cos(angle) * widget.size * 0.35,
        sin(angle) * widget.size * 0.35,
      );

      return Positioned(
        left: widget.size / 2 + offset.dx - 4,
        top: widget.size / 2 + offset.dy - 4,
        child: Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: context.primaryColor,
            shape: BoxShape.circle,
          ),
        ),
      );
    });
  }
}

class _ScanningPainter extends CustomPainter {
  final double progress;

  _ScanningPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Jks.context!.primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(size.width / 2, size.height / 2)
      ..lineTo(
        size.width / 2 + cos(progress * 2 * pi) * size.width * 0.4,
        size.height / 2 + sin(progress * 2 * pi) * size.height * 0.4,
      );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _ScanningPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
