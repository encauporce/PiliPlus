import 'package:PiliPlus/models/common/enum_with_label.dart';
import 'package:material_ui/material_ui.dart' show Alignment;

enum VideoAlignmentType with EnumWithLabel {
  center('居中', alignment: Alignment.center),
  left('左对齐', alignment: Alignment.centerLeft),
  right('右对齐', alignment: Alignment.centerRight),
  ;

  @override
  final String label;
  final Alignment alignment;
  const VideoAlignmentType(this.label, {required this.alignment});
}
