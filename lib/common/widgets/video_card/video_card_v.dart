import 'package:PiliPlus/common/style.dart';
import 'package:PiliPlus/common/widgets/badge.dart';
import 'package:PiliPlus/common/widgets/image/image_save.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/stat/stat.dart';
import 'package:PiliPlus/common/widgets/video_popup_menu.dart';
import 'package:PiliPlus/http/search.dart';
import 'package:PiliPlus/models/home/rcmd/result.dart';
import 'package:PiliPlus/models/model_rec_video_item.dart';
import 'package:PiliPlus/models_new/video/video_detail/dimension.dart';
import 'package:PiliPlus/utils/app_scheme.dart';
import 'package:PiliPlus/utils/date_utils.dart';
import 'package:PiliPlus/utils/duration_utils.dart';
import 'package:PiliPlus/utils/extension/dimension_ext.dart';
import 'package:PiliPlus/utils/id_utils.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

// 视频卡片 - 垂直布局
class VideoCardV extends StatelessWidget {
  final BaseRcmdVideoItemModel videoItem;
  final VoidCallback? onRemove;

  const VideoCardV({
    super.key,
    required this.videoItem,
    this.onRemove,
  });

  Future<void> onPushDetail() async {
    switch (videoItem.goto) {
      case 'bangumi':
        PageUtils.viewPgc(epId: videoItem.param!);
        break;
      case 'av':
        var bvid = videoItem.bvid ?? IdUtils.av2bv(videoItem.aid!);
        var cid = videoItem.cid;
        bool isVertical = false;
        Dimension? dimension;
        if (videoItem is RcmdVideoItemAppModel) {
          if (videoItem.uri case final uri?) {
            isVertical = uri.isVerticalFromUri;
          }
        }
        if (cid == null) {
          if (await SearchHttp.ab2cWithDimension(aid: videoItem.aid, bvid: bvid)
              case final res?) {
            cid = res.cid;
            dimension = res.dimension;
          }
        }
        if (cid != null) {
          PageUtils.toVideoPage(
            aid: videoItem.aid,
            bvid: bvid,
            cid: cid,
            cover: videoItem.cover,
            title: videoItem.title,
            isVertical: isVertical,
            dimension: dimension,
          );
        }
        break;
      // 动态
      case 'picture':
        try {
          PiliScheme.routePushFromUrl(videoItem.uri!);
        } catch (err) {
          SmartDialog.showToast(err.toString());
        }
        break;
      default:
        if (videoItem.uri?.isNotEmpty == true) {
          PiliScheme.routePushFromUrl(videoItem.uri!);
        }
    }
  }

  /// 卡片与封面的统一圆角，保证两者曲率一致
  static const _radius = 8.0;
  static const _cardRadius = BorderRadius.all(Radius.circular(_radius));

  @override
  Widget build(BuildContext context) {
    void onLongPress() => imageSaveDialog(
      title: videoItem.title,
      cover: videoItem.cover,
      bvid: videoItem.bvid,
    );
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: _cardRadius,
            side: BorderSide(color: ColorScheme.of(context).outline),
          ),
          child: InkWell(
            onTap: onPushDetail,
            onLongPress: onLongPress,
            onSecondaryTap: PlatformUtils.isMobile ? null : onLongPress,
            borderRadius: _cardRadius,
            child: Column(
              crossAxisAlignment: .stretch,
              children: [
                // 标题置顶
                Expanded(child: title(context)),
                // 封面居中，圆角与卡片一致
                cover(),
                // 时长 / 播放 / 弹幕 / UP 名置底
                content(context),
              ],
            ),
          ),
        ),
        if (videoItem.goto == 'av')
          Positioned(
            right: -5,
            bottom: -2,
            width: 29,
            height: 29,
            child: VideoPopupMenu(
              iconSize: 17,
              videoItem: videoItem,
              onRemove: onRemove,
            ),
          ),
      ],
    );
  }

  /// 标题：卡片最上方
  Widget title(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const .fromLTRB(7, 5, 7, 3),
      child: ClipRect(
        child: Align(
          alignment: Alignment.topLeft,
          child: Text(
            videoItem.title,
            maxLines: 2,
            overflow: .ellipsis,
            style: TextStyle(
              fontSize: theme.textTheme.bodyMedium?.fontSize,
              fontWeight: FontWeight.w500,
              height: 1.32,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }

  /// 封面：夹在标题与底部信息之间，圆角与卡片保持一致
  Widget cover() {
    return Padding(
      padding: const .symmetric(horizontal: 6, vertical: 2),
      child: AspectRatio(
        aspectRatio: Style.aspectRatio,
        child: LayoutBuilder(
          builder: (context, boxConstraints) => NetworkImgLayer(
            src: videoItem.cover,
            width: boxConstraints.maxWidth,
            height: boxConstraints.maxHeight,
            borderRadius: _cardRadius,
          ),
        ),
      ),
    );
  }

  /// 底部信息：时长 / 播放量 / 弹幕量 / UP 名
  Widget content(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.outline;
    return Padding(
      padding: const .fromLTRB(7, 3, 7, 5),
      child: Column(
        mainAxisSize: .min,
        crossAxisAlignment: .start,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: FittedBox(
              fit: .scaleDown,
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisSize: .min,
                spacing: 8,
                children: [
                  if (videoItem.duration > 0)
                    Row(
                      mainAxisSize: .min,
                      spacing: 2,
                      children: [
                        Icon(Icons.schedule, size: 12, color: color),
                        Text(
                          DurationUtils.formatDuration(videoItem.duration),
                          style: TextStyle(fontSize: 12, color: color),
                        ),
                      ],
                    ),
                  StatWidget(type: .play, value: videoItem.stat.view),
                  if (videoItem.goto != 'picture')
                    StatWidget(type: .danmaku, value: videoItem.stat.danmu),
                ],
              ),
            ),
          ),
          const SizedBox(height: 3),
          Row(
            spacing: 2,
            children: [
              if (videoItem.goto == 'bangumi')
                PBadge(
                  text: videoItem.pgcBadge,
                  isStack: false,
                  size: .small,
                  type: .line_primary,
                  fontSize: 9,
                ),
              if (videoItem.rcmdReason != null)
                PBadge(
                  text: videoItem.rcmdReason,
                  isStack: false,
                  size: .small,
                  type: .secondary,
                ),
              if (videoItem.goto == 'picture')
                const PBadge(
                  text: '动态',
                  isStack: false,
                  size: .small,
                  type: .line_primary,
                  fontSize: 9,
                ),
              if (videoItem.isFollowed)
                const PBadge(
                  text: '已关注',
                  isStack: false,
                  size: .small,
                  type: .secondary,
                ),
              Expanded(
                flex: 1,
                child: Text(
                  videoItem.owner.name.toString(),
                  maxLines: 1,
                  overflow: .ellipsis,
                  semanticsLabel: 'UP：${videoItem.owner.name}',
                  style: TextStyle(
                    height: 1.4,
                    fontSize: theme.textTheme.labelMedium!.fontSize,
                    color: color,
                  ),
                ),
              ),
              if (videoItem is RcmdVideoItemModel)
                Text(
                  DateFormatUtils.dateFormat(
                    videoItem.pubdate,
                    short: shortFormat,
                    long: longFormat,
                  ),
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: theme.textTheme.labelSmall!.fontSize,
                    color: color,
                  ),
                ),
              if (videoItem.goto == 'av') const SizedBox(width: 12),
            ],
          ),
        ],
      ),
    );
  }

  static final shortFormat = DateFormat('M-d');
  static final longFormat = DateFormat('yy-M-d');
}
