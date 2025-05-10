import 'package:blazely/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreenAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const HomeScreenAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider).value;

    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: CircleAvatar(
          radius: 25,
          backgroundColor: Colors.white,
          child: ClipOval(
            child:
                profile?.profilePictureUrl != null
                    ? Image.network(profile!.profilePictureUrl)
                    : Image.asset("assets/images/no_profile_picture.png"),
          ),
        ),
      ),
      centerTitle: false,
      title: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "${profile?.user?.firstName} ${profile?.user?.lastName}",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Text(
            "${profile?.user?.email}",
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.start,
          ),
        ],
      ),
      actions: const [Icon(Icons.search, size: 35)],
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
