import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:super_simple_accountant/assets.dart';
import 'package:super_simple_accountant/extensions.dart';

class ResponsiveAppBar extends StatelessWidget implements PreferredSizeWidget {
  final BuildContext context;
  final String title;
  final bool showAppIcon;
  final bool showMenu;
  final VoidCallback? onExport;

  const ResponsiveAppBar({
    super.key,
    required this.context,
    required this.title,
    this.showAppIcon = false,
    this.showMenu = false,
    this.onExport,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: context.largerThanMobile ? 120 : null,
      title: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Builder(
          builder: (context) {
            if (showAppIcon) return _TitleWithAppIcon(title: title);
            return _AppBarTitle(title: title);
          },
        ),
      ),
      actions: showMenu
          ? [
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'export' && onExport != null) {
                    onExport!();
                  }
                },
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem<String>(
                    value: 'export',
                    child: Text(
                      context.l10n.exportEntries,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ]
          : null,
    );
  }

  @override
  Size get preferredSize {
    return Size(
      context.width,
      context.largerThanMobile ? 120 : kToolbarHeight,
    );
  }
}

class _TitleWithAppIcon extends StatelessWidget {
  final String title;

  const _TitleWithAppIcon({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(kIsWeb ? 24 : 10),
          child: Image.asset(Assets.appIconRounded, scale: kIsWeb ? 3.2 : 6.3),
        ),
        const SizedBox(width: kIsWeb ? 24 : 16),
        _AppBarTitle(title: title),
      ],
    );
  }
}

class _AppBarTitle extends StatelessWidget {
  final String title;

  const _AppBarTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Text(
        title,
        style: TextStyle(fontSize: context.largerThanMobile ? 32 : 24),
      ),
    );
  }
}
