import 'package:essentials/essentials.dart';
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:morar/feature/reservation/presentation/page/reservation_deleted_page.dart';
import 'package:morar/feature/reservation/presentation/page/reservation_page.dart';

import '../../../../core/dependency/application_container.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../domain/entity/reservation_scheduled.dart';
import '../bloc/reservation_bloc.dart';
import '../bloc/reservation_state.dart';
import '../widget/reservation_schedule_card_widget.dart';

class ReservationSchedulesPage extends StatelessWidget {
  final ReservationPageArgs? arguments;
  const ReservationSchedulesPage({
    Key? key,
    required this.arguments,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Environment env = ApplicationContainer.instance().resolve<Environment>();
    final ReservationBloc bloc = BlocProvider.of(context);

    return BlocConsumer<ReservationBloc, ReservationState>(
      listener: (context, state) {
        if (state is ReservationDeletedState) {
          bloc.getSpaces();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReservationDeletedPage(),
            ),
          );
        }
      },
      bloc: bloc,
      builder: (context, state) {
        if (state is ReservationEmptyState) {
          return Column(
            children: [
              Expanded(
                child: Center(child: CircularProgressIndicator()),
              ),
            ],
          );
        }
        if (state is LoadingSpaceState) {
          return Column(
            children: [
              Expanded(
                child: LoadingWidget(),
              ),
            ],
          );
        }
        if (state is FailureSpaceState) {
          return Column(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(Dimens.spacingMedium),
                  child: ErrorHandlingWidget(
                    reTryFunction: () {
                      bloc.getSpaces();
                    },
                    backFunction: () => Navigator.pop(context, true),
                    isProduction: env.isProduction,
                    error: "",
                    errorCode: "",
                  ),
                ),
              ),
            ],
          );
        }
        if (state is LoadedSpaceState ||
            state is LoadingCalendarState ||
            state is LoadedCalendarState ||
            state is FailureCalendarState ||
            state is LoadingDialogState ||
            state is LoadedDialogState ||
            state is FailureDialogState) {
          if (arguments?.reserveNotificationContext != null) {
            var reserve = state.reservations!
                .cast<ReservationScheduled?>()
                .firstWhere(
                    (element) =>
                        // element?.notificationParameter ==
                        //     agreementsNotificationContext ||
                        element?.id.toString() ==
                        arguments?.reserveNotificationContext,
                    orElse: () => null);
            if (reserve != null) {
              reserve.highlight = true;
            }
            arguments?.reserveNotificationContext = null;
          }
          return state.reservations!.isNotEmpty
              ? SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SubtitleWidget(),
                      Divider(),
                      Padding(
                        padding: EdgeInsets.all(Dimens.spacing),
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: state.reservations!.length,
                          itemBuilder: (context, index) {
                            return ReservationSchudeleCardWidget(
                              model: state.reservations![index],
                              bloc: bloc,
                              cancelReservation: () {
                                bloc.deleteReservation(
                                  state.reservations![index].id.toString(),
                                  state.reservations![index].reservationType
                                      .toString(),
                                  context,
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                )
              : state.spaces.isEmpty
                  ? Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset("assets/ic_billet_alert.svg"),
                          SizedBox(height: Dimens.spacing),
                          Text(
                            getString(context, "reserves_condominium_error"),
                            style: TextStyle(
                                color: LelloTheme.palleteOf(theme).text()),
                          ),
                        ],
                      ),
                    )
                  : Center(
                      child: Text(
                        getString(context, "reserves_dont_booked"),
                        style: TextStyle(
                            color: LelloTheme.palleteOf(theme).text()),
                      ),
                    );
        }
        return Container();
      },
    );
  }
}

class SubtitleWidget extends StatelessWidget {
  const SubtitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(
        top: Dimens.spacingLarge,
        left: Dimens.spacingMedium,
        right: Dimens.spacingMedium,
        bottom: Dimens.spacing,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Legenda:",
            style: LelloTextStyles.subtitleBold(theme),
          ),
          SizedBox(width: Dimens.spacingLarge),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Row(
                    children: [
                      Container(
                        height: 10.0,
                        width: 10.0,
                        decoration: BoxDecoration(
                          color: Color(0xFF219653),
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: Dimens.spacingSmall),
                      Text("Reservado")
                    ],
                  ),
                  SizedBox(width: Dimens.spacingMedium),
                  Row(
                    children: [
                      Container(
                        height: 10.0,
                        width: 10.0,
                        decoration: BoxDecoration(
                          color: Color(0xFFF22200),
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: Dimens.spacingSmall),
                      Text("Cancelado")
                    ],
                  ),
                ],
              ),
              SizedBox(height: Dimens.spacing),
              Row(
                children: [
                  Container(
                    height: 10.0,
                    width: 10.0,
                    decoration: BoxDecoration(
                      color: LelloTheme.palleteOf(theme).warning(),
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: Dimens.spacingSmall),
                  Text("Aguardando Pagamento")
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
