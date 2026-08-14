import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/feature/space/domain/entity/space.dart';
import 'package:shared_features/feature/authentication/presentation/store/authentication_store.dart';

class SpaceListItem extends StatefulWidget {
  final Space space;
  final Function(Space)? onPressed;

  const SpaceListItem({Key? key, required this.space, this.onPressed})
      : super(key: key);

  @override
  State<SpaceListItem> createState() => _SpaceListItemState();
}

class _SpaceListItemState extends State<SpaceListItem> {
  Map<String, String>? customHeader;

  final AuthenticationStore authenticationStore =
      ApplicationContainer.instance().resolve();

  @override
  void initState() {
    super.initState();
    customHeader = authenticationStore.getCustomHeader();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () {
        widget.onPressed?.call(widget.space);
      },
      child: Padding(
        padding: EdgeInsets.all(Dimens.spacingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
                height: 160,
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    image: DecorationImage(
                        fit: BoxFit.fitWidth,
                        image: NetworkImage(
                          widget.space.pictureUrl ?? "",
                          headers: customHeader,
                        )))),
            SizedBox(height: Dimens.spacing),
            Row(
              children: [
                Expanded(
                    child: Text(widget.space.name ?? "-",
                        style: LelloTextStyles.body(theme))),
                SvgPicture.asset("assets/ic_arrow_right.svg")
              ],
            )
          ],
        ),
      ),
    );
  }
}
