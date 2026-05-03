import 'package:clipboard/base/constants/strings/strings.dart';
import 'package:clipboard/base/domain/services/in_app_review_service.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: InAppReviewService)
class InAppReviewServiceImpl implements InAppReviewService {
  final InAppReview _inAppReview = InAppReview.instance;

  @override
  Future<bool> isAvailable() => _inAppReview.isAvailable();

  @override
  Future<void> requestReview() => _inAppReview.requestReview();

  @override
  Future<void> openStoreListing() => _inAppReview.openStoreListing(
    appStoreId: iosAppStoreId,
    microsoftStoreId: microsoftStoreId == '' ? null : microsoftStoreId,
  );
}
