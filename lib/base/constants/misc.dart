import 'package:super_clipboard/super_clipboard.dart';

const avif = SimpleFileFormat(
  uniformTypeIdentifiers: ['public.avif'],
  windowsFormats: ['AVIF'],
  mimeTypes: ['image/avif'],
);

const svg = SimpleFileFormat(
  uniformTypeIdentifiers: ['public.svg-image'],
  mimeTypes: [
    'public.svg-image',
    "image/svg+xml",
    "image/svg",
  ],
);

const allSupportedClipFormats = [
  ...Formats.standardFormats,
  avif,
  svg,
];
