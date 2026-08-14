import 'package:cached_network_image/cached_network_image.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lello/feature/reports_book/domain/entity/report_contents.dart';
import 'package:lello/feature/reports_book/domain/entity/report_type_user.dart';
import 'package:lello/feature/reports_book/presentation/widgets/load_pdf_by_link.dart';
import 'package:lello/feature/reports_book/presentation/widgets/report_preview_widget.dart';
import 'package:shared_features/core/widgets/loading_widget.dart';

class ReportDetailsWidget extends StatefulWidget {
  final ReportContents content;
  final ThemeData theme;
  final String residentName;
  final String unit;

  const ReportDetailsWidget({
    Key? key,
    required this.content,
    required this.theme,
    required this.residentName,
    required this.unit,
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
      padding: EdgeInsets.only(
          top: Dimens.spacingLarge,
          left: Dimens.spacingLarge,
          right: Dimens.spacingLarge),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: widget.content.typeUser == TypeUser.sindico.index
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Text(
            widget.content.typeUser == TypeUser.sindico.index
                ? getString(context, 'reports_your_reply')
                : getString(context, 'reports_resident_reply'),
            style: widget.content.typeUser == TypeUser.sindico.index
                ? TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w700,
                    color: LelloTheme.palleteOf(theme).secondary(),
                  )
                : TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w700,
                    color: theme.primaryColor,
                  ),
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            widget.content.getDate(),
            style: LelloTextStyles.subBody(widget.theme),
            overflow: TextOverflow.ellipsis,
          ),
          if (widget.content.typeUser == TypeUser.morador.index)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 5.0,
                ),
                if (widget.residentName.isNotEmpty)
                  Container(
                    child: Text(
                      "Condômino: ${widget.residentName}",
                      style: LelloTextStyles.bodyBold(widget.theme),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                const SizedBox(
                  height: 5.0,
                ),
                Container(
                  child: Text(
                    "Unidade: ${widget.unit}",
                    style: LelloTextStyles.bodyBold(widget.theme),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          const SizedBox(
            height: 20.0,
          ),
          Container(
            child: widget.content.typeUser == TypeUser.sindico.index
                ? Text(widget.content.content!,
                    style: LelloTextStyles.body(widget.theme),
                    textAlign: TextAlign.end)
                : Text(
                    widget.content.content!,
                    style: LelloTextStyles.body(widget.theme),
                    textAlign: TextAlign.start,
                  ),
          ),
          if (widget.content.content != null &&
              widget.content.attachment != null &&
              widget.content.attachmentType != null &&
              (widget.content.attachmentType!.contains("image") ||
                  widget.content.attachmentType!.contains("application/pdf")))
            Column(
              crossAxisAlignment:
                  widget.content.typeUser == TypeUser.sindico.index
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20.0,
                ),
                Text(
                  getString(context, 'reports_attached_file'),
                  style: LelloTextStyles.bodyBold(widget.theme),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(
                  height: 10.0,
                ),
                if (widget.content.attachmentType != null &&
                    widget.content.attachmentType!.contains("image"))
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return DetailScreenLink(
                              attachmentLink: widget.content.attachmentLink!,
                              theme: widget.theme,
                            );
                          },
                        ));
                      },
                      child: Hero(
                        tag: widget.content.attachmentLink!,
                        child: CachedNetworkImage(
                          imageUrl: widget.content.attachmentLink!,
                          placeholder: (context, url) =>
                              const Center(child: const LoadingWidget()),
                          errorWidget: (context, url, error) => Center(
                            child: Text(
                              "Não foi possível carregar",
                              style: LelloTextStyles.subBody(widget.theme),
                            ),
                          ),
                        ),
                      ),
                    ),
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
                    child: SizedBox(
                      height: 100,
                      width: 100,
                      child: SvgPicture.asset(
                        "assets/ic_documents.svg",
                        height: 80,
                        width: 80,
                      ),
                    ),
                  ),
              ],
            ),
          const SizedBox(
            height: 20.0,
          ),
          const Divider(
            height: 1,
          ),
        ],
      ),
    );
  }
}
