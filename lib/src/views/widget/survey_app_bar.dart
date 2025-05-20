import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survey_kit/survey_kit.dart';

class SurveyAppBar extends StatefulWidget {
  const SurveyAppBar({
    super.key,
    required this.appBarConfiguration,
    this.controller,
  });
  final AppBarConfiguration appBarConfiguration;
  final SurveyController? controller;

  @override
  State<SurveyAppBar> createState() => _SurveyAppBarState();
}

class _SurveyAppBarState extends State<SurveyAppBar> {
  @override
  AppBar build(BuildContext context) {
    final appBarConfiguration = widget.appBarConfiguration;

    final _showProgress =
        appBarConfiguration.showProgress ?? context.read<bool>();

    final surveyController =
        widget.controller ?? context.read<SurveyController>();

    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: appBarConfiguration.leading != null &&
              appBarConfiguration.canGoBackWithLeading == true
          ? BlocBuilder<SurveyPresenter, SurveyState>(
              builder: (context, state) {
                if (state is PresentingSurveyState &&
                    state.currentStepIndex > 0) {
                  return widget.appBarConfiguration.leading ??
                      BackButton(
                        onPressed: () {
                          surveyController.stepBack(
                            context: context,
                          );
                        },
                      );
                } else {
                  return const SizedBox.shrink();
                }
              },
            )
          : null,
      title: _showProgress ? const SurveyProgress() : const SizedBox.shrink(),
    );
  }
}
