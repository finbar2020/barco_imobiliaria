import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/feature/home/presentation/widget/sliver/bloc/home_sliver_app_bar_bloc.dart';
import 'package:lello/feature/home/presentation/widget/sliver/bloc/home_sliver_app_bar_state.dart';
import 'package:lello/feature/home/presentation/widget/sliver/delegate/widget/home_sliver_app_bar_delegate.dart';

class SliverWidget extends StatefulWidget {
  final List<Widget> children;
  final ScrollController? scrollController;
  final bool hasScroll;
  final bool showBalance;
  final int? pendencyNumber;
  final bool isGeneric;

  const SliverWidget(
      {Key? key,
      required this.children,
      this.hasScroll = true,
      this.isGeneric = false,
      this.scrollController,
      this.showBalance = false,
      this.pendencyNumber})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _SliverWidgetState();
}

class _SliverWidgetState extends State<SliverWidget> {
  final _bloc = ApplicationContainer.instance().resolve<HomeSliverAppBarBloc>();

  @override
  Widget build(BuildContext context) {
    List<Widget> slivers = [
      SliverPersistentHeader(
        pinned: false,
        floating: false,
        delegate: HomeSliverAppBarDelegate(
            isGeneric: widget.isGeneric,
            pendencyNumber: widget.pendencyNumber,
            showBalance: widget.showBalance,
            onExpanded: (isExpanded) {
              _bloc.beginLockScroll(!isExpanded);
            }),
      )
    ];
    slivers.addAll(widget.children);
    return BlocBuilder<HomeSliverAppBarBloc, HomeSliverAppBarState>(
        bloc: _bloc,
        builder: (context, state) => CustomScrollView(
            physics: widget.hasScroll
                ? const AlwaysScrollableScrollPhysics()
                : const NeverScrollableScrollPhysics(),
            controller: widget.scrollController,
            slivers: slivers));
  }
}
