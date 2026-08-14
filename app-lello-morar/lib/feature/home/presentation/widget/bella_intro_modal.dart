import 'package:essentials/ui/dimens.dart';
import 'package:essentials/ui/widget/button/inverted_primary_button.dart';
import 'package:essentials/ui/widget/text/lello_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:essentials/ui/app_theme.dart';
import 'package:essentials/essentials.dart' hide Image;
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/feature/ia_bella/domain/entity/bella_message_entity.dart';
import 'package:morar/feature/ia_bella/presentation/widgets/bella_header_widget.dart';

class BellaIntroModal extends StatelessWidget {
  final VoidCallback onClose;

  const BellaIntroModal({Key? key, required this.onClose}) : super(key: key);

  static const String _bellaModalKey = 'bella_intro_modal_shown';

  static Future<bool> shouldShow() async {
    final prefs = await SharedPreferences.getInstance();
    return !(prefs.getBool(_bellaModalKey) ?? false);
  }

  static Future<void> setShown() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_bellaModalKey, true);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iaName = FlavorConfig.config.iaName;
    return WillPopScope(
      onWillPop: () async {
        await setShown();
        onClose();
        return true;
      },
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const BellaHeaderWidget(width: 225, height: 130),
              const SizedBox(height: 16),
              Text(
                getStringWithParams(
                  context,
                  'bella_intro_title',
                  [iaName],
                ),
                textAlign: TextAlign.center,
                style: LelloTextStyles.titleBold(theme)!,
              ),
              const SizedBox(height: 8),
              Text(
                getString(context, 'bella_intro_subtitle'),
                textAlign: TextAlign.center,
                style: LelloTextStyles.body(theme),
              ),
              SizedBox(height: Dimens.spacingMedium),
              _BellaIntroContent(onAnyNavigate: () async {
                await setShown();
                onClose();
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                }
              }),
              SizedBox(height: Dimens.spacingMedium),
              Text(
                getStringWithParams(
                  context,
                  'bella_intro_warning',
                  [iaName],
                ),
                style: LelloTextStyles.bodyBold(theme)!.copyWith(
                  color: theme.primaryColor,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: Dimens.spacingMedium),
              InvertedPrimaryButton(
                onPressed: () async {
                  await setShown();
                  onClose();
                  Navigator.of(context).pop();
                },
                child: Text(getString(context, 'close')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BellaIntroContent extends StatefulWidget {
  final Future<void> Function()? onAnyNavigate;
  const _BellaIntroContent({Key? key, this.onAnyNavigate}) : super(key: key);
  @override
  State<_BellaIntroContent> createState() => _BellaIntroContentState();
}

class _BellaIntroContentState extends State<_BellaIntroContent> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, String>> get _options => [
        {
          'title': getString(context, 'bills'),
          'subtitle': getString(context, 'bills_subtitle')
        },
        {
          'title': getString(context, 'area_reservation'),
          'subtitle': getString(context, 'area_reservation_subtitle')
        },
        {
          'title': getString(context, 'next_assembly'),
          'subtitle': getString(context, 'next_assembly_subtitle')
        },
      ];

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _openBellaWithText(String text) async {
    if (text.trim().isEmpty) return;
    if (widget.onAnyNavigate != null) await widget.onAnyNavigate!();
    Navigator.pushNamed(
      context,
      ApplicationRoute.iaBella,
      arguments: BellaMessageEntity(text: text, isUser: true),
    );
    _searchController.clear();
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iaName = FlavorConfig.config.iaName;
    return Column(
      children: [
        Row(
          children: [
            if (_isFocused)
              IconButton(
                icon: Icon(Icons.arrow_back,
                    color: LelloTheme.palleteOf(theme).primary()),
                onPressed: () {
                  _focusNode.unfocus();
                },
              ),
            Expanded(
              child: TextField(
                controller: _searchController,
                focusNode: _focusNode,
                decoration: InputDecoration(
                  hintText: getStringWithParams(
                    context,
                    'bella_search_placeholder',
                    [iaName],
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                ),
                onSubmitted: _openBellaWithText,
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 20,
              backgroundColor: LelloTheme.palleteOf(theme).primary(),
              child: IconButton(
                icon: const Icon(Icons.search, color: Colors.white, size: 20),
                onPressed: () {
                  _openBellaWithText(_searchController.text);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 160,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _options.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              return Container(
                width: 150,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: theme.primaryColor),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '"${_options[index]['title']}"',
                      style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.primaryColor),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _options[index]['subtitle']!,
                      style: theme.textTheme.bodySmall,
                    ),
                    const Spacer(),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: CircleAvatar(
                        radius: 15,
                        backgroundColor: LelloTheme.palleteOf(theme).primary(),
                        child: IconButton(
                          icon: const Icon(Icons.search,
                              color: Colors.white, size: 15),
                          onPressed: () {
                            _openBellaWithText(_options[index]['title']!);
                          },
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
