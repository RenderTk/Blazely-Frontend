import 'package:blazely/models/group_list.dart';
import 'package:blazely/models/task_list.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

const userGroupsListsUrl = '/api/groups/';
const createGroupUrl = '/api/groups/';
String updateAndDeleteUrl = "api/groups/<groupId>/";
String manageListsUrl = "api/groups/<groupId>/manage_lists/";

enum ManageTaskListOnGroupAction { add, remove }

class GroupListService {
  final logger = Logger();

  Future<List<GroupList>> getLoggedInUserGroups(Dio dio) async {
    try {
      final response = await dio.get(userGroupsListsUrl);

      if (response.statusCode == 200) {
        final data = response.data as List<dynamic>;
        return data
            .map((e) => GroupList.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      throw Exception("An error occurred when fetching your groups.");
    } catch (e, stackTrace) {
      logger.e(
        "Failed to fetch logged-in user groups",
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<GroupList> createGroup(Dio dio, String name) async {
    try {
      if (name.isEmpty) {
        throw Exception("Group name cannot be empty.");
      }
      final response = await dio.post(createGroupUrl, data: {"name": name});
      final createdGroup = GroupList.fromJson(response.data);
      return createdGroup;
    } catch (e, stackTrace) {
      logger.e("Failed to create the group.", error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<void> updateGroup(Dio dio, GroupList groupList) async {
    if (groupList.id <= 0) return;
    try {
      final response = await dio.put(
        updateAndDeleteUrl.replaceAll("<groupId>", "${groupList.id}"),
        data: groupList.toJson(),
      );
      if (response.statusCode != 200) {
        throw Exception("An error occurred when updating the group.");
      }
    } catch (e, stackTrace) {
      logger.e("Failed to update the group.", error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<void> deleteGroup(Dio dio, GroupList groupList) async {
    try {
      final response = await dio.delete(
        updateAndDeleteUrl.replaceAll("<groupId>", "${groupList.id}"),
      );

      //server retrurns 204 when successfully deleted
      if (response.statusCode != 204) {
        throw Exception("An error occurred when deleting the group.");
      }
    } catch (e, stackTrace) {
      logger.e("Failed to delete the group.", error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<void> unGroupLists(
    Dio dio,
    GroupList groupList,
    List<TaskList> taskLists,
  ) async {
    if (groupList.lists == null) return;
    try {
      final response = await dio.patch(
        manageListsUrl.replaceAll("<groupId>", "${groupList.id}"),
        queryParameters: {"action": ManageTaskListOnGroupAction.remove.name},
        data: {"tasklist_ids": taskLists.map((e) => e.id).toList()},
      );
      if (response.statusCode != 200) {
        throw Exception(
          "An error occurred when updating the tasklists on the group.",
        );
      }
    } catch (e, stackTrace) {
      logger.e(
        "Failed to update the tasklists on the group.",
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<void> groupLists(
    Dio dio,
    GroupList groupList,
    List<TaskList> taskLists,
  ) async {
    if (groupList.lists == null) return;
    if (taskLists.isEmpty) return;
    try {
      final response = await dio.patch(
        manageListsUrl.replaceAll("<groupId>", "${groupList.id}"),
        queryParameters: {"action": ManageTaskListOnGroupAction.add.name},
        data: {"tasklist_ids": taskLists.map((e) => e.id).toList()},
      );
      if (response.statusCode != 200) {
        throw Exception(
          "An error occurred when updating the tasklists on the group.",
        );
      }
    } catch (e, stackTrace) {
      logger.e(
        "Failed to update the tasklists on the group.",
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<void> manageList(
    Dio dio,
    GroupList groupList,
    TaskList taskList,
    ManageTaskListOnGroupAction action,
  ) async {
    if (groupList.lists == null) {
      return;
    }
    try {
      final response = await dio.patch(
        manageListsUrl.replaceAll("<groupId>", "${groupList.id}"),
        queryParameters: {"action": action.name},
        data: {
          "tasklist_ids": [taskList.id],
        },
      );
      if (response.statusCode != 200) {
        throw Exception(
          "An error occurred when updating the tasklist on the group.",
        );
      }
    } catch (e, stackTrace) {
      logger.e(
        "Failed to update the tasklist on the group.",
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}
