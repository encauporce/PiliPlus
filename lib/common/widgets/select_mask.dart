import 'package:PiliPlus/common/style.dart';
import 'package:material_ui/material_ui.dart';

Widget selectMask(
  ColorScheme colorScheme,
  bool checked, {
  BorderRadiusGeometry borderRadius = Style.mdRadius,
}) {
  final isDark = colorScheme.brightness == Brightness.dark;
  return AnimatedOpacity(
    opacity: checked ? 1 : 0,
    duration: Duration.zero,
    child: Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: isDark ? Colors.black : Colors.white,
        border: Border.all(
          color: isDark ? Colors.white : Colors.black,
          width: 1.0,
        ),
      ),
      child: AnimatedScale(
        scale: checked ? 1 : 0,
        duration: Duration.zero,
        curve: Curves.easeInOut,
        child: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: isDark ? Colors.black : Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: isDark ? Colors.white : Colors.black,
              width: 1.0,
            ),
          ),
          child: Icon(
            Icons.done_all_outlined,
            color: isDark ? Colors.white : Colors.black,
            semanticLabel: '取消选择',
          ),
        ),
      ),
    ),
  );
}
