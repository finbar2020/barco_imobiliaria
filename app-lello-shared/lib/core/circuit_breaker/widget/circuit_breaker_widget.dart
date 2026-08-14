import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:shared_features/core/circuit_breaker/controller/circuit_breaker_controller.dart';
import 'package:shared_features/core/circuit_breaker/enum/circuit_breaker_situation_enum.dart';
import 'package:shared_features/core/circuit_breaker/models/circuit_item_rule.dart';
import 'package:shared_features/core/circuit_breaker/widget/circuit_breaker_modal_disable_messager.dart';
import 'package:shared_features/shared_features.dart';

class CircuitBreakerWidget extends StatelessWidget {
  final Widget child;
  final String applicationRbac;
  final String? reference;
  final SharedApplicationContainer appContainer;
  final bool rbacEnabled;

  CircuitBreakerWidget({
    Key? key,
    required this.child,
    required this.applicationRbac,
    required this.reference,
    required this.appContainer,
    required this.rbacEnabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (rbacEnabled == false) return Container();
    CircuitBreakerController controller = appContainer.resolve();

    return StreamBuilder<List<CircuitItemRule>>(
      stream: controller.ruleStream.stream,
      builder: (context, snapshot) {
        //if (snapshot.hasData) {
        var rule = controller.getRule(
            applicationRbac: applicationRbac, reference: reference);
        var hide = (rule != null &&
            rule.situation == CircuitBreakerSituationEnum.hide);
        var disable = rule != null &&
            rule.situation == CircuitBreakerSituationEnum.disabled;

        if (hide) return Container();
        if (disable == false) return child;

        return InkWell(
          onTap: () {
            // Log analytics event when user tries to interact with disabled widget
            FirebaseAnalytics.instance
                .logEvent(name: "circuit_breaker_disabled", parameters: {
              'application_rbac': applicationRbac,
              if (reference != null) 'reference': reference!,
              if (rule?.disabledMessage != null)
                'disabled_message': rule!.disabledMessage!,
            });

            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return CircuitBreakerModalDisableMessager(
                  title: null,
                  message: rule?.disabledMessage,
                );
              },
            );
          },
          child: IgnorePointer(
            ignoring: true,
            child: Opacity(
              opacity: 0.5,
              child: child,
            ),
          ),
        );
      },
    );
  }
}
