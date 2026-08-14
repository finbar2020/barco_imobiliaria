import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class RatingBarWidget extends StatefulWidget {
  RatingBarWidget({
    Key? key,
    required this.allowHalfRating,
    this.size = 32.0,
    this.setRating,
    this.initValue,
    this.disableRating = false,
    this.color,
  }) : super(key: key);

  final bool allowHalfRating;
  final Function(double newRating)? setRating;
  final double size;
  final double? initValue;
  final bool disableRating;
  final Color? color;

  @override
  State<RatingBarWidget> createState() => _RatingBarWidgetState();
}

class _RatingBarWidgetState extends State<RatingBarWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.setRating == null
        ? IgnorePointer(
            child: _ratingBar(),
          )
        : _ratingBar();
  }

  RatingBar _ratingBar() {
    return RatingBar(
      initialRating: widget.initValue ?? 0.0,
      minRating: 0.0,
      maxRating: 5.0,
      direction: Axis.horizontal,
      allowHalfRating: widget.allowHalfRating,
      itemCount: 5,
      updateOnDrag: true,
      ignoreGestures: widget.disableRating == true,
      itemSize: widget.size,
      itemPadding: EdgeInsets.symmetric(horizontal: Dimens.spacingXSmall),
      ratingWidget: RatingWidget(
        full: SvgPicture.asset("assets/rating_star_full.svg",
            color: widget.color),
        half: SvgPicture.asset("assets/rating_star_half.svg",
            color: widget.color),
        empty: SvgPicture.asset("assets/rating_star_empty.svg",
            color: widget.color),
      ),
      onRatingUpdate: (value) {
        if (widget.setRating != null) {
          widget.setRating!(value);
        }
      },
      glowColor: widget.color,
    );
  }
}
