import 'package:PiliPlus/common/style.dart';
import 'package:PiliPlus/models_new/live/live_medal_wall/uinfo_medal.dart';
import 'package:PiliPlus/utils/color_utils.dart';
import 'package:material_ui/material_ui.dart';

const _kFontSize = 10.0;
const _kStrutStyle = StrutStyle(height: 1, leading: 0, fontSize: _kFontSize);
const _kPadding = EdgeInsets.symmetric(horizontal: 8, vertical: 3);

class MedalWidget extends StatelessWidget {
  const MedalWidget({
    super.key,
    required this.medalName,
    required this.level,
    required this.backgroundColor,
    required this.nameColor,
    this.fontSize = _kFontSize,
    this.strutStyle = _kStrutStyle,
    this.padding = _kPadding,
  });

  MedalWidget.fromMedalInfo({
    super.key,
    required UinfoMedal medal,
    this.fontSize = _kFontSize,
    this.strutStyle = _kStrutStyle,
    this.padding = _kPadding,
  }) : medalName = medal.name!,
       level = medal.level!,
       backgroundColor = ColourUtils.parseMedalColor(medal.v2MedalColorStart!),
       nameColor = ColourUtils.parseColor(medal.v2MedalColorText!);

  final String medalName;
  final int level;
  final Color backgroundColor;
  final Color nameColor;
  final double fontSize;
  final StrutStyle strutStyle;
  final EdgeInsets padding;

  static const mediumPadding = EdgeInsets.symmetric(horizontal: 6, vertical: 3);

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);
    // 墨水屏：粉丝牌原来是「直播间主题色底 + 彩色名字」，
    // 转灰后是一块深浅不一的脏灰，还和 LV 徽章抢视觉。统一成白底 + 1dp 黑框。
    final fg = colorScheme.onSurface;
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: Style.mdRadius,
        color: colorScheme.surface,
        border: Border.all(color: colorScheme.outline, width: 1),
      ),
      child: Text.rich(
        strutStyle: strutStyle,
        TextSpan(
          children: [
            TextSpan(
              text: medalName,
              style: TextStyle(
                height: 1,
                fontSize: fontSize,
                color: fg,
              ),
            ),
            TextSpan(
              text: ' $level',
              style: TextStyle(
                height: 1,
                fontSize: fontSize,
                color: fg,
                fontWeight: .bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
