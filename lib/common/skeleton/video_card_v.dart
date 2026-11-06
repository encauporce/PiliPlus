import 'package:PiliPlus/common/skeleton/skeleton.dart';
import 'package:PiliPlus/common/style.dart';
import 'package:material_ui/material_ui.dart';

class VideoCardVSkeleton extends StatelessWidget {
  const VideoCardVSkeleton({super.key, this.skeleton = true});

  final bool skeleton;

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);
    // 墨水屏浅色下用略深的灰块，否则骨架在白底上看不出来
    final color = colorScheme.brightness == Brightness.dark
        ? colorScheme.onInverseSurface
        : const Color(0xFFDDDDDD);
    final child = Column(
      crossAxisAlignment: .stretch,
      children: [
        // 标题
        Expanded(
          child: Padding(
            padding: const .fromLTRB(7, 6, 7, 3),
            child: Column(
              crossAxisAlignment: .stretch,
              children: [
                Container(height: 12, color: color),
                const SizedBox(height: 5),
                Align(
                  alignment: Alignment.centerLeft,
                  child: FractionallySizedBox(
                    widthFactor: 0.6,
                    child: Container(height: 12, color: color),
                  ),
                ),
              ],
            ),
          ),
        ),
        // 封面
        Padding(
          padding: const .symmetric(horizontal: 6, vertical: 2),
          child: AspectRatio(
            aspectRatio: Style.aspectRatio,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: color,
                borderRadius: const .all(.circular(8)),
              ),
            ),
          ),
        ),
        // 时长 / 播放 / 弹幕 + UP 名
        Padding(
          padding: const .fromLTRB(7, 5, 7, 6),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Row(
                spacing: 8,
                children: [
                  Expanded(child: Container(height: 11, color: color)),
                  Expanded(child: Container(height: 11, color: color)),
                  Expanded(child: Container(height: 11, color: color)),
                ],
              ),
              Container(
                height: 11,
                width: 75,
                color: color,
                margin: const .only(top: 5),
              ),
            ],
          ),
        ),
      ],
    );
    if (skeleton) return Skeleton(child: child);
    return child;
  }
}
