import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:material_ui/material_ui.dart';

class CustomToast extends StatelessWidget {
  const CustomToast(this.msg, {super.key});

  final String msg;

  static double toastOpacity = Pref.defaultToastOp;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colorScheme = theme.colorScheme;
    return Container(
      margin: .only(
        bottom: MediaQuery.viewPaddingOf(context).bottom + 30,
      ),
      padding: const .symmetric(horizontal: 17, vertical: 10),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: const .all(.circular(20)),
        border: Border.all(
          color: isDark ? Colors.white : Colors.black,
          width: 1.0,
        ),
      ),
      child: Text(
        msg,
        style: TextStyle(
          fontSize: 13,
          color: colorScheme.onPrimaryContainer,
        ),
      ),
    );
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget(this.msg, {super.key});

  ///loading msg
  final String msg;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final onSurfaceVariant = theme.colorScheme.onSurfaceVariant;
    return Container(
      padding: const .symmetric(horizontal: 30, vertical: 20),
      decoration: BoxDecoration(
        color: theme.dialogTheme.backgroundColor ?? theme.colorScheme.surface,
        borderRadius: const .all(.circular(15)),
        border: Border.all(
          color: isDark ? Colors.white : Colors.black,
          width: 1.0,
        ),
      ),
      child: Column(
        spacing: 20,
        mainAxisSize: .min,
        children: [
          //loading animation
          CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation(onSurfaceVariant),
          ),
          //msg
          Text(msg, style: TextStyle(color: onSurfaceVariant)),
        ],
      ),
    );
  }
}

class NotifyWarning extends StatelessWidget {
  const NotifyWarning(this.msg, {super.key});

  final String msg;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final onSurfaceVariant = theme.colorScheme.onSurfaceVariant;
    return Container(
      decoration: BoxDecoration(
        borderRadius: const .all(.circular(8)),
        color: theme.dialogTheme.backgroundColor ?? theme.colorScheme.surface,
        border: Border.all(
          color: isDark ? Colors.white : Colors.black,
          width: 1.0,
        ),
      ),
      padding: const .symmetric(horizontal: 20, vertical: 10),
      child: Column(
        spacing: 5,
        mainAxisSize: .min,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            size: 22,
            color: onSurfaceVariant,
          ),
          Text(msg, style: TextStyle(color: onSurfaceVariant)),
        ],
      ),
    );
  }
}
