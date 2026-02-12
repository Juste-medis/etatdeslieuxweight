import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/copole.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/utls.dart';
import 'package:jatai_etadmin/app/core/network/rest_apis.dart';
import 'package:jatai_etadmin/app/core/static/model_keys.dart';
import 'package:jatai_etadmin/app/models/_inventory.dart';
import 'package:jatai_etadmin/app/models/base_response_model.dart';
import 'package:jatai_etadmin/app/models/review.dart';
import 'package:jatai_etadmin/app/pages/review/overview_card.dart';
import 'package:jatai_etadmin/app/providers/_proccuration_provider.dart';
import 'package:jatai_etadmin/app/widgets/dialogs/confirm_dialog.dart';
import 'package:nb_utils/nb_utils.dart';

import 'package:jatai_etadmin/app/providers/providers.dart';
import 'package:provider/provider.dart';

import 'package:jatai_etadmin/app/core/helpers/utils/french_translations.dart';
import 'package:jatai_etadmin/app/core/helpers/extensions/_build_context_extensions.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_grid/responsive_grid.dart';

class ProccurationDashboard extends StatefulWidget {
  final Procuration proccuration;
  const ProccurationDashboard({super.key, required this.proccuration});

  @override
  State<ProccurationDashboard> createState() => _ProccurationDashboardState();
}

