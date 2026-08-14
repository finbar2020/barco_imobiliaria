import 'package:flutter/material.dart';
import 'package:essentials/essentials.dart';

import '../enum/staff_access_permission_enum.dart';

class AccessTable extends StatefulWidget {
  const AccessTable({super.key});

  @override
  _AccessTableState createState() => _AccessTableState();
}

class _AccessTableState extends State<AccessTable> {
  late final LinkedScrollControllerGroup _controllers;
  late final ScrollController _horizontalScrollController;
  late final ScrollController _headerController;
  final _verticalScrollController = ScrollController();
  final _fixedColumnScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _controllers = LinkedScrollControllerGroup();
    _headerController = _controllers.addAndGet();
    _horizontalScrollController = _controllers.addAndGet();

    _fixedColumnScrollController.addListener(() {
      if (_verticalScrollController.offset !=
          _fixedColumnScrollController.offset) {
        _verticalScrollController.jumpTo(_fixedColumnScrollController.offset);
      }
    });
    _verticalScrollController.addListener(() {
      if (_fixedColumnScrollController.offset !=
          _verticalScrollController.offset) {
        _fixedColumnScrollController.jumpTo(_verticalScrollController.offset);
      }
    });
  }

  @override
  void dispose() {
    _fixedColumnScrollController.dispose();
    _verticalScrollController.dispose();
    _horizontalScrollController.dispose();
    _headerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 170,
                height: 60,
                color: Colors.grey[200],
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    getString(context, "access"),
                    style: LelloTextStyles.bodyBold(theme),
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  controller: _headerController,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: StaffAccessRole.values
                        .map(
                          (role) => _headerItem(
                            role,
                            context,
                            theme,
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Row(
              children: [
                SizedBox(
                  width: 170,
                  child: SingleChildScrollView(
                    controller: _fixedColumnScrollController,
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: accessPermissions.keys.map((type) {
                        return Container(
                          height: 75,
                          width: 170,
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 8.0),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.grey.shade300),
                            ),
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              type.labelOf(context),
                              textAlign: TextAlign.start,
                              maxLines: 3,
                              style: LelloTextStyles.body(theme),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                Expanded(
                  child: Scrollbar(
                    thumbVisibility: true,
                    trackVisibility: true,
                    thickness: 5,
                    scrollbarOrientation: ScrollbarOrientation.top,
                    child: SingleChildScrollView(
                      controller: _horizontalScrollController,
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView(
                        controller: _verticalScrollController,
                        scrollDirection: Axis.vertical,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: accessPermissions.entries.map((entry) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: StaffAccessRole.values
                                  .map(
                                    (role) => _buildCheckIcon(
                                      entry.value.isAllowed(role),
                                    ),
                                  )
                                  .toList(),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerItem(
    StaffAccessRole role,
    BuildContext context,
    ThemeData theme,
  ) {
    return Container(
      width: 120,
      height: 60,
      padding: const EdgeInsets.all(8.0),
      color: Colors.grey[200],
      child: Center(
        child: Text(
          role.labelOf(context),
          style: LelloTextStyles.bodyBold(theme),
        ),
      ),
    );
  }

  Widget _buildCheckIcon(bool value) {
    return Container(
      width: 120,
      height: 75,
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Center(
        child: value
            ? const Icon(Icons.check_circle, color: Colors.green)
            : const Icon(Icons.cancel, color: Colors.red),
      ),
    );
  }
}
