import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_completed_request.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_request_status.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_my_request_item_actions/pages/comfort_my_request_item_actions_page.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_my_requests/controller/comfort_my_request_controller.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_my_requests/widgets/confort_request_item_details.dart';
import 'package:shared_features/shared_features.dart';

class ComfortRequestItem extends StatelessWidget {
  const ComfortRequestItem({
    super.key,
    required this.comfortMyRequestsController,
    required this.appContainer,
    required this.item,
    required this.index,
  });

  final ComfortMyRequestsController comfortMyRequestsController;
  final SharedApplicationContainer appContainer;
  final ComfortCompletedRequest item;
  final int index;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: item.status == ComfortRequestStatus.canceled
          ? null
          : () {
              comfortMyRequestsController.isBottomSheetOpen = true;
              comfortMyRequestsController.comfortMyRequestsAnalyticsTimerStop();
              comfortMyRequestsController
                  .comfortMyRequestsBottomSheetAnalyticsTimerStart();
              Modal.showBottomSheet(
                context: context,
                isScrollControlled: true,
                radius: Dimens.spacingLarge,
                builder: (context) => ComfortMyRequestItemActionsBottomSheet(
                  request: item,
                  appContainer: appContainer,
                  updateAllItems: () {
                    comfortMyRequestsController.updateAll();
                  },
                  updatedItemResponse: (ComfortCompletedRequest updatedItem) {
                    comfortMyRequestsController.updateItem(updatedItem, index);
                  },
                ),
              ).then((value) {
                comfortMyRequestsController.isBottomSheetOpen = false;
                comfortMyRequestsController
                    .comfortMyRequestsBottomSheetAnalyticsTimerStop();
                comfortMyRequestsController
                    .comfortMyRequestsAnalyticsTimerStart();
              });
            },
      child: Padding(
        padding: EdgeInsets.fromLTRB(Dimens.spacingXSmall, Dimens.spacingXSmall,
            Dimens.spacingXSmall, 0),
        child: Material(
          child: Opacity(
            opacity: item.status == ComfortRequestStatus.canceled ? 0.6 : 1.0,
            child: Container(
                padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black54,
                      offset: Offset(0, 2),
                      blurRadius: 4.0,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    ConfortRequestItemDetails(
                        appContainer: appContainer, item: item),
                    SizedBox(height: Dimens.spacingSmall),
                    Divider(
                        height: 0, thickness: 0.8, color: Color(0x5C052126)),
                    Icon(
                        item.isExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: Color(0xFF5C0521)),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
