import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:morar/feature/me/domain/entity/condominium.dart';
import 'package:morar/feature/home/domain/entity/unity.dart';
import 'package:morar/feature/session/presentation/bloc/session_state.dart';

/// Fullscreen overlay for selecting a condominium unit.
/// Displays a header with close chevron, optional search field,
/// and a scrollable list of units with radio-style selection.
class UnitSelectionOverlay extends StatefulWidget {
  final List<List<dynamic>> units;
  final SessionState sessionState;
  final void Function(Condominium condominium, Unity unity) onUnitSelected;
  final VoidCallback onClose;

  const UnitSelectionOverlay({
    Key? key,
    required this.units,
    required this.sessionState,
    required this.onUnitSelected,
    required this.onClose,
  }) : super(key: key);

  @override
  State<UnitSelectionOverlay> createState() => _UnitSelectionOverlayState();
}

class _UnitSelectionOverlayState extends State<UnitSelectionOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  final TextEditingController _searchController = TextEditingController();
  String _filter = '';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _close() {
    widget.onClose();
  }

  List<List<dynamic>> get _filteredUnits {
    if (_filter.isEmpty) return widget.units;
    final query = _filter.toLowerCase();
    return widget.units.where((unit) {
      final condo = unit[0] as Condominium;
      final unity = unit[1] as Unity;
      final condoName = condo.name?.toLowerCase() ?? '';
      final unityTitle = unity.namedTitle.toLowerCase();
      final address = condo.address?.toLowerCase() ?? '';
      final reference = condo.reference?.toLowerCase() ?? '';
      return condoName.contains(query) ||
          unityTitle.contains(query) ||
          address.contains(query) ||
          reference.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pallete = LelloTheme.palleteOf(theme);
    final condoName = widget.sessionState.session?.condominium?.name ?? '';
    final unityTitle = widget.sessionState.session?.unity?.namedTitle ?? '';

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Material(
          color: pallete.appBarHome(),
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                // ── Header row (mirrors HomeAppBar, chevron points UP) ──
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: GestureDetector(
                    onTap: _close,
                    behavior: HitTestBehavior.opaque,
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/condo-icon.svg',
                          width: 24,
                          height: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Row(
                            children: [
                              Flexible(
                                child: Text(
                                  condoName,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style:
                                      LelloTextStyles.body(theme)?.copyWith(
                                    color: pallete.customColor(),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              if (unityTitle.isNotEmpty)
                                Text(
                                  ' - $unityTitle',
                                  style:
                                      LelloTextStyles.body(theme)?.copyWith(
                                    color: pallete.customColor(),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.keyboard_arrow_up_rounded,
                          color: pallete.customColor(),
                          size: 24,
                        ),
                      ],
                    ),
                  ),
                ),

                // ── Search field (hidden when only one unit) ──
                if (widget.units.length > 1)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: pallete.background(),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) => setState(() => _filter = value),
                        style: LelloTextStyles.subtitle(theme),
                        decoration: InputDecoration(
                          hintText: getString(context, "search_unit"),
                          hintStyle: LelloTextStyles.subtitle(theme)?.copyWith(
                            color: pallete.textOpaque(),
                          ),
                          suffixIcon: Icon(
                            Icons.search,
                            color: pallete.textOpaque(),
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                  ),

                const SizedBox(height: 8),

                // ── Unit list ──
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredUnits.length,
                    separatorBuilder: (_, __) => Divider(
                      color: pallete.customColor().withValues(alpha: 0.15),
                      height: 1,
                    ),
                    itemBuilder: (context, index) {
                      final unit = _filteredUnits[index];
                      final condo = unit[0] as Condominium;
                      final unity = unit[1] as Unity;
                      final isSelected =
                          widget.sessionState.session?.condominium?.name ==
                                  condo.name &&
                              widget.sessionState.session?.unity?.title ==
                                  unity.title;

                      return _buildUnitTile(
                        context,
                        condo,
                        unity,
                        isSelected,
                        theme,
                        pallete,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUnitTile(
    BuildContext context,
    Condominium condo,
    Unity unity,
    bool isSelected,
    ThemeData theme,
    ColorPallete pallete,
  ) {
    return InkWell(
      onTap: () {
        // Close overlay first, THEN trigger selection
        _close();
        widget.onUnitSelected(condo, unity);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            // Unit info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          condo.name?.toUpperCase() ?? '',
                          overflow: TextOverflow.ellipsis,
                          style: LelloTextStyles.bodyBold(theme)?.copyWith(
                            color: pallete.customColor(),
                          ),
                        ),
                      ),
                      if (unity.namedTitle.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: Text(
                            unity.namedTitle.toUpperCase(),
                            style: LelloTextStyles.bodyBold(theme)?.copyWith(
                              color: pallete.customColor(),
                            ),
                          ),
                        ),
                    ],
                  ),
                  if (condo.address != null && condo.address!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      condo.address!.toUpperCase(),
                      style: LelloTextStyles.body(theme)?.copyWith(
                        color: pallete.customColor().withValues(alpha: 0.87),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(width: 16),

            // Radio indicator
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: pallete.customColor(),
                  width: 2,
                ),
                color: isSelected ? pallete.customColor() : Colors.transparent,
              ),
              child: isSelected
                  ? Icon(
                      Icons.check,
                      color: pallete.appBarHome(),
                      size: 16,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
