import 'package:flutter/material.dart';

import '../../../app_localization.dart';
import '../../app_theme.dart';
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
                    style: LelloTheme.light.textTheme.bodyMedium,
                    text: getString(
                      context,
                      title,
                    ),
                  ),
                  if (content != null)
                    TextSpan(
                      text: ": ",
                      style: LelloTheme.light.textTheme.bodyMedium,
                    ),
                  if (content != null)
                    TextSpan(
                      style: LelloTheme.light.textTheme.bodyMedium?.merge(
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
