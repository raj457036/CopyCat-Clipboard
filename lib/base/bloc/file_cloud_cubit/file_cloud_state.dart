part of 'file_cloud_cubit.dart';

@freezed
class FileCloudState with _$FileCloudState {
  const factory FileCloudState.initial() = FileCloudInitial;
  const factory FileCloudState.downloading(ClipboardItem item) =
      FileCloudDownloading;
  const factory FileCloudState.downloaded(ClipboardItem item) =
      FileCloudDownloaded;
  const factory FileCloudState.error(Failure failure, ClipboardItem item) =
      FileCloudError;
}
