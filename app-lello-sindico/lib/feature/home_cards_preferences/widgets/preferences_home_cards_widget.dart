import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';

class PreferencesHomeCardWidget extends StatefulWidget {
  final Widget imagePath;
  final String text;
  final VoidCallback onTap;
  final SessionBloc sessionBloc;
  final bool isFavorite;
  const PreferencesHomeCardWidget({
    Key? key,
    required this.imagePath,
    required this.text,
    required this.sessionBloc,
    required this.onTap,
    required this.isFavorite,
  }) : super(key: key);

  @override
  State<PreferencesHomeCardWidget> createState() =>
      _PreferencesHomeCardWidgetState();
}

class _PreferencesHomeCardWidgetState extends State<PreferencesHomeCardWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: InkWell(
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        focusColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: widget.onTap,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 110.0),
          child: Container(
            padding: const EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width / 2 - 25,
            decoration: BoxDecoration(
                border: Border.all(
                  width: 0.5,
                  color: LelloTheme.palleteOf(theme).grey(),
                ),
                borderRadius: BorderRadius.circular(8)),
            child: Stack(
              children: [
                Positioned(
                    right: 5.0,
                    top: 5.0,
                    child: widget.isFavorite
                        ? Icon(
                            Icons.star,
                            size: 30.0,
                            color: Color(0xFFC20332),
                          )
                        : Icon(
                            Icons.star_border_outlined,
                            size: 30.0,
                            color: LelloTheme.palleteOf(theme).grey(),
                          )),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          widget.imagePath,
                          SizedBox(
                            height: 8,
                          ),
                          AutoSizeText(
                            getString(context, widget.text),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
