import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/widget/hex_color.dart';

class ReservationChangeReservedPage extends StatefulWidget {
  const ReservationChangeReservedPage({Key? key}) : super(key: key);

  @override
  _ReservationChangeReservedPageState createState() =>
      _ReservationChangeReservedPageState();
}

class _ReservationChangeReservedPageState
    extends State<ReservationChangeReservedPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        appBar: PrimaryAppBar(
          theme: theme,
          title: getString(context, "space_change_scheduled"),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Container(
            height: 54.0,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0, backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: HexColor("#606062")),
                ),
              ),
              child: Text(
                "VTeste",
                style: LelloTextStyles.button(theme)!
                    .copyWith(color: Colors.black),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMonthYear(theme),
                SizedBox(height: Dimens.spacingSmall),
                Text(
                  "Dia 16, Sexta-Feira",
                  style: LelloTextStyles.body(theme)!
                      .copyWith(color: HexColor("#494949")),
                ),
                SizedBox(height: Dimens.spacingLarge),
                Row(
                  children: [
                    Container(
                      height: 22.0,
                      width: 22.0,
                      decoration: BoxDecoration(
                        color: HexColor("#CB2640"),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: Dimens.spacing),
                    Text(
                      "Reserva",
                      style: LelloTextStyles.bodyBold(theme),
                    ),
                  ],
                ),
                SizedBox(height: Dimens.spacingLarge),
                _buildColumnInfo("Unidade", "12A", theme),
                SizedBox(height: Dimens.spacing),
                _buildColumnInfo("Horário de inicio", "14:00", theme),
                SizedBox(height: Dimens.spacing),
                _buildColumnInfo("Horário de término", "15:00", theme),
                SizedBox(height: Dimens.spacing),
                Container(
                  height: 36.0,
                  width: 145.0,
                  child: PrimaryButton(
                    text: getString(context, "cancel"),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column _buildColumnInfo(
    String title,
    String subtitle,
    ThemeData theme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: LelloTextStyles.caption(theme)!
              .copyWith(fontWeight: FontWeight.w700),
        ),
        SizedBox(height: Dimens.spacingXSmall),
        Text(
          subtitle,
          style: LelloTextStyles.caption(theme),
        ),
      ],
    );
  }

  Row _buildMonthYear(ThemeData theme) {
    return Row(
      children: [
        Text(
          "Mês - ",
          style: LelloTextStyles.title(theme),
        ),
        Text(
          "Ano",
          style: LelloTextStyles.title(theme),
        ),
      ],
    );
  }
}
