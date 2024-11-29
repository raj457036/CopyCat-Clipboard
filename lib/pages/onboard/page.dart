import 'package:clipboard/di/di.dart';
import 'package:clipboard/pages/onboard/widgets/encryption.dart';
import 'package:clipboard/pages/onboard/widgets/syncing/syncing_clips.dart';
import 'package:clipboard/pages/onboard/widgets/syncing/syncing_collection.dart';
import 'package:clipboard/pages/onboard/widgets/welcome.dart';
import 'package:copycat_base/bloc/drive_setup_cubit/drive_setup_cubit.dart';
import 'package:copycat_base/bloc/offline_persistance_cubit/offline_persistance_cubit.dart';
import 'package:copycat_base/constants/strings/route_constants.dart';
import 'package:copycat_base/constants/widget_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class OnBoardPage extends StatefulWidget {
  const OnBoardPage({super.key});

  @override
  State<OnBoardPage> createState() => _OnBoardPageState();
}

class _OnBoardPageState extends State<OnBoardPage> {
  int page = 0;

  void gotToPage(int page) {
    setState(() {
      this.page = page;
    });
  }

  void goHome() {
    context.read<DriveSetupCubit>().fetch();
    context.read<OfflinePersistenceCubit>().startListners();
    context.goNamed(RouteConstants.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(padding16),
        child: switch (page) {
          0 => WelcomeStep(
              onContinue: () => gotToPage(1),
            ),
          1 => EncryptionStep(
              onContinue: () => gotToPage(2),
            ),
          2 => SyncingCollectionStep(
              onContinue: () => gotToPage(3),
              collectionRepository: sl(),
            ),
          3 => SyncingClipsStep(
              onContinue: goHome,
              clipboardRepository: sl(
                instanceName: "cloud",
              ),
            ),
          _ => SizedBox.shrink(),
        },
      ),
    );
  }
}
