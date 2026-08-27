import 'package:flutter/material.dart';

import '../../../app_localization.dart';
import '../../dimens.dart';

class FilterItem extends StatelessWidget {
  final String title;
  final String? content;
  final Function() onTap;
  const FilterItem({
    Key? key,
    required this.title,
    required this.content,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Dimens.spacing,
          vertical: Dimens.spacingSmall,
        ),
        child: Row(
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    style: theme.textTheme.bodyMedium,
                    text: getString(
                      context,
                      title,
                    ),
                  ),
                  if (content != null)
                    TextSpan(
                      text: ": ",
                      style: theme.textTheme.bodyMedium,
                    ),
                  if (content != null)
                    TextSpan(
                      style: theme.textTheme.bodyMedium?.merge(
                        const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      text: getString(
                        context,
                        content!,
                      ).isEmpty
                          ? content!
                          : getString(
                              context,
                              content!,
                            ),
                    ),
                ],
              ),
            ),
            SizedBox(
              width: Dimens.spacingSmall,
            ),
            InkWell(
              onTap: onTap,
              child: const Icon(
                Icons.close,
                size: 15,
              ),
            )
          ],
        ),
      ),
    );
  }
}
