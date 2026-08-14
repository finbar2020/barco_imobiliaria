import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund_receipt.dart';

class ResinReceiptsCarousel extends StatefulWidget {
  final CarouselSliderController carouselController;
  final List<ResinRefundReceipt> receipts;
  const ResinReceiptsCarousel({
    Key? key,
    required this.carouselController,
    required this.receipts,
  }) : super(key: key);

  @override
  State<ResinReceiptsCarousel> createState() => _ResinReceiptsCarouselState();
}

class _ResinReceiptsCarouselState extends State<ResinReceiptsCarousel> {
  int indexFile = 0;
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: Dimens.spacing),
          child: Center(
            child: Text("${indexFile + 1}/${widget.receipts.length}"),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimens.spacingSmall),
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.keyboard_arrow_left),
                onPressed: () {
                  widget.carouselController.previousPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.linear);
                },
              ),
              Expanded(
                child: Container(
                  height: 280.0,
                  child: CarouselSlider.builder(
                    itemCount: widget.receipts.length,
                    carouselController: widget.carouselController,
                    options: CarouselOptions(
                      autoPlay: false,
                      enlargeCenterPage: true,
                      viewportFraction: 0.9,
                      aspectRatio: 1.0,
                      initialPage: 0,
                      enableInfiniteScroll: false,
                      onPageChanged: (index, CarouselPageChangedReason) =>
                          setState(() {
                        indexFile = index;
                      }),
                    ),
                    itemBuilder: (BuildContext context, int itemIndex,
                            int pageViewIndex) =>
                        Container(
                      child: Container(
                        child: widget.receipts[itemIndex].digitalDocument
                                    ?.file ==
                                null
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    getString(context,
                                        "resin_review_data_receipts_empty"),
                                    textAlign: TextAlign.center,
                                    style:
                                        LelloTextStyles.body(theme)?.copyWith(
                                      color: LelloTheme.palleteOf(theme).text(),
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: FileIcon(
                                        file: widget.receipts[itemIndex]
                                            .digitalDocument!.file!,
                                        imageIconSize: 240.0,
                                        canDownloadFile: true,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                        top: Dimens.spacingMedium),
                                    child: Text(
                                      _getDescription(
                                          widget.receipts[itemIndex]),
                                      textAlign: TextAlign.center,
                                      textScaleFactor: 1.0,
                                      style:
                                          LelloTextStyles.body(theme)?.copyWith(
                                        color:
                                            LelloTheme.palleteOf(theme).text(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.keyboard_arrow_right),
                onPressed: () {
                  widget.carouselController.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.linear);
                },
              ),
            ],
          ),
        ),
        Center(
          child: Text(
              "${getString(context, 'resin_total_receipts_value')}: ${getTotalReceiptsValueFormatted()}",
              textAlign: TextAlign.center,
              style: LelloTextStyles.bodyBold(theme)),
        ),
      ],
    );
  }

  String getTotalReceiptsValueFormatted() {
    double value = 0.0;
    widget.receipts.forEach((element) {
      value += element.receiptValue;
    });
    NumberFormat format = NumberFormat.currency(symbol: "R\$");
    return format.format(value);
  }

  String _getDescription(ResinRefundReceipt receipt) {
    String type = (getString(context, receipt.receiptTypeKey)).isNotEmpty
        ? "${getString(context, receipt.receiptTypeKey)} -"
        : "";
    String value =
        "${getString(context, 'value')}: ${receipt.valueFormatted()}";
    return "$type $value\n${receipt.sendDateFormatted()}";
  }
}
