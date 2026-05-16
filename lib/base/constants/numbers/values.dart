import 'package:clipboard/base/constants/numbers/duration.dart';

const kMaxDropItemCount = 5;

// Configs

/// Default no. of devices allowed to be synced at a time
const defaultNoOfSyncedDevices = 3;

/// Default no. of collections allowed to be active at a time
const defaultCollectionCount = 3;

/// Default number of items allowed in an active paste stack
const defaultPasteStackLimit = 10;

/// Default sync items within the last [defaultSyncHourOffset] hours
const defaultSyncHourOffset = 24;

/// Default maximum number of items per collection
const defaultMaxItemPerCollection = 50;

const defaultBestEffortSyncInterval = 15 * $60S; // 15 mins
