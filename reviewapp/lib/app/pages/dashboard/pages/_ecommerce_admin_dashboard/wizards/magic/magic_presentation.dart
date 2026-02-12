import 'package:flutter/material.dart';
import 'package:mon_etatsdeslieux/app/core/static/model_keys.dart';
import 'package:mon_etatsdeslieux/app/providers/providers.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid/responsive_grid.dart';

class MagicPresentation extends StatelessWidget {
  final VoidCallback onsTart;

  const MagicPresentation({super.key, required this.onsTart});

  @override
  Widget build(BuildContext context) {
    final wizardState = context.watch<AppThemeProvider>();
    Jks.wizardState = wizardState;

    Theme.of(context);
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildIllustrationSection(context),
              _buildHeaderSection(context),
              8.height,
              _buildMainTitle(context),
              14.height,
              _buildStepInstruction(context),
              buildMagicCTASection(context, onsTart: onsTart),
            ],
          ),
        ),
      ),
    );
  }
}

// Méthodes séparées pour chaque section
Widget _buildHeaderSection(BuildContext context) {
  return Container(
    margin: const EdgeInsets.only(bottom: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              "MonEtaix",
              style: context.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: context.primaryColor,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(width: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    context.primaryColor,
                    context.primaryColor.withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: context.primaryColor.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                "Beta",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _buildMainTitle(BuildContext context) {
  return Text(
    "Pré-remplir automatiquement la pièce",
    style: context.textTheme.headlineSmall?.copyWith(
      fontWeight: FontWeight.w700,
      color: Colors.grey.shade900,
    ),
  ).center();
}

Widget _buildIllustrationSection(BuildContext context) {
  return Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          context.primaryColor.withOpacity(0.05),
          context.primaryColor.withOpacity(0.02),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      shape: BoxShape.circle,
    ),
    child: Stack(
      alignment: Alignment.center,
      children: [
        // Background circles
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: context.primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
        ),
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: context.primaryColor.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
        ),

        // Main icon
        Icon(
          Icons.auto_awesome_mosaic_rounded,
          size: 20,
          color: context.primaryColor,
        ),
      ],
    ),
  );
}

Widget _buildStepInstruction(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Comment ça marche ?",
        style: context.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
          color: Colors.grey.shade900,
        ),
      ),
      const SizedBox(height: 16),

      // Steps
      ResponsiveGridRow(
        children: [
          ResponsiveGridCol(
            xs: 12,
            sm: 12,
            md: 6,
            lg: 6,
            child: _buildSteRow(
              context,
              1,
              "Prenez une photo de la pièce",
              "Utilisez votre appareil pour capturer une image claire de la pièce à analyser.",
            ).paddingOnly(bottom: 16),
          ),
          ResponsiveGridCol(
            xs: 12,
            sm: 12,
            md: 6,
            lg: 6,
            child: _buildSteRow(
              context,
              2,
              "Analyse intelligente",
              "MonEtaix utilise l'IA pour identifier les éléments présents dans la pièce.",
            ).paddingOnly(bottom: 16),
          ),
          ResponsiveGridCol(
            xs: 12,
            sm: 12,
            md: 6,
            lg: 6,
            child: _buildSteRow(
              context,
              3,
              "Vérifiez et ajustez",
              "Passez en revue les informations détectées et apportez des modifications si nécessaire.",
            ).paddingOnly(bottom: 16),
          ),
        ],
      ),
    ],
  );
}

Widget _buildSteRow(
  BuildContext context,
  int stepNumber,
  String title,
  String description,
) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Step number badge
      Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              context.primaryColor,
              context.primaryColor.withOpacity(0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            "$stepNumber",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ),
      ),
      const SizedBox(width: 16),

      // Instruction text
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade900,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: context.textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade700,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget buildMagicCTASection(
  BuildContext context, {
  required VoidCallback? onsTart,
  title = "Commencer l'analyse",
}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      // Button
      TextButton(
        onPressed: onsTart,
        style: TextButton.styleFrom(padding: const EdgeInsets.all(0)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: context.textTheme.titleMedium?.copyWith(
                color: context.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 12),
            if (Jks.wizardState.loading)
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            else
              const Icon(Icons.arrow_forward_rounded, size: 20),
          ],
        ),
      ),
      10.height,
      Text(
        "Processus 100% sécurisé et confidentiel",
        style: context.textTheme.bodySmall?.copyWith(
          color: Colors.grey.shade600,
        ),
      ),
    ],
  ).center();
}
