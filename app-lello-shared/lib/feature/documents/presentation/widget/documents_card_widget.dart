import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class DocumentsCardWidget extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  /// `true` na página-menu (o `title` é uma chave de localização). `false` na
  /// lista (o `title` é o nome literal do documento).
  final bool isFirstPage;

  const DocumentsCardWidget({
    Key? key,
    required this.title,
    required this.onTap,
    this.isFirstPage = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(25.0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: SvgPicture.asset(
                    "assets/ic_documents_detail.svg",
                    package: 'shared_features',
                  ),
                ),
                SizedBox(width: Dimens.homeMenuIconSize),
                Expanded(
                  flex: 5,
                  child: isFirstPage
                      ? Text(
                          getString(context, title),
                          style: LelloTextStyles.body(theme),
                        )
                      : Text(
                          title,
                          style: LelloTextStyles.body(theme),
                        ),
                ),
                if (!isFirstPage)
                  Expanded(
                    flex: 1,
                    child: Icon(Icons.keyboard_arrow_right),
                  ),
              ],
            ),
          ),
        ),
        Divider(height: 1),
      ],
    );
  }
}
