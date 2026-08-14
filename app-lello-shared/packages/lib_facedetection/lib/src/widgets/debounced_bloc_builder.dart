import 'dart:async';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class DebouncedBlocBuilder<B extends BlocBase<S>, S> extends StatefulWidget {
  final B bloc;
  final BlocWidgetBuilder<S> builder;
  final Duration debounceDuration;

  const DebouncedBlocBuilder({
    super.key,
    required this.bloc,
    required this.builder,
    this.debounceDuration = const Duration(milliseconds: 200),
  });

  @override
  State<DebouncedBlocBuilder<B, S>> createState() =>
      _DebouncedBlocBuilderState<B, S>();
}

class _DebouncedBlocBuilderState<B extends BlocBase<S>, S>
    extends State<DebouncedBlocBuilder<B, S>> {
  Timer? _debounceTimer;
  S? _lastState;
  S? _currentState;
  DateTime? _lastUpdateTime;

  @override
  void initState() {
    super.initState();
    _lastState = widget.bloc.state;
    _currentState = _lastState;
    _lastUpdateTime = DateTime.now();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<B, S>(
      bloc: widget.bloc,
      buildWhen: (previous, current) {
        final now = DateTime.now();

        // Prevent updates that are too frequent
        if (_lastUpdateTime != null) {
          final timeSinceLastUpdate = now.difference(_lastUpdateTime!);

          // Only allow updates if enough time has passed
          if (timeSinceLastUpdate <
              Duration(milliseconds: widget.debounceDuration.inMilliseconds)) {
            return false;
          }
        }

        final shouldUpdate = previous != current;
        return shouldUpdate;
      },
      builder: (context, state) {
        _lastState = _currentState;
        _lastUpdateTime = DateTime.now();
        return widget.builder(context, state);
      },
    );
  }
}
