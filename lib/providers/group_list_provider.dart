import 'package:blazely/models/group_list.dart';
import 'package:blazely/services/group_list_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

class GroupListAsyncNotifier extends AsyncNotifier<List<GroupList>> {
  final logger = Logger();
  final _groupListService = GroupListService();

  @override
  Future<List<GroupList>> build() async {
    try {
      final groups = await _groupListService.getLoggedInUserGroups(ref);
      return groups;
    } catch (e, stackTrace) {
      logger.e(
        "Failed to fetch logged-in user group lists",
        error: e,
        stackTrace: stackTrace,
      );
      return [];
    }
  }
}

final groupListAsyncProvider =
    AsyncNotifierProvider<GroupListAsyncNotifier, List<GroupList>>(
      () => GroupListAsyncNotifier(),
    );
