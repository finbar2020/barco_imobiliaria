import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:morar/feature/billets/domain/entity/billet.dart';

class BilletsCardWidget extends StatelessWidget {
  final VoidCallback onTap;
  final Billet model;
  const BilletsCardWidget({Key? key, required this.onTap, required this.model})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formatCurrency = new NumberFormat.currency(symbol: "R\$");
    final theme = LelloTheme.light;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Dimens.spacing),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${model.mes}/${model.period!.year}",
                              overflow: TextOverflow.ellipsis,
                              style: LelloTextStyles.body(theme)!.copyWith(
                                color: LelloTheme.palleteOf(theme).textOpaque(),
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  height: 10.0,
                                  width: 10.0,
                                  decoration: BoxDecoration(
                                    color: model.color(theme),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: Dimens.spacingSmall),
                                Text(
                                  getString(context, model.statusText),
                                  overflow: TextOverflow.ellipsis,
                                  style:
                                      LelloTextStyles.subBody(theme)!.copyWith(
                                    color: model.color(theme),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                        SizedBox(height: Dimens.spacingXSmall),
                        Text(
                          model.name ?? "",
                          overflow: TextOverflow.visible,
                          style: LelloTextStyles.subBody(theme),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: Dimens.spacingSmall),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          model.dueDate,
                          overflow: TextOverflow.ellipsis,
                          style: LelloTextStyles.caption(theme)!
                              .copyWith(color: model.colorDueDate),
                        ),
                        SizedBox(height: Dimens.spacing),
                        Text(
                          formatCurrency.format(model.value),
                          overflow: TextOverflow.ellipsis,
                          style: LelloTextStyles.subtitle(theme),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: Dimens.spacing),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.keyboard_arrow_right,
                        color: LelloTheme.palleteOf(theme).textOpaque(),
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
