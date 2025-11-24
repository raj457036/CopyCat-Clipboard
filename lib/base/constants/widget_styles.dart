import 'package:flutter/widgets.dart';

// Padding
const padding2 = 2.0;
const padding4 = 4.0;
const padding6 = 6.0;
const padding8 = 8.0;
const padding10 = 10.0;
const padding12 = 12.0;
const padding14 = 14.0;
const padding16 = 16.0;
const padding20 = 20.0;
const padding28 = 28.0;
const padding38 = 38.0;

// Widths
const width2 = SizedBox(width: 2);
const width4 = SizedBox(width: 4);
const width6 = SizedBox(width: 6);
const width8 = SizedBox(width: 8);
const width10 = SizedBox(width: 10);
const width12 = SizedBox(width: 12);
const width14 = SizedBox(width: 14);
const width16 = SizedBox(width: 16);

// Heights
const height2 = SizedBox(height: 2);
const height4 = SizedBox(height: 4);
const height5 = SizedBox(height: 5);
const height6 = SizedBox(height: 6);
const height8 = SizedBox(height: 8);
const height10 = SizedBox(height: 10);
const height12 = SizedBox(height: 12);
const height16 = SizedBox(height: 16);
const height20 = SizedBox(height: 20);
const height24 = SizedBox(height: 24);
const height32 = SizedBox(height: 32);
const height54 = SizedBox(height: 54);

// radius
const radius8 = BorderRadius.all(
  Radius.circular(8),
);
const radius12 = BorderRadius.all(
  Radius.circular(12),
);
const radius16 = BorderRadius.all(
  Radius.circular(16),
);
const radius26 = BorderRadius.all(
  Radius.circular(26),
);
const circleRadius12 = Radius.circular(12);

const radiusBottom12 = BorderRadius.vertical(
  bottom: Radius.circular(12),
);
const radiusBottom8 = BorderRadius.vertical(
  bottom: Radius.circular(8),
);

// edge insets

const insetTB8 = EdgeInsets.only(
  top: padding8,
  bottom: padding8,
);

const inset12 = EdgeInsets.all(padding12);

const insetTRB16 = EdgeInsets.only(
  top: padding12,
  right: padding8,
  bottom: padding16,
);

const insetAll16 = EdgeInsets.all(padding16);

const initialWindowWidth = 1280.0;
const initialWindowHeight = 720.0;
const dockedLRMaxWidth = 330.0;
const dockedLRMinWidth = 200.0;
const dockedTBMaxHeight = 330.0;
const dockedTBMinHeight = 200.0;

const initialWindowSize = Size(initialWindowWidth, initialWindowHeight);
const minimumWindowSize = Size(dockedLRMinWidth, dockedTBMinHeight);
