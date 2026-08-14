import 'dart:async';

import 'package:essentials/analytics/analytics_log_events.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:shared_features/core/custom_cached_network_image/custom_cached_network_image.dart';
import 'package:shared_features/feature/banners/domain/entity/banner.dart';
import 'package:shared_features/feature/banners/domain/entity/banner_location_enum.dart';
import 'package:shared_features/feature/banners/domain/entity/banner_redirect_type_enum.dart';
import 'package:shared_features/feature/banners/presentation/bloc/banners_state.dart';
import 'package:shared_features/feature/banners/presentation/controllers/banners_controller.dart';
import 'package:shared_features/feature/launcher_url/launcher_url.dart';
import 'package:shared_features/shared_features.dart';

class BannersWidget extends StatefulWidget {
  final SharedApplicationContainer appContainer;
  final sessionBloc;
  final Null Function(BannerEntity banner) onBannerClick;
  final String? title;
  final int maxItems;
  final bool showCounterIndicator;
  final String? accessButtonLabel;
  final BannerLocationEnum? location;
  final bool compact;
  final bool stacked;

  BannersWidget({
    Key? key,
    required this.appContainer,
    required this.sessionBloc,
    required this.onBannerClick,
    this.title,
    this.maxItems = 10,
    this.showCounterIndicator = false,
    this.accessButtonLabel,
    this.location,
    this.compact = false,
    this.stacked = false,
  })  : assert(maxItems > 0),
        super(key: key);

  @override
  State<BannersWidget> createState() => _BannersWidgetState();
}

class _BannersWidgetState extends State<BannersWidget> {
  static const double _bannerCardSpacing = 16.0;
  static const double _bannerViewportFraction = 0.88;
  static const int _loopStartPage = 10000;
  static const double _bannerListHeight = 260.0;
  static const double _bannerImageHeight = 140.0;
  static const double _bannerCompactListHeight = 128.0;
  static const double _bannerCompactImageSize = 80.0;
  static const double _bannerStackedImageSize = 136.0;
  static const double _indicatorActiveWidth = 32.0;
  static const double _indicatorDotSize = 10.0;

  late BannersController controller;
  late final PageController _pageController;
  Timer? _autoScrollTimer;
  int _currentBannerIndex = 0;
  int _currentPage = _loopStartPage;
  bool _loopPositionInitialized = false;

