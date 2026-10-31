import 'package:PiliPlus/models/common/enum_with_label.dart';

enum SuperResolutionType with EnumWithLabel {
  disable('关闭'),
  efficiency('开启网点'),
  quality('开启网点'),
  ;

  @override
  final String label;
  const SuperResolutionType(this.label);
}
