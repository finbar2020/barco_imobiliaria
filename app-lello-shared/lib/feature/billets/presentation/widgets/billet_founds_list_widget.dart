part of shared_features;

class BilletFoundsListWidget extends StatelessWidget {
  final List founds;
  BilletFoundsListWidget({Key? key, required this.founds}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Dimens.spacingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            (getString(context, "billet_founds_title")).toUpperCase(),
            style: LelloTextStyles.subtitle(theme)
                ?.copyWith(color: LelloTheme.palleteOf(theme).text()),
          ),
          SizedBox(height: Dimens.spacingMedium),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                getString(context, "billet_found"),
                style: LelloTextStyles.bodyBold(theme)
                    ?.copyWith(color: LelloTheme.palleteOf(theme).text()),
              ),
              Text(
                getString(context, "billet_detail_value"),
                style: LelloTextStyles.bodyBold(theme)
                    ?.copyWith(color: LelloTheme.palleteOf(theme).text()),
              ),
            ],
          ),
          SizedBox(height: Dimens.spacing),
          ListView.separated(
            separatorBuilder: (context, index) => Divider(),
            itemCount: founds.length,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: ((context, index) {
              return Padding(
                padding: EdgeInsets.only(bottom: Dimens.spacing),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            founds[index].description ?? "",
                            style: LelloTextStyles.body(theme)?.copyWith(
                                color: LelloTheme.palleteOf(theme).text()),
                          ),
                        ),
                        SizedBox(width: Dimens.spacing),
                        // Expanded(child: Divider(height: 2)),
                      ],
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        founds[index].valueFormatted,
                        style: LelloTextStyles.body(theme)?.copyWith(
                            color: LelloTheme.palleteOf(theme).text()),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
          SizedBox(height: Dimens.spacingLarge),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                getString(context, "billet_detail_total"),
                style: LelloTextStyles.subtitleBold(theme)
                    ?.copyWith(color: LelloTheme.palleteOf(theme).text()),
              ),
              Text(
                _getTotalValue(founds),
                style: LelloTextStyles.subtitleBold(theme)
                    ?.copyWith(color: LelloTheme.palleteOf(theme).text()),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getTotalValue(List founds) {
    final numberFormat = new NumberFormat(",###.00");
    double total = 0.0;
    founds.forEach((element) {
      if (element.value != null) {
        total += element.value!;
      }
    });
    return numberFormat.format(total);
  }
}
