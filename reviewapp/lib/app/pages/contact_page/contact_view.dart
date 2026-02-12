// 🎯 Dart imports:

// 🐦 Flutter imports:
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:mon_etatsdeslieux/app/core/helpers/fuctions/helper_functions.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/utils/french_translations.dart';
import 'package:mon_etatsdeslieux/app/core/network/rest_apis.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:responsive_framework/responsive_framework.dart' as rf;
import 'package:responsive_grid/responsive_grid.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  final _focusNode = FocusNode();

  bool _isSending = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSending = true);

      var request = {
        "fullName": _nameController.text.trim(),
        "email": _emailController.text.trim(),
        "subject": _subjectController.text.trim(),
        "message": _messageController.text.trim(),
      };

      // Simuler l'envoi du formulaire
      await sendMessageToSupport(request)
          .then((response) {
            if (response.status == true) {
              setState(() {
                _isSending = false;
                _nameController.clear();
                _emailController.clear();
                _subjectController.clear();
                _messageController.clear();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Votre message a été envoyé avec succès !".tr,
                    style: TextStyle(
                      color: context.theme.colorScheme.onPrimary,
                    ),
                  ),
                  backgroundColor: context.theme.colorScheme.primary,
                ),
              );
            }
          })
          .catchError((error) {
            toast(
              "Une erreur est survenue lors de l'envoi du message. Veuillez réessayer."
                  .tr,
            );
          })
          .whenComplete(() {
            setState(() => _isSending = false);
          });
    }
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _isMobile = rf.ResponsiveBreakpoints.of(context).isMobile;

    return Scaffold(
      backgroundColor: _theme.colorScheme.primaryContainer,
      appBar: AppBar(
        title: Text("Contactez-nous".tr),
        centerTitle: false,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(_isMobile ? 16 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            _buildHeaderSection(_theme),
            const SizedBox(height: 32),

            // Contact Cards
            _buildContactCards(_theme, _isMobile),
            const SizedBox(height: 40),

            // Contact Form
            Text(
              "Envoyez-nous un message".tr,
              style: _theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            _buildContactForm(_theme),
            const SizedBox(height: 40),

            // FAQ Section
            _buildFAQSection(_theme),
            const SizedBox(height: 40),
            // Legal & Social Section
            _buildLegalAndSocialSection(_theme),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // Section CGU / Politique + Réseaux sociaux        Text(
  Widget _buildLegalAndSocialSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichTextWidget(
          list: [
            TextSpan(
              text:
                  "MonEtat est une plateforme innovante qui simplifie la vente ou la location de votre bien, sans les frais excessifs des agences traditionnelles. Avec notre modèle de paiement à la tâche, vous déléguez uniquement ce dont vous avez besoin. \n\n"
                      .tr,
              style: theme.textTheme.titleLarge?.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                textBaseline: TextBaseline.alphabetic,
              ),
            ),
            TextSpan(
              text: "Vous pouvez également consulter nos ".tr,
              style: theme.textTheme.titleLarge?.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: "Conditions Générales d'Utilisation (CGU)",
              recognizer: TapGestureRecognizer()
                ..onTap = () async {
                  await _launchUrl(
                    "https://adidomedis.cloud/conditions-generales-dutilisation-jatai-etat-des-lieux",
                  );
                },
              style: theme.textTheme.titleLarge?.copyWith(
                fontSize: 14,
                color: theme.colorScheme.primary,
              ),
            ),
            TextSpan(
              text: " et notre ".tr,
              style: theme.textTheme.titleLarge?.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: "Politique de Confidentialité",
              recognizer: TapGestureRecognizer()
                ..onTap = () async {
                  await _launchUrl(
                    "https://adidomedis.cloud/politique-de-confidentialite",
                  );
                },
              style: theme.textTheme.titleLarge?.copyWith(
                fontSize: 14,
                color: theme.colorScheme.primary,
              ),
            ),
            TextSpan(
              text: ".".tr,
              style: theme.textTheme.titleLarge?.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 28),
        Text(
          "Suivez-nous".tr,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          "Retrouvez-nous et suivez notre actualité sur les réseaux sociaux :"
              .tr,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 16),
        _buildSocialLinks(theme),
      ],
    );
  }

  Widget _buildSocialLinks(ThemeData theme) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: _socialLinks
          .map(
            (s) => InkWell(
              onTap: () => _launchUrl(s.url),
              borderRadius: BorderRadius.circular(50),
              child: Container(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (s.iconurl.isNotEmpty)
                      getImageType(
                        s.iconurl,
                        fit: BoxFit.cover,
                        height: 20,
                        width: 20,
                      )
                    else
                      Icon(s.icon, size: 18, color: s.color),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  final List<_SocialLink> _socialLinks = [
    _SocialLink(
      label: "YouTube",
      url: "https://www.youtube.com/@Jatai-immo",
      icon: Icons.play_circle_fill,
      color: const Color(0xFFFF0000),
    ),
    _SocialLink(
      label: "Facebook",
      url:
          "https://www.facebook.com/people/Jatai-immo/61556266556520/?sk=about",
      icon: Icons.facebook,
      color: const Color(0xFF1877F2),
    ),
    _SocialLink(
      label: "Instagram",
      url: "https://www.instagram.com/adidomedis.cloud/",
      icon: Icons.camera_alt_outlined,
      color: const Color(0xFFE1306C),
      iconurl: 'assets/app_icons/instagram.svg',
    ),
    _SocialLink(
      label: "TikTok",
      url: "https://www.tiktok.com/@adidomedis.cloud",
      iconurl: 'assets/app_icons/tik-tok.svg',
      icon: Icons.music_note,
      color: Colors.black,
    ),
    _SocialLink(
      label: "X",
      url: "https://x.com/jataiimmo",
      icon: Icons.alternate_email,
      iconurl: 'assets/app_icons/x.svg',
      color: Colors.black,
    ),
    _SocialLink(
      label: "LinkedIn",
      url: "https://www.linkedin.com/company/jatai-immo/",
      iconurl: "assets/app_icons/linkedin.svg",
      icon: Icons.business_center_outlined,
      color: const Color(0xFF0A66C2),
    ),
  ];

  Widget _buildHeaderSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Nous sommes là pour vous aider".tr,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Notre équipe est disponible pour répondre à toutes vos questions concernant votre état des lieux."
              .tr,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildContactCards(ThemeData theme, bool isMobile) {
    return ResponsiveGridRow(
      children: [
        _buildContactCard(
          icon: Icons.email,
          title: "Email".tr,
          subtitle: 'contact@adidomedis.cloud',
          onTap: () => _launchUrl('mailto:contact@adidomedis.cloud'),
          theme: theme,
          isMobile: isMobile,
        ),
        _buildContactCard(
          icon: Icons.phone,
          title: "Téléphone".tr,
          subtitle: '+33 01 87 66 27 90',
          onTap: () => _launchUrl('tel:+330187662790'),
          theme: theme,
          isMobile: isMobile,
        ),
        _buildContactCard(
          icon: Icons.location_on,
          title: "Adresse".tr,
          subtitle: '58 Rue de Monceau, 75008 Paris',
          onTap: () => _launchUrl(
            'https://www.google.com/maps?q=58+Rue+de+Monceau,+75008+Paris',
          ),
          theme: theme,
          isMobile: isMobile,
        ),
      ],
    );
  }

  ResponsiveGridCol _buildContactCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required ThemeData theme,
    required bool isMobile,
  }) {
    return ResponsiveGridCol(
      xs: 12,
      md: 4,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icon, size: 32, color: theme.colorScheme.primary),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactForm(ThemeData theme) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: "Votre nom complet".tr,
                    prefixIcon: const Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Veuillez entrer votre nom".tr;
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: "Votre adresse email".tr,
                    prefixIcon: const Icon(Icons.email),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Veuillez entrer votre email".tr;
                    }
                    if (!RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    ).hasMatch(value)) {
                      return "Veuillez entrer un email valide".tr;
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _subjectController,
            decoration: InputDecoration(
              labelText: "Sujet de votre message".tr,
              prefixIcon: const Icon(Icons.subject),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Veuillez entrer un sujet".tr;
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _messageController,
            focusNode: _focusNode,
            decoration: InputDecoration(
              labelText: "Votre message".tr,
              alignLabelWithHint: true,
              prefixIcon: const Icon(Icons.message),
            ),
            maxLines: 5,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Veuillez entrer votre message".tr;
              }
              if (value.length < 10) {
                return "Le message doit contenir au moins 10 caractères".tr;
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isSending ? null : _submitForm,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isSending
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    )
                  : Text(
                      "Envoyer le message".tr,
                      style: const TextStyle(fontSize: 16),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Questions fréquentes".tr,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),
        _buildFAQItem(
          question: "Comment créer un nouvel état des lieux ?".tr,
          answer:
              "Pour créer un nouvel état des lieux, allez dans votre tableau de bord et cliquez sur le bouton \"Nouvel état des lieux\". Suivez ensuite les étapes guidées."
                  .tr,
          theme: theme,
        ),
        _buildFAQItem(
          question:
              "Puis-je modifier un état des lieux après l'avoir finalisé ?".tr,
          answer:
              "Oui, vous pouvez modifier un état des lieux dans les 24 heures après sa finalisation. Passé ce délai, contactez-nous pour toute modification."
                  .tr,
          theme: theme,
        ),
        _buildFAQItem(
          question:
              "Comment partager un état des lieux avec un propriétaire ?".tr,
          answer:
              "Une fois l'état des lieux complété, vous pouvez le partager via email directement depuis l'application en cliquant sur le bouton \"Partager\"."
                  .tr,
          theme: theme,
        ),
      ],
    );
  }

  Widget _buildFAQItem({
    required String question,
    required String answer,
    required ThemeData theme,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ExpansionTile(
          title: Text(
            question,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
              child: Text(
                answer,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SocialLink {
  final String label;
  final String url;
  final IconData icon;
  String iconurl;

  final Color color;
  _SocialLink({
    required this.label,
    required this.url,
    required this.icon,
    required this.color,
    this.iconurl = '',
  });
}
