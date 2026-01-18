import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lib_base/enum/page_state.dart';
import 'package:lib_base/getx/state/base_state.dart';
import 'package:get/get.dart';

class OnboardingItem {
  final String image;
  final String title;
  final String description;

  OnboardingItem({
    required this.image,
    required this.title,
    required this.description,
  });
}

class OnboardingState extends BaseState {
  final List<OnboardingItem> items = [
    OnboardingItem(
      image: 'onboardig_1.webp',
      title: 'Take hold of your finances',
      description:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut eget mauris massa pharetra.',
    ),
    OnboardingItem(
      image: 'onboardig_2.webp',
      title: 'Smart trading tools',
      description:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut eget mauris massa pharetra.',
    ),
    OnboardingItem(
      image: 'onboardig_3.webp',
      title: 'Invest in the future',
      description:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut eget mauris massa pharetra.',
    ),
  ];

  OnboardingState() {
    isNeedScaffold = true;
    isShowAppBar = false;
    safeAreaTop = true;
    safeAreaBottom = true;
    navBackgroundColor = Colors.transparent;
  }

  @override
  void release() {
    // Release resources if any
  }
}
