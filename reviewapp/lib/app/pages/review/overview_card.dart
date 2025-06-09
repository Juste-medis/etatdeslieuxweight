import 'package:flutter/material.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/fuctions/helper_functions.dart';
import 'package:nb_utils/nb_utils.dart';

class BorderOverviewCard extends StatefulWidget {
  const BorderOverviewCard({
    super.key,
    this.iconPath,
    this.onTap,
    this.title,
    this.subtitle,
    this.error,
    this.iconBackgroundColor,
    this.cardBackgroundColor,
    this.border,
    this.cardType = BorderOverviewCardType.vertical,
  });
  final dynamic iconPath;
  final Widget? title;
  final Widget? subtitle;
  final Widget? error;
  final Color? iconBackgroundColor;
  final Color? cardBackgroundColor;
  final BoxBorder? border;
  final BorderOverviewCardType cardType;
  final dynamic onTap;

  @override
  State<BorderOverviewCard> createState() => _BorderOverviewCardState();
}

class _BorderOverviewCardState extends State<BorderOverviewCard> {
  bool isHovering = false;
  void changeHoverState(bool value) {
    return setState(() => isHovering = value);
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _isVerticalCard = widget.cardType == BorderOverviewCardType.vertical;

    final _border = widget.border ??
        const Border(
          top: BorderSide(
            color: Colors.amber,
            width: 6,
          ),
        );

    return MouseRegion(
      onEnter: (_) => changeHoverState(true),
      onExit: (_) => changeHoverState(false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Material(
          color:
              widget.cardBackgroundColor ?? _theme.colorScheme.primaryContainer,
          elevation: isHovering ? 4.75 : 0,
          clipBehavior: Clip.antiAlias,
          child: DecoratedBox(
            decoration: BoxDecoration(
                border: Border.all(color: _theme.dividerColor, width: .5)),
            child: Container(
              decoration: BoxDecoration(border: _border),
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: 4,
                vertical: 16,
              ),
              child: _isVerticalCard
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildIcon(context),
                        const SizedBox.square(dimension: 16),
                        _buildContent(context, _isVerticalCard),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildIcon(context),
                        const SizedBox.square(dimension: 16),
                        Flexible(
                            child: _buildContent(context, _isVerticalCard)),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(BuildContext context) {
    return Container(
      constraints: BoxConstraints.tight(
        const Size.square(30),
      ),
      padding: const EdgeInsetsDirectional.all(8),
      decoration: BoxDecoration(
        color: widget.iconBackgroundColor,
      ),
      child: widget.iconPath is Widget
          ? widget.iconPath
          : AnimageWidget(
              imagePath: widget.iconPath,
              width: 40,
              height: 40,
              fit: BoxFit.cover,
              // fit: BoxFit.,
            ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    bool isVerticalCard,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment:
          isVerticalCard ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        if (widget.title != null) Flexible(child: widget.title!),
        const SizedBox.square(
          dimension: 4,
        ),
        if (widget.subtitle != null) Flexible(child: widget.subtitle!),
        if (widget.error != null) 10.height,
        if (widget.error != null) Flexible(child: widget.error!),
      ],
    );
  }
}

enum BorderOverviewCardType { vertical, horizontal }
