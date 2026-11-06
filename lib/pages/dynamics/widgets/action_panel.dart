import 'package:PiliPlus/models/dynamics/result.dart';
import 'package:PiliPlus/pages/dynamics_repost/view.dart';
import 'package:PiliPlus/utils/num_utils.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/request_utils.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_ui/material_ui.dart';

class ActionPanel extends StatelessWidget {
  const ActionPanel({
    super.key,
    required this.item,
  });
  final DynamicItemModel item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final outline = theme.colorScheme.outline;
    final moduleStat = item.modules.moduleStat!;
    final forward = moduleStat.forward!;
    final comment = moduleStat.comment!;
    final like = moduleStat.like!;
    final btnStyle = TextButton.styleFrom(
      tapTargetSize: .padded,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      foregroundColor: outline,
    ).copyWith(
      // 全局 textButtonTheme 会给每个 TextButton 描 1dp 黑边，
      // 三个按钮并排时相邻两条边叠成 2dp 的粗双线。
      // 这里关掉各自的边，改由外层容器统一描边 + 内部竖线分隔。
      side: const WidgetStatePropertyAll(BorderSide.none),
    );
    final divider = VerticalDivider(width: 1, thickness: 1, color: outline);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: const .all(.circular(8)),
        border: Border.all(color: outline, width: 1.0),
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: Builder(
                builder: (context) {
                  return TextButton.icon(
                    onPressed: () => showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      useSafeArea: true,
                      builder: (_) => RepostPanel(
                        item: item,
                        onSuccess: () {
                          int count = forward.count ?? 0;
                          forward.count = count + 1;
                          if (context.mounted) {
                            (context as Element?)?.markNeedsBuild();
                          }
                        },
                        replyInfo: item.basic?.replyInfo,
                        mentionItem: item.modules.moduleAuthor?.mentionItem,
                      ),
                    ),
                    icon: Icon(
                      FontAwesomeIcons.shareFromSquare,
                      size: 16,
                      color: outline,
                      semanticLabel: "转发",
                    ),
                    style: btnStyle,
                    label: Text(
                      forward.count != null
                          ? NumUtils.numFormat(forward.count)
                          : '转发',
                    ),
                  );
                },
              ),
            ),
            divider,
            Expanded(
              child: TextButton.icon(
                onPressed: () => PageUtils.pushDynDetail(
                  item,
                  isPush: true,
                  viewComment: true,
                ),
                icon: Icon(
                  FontAwesomeIcons.comment,
                  size: 16,
                  color: outline,
                  semanticLabel: "评论",
                ),
                style: btnStyle,
                label: Text(
                  comment.count != null
                      ? NumUtils.numFormat(comment.count)
                      : '评论',
                ),
              ),
            ),
            divider,
            Expanded(
              child: Builder(
                builder: (context) {
                  final IconData icon;
                  final Color color;
                  final String label;
                  if (like.status ?? false) {
                    icon = FontAwesomeIcons.solidThumbsUp;
                    color = primary;
                    label = '已赞';
                  } else {
                    icon = FontAwesomeIcons.thumbsUp;
                    color = outline;
                    label = '点赞';
                  }
                  final likeIcon = Icon(
                    icon,
                    size: 16,
                    color: color,
                    semanticLabel: label,
                  );
                  return TextButton.icon(
                    onPressed: () => RequestUtils.onLikeDynamic(
                      item,
                      likeIcon.color == primary,
                      () {
                        if (context.mounted) {
                          (context as Element?)?.markNeedsBuild();
                        }
                      },
                    ),
                    icon: likeIcon,
                    style: btnStyle,
                    label: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      transitionBuilder: (child, animation) =>
                          ScaleTransition(scale: animation, child: child),
                      child: Text(
                        like.count != null
                            ? NumUtils.numFormat(like.count)
                            : '点赞',
                        key: ValueKey<int?>(like.count),
                        style: TextStyle(
                          color: like.status! ? primary : outline,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
