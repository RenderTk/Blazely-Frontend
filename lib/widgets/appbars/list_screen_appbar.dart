import 'package:flutter/material.dart';

class ListScreenAppbar extends StatelessWidget implements PreferredSizeWidget {
  const ListScreenAppbar({
    super.key,
    required this.title,
    this.leadingEmoji,
    this.showShareTaskButton = false,
  });

  final String title;
  final String? leadingEmoji;
  final bool showShareTaskButton;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Row(
        children: [
          if (leadingEmoji != null) ...[
            Text(leadingEmoji!, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(width: 10),
          ],
          Flexible(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
      actions: [
        if (showShareTaskButton)
          IconButton(
            icon: const Icon(Icons.person_add_alt_outlined),
            onPressed: () {},
          ),
        IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
