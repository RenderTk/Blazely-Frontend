import 'package:blazely/providers/models_providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreenAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const HomeScreenAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileAsyncProvider);

    return profileAsync.when(
      data:
          (profile) => AppBar(
            leading: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.white,
                    child: ClipOval(
                      child:
                          profile != null
                              ? Image.network(profile.profilePictureUrl)
                              : Image.asset(
                                "assets/images/no_profile_picture.png",
                              ),
                    ),
                  )
                  .animate()
                  .fadeIn(duration: 400.ms)
                  .scale(
                    begin: Offset(0.2, 0.8),
                    end: Offset(1.0, 1.0),
                    duration: 400.ms,
                  ),
            ),
            centerTitle: false,
            title: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  profile != null
                      ? "${profile.user.firstName} ${profile.user.lastName}"
                      : "Couldn't load your profile details.",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text(
                  profile != null ? profile.user.email : "",
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
            actions: const [Icon(Icons.search, size: 35)],
            elevation: 0,
          ),
      loading:
          () => AppBar(
            leading: const CircularProgressIndicator(),
            title: Text(
              "Loading your profile details...",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            centerTitle: true,
          ),
      error:
          (error, stackTrace) => AppBar(
            leading: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: CircleAvatar(
                radius: 25,
                backgroundColor: Colors.white,
                child: ClipOval(
                  child: Image.asset("assets/images/no_profile_picture.png"),
                ),
              ),
            ),
            centerTitle: false,
            title: Text(
              "An error ocurred when fetching your profile.",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
