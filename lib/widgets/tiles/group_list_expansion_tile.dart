import 'package:blazely/models/group_list.dart';
import 'package:blazely/widgets/buttons/group_list_action_menu_button.dart';
import 'package:blazely/widgets/tiles/task_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ExpandedTracker {
  bool isExpanded;

  ExpandedTracker(this.isExpanded);
}

class GroupListExpansionTile extends StatefulWidget {
  const GroupListExpansionTile({
    super.key,
    required this.groupList,
    required this.taskListsTiles,
  });

  final GroupList groupList;
  final List<TaskListTile> taskListsTiles;

  @override
  State<GroupListExpansionTile> createState() => _GroupListExpansionTileState();
}

class _GroupListExpansionTileState extends State<GroupListExpansionTile> {
  var expandedTracker = ExpandedTracker(false);
  final softBlack = Color.fromARGB(255, 24, 24, 24);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        dividerColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
        expansionTileTheme: const ExpansionTileThemeData(
          backgroundColor: Colors.transparent,
          collapsedBackgroundColor: Colors.transparent,
        ),
      ),
      child: ExpansionTile(
        onExpansionChanged:
            (value) => setState(() => expandedTracker.isExpanded = value),
        leading:
            expandedTracker.isExpanded
                ? null
                : const Icon(
                  Icons.library_books_outlined,
                  color: Colors.blueGrey,
                ),
        title:
            !expandedTracker.isExpanded
                ? Text(
                  widget.groupList.name,
                  style: Theme.of(context).textTheme.bodyMedium,
                )
                : Row(
                  children: [
                    Text(
                      widget.groupList.name,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Spacer(),
                    GroupListActionMenu(grouplist: widget.groupList),
                  ],
                ),
        tilePadding: EdgeInsets.symmetric(horizontal: 12),
        childrenPadding: EdgeInsets.symmetric(horizontal: 25),
        backgroundColor: Colors.transparent,
        collapsedBackgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        children: [
          if (expandedTracker.isExpanded && widget.taskListsTiles.isEmpty) ...[
            Center(
              child: Text(
                '✨ Tap or drag here to add lists ✨',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxHeight: 300, //Limits the height to 300
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.taskListsTiles.length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    Container(
                      width: 4,
                      height:
                          40, // adjust height as needed or wrap with IntrinsicHeight
                      color: Colors.blue, // or your preferred color
                    ),
                    Expanded(
                      child: widget.taskListsTiles[index]
                          .animate()
                          .fadeIn(
                            duration: 300.ms,
                            delay: (index * 100).ms,
                          ) // assuming you have an index
                          .slideX(
                            begin: 0.3,
                            duration: 500.ms,
                            delay: (index * 100).ms,
                            curve: Curves.easeOutBack,
                          )
                          .scale(
                            begin: Offset(0.8, 0.8),
                            duration: 350.ms,
                            delay: (index * 100).ms,
                          ), // runs after the above w/new duration
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