class _ProccurationDashboardState extends State<ProccurationDashboard> {
  final PageController _pageController = PageController();
  late AppThemeProvider wizardState;
  late ProccurationProvider proccurationState;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    wizardState = context.watch<AppThemeProvider>();
    proccurationState = context.watch<ProccurationProvider>();
  }

  @override
  dispose() {
    _pageController.dispose();
    Jks.canEditReview = "canEditReview";
    Jks.proc = proccurationState.editingProccuration;
    super.dispose();
  }

  void previewProccuration() async {
    context.push(
      '/preview/proccuration/${widget.proccuration.id}',
      extra: widget.proccuration,
    );
  }

  @override
  void initState() {
    super.initState();
    Jks.reglerpayment = reglerProcurationpayment;
  }

  @override
  Widget build(BuildContext context) {
    Jks.context = context;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final wizardState = context.watch<AppThemeProvider>();
    final reviewState = context.watch<ReviewProvider>();
    final proccurationState = context.watch<ProccurationProvider>();
    Jks.reviewState = reviewState;
    Jks.wizardState = wizardState;
    Jks.proccurationState = proccurationState;

    final _mqSize = MediaQuery.sizeOf(context);
    final _theme = Theme.of(context);
    final _padding = responsiveValue<double>(context, xs: 16, lg: 24);
    final isfromNewProc = widget.proccuration.source == 'saved' ||
        widget.proccuration.source == 'notification';

    var proc = isfromNewProc
        ? proccurationState.editingProccuration!
        : proccurationState.proccurations
            .firstWhere((element) => element.id == widget.proccuration.id);
    final theAutors = [
      ...proc.owners!,
      ...proc.exitenants!,
      ...proc.entrantenants!,
    ];

    //<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

    if (proc.meta?["signatures"] != null &&
            proc.meta!["signatures"].isNotEmpty ||
        proccurationState.editingProccuration?.status == "signing" ||
        !proccurationState.editingProccuration!.isTheAutor()) {
      Jks.canEditReview = "canEditReview";
    }

    //<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
    var moreOverviewData = [
      (
        "Informations générales".tr,
        "Cliquez pour renseigner l'adresse postale du logement.".tr,
        (proc.propertyDetails?.surface != "" &&
                proc.propertyDetails?.address != "")
            ? 2
            : 1,
        () {
          proc = isfromNewProc
              ? proccurationState.editingProccuration!
              : proccurationState.proccurations.firstWhere(
                  (element) => element.id == widget.proccuration.id);
          wizardState.prefillProccuration(
            proc,
          );
          proccurationState.seteditingProcuration(proc);

          context.push(
            '/thegood/${proc.id}',
            extra: Review.fromProccuration(proc),
          );
        },
        "Certains champs sont obligatoires".tr,
      ),
      (
        "Caractéristiques du logement".tr,
        "Cliquez pour renseigner La superficie et les éléments de chauffage."
            .tr,
        (proc.propertyDetails?.heatingType != null &&
                proc.propertyDetails?.heatingMode != null &&
                proc.propertyDetails?.hotWaterType != null &&
                proc.propertyDetails?.hotWaterMode != null)
            ? 2
            : 1,
        () {
          proc = isfromNewProc
              ? proccurationState.editingProccuration!
              : proccurationState.proccurations.firstWhere(
                  (element) => element.id == widget.proccuration.id);
          wizardState.prefillProccuration(
            proc,
          );
          proccurationState.seteditingProcuration(proc);

          context.push('/complementary/${proc.id}',
              extra: Review.fromProccuration(proc));
        },
        "Certains champs ne sont pas renseignés".tr,
      ),
      (
        "Réalisation et access à l'état des lieux".tr,
        "Cliquez pour renseigner la date prévue de l'état des lieux et la personne qui le réalisera."
            .tr,
        ((proc.estimatedDateOfReview != null &&
                proc.accesgivenTo!.isNotEmpty &&
                proc.meta!["review_estimed_date"] != "" &&
                proc.documentAddress != ""))
            ? 2
            : 1,
        () {
          proc = isfromNewProc
              ? proccurationState.editingProccuration!
              : proccurationState.proccurations.firstWhere(
                  (element) => element.id == widget.proccuration.id);
          wizardState.prefillProccuration(
            proc,
          );
          proccurationState.seteditingProcuration(proc);

          context.push('/entrydateacces/${proc.id}',
              extra: Review.fromProccuration(proc));
        },
        "Certains champs sont obligatoires".tr,
      ),
      (
        "Informations complémentaires".tr,
        "Cliquez pour renseigner la nouvelle adresse du locataire, les commentaires et les informations complémentaires."
            .tr,
        2,
        () {
          proc = isfromNewProc
              ? proccurationState.editingProccuration!
              : proccurationState.proccurations.firstWhere(
                  (element) => element.id == widget.proccuration.id);
          wizardState.prefillProccuration(
            proc,
          );
          proccurationState.seteditingProcuration(proc);

          context.push('/srtoantlocataireaddress/${proc.id}', extra: {
            "review": Review.fromProccuration(proc),
            "procuration": proc,
          });
        },
        "Certains champs sont obligatoires".tr,
      ),
    ];

    return Consumer<AppThemeProvider>(
      builder: (context, lang, child) {
        Jks.context = context;

        return Scaffold(
          backgroundColor: isDark ? black : white,
          body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(
                    scrollbars: false,
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        backbutton(() {
                          context.popRoute();
                        }),
                        if (proc.meta?["signatures"] != null &&
                            proc.meta!["signatures"].isNotEmpty)
                          Container(
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xff03BB9A).withAlpha(25),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color:
                                    _theme.colorScheme.outline.withAlpha(100),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.verified,
                                      color: const Color(0xff03BB9A),
                                      size: 20,
                                    ),
                                    8.width,
                                    Text(
                                      "Signatures".tr,
                                      style: _theme.textTheme.titleMedium
                                          ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                12.height,
                                ...proc.meta!["signatures"].keys.map((key) {
                                  var signatory = theAutors.firstWhere(
                                    (s) => s.id == key,
                                    orElse: () => InventoryAuthor(
                                      id: key,
                                      firstname: "Inconnu",
                                      lastName: "Inconnu",
                                    ),
                                  );
                                  var signatureData =
                                      proc.meta!["signatures"][key];
                                  var signatureDate =
                                      formatDate(signatureData?["timestamp"]);

                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 12,
                                          backgroundColor:
                                              const Color(0xff03BB9A)
                                                  .withAlpha(25),
                                          child: Icon(
                                            Icons.check,
                                            size: 16,
                                            color: const Color(0xff03BB9A),
                                          ),
                                        ),
                                        12.width,
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return SignatoryDetailsDialog(
                                                      signatory: signatory,
                                                      proc: proc,
                                                      hasSigned:
                                                          proc.haveSigned(
                                                              author:
                                                                  signatory),
                                                      signatureDate:
                                                          signatureDate,
                                                      onSign: () {},
                                                      onReminder: () {});
                                                },
                                              );
                                            },
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      authorname(signatory),
                                                      style: _theme
                                                          .textTheme.bodyMedium
                                                          ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                                2.height,
                                                Text(
                                                  "Signé le $signatureDate".tr,
                                                  style: _theme
                                                      .textTheme.bodySmall
                                                      ?.copyWith(
                                                          color: _theme
                                                              .colorScheme
                                                              .onSurface),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Icon(
                                          Icons.verified,
                                          size: 16,
                                          color: const Color(0xff03BB9A),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ],
                            ),
                          ),
                        if (proc.meta?["signaturesMeta"]?["missingSignatures"]
                                ?.isNotEmpty ??
                            false)
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: _theme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: _theme.colorScheme.outline.withAlpha(50),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.edit_note,
                                      color: _theme.colorScheme.primary,
                                      size: 20,
                                    ),
                                    8.width,
                                    Text(
                                      "Personnes restant à signer".tr,
                                      style: _theme.textTheme.titleMedium
                                          ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                12.height,
                                ...theAutors.where((signatory) {
                                  var missingSignatures =
                                      proc.meta?["signaturesMeta"]
                                          ?["missingSignatures"];

                                  return missingSignatures != null &&
                                      missingSignatures.contains(signatory.id);
                                }).map(
                                  (signatory) => Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 12,
                                          backgroundColor: _theme
                                              .colorScheme.primary
                                              .withAlpha(25),
                                          child: Icon(
                                            Icons.person,
                                            size: 16,
                                            color: _theme.colorScheme.primary,
                                          ),
                                        ),
                                        12.width,
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return SignatoryDetailsDialog(
                                                      signatory: signatory,
                                                      proc: proc,
                                                      hasSigned: false,
                                                      signatureDate: (proc
                                                                      .meta![
                                                                  "signatures"] ??
                                                              {})[signatory.id]
                                                          ?["timestamp"],
                                                      onSign: () {},
                                                      onReminder: () {});
                                                },
                                              );
                                            },
                                            child: Row(
                                              children: [
                                                Text(
                                                  authorname(signatory),
                                                  style: _theme
                                                      .textTheme.titleSmall
                                                      ?.copyWith(),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Icon(
                                          Icons.timelapse_rounded,
                                          size: 16,
                                          color: _theme.colorScheme.onTertiary,
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        20.height,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              proc.propertyDetails?.address ?? "",
                              style: _theme.textTheme.titleLarge?.copyWith(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "${proc.propertyDetails?.complement}",
                              style: _theme.textTheme.bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.w800),
                            ),
                            8.height,
                            RichTextWidget(list: [
                              TextSpan(
                                text: "Date prévue de l'état des lieux: \n"
                                    .tr
                                    .capitalizeFirstLetter(),
                                style: _theme.textTheme.labelLarge?.copyWith(
                                  color: _theme.colorScheme.onSurface,
                                ),
                              ),
                              TextSpan(
                                text:
                                    "${formatDate(proc.estimatedDateOfReview.toString())} "
                                        .tr
                                        .capitalizeFirstLetter(),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () async {},
                                style: _theme.textTheme.bodyMedium?.copyWith(
                                    color: _theme.colorScheme.primary,
                                    fontWeight: FontWeight.w600),
                              )
                            ]),
                          ],
                        ).paddingSymmetric(horizontal: 10),
                        10.height,
                        if (proc.credited == false)
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xffFF8C08).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xffFF8C08),
                                width: 1,
                              ),
                            ),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.timer,
                                            size: 20,
                                            color: const Color(0xffFF8C08),
                                          ),
                                          8.width,
                                          Expanded(
                                            child: RichTextWidget(list: [
                                              TextSpan(
                                                text: "En attente de règlement"
                                                    .tr,
                                                style: _theme
                                                    .textTheme.bodyMedium
                                                    ?.copyWith(
                                                  color:
                                                      const Color(0xffFF8C08),
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ]),
                                          ),
                                        ],
                                      ), //hint text
                                      12.height,
                                      Text(
                                          "Reglez la procuration pour pouvoir l'nvoyer aux signataires et accéder à l'état des lieux."
                                              .tr
                                              .capitalizeFirstLetter(),
                                          style: _theme.textTheme.bodyMedium
                                              ?.copyWith(
                                            color: _theme.colorScheme.onSurface
                                                .withOpacity(0.6),
                                          )),
                                      const SizedBox(height: 8),
                                      ElevatedButton.icon(
                                        onPressed: proccurationState.isLoading
                                            ? null
                                            : () {
                                                reglerProcurationpayment(
                                                  context,
                                                  proc,
                                                );
                                              },
                                        icon: proccurationState.isLoading
                                            ? SizedBox(
                                                width: 16,
                                                height: 16,
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  color: _theme
                                                      .colorScheme.onPrimary,
                                                ),
                                              )
                                            : Icon(
                                                Icons.payment,
                                                size: 16,
                                                color: _theme
                                                    .colorScheme.onPrimary,
                                              ),
                                        label: Text(
                                          "Régler maintenant".tr,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: _theme.colorScheme.onPrimary,
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              _theme.colorScheme.primary,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 8),
                                          minimumSize: const Size(100, 30),
                                        ),
                                      ),
                                    ],
                                  ),
                                ]),
                          ),
                        20.height,
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (proc.credited == true)
                                OutlinedButton.icon(
                                    onPressed: proccurationState.isLoading
                                        ? null
                                        : () async {
                                            proccurationState.setloading(true);
                                            await getUnityReview(proc.id,
                                                    procurationId: proc.id)
                                                .then((res) async {
                                              if (res.status == true) {
                                                proccurationState
                                                    .setloading(false);

                                                var review = Review.fromJson(res
                                                        .data
                                                    as Map<String, dynamic>);
                                                review.source = "procuration";
                                                final wizardState = context
                                                    .read<AppThemeProvider>();
                                                wizardState.prefillReview(
                                                  review,
                                                );

                                                context.push(
                                                  '/review/${review.id}',
                                                  extra: review,
                                                );
                                              }
                                            }).catchError((e) {
                                              my_inspect(e);

                                              proccurationState
                                                  .setloading(false);
                                            });
                                          },
                                    label: Text("Etat des lieux".tr),
                                    icon: proccurationState.isLoading
                                        ? SizedBox(
                                            width: 16,
                                            height: 16,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: _theme.colorScheme.primary,
                                            ),
                                          )
                                        : Icon(Icons.file_open_sharp))
                              else
                                SizedBox.shrink(),
                              FloatingActionButton(
                                onPressed: () {
                                  proccurationState.seteditingProcuration(proc);
                                  proccurationState.previewTheProcuration(proc);
                                  previewProccuration();
                                },
                                backgroundColor: _theme.colorScheme.primary,
                                child: Icon(
                                  Icons.document_scanner_rounded,
                                  color: _theme.colorScheme.onPrimary,
                                ),
                              )
                            ]).paddingSymmetric(horizontal: 10),
                        20.height,
                        Column(
                          children:
                              List.generate(moreOverviewData.length, (index) {
                            final _data = moreOverviewData[index];

                            Color theColor;
                            IconData theIcon;
                            if (proc.status == "completed") {
                              theColor = const Color(0xff03BB9A);
                              theIcon = Icons.check_circle;
                            } else {
                              switch (_data.$3) {
                                case 1:
                                  theColor = const Color(0xffFF8C08);
                                  theIcon = Icons.warning;
                                  break;
                                case 2:
                                  theColor = const Color(0xff03BB9A);
                                  theIcon = Icons.check_circle;

                                  break;
                                default:
                                  theColor = const Color(0xffFF5A58);
                                  theIcon = Icons.stop_circle;
                              }
                            }

                            return Padding(
                              padding: EdgeInsetsDirectional.only(
                                top: 0,
                                start: _mqSize.width < 992 ? 6 : _padding / 2.5,
                                end: _mqSize.width < 992 ? 6 : _padding / 2.5,
                              ),
                              child: BorderOverviewCard(
                                onTap: _data.$4,
                                iconPath: Icon(
                                  theIcon,
                                  color: theColor,
                                ),
                                border: Border(
                                  left: BorderSide(color: theColor, width: 6),
                                ),
                                title: Text(
                                  _data.$1,
                                  style: _theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                subtitle: Text(
                                  _data.$2.tr,
                                  style:
                                      _theme.textTheme.bodyMedium?.copyWith(),
                                ),
                                error: _data.$3 != 2
                                    ? Text(
                                        _data.$5,
                                        style: _theme.textTheme.bodyMedium
                                            ?.copyWith(color: theColor),
                                      )
                                    : null,
                                cardType: BorderOverviewCardType.horizontal,
                              ),
                            );
                          }),
                        )
                      ]))),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Spacer(),
                TextButton.icon(
                  onPressed: proccurationState.isLoading
                      ? null
                      : () async {
                          final confirmed = await showAwesomeConfirmDialog(
                            context: context,
                            title: "Supprimer la procuration".tr,
                            description:
                                'êtes-vous sûr de vouloir supprimer cette procuration ? Cette action est irréversible.'
                                    .tr,
                          );
                          if (confirmed ?? false) {
                            final deletion = await proccurationState
                                .deleteTheproccuration(proc);
                            if (deletion) {
                              Jks.context!.popRoute();
                            }
                          }
                        },
                  icon: Icon(Icons.delete, color: _theme.colorScheme.error),
                  label: Text(
                    "Supprimer".tr,
                    style: TextStyle(color: _theme.colorScheme.error),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class SignatoryDetailsDialog extends StatelessWidget {
  final InventoryAuthor signatory;
  final Procuration proc;
  final bool hasSigned;
  final String? signatureDate;
  final VoidCallback? onSign;
  final VoidCallback? onReminder;

  const SignatoryDetailsDialog({
    super.key,
    required this.signatory,
    required this.proc,
    this.hasSigned = false,
    this.signatureDate,
    this.onSign,
    this.onReminder,
  });

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        constraints: const BoxConstraints(maxWidth: 350),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              authorname(signatory),
              style: _theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            if (signatory.denomination?.isNotEmpty == true) ...[
              8.height,
              Text(
                signatory.denomination!,
                style: _theme.textTheme.bodyMedium?.copyWith(
                  color: _theme.colorScheme.onSurface.withOpacity(0.6),
                ),
                textAlign: TextAlign.center,
              ),
            ],
            16.height,
            _buildStatusContainer(_theme),
            if (proc.isTheAutor()) ...[
              16.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (!proc.anySigned())
                    _buildTinyActionButton(
                      icon: Icons.edit_outlined,
                      label: "Modifier".tr,
                      onTap: () {
                        Navigator.pop(context);
                        Jks.proccurationState.seteditingAuthor(signatory);
                        context.push(
                          '/inventoryauthor-inventory/${signatory.id}',
                          extra: InventoryAuthorParam(
                              from: "procuration",
                              cb: (data, action) async {
                                Jks.proccurationState.setloading(true);
                                var rere = await Jks.proccurationState
                                    .updateTheproccuration(proc, action!,
                                        updateAuthor: data,
                                        wizardState: Jks.wizardState);
                                Jks.wizardState.setloading(false);
                                Jks.wizardState.prefillProccuration(rere);
                                return;
                              },
                              data: signatory,
                              canModifyMandataire: false),
                        );
                      },
                      theme: _theme,
                    ),
                  if (!hasSigned)
                    _buildTinyActionButton(
                      icon: Icons.notifications_outlined,
                      label: "Rappel".tr,
                      onTap: () {},
                      theme: _theme,
                    ),
                  if (!hasSigned)
                    _buildTinyActionButton(
                      icon: Icons.message_outlined,
                      label: "Message".tr,
                      onTap: () {},
                      theme: _theme,
                    ),
                ],
              ),
            ],
            if (_hasContactInfo()) ...[
              8.height,
              _buildContactInfo(_theme),
            ],
            12.height,
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Fermer".tr),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTinyActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required ThemeData theme,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.primary),
          4.height,
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusContainer(ThemeData theme) {
    if (hasSigned && signatureDate != null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xff03BB9A).withAlpha(25),
          border: Border.all(
            color: const Color(0xff03BB9A),
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle,
              size: 16,
              color: const Color(0xff03BB9A),
            ),
            6.width,
            Expanded(
              child: Text(
                "Signé le $signatureDate".tr,
                style: theme.textTheme.bodySmall?.copyWith(
                    color: const Color(0xff03BB9A),
                    fontWeight: FontWeight.w500,
                    fontSize: 10),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: theme.colorScheme.outline.withAlpha(50)),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          "En attente de signature".tr,
          style: theme.textTheme.bodySmall,
        ),
      );
    }
  }

  Widget _buildContactInfo(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (signatory.email?.isNotEmpty == true) ...[
            Row(
              children: [
                Icon(Icons.email_outlined, size: 16),
                8.width,
                Expanded(
                  child: Text(
                    signatory.email!,
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              ],
            ),
            if (signatory.phone?.isNotEmpty == true ||
                signatory.address?.isNotEmpty == true)
              8.height,
          ],
          if (signatory.phone?.isNotEmpty == true) ...[
            Row(
              children: [
                Icon(Icons.phone_outlined, size: 16),
                8.width,
                Expanded(
                  child: Text(
                    signatory.phone!,
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              ],
            ),
            if (signatory.address?.isNotEmpty == true) 8.height,
          ],
          if (signatory.address?.isNotEmpty == true)
            Row(
              children: [
                Icon(Icons.location_on_outlined, size: 16),
                8.width,
                Expanded(
                  child: Text(
                    signatory.address!,
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  bool _hasContactInfo() {
    return signatory.email?.isNotEmpty == true ||
        signatory.phone?.isNotEmpty == true ||
        signatory.address?.isNotEmpty == true;
  }
}

class UserInfoDialog extends StatelessWidget {
  final InventoryAuthor user;
  final Procuration? proccuration;

  const UserInfoDialog({
    super.key,
    required this.user,
    this.proccuration,
  });

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        constraints: const BoxConstraints(maxWidth: 400),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: _theme.colorScheme.primary.withAlpha(25),
                    child: Icon(
                      Icons.person,
                      color: _theme.colorScheme.primary,
                    ),
                  ),
                  12.width,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          authorname(user),
                          style: _theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (user.denomination?.isNotEmpty == true) ...[
                          4.height,
                          Text(
                            user.denomination!,
                            style: _theme.textTheme.bodyMedium?.copyWith(
                              color:
                                  _theme.colorScheme.onSurface.withOpacity(0.6),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              20.height,

              // Contact Information
              if (_hasUserInfo()) ...[
                Text(
                  "Informations de contact".tr,
                  style: _theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                12.height,
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _theme.colorScheme.surface,
                    border: Border.all(
                      color: _theme.colorScheme.outline.withOpacity(0.2),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      if (user.email?.isNotEmpty == true)
                        _buildInfoRow(
                          icon: Icons.email_outlined,
                          label: "Email".tr,
                          value: user.email!,
                          theme: _theme,
                        ),
                      if (user.phone?.isNotEmpty == true) ...[
                        if (user.email?.isNotEmpty == true) 12.height,
                        _buildInfoRow(
                          icon: Icons.phone_outlined,
                          label: "Téléphone".tr,
                          value: user.phone!,
                          theme: _theme,
                        ),
                      ],
                      if (user.address?.isNotEmpty == true) ...[
                        if (user.email?.isNotEmpty == true ||
                            user.phone?.isNotEmpty == true)
                          12.height,
                        _buildInfoRow(
                          icon: Icons.location_on_outlined,
                          label: "Adresse".tr,
                          value: user.address!,
                          theme: _theme,
                        ),
                      ],
                    ],
                  ),
                ),
                20.height,
              ],
              // Proccuration Information
              if (proccuration != null) ...[
                Text(
                  "Informations de la procuration".tr,
                  style: _theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                12.height,
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _theme.colorScheme.surface,
                    border: Border.all(
                      color: _theme.colorScheme.outline.withOpacity(0.2),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow(
                        icon: Icons.calendar_today_outlined,
                        label: "Crée le".tr,
                        value: proccuration!.createdAt != null
                            ? formatDate(proccuration!.createdAt!.toString())
                            : "Inconnue".tr,
                        theme: _theme,
                      ),
                      12.height,
                      if (proccuration!.status != null) ...[
                        12.height,
                        _buildInfoRow(
                          icon: Icons.check_circle_outline,
                          label: "Statut".tr,
                          value: proccuration!.status!.tr,
                          theme: _theme,
                        ),
                      ],
                      if (proccuration!.propertyDetails?.address != null) ...[
                        12.height,
                        _buildInfoRow(
                          icon: Icons.location_on_outlined,
                          label: "Adresse du bien".tr,
                          value: proccuration!.propertyDetails!.address!,
                          theme: _theme,
                        ),
                      ],
                      if (proccuration!.propertyDetails?.complement != "") ...[
                        12.height,
                        _buildInfoRow(
                          icon: Icons.info_outline,
                          label: "Complément d'adresse".tr,
                          value: proccuration!.propertyDetails!.complement!,
                          theme: _theme,
                        ),
                      ],
                    ],
                  ),
                ),
                20.height,
              ],

              // Close button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Fermer".tr),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required ThemeData theme,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: theme.colorScheme.primary,
        ),
        12.width,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              2.height,
              Text(
                value,
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }

  bool _hasUserInfo() {
    return user.email?.isNotEmpty == true ||
        user.phone?.isNotEmpty == true ||
        user.address?.isNotEmpty == true;
  }
}

void reglerProcurationpayment(
  BuildContext context,
  Procuration proc, {
  VoidCallback? onSuccess,
  VoidCallback? onError,
}) {
  showpayementIntentDialog(
    context,
    dialogTitle: 'Utiliser un double crédit État des Lieux ?'.tr,
    dialogDescription:
        'Ce crédit vous permet de déleguer vos états de lieux à vos locataires'
            .tr,
    balence: Jks.wizardState.currentUser.balance?.procurement ?? 0,
    source: "procurationcreated",
    onConfirmed: () {
      Navigator.pop(context);
      Navigator.pop(context);
      if (onSuccess != null) {
        onSuccess();
      }
    },
    onConsumption: () {
      Jks.paymentState.useOneCredit({
        'type': "procurement",
        "procuration_id": Jks.wizardState.formValues['procurationId'] ?? proc.id
      }).then((val) {
        Jks.languageState.showAppNotification(
          title: "Reglée".tr,
          message:
              "Procuration réglée, vous pouvez maintenant l'envoyer aux signataires"
                  .tr,
        );
        var newpro = proc.copyWith(
          credited: true,
        );
        if (Jks.proccurationState.proccurations.isNotEmpty) {
          int index = Jks.proccurationState.proccurations
              .indexWhere((element) => element.id == proc.id);

          if (index != -1) {
            Jks.proccurationState.proccurations[index] = newpro;

            Jks.wizardState.prefillProccuration(newpro, quietly: true);
          }
        }
        Jks.proccurationState.seteditingProcuration(newpro);

        Navigator.pop(context);
        if (onSuccess != null) {
          onSuccess();
        }
      });
    },
  );
}
