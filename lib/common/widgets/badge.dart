import 'package:PiliPlus/models/common/badge_type.dart';
import 'package:PiliPlus/utils/extension/string_ext.dart';
import 'package:PiliPlus/utils/extension/theme_ext.dart' show ColorSchemeExt;
import 'package:material_ui/material_ui.dart';

class PBadge extends StatelessWidget {
  final String? text;

  final bool isStack;
  final double? top;
  final double? right;
  final double? bottom;
  final double? left;
  final EdgeInsets? padding;

  final PBadgeType type;
  final PBadgeSize size;

  final double fontSize;
  final bool isBold;
  final double? textScaleFactor;

  const PBadge({
    super.key,
    required this.text,
    this.top,
    this.right,
    this.bottom,
    this.left,
    this.type = PBadgeType.primary,
    this.size = PBadgeSize.medium,
    this.isStack = true,
    this.fontSize = 11,
    this.isBold = true,
    this.textScaleFactor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    if (text.isNullOrEmpty) {
      return const SizedBox.shrink();
    }

    final colorScheme = ColorScheme.of(context);

    final Color bgColor;
    final Color color;
    final isDark = colorScheme.isDark;
    Color borderColor = isDark ? Colors.white : Colors.black;
    // 墨水屏：主题种子色（绿）转灰后是中灰块 + 白字，一片雾。
    // 全部收敛成「黑底白字 / 白底黑框」两态。
    final Color solid = isDark ? Colors.white : Colors.black;
    final Color onSolid = isDark ? Colors.black : Colors.white;

    switch (type) {
      case PBadgeType.primary:
        bgColor = solid;
        color = onSolid;
      case PBadgeType.secondary:
        bgColor = colorScheme.surface;
        color = colorScheme.onSurface;
      case PBadgeType.gray:
        bgColor = Colors.black;
        color = Colors.white;
        borderColor = Colors.white;
      case PBadgeType.error:
        bgColor = solid;
        color = onSolid;
      case PBadgeType.line_primary:
        color = colorScheme.onSurface;
        bgColor = Colors.transparent;
        borderColor = colorScheme.outline;
      case PBadgeType.line_secondary:
        color = colorScheme.onSurface;
        bgColor = Colors.transparent;
        borderColor = colorScheme.outline;
      case PBadgeType.free:
        bgColor = solid;
        color = onSolid;
      case PBadgeType.shop:
        bgColor = colorScheme.surface;
        color = colorScheme.onSurface;
    }

    const defPaddingStyle = EdgeInsets.symmetric(vertical: 2, horizontal: 3);
    final BorderRadius br = size == .small
        ? const .all(.circular(3))
        : const .all(.circular(4));

    Widget content = Container(
      padding: padding ?? defPaddingStyle,
      decoration: BoxDecoration(
        borderRadius: br,
        color: bgColor,
        border: .all(color: borderColor),
      ),
      child: Text(
        text!,
        textScaler: textScaleFactor != null ? .linear(textScaleFactor!) : null,
        style: TextStyle(
          height: 1,
          fontSize: fontSize,
          color: color,
          fontWeight: isBold ? FontWeight.bold : null,
        ),
        strutStyle: StrutStyle(
          leading: 0,
          height: 1,
          fontSize: fontSize,
          fontWeight: isBold ? FontWeight.bold : null,
        ),
      ),
    );
    if (isStack) {
      return Positioned(
        top: top,
        left: left,
        right: right,
        bottom: bottom,
        child: content,
      );
    } else {
      return content;
    }
  }
}
