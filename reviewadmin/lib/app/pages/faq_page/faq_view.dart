// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:expansion_widget/expansion_widget.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/french_translations.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/utls.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:responsive_grid/responsive_grid.dart';

// 🌎 Project imports:
import '../../../generated/l10n.dart' as l;
import '../../core/theme/_app_colors.dart';
import '../../widgets/shadow_container/_shadow_container.dart';

class FaqView extends StatefulWidget {
  const FaqView({super.key});

  @override
  State<FaqView> createState() => _FaqViewState();
}

class _FaqViewState extends State<FaqView> {
  @override
  Widget build(BuildContext context) {
    //final lang = l.S.current;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final lang = l.S.of(context);
    final _padding = responsiveValue<double>(
      context,
      xs: 16,
      sm: 16,
      md: 16,
      lg: 24,
    );

    return Scaffold(
      backgroundColor:
          context.theme.brightness == Brightness.dark ? blackColor : whiteColor,
      body: Padding(
        padding: EdgeInsets.all(_padding),
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: termsList.length + 1,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            if (index == termsList.length) {
              return OutlinedButton(
                  onPressed: () {
                    commonLaunchUrl(
                        "https://jatai.fr/questions-frequentes-sur-les-conseillers-immobiliers");
                  },
                  child: Text("Voir le guide complet".tr));
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Container(
                  padding: EdgeInsets.all(_padding),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: theme.colorScheme.primaryContainer,
                    border:
                        Border.all(color: theme.colorScheme.surface, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xff2E2D74).withOpacity(0.05),
                        blurRadius: 30,
                        spreadRadius: 0,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ExpansionWidget(
                    expandedAlignment: Alignment.topLeft,
                    initiallyExpanded: index == 0,
                    titleBuilder: (animationValue, easeInValue, isExpanded,
                            toggleFunction) =>
                        InkWell(
                      onTap: () => toggleFunction(animated: true),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Text(
                              termsList[index]['title'] ?? '',
                              style: textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                          ),
                          const SizedBox(width: 4.0),
                          Icon(
                            isExpanded
                                ? Icons.remove_circle_outline
                                : Icons.add_circle_outline_outlined,
                            color: AcnooAppColors.kPrimary700,
                          )
                        ],
                      ),
                    ),
                    content: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        termsList[index]['description'] ?? '',
                        textAlign: TextAlign.start,
                        style: textTheme.bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w400),
                      ),
                    ),
                  )),
            );
          },
        ),
      ),
    );
  }

  List<Map<String, String>> get termsList => [
        {
          'title':
              "Quelle est la différence entre un état des lieux simple et croisé ?"
                  .tr,
          'description':
              "Un état des lieux simple est réalisé de manière classique entre deux parties. Un état des lieux croisé fonctionne à distance via procuration : le locataire sortant et le locataire entrant se rencontrent pour établir mutuellement les états des lieux d'entrée et de sortie, représentant le bailleur par procuration. Ce format permet une réalisation contradictoire, autonome et juridiquement valable."
                  .tr
        },
        {
          'title':
              "Faut-il que les locataires soient d'accord pour signer la procuration ?"
                  .tr,
          'description':
              "Oui. La validité du processus repose sur l'accord explicite de chaque locataire pour accepter la procuration. Chacun reçoit un lien personnalisé, signe électroniquement le mandat, et accepte d'agir au nom du bailleur. Aucune démarche ne peut être validée sans cet accord."
                  .tr
        },
        {
          'title': "Comment les locataires sont-ils informés et guidés ?".tr,
          'description':
              "Dès la création du mandat, le locataire reçoit un e-mail contenant l'accès au formulaire, les explications et les étapes à suivre. Des instructions claires guident les locataires pas à pas et notre support reste joignable à tout moment."
                  .tr
        },
        {
          'title':
              "L'état des lieux réalisé via Jatai a-t-il une valeur légale ?"
                  .tr,
          'description':
              "Oui. Les états des lieux sont établis de manière contradictoire, horodatés, signés électroniquement et archivés de façon sécurisée. Ils sont conformes aux exigences légales et un QR code antifraude garantit l'intégrité du document après signature."
                  .tr
        },
        {
          'title': "Quel type de signature est utilisée ?".tr,
          'description':
              "Jatai utilise une signature électronique sécurisée garantissant l'identité du signataire et l'intégrité du document. Pour renforcer la valeur probatoire, chaque signature peut être accompagnée d'un selfie avec la pièce d'identité et de la photo du document d'identité."
                  .tr
        },
        {
          'title':
              "Puis-je télécharger le PDF de l'état des lieux une fois complété ?"
                  .tr,
          'description':
              "Oui. Une fois les états des lieux finalisés et signés, chaque partie reçoit automatiquement les documents PDF par e-mail. Le bailleur et les locataires peuvent également les télécharger depuis leurs espaces personnels Jatai."
                  .tr
        },
        {
          'title':
              "Comment puis-je être sûr de la qualité des prestataires proposés par Jatai ?"
                  .tr,
          'description':
              "Tous nos prestataires sont sélectionnés avec soin, vérifiés pour leur expérience et leur professionnalisme, et évalués régulièrement par les clients pour garantir un niveau de service optimal."
                  .tr
        },
        {
          'title':
              "Que se passe-t-il si un prestataire ne respecte pas ses engagements ?"
                  .tr,
          'description':
              "En cas de non-aboutissement de la mission, Jatai s'engage à ne pas libérer le paiement effectué par le client au prestataire, garantissant ainsi un remboursement intégral au client. De plus, nous offrons un système de garantie de satisfaction et d'assistance pour vous aider à résoudre tout problème avec un prestataire. Vous pouvez également changer de prestataire à tout moment si vous n'êtes pas satisfait."
                  .tr
        },
        {
          'title':
              "Est-ce que cette méthode me coûte plus cher qu'une agence immobilière ?"
                  .tr,
          'description':
              "Non, au contraire. Avec Jatai, vous ne payez que pour les services dont vous avez besoin, à des tarifs transparents et définis à l'avance. Cela vous permet de réaliser des économies importantes par rapport aux commissions traditionnelles des agences."
                  .tr
        },
        {
          'title':
              "Comment puis-je suivre l'avancement des missions confiées aux prestataires ?"
                  .tr,
          'description':
              "Il vous suffit de communiquer avec notre service client, et nous vous tiendrons informé de l'avancement de chaque mission. Notre équipe est disponible pour répondre à vos questions et vous fournir des mises à jour régulières dans les plus brefs délais."
                  .tr
        },
        {
          'title': "Comment se passe le paiement des prestations ?".tr,
          'description':
              "Le paiement est effectué via un système sécurisé. Les fonds ne sont libérés au prestataire qu'après l'accomplissement de la mission. En cas d'échec de celle-ci, Jatai s'engage à procéder au remboursement sous 48 heures."
                  .tr
        },
        {
          'title':
              "Et si j'ai besoin d'aide ou de conseils pendant le processus ?"
                  .tr,
          'description':
              "Notre équipe d'assistance est disponible pour répondre à toutes vos questions et vous guider à chaque étape, que ce soit par téléphone ou email."
                  .tr
        }
      ];
}
