import 'package:essentials/ui/app_theme.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/feature/ia_bella/domain/entity/bella_message_entity.dart';

class BellaSearchComponent extends StatefulWidget {
  const BellaSearchComponent({Key? key}) : super(key: key);

  @override
  State<BellaSearchComponent> createState() => _BellaSearchComponentState();
}

class _BellaSearchComponentState extends State<BellaSearchComponent> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;
  final iaName = FlavorConfig.config.iaName;
  final TextEditingController _searchController = TextEditingController();

  List<String> get _chips => [
        getString(context, 'second_bill_copy'),
        getString(context, 'last_assembly_chip'),
        getString(context, 'condominium_rules'),
      ];

  List<String> get _chipPrompts => [
        getString(context, 'second_bill_copy'),
        getString(context, 'last_assembly_prompt'),
        getString(context, 'condominium_rules'),
      ];

  List<String?> get _chipDisplayTexts => [
        null,
        getString(context, 'last_assembly'),
        null,
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

  void _openBellaWithText(String text, {String? displayText}) {
    if (text.trim().isEmpty) return;
    Navigator.pushNamed(
      context,
      ApplicationRoute.iaBella,
      arguments: BellaMessageEntity(
        text: text,
        displayText: displayText,
        isUser: true,
      ),
    );
    _searchController.clear();
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
          child: Row(
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
                    hintText: getStringWithParams(context, 'bella_search_placeholder', [iaName]),
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
                  onChanged: (value) {
                    // lógica de busca
                  },
                  onSubmitted: (value) {
                    _openBellaWithText(value);
                  },
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
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _chips.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                return ActionChip(
                    backgroundColor: Colors.grey.shade100,
                    label: Row(
                      children: [
                        Text(_chips[index],
                            style: TextStyle(
                                color: LelloTheme.palleteOf(theme).primary())),
                        const SizedBox(width: 4),
                        Icon(Icons.search,
                            size: 18,
                            color: LelloTheme.palleteOf(theme).primary()),
                      ],
                    ),
                    onPressed: () {
                      _openBellaWithText(
                        _chipPrompts[index],
                        displayText: _chipDisplayTexts[index],
                      );
                    });
              },
            ),
          ),
        ),
      ],
    );
  }
}
