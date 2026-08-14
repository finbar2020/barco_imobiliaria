import 'package:cached_network_image/cached_network_image.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:morar/feature/reports_book/domain/entity/report_contents.dart';
import 'package:morar/feature/reports_book/domain/entity/report_type_user.dart';
import 'package:morar/feature/reports_book/presentation/widgets/load_pdf_by_link.dart';
import 'package:morar/feature/reports_book/presentation/widgets/report_preview_widget.dart';

class ReportDetailsWidget extends StatefulWidget {
  final ReportContents content;
  final String typeReport;
  final Map<String, String>? httpHeaders;

  const ReportDetailsWidget({
    Key? key,
    required this.content,
    required this.httpHeaders,
    required this.typeReport,
  }) : super(key: key);

  @override
  _ReportDetailsWidgetState createState() => _ReportDetailsWidgetState();
}

class _ReportDetailsWidgetState extends State<ReportDetailsWidget> {
  late bool imageLoaded;
  @override
  void initState() {
    super.initState();
    imageLoaded = false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(Dimens.spacing),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: widget.content.typeUser == 0
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Text(
            widget.content.typeUser == 0
                ? getString(context, 'reports_your_reply')
                : getString(context, 'reports_manager_reply'),
            style: widget.content.typeUser == 0
                ? LelloTextStyles.bodyBold(theme)
                : TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w700,
                    color: theme.primaryColor),
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(
            height: Dimens.spacingXSmall,
          ),
          Text(
            widget.content.getDate(),
            style: LelloTextStyles.subBody(theme),
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(
            height: Dimens.spacingSmall,
          ),
          Container(
            child: Text(
              widget.content.content!,
              style: LelloTextStyles.body(theme),
              textAlign: widget.content.typeUser == TypeUser.morador.index
                  ? TextAlign.end
                  : TextAlign.start,
            ),
          ),
          if (widget.content.content != null &&
              widget.content.attachment != null)
            Column(
              crossAxisAlignment:
                  widget.content.typeUser == TypeUser.morador.index
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: Dimens.spacing,
                ),
                Text(
                  getString(context, 'reports_attached_file'),
                  style: LelloTextStyles.bodyBold(theme)!
                      .copyWith(color: LelloTheme.palleteOf(theme).textLight()),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                  height: 10.0,
                ),
                if (widget.content.attachmentType != null &&
                    widget.content.attachmentType!.contains("application/pdf"))
                  InkWell(
                    onTap: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ShowPDFWidget(
                            attachmentLink: widget.content.attachmentLink!,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      height: 80,
                      width: 80,
                      child: SvgPicture.asset(
                        "assets/ic_documents.svg",
                        height: 60,
                        width: 60,
                      ),
                    ),
                  ),
                if (widget.content.attachmentType != null &&
                    widget.content.attachmentType!.contains("image"))
                  Container(
                    height: 100,
                    width: 100,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return new DetailScreenLink(
                              attachmentLink: widget.content.attachmentLink!,
                              theme: theme,
                            );
                          },
                        ));
                      },
                      child: new Hero(
                        tag: widget.content.attachmentLink!,
                        child: CachedNetworkImage(
                          httpHeaders: widget.httpHeaders,
                          imageUrl: widget.content.attachmentLink!,
                          placeholder: (context, url) =>
                              new Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => new Center(
                            child: Text(
                              getString(context, "unable_to_load"),
                              style: LelloTextStyles.subBody(theme),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          SizedBox(
            height: 20.0,
          ),
          Divider(
            height: 1,
          ),
        ],
      ),
    );
  }
}