  @override
  void initState() {
    super.initState();
    controller = widget.appContainer.resolve();
    controller.getBanners();

    _pageController = PageController(
      viewportFraction: _bannerViewportFraction,
      initialPage: _loopStartPage,
    );

    _autoScrollTimer = Timer.periodic(const Duration(seconds: 15), (_) {
      if (!mounted || !_pageController.hasClients) return;

      final state = controller.bloc.state;
      final visibleBanners = _visibleBannersFromState(state);
      if (visibleBanners.length <= 1) return;

      final nextPage = _currentPage + 1;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
  }

  List<BannerEntity> _visibleBannersFromState(BannersState state) {
    if (state is! LoadedBannersState) return const [];

    final filtered = widget.location != null
        ? state.banners.where((b) => b.location == widget.location).toList()
        : state.banners.toList();

    final active = filtered
        .where((b) => b.ativo == null || b.ativo!.toUpperCase() != 'N')
        .toList();

    active.sort((a, b) => (a.ordem ?? 0).compareTo(b.ordem ?? 0));

    return active.take(widget.maxItems).toList(growable: false);
  }

  int _normalizeIndex(int index, int itemCount) {
    if (itemCount <= 0) return 0;

    final normalized = index % itemCount;
    return normalized < 0 ? normalized + itemCount : normalized;
  }

  void _onPageChanged(int page, int itemCount) {
    if (!mounted || itemCount <= 0) return;

    setState(() {
      _currentPage = page;
      _currentBannerIndex = _normalizeIndex(page, itemCount);
    });
  }

  void _ensureLoopPosition(int itemCount) {
    if (_loopPositionInitialized || itemCount <= 1) return;

    final alignedPage = _loopStartPage - (_loopStartPage % itemCount);
    _currentPage = alignedPage;
    _currentBannerIndex = 0;
    _loopPositionInitialized = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_pageController.hasClients) return;
      _pageController.jumpToPage(alignedPage);
    });
  }

  Widget _buildCounterIndicator(ThemeData theme, int itemCount) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(itemCount, (index) {
          final isActive = index == _currentBannerIndex;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: isActive ? _indicatorActiveWidth : _indicatorDotSize,
            height: _indicatorDotSize,
            decoration: BoxDecoration(
              color: isActive ? theme.primaryColor : Colors.grey.shade400,
              borderRadius: BorderRadius.circular(999),
            ),
          );
        }),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _autoScrollTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: controller.bloc,
      child: BlocBuilder(
        bloc: controller.bloc,
        builder: (context, state) =>
            _buildWidgets(context, state as BannersState),
      ),
    );
  }

  Widget _buildWidgets(BuildContext context, BannersState state) {
    if (state is LoadingBannersState) {
      return Padding(
        padding: EdgeInsets.all(Dimens.spacingLarge),
        child: Row(
          children: [
            Expanded(child: Center(child: CircularProgressIndicator())),
          ],
        ),
      );
    }

    if (state is LoadedBannersState) {
      return _buildBanners(
        context: context,
        banners: _visibleBannersFromState(state),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildBanners({
    required BuildContext context,
    required List<BannerEntity> banners,
  }) {
    final theme = Theme.of(context);
    if (banners.isEmpty) return const SizedBox.shrink();

    if (_currentBannerIndex >= banners.length) {
      _currentBannerIndex = 0;
    }

    if (!widget.stacked) _ensureLoopPosition(banners.length);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.title != null || !widget.stacked)
            Text(
              widget.title ?? getString(context, 'for_you'),
              style: LelloTextStyles.titleSmallBold(theme)!.copyWith(
                color: LelloTheme.palleteOf(theme).text(),
              ),
            ),
          if (widget.title != null || !widget.stacked)
            const SizedBox(height: 8),
          if (widget.stacked)
            ...banners.map(
              (banner) => Padding(
                padding: const EdgeInsets.only(bottom: _bannerCardSpacing / 2),
                child: GestureDetector(
                  onTap: () => _onBannerSelected(banner),
                  child: widget.compact
                      ? _buildStackedCompactBannerCard(context, theme, banner)
                      : _buildFullBannerCard(context, theme, banner),
                ),
              ),
            )
          else
            SizedBox(
              height:
                  widget.compact ? _bannerCompactListHeight : _bannerListHeight,
              child: PageView.builder(
                controller: _pageController,
                itemCount: banners.length > 1 ? null : 1,
                onPageChanged: (page) => _onPageChanged(page, banners.length),
                itemBuilder: (context, index) {
                  final banner =
                      banners[_normalizeIndex(index, banners.length)];

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: _bannerCardSpacing / 2),
                    child: GestureDetector(
                      onTap: () => _onBannerSelected(banner),
                      child: widget.compact
                          ? _buildCompactBannerCard(context, theme, banner)
                          : _buildFullBannerCard(context, theme, banner),
                    ),
                  );
                },
              ),
            ),
          if (widget.showCounterIndicator &&
              !widget.stacked &&
              banners.length > 1)
            _buildCounterIndicator(theme, banners.length),
        ],
      ),
    );
  }

  Widget _buildFullBannerCard(
      BuildContext context, ThemeData theme, BannerEntity banner) {
    return Container(
      width: double.infinity,
      height: _bannerListHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: LelloTheme.palleteOf(theme).grey().withValues(alpha: 0.35),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            child: SizedBox(
              width: double.infinity,
              height: _bannerImageHeight,
              child: CustomCachedNetworkImage(
                link: banner.urlImage,
                applicationContainer: widget.appContainer,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    banner.name ?? 'Titulo do banner',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: LelloTextStyles.subtitleBold(theme)!.copyWith(
                      color: LelloTheme.palleteOf(theme).text(),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      onPressed: () => _onBannerSelected(banner),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.primaryColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        widget.accessButtonLabel ?? 'Acesse aqui',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStackedCompactBannerCard(
      BuildContext context, ThemeData theme, BannerEntity banner) {
    final borderColor =
        LelloTheme.palleteOf(theme).grey().withValues(alpha: 0.35);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: Container(
                  width: _bannerStackedImageSize,
                  height: _bannerStackedImageSize,
                  decoration: BoxDecoration(
                    border: Border.all(color: borderColor, width: 1),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: CustomCachedNetworkImage(
                    link: banner.urlImage,
                    applicationContainer: widget.appContainer,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          banner.name ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: LelloTextStyles.subtitleBold(theme)!.copyWith(
                            color: LelloTheme.palleteOf(theme).text(),
                          ),
                        ),
                        if (banner.subtitle?.isNotEmpty == true) ...[
                          const SizedBox(height: 4),
                          Text(
                            banner.subtitle!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: LelloTextStyles.body(theme)!.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () => _onBannerSelected(banner),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.primaryColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        widget.accessButtonLabel ?? 'Acessar',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactBannerCard(
      BuildContext context, ThemeData theme, BannerEntity banner) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: LelloTheme.palleteOf(theme).grey().withValues(alpha: 0.35),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              width: _bannerCompactImageSize,
              height: _bannerCompactImageSize,
              child: CustomCachedNetworkImage(
                link: banner.urlImage,
                applicationContainer: widget.appContainer,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  banner.name ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: LelloTextStyles.subtitleBold(theme)!.copyWith(
                    color: LelloTheme.palleteOf(theme).text(),
                  ),
                ),
                if (banner.subtitle?.isNotEmpty == true) ...[
                  const SizedBox(height: 4),
                  Text(
                    banner.subtitle!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: LelloTextStyles.body(theme)!.copyWith(
                      color: LelloTheme.palleteOf(theme).text(),
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    onPressed: () => _onBannerSelected(banner),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      widget.accessButtonLabel ?? 'Acessar',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onBannerSelected(BannerEntity banner) {
    AnalyticsLogEvents.logEvent(
      appOrigin: controller.appOriginEnum,
      userId: widget.sessionBloc.state.session?.me?.id ?? '',
      event: controller.getAnalyticsEvent,
      unitValue: controller.getUnitName,
      referenceValue: controller.getCondoReference,
      otherParameters: {
        'id_banner': banner.id,
        'id_parceiro': banner.arg?.partnerId ?? '',
        'id_partner': banner.arg?.partnerId ?? '',
      },
    );

    switch (banner.redirectType) {
      case (BannerRedirectTypeEnum.url):
        if (banner.redirect != null) {
          UrlLauncherNative.openUrl(banner.redirect.toString());
        }
        break;
      case (BannerRedirectTypeEnum.whatsapp):
        if (banner.redirect?.isNotEmpty == true) {
          final phone = banner.redirect!.replaceAll(RegExp(r'[^0-9]'), '');
          final url =
              phone.isNotEmpty ? 'https://wa.me/$phone' : banner.redirect!;
          UrlLauncherNative.openUrl(url);
        }
        break;
      case (BannerRedirectTypeEnum.feature):
        widget.onBannerClick(banner);
        break;
      default:
        break;
    }
  }
}
