import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saig_app/domain/domain.dart';
import 'package:saig_app/presentation/providers/uploads/upload_items_provider.dart';

enum UploadsFilter {
  all,
  pending,
  completed,
  error,
}

final uploadsFilterProvider = StateProvider<UploadsFilter>((ref){
  return UploadsFilter.pending;
});


final uploadsPendingCountProvider = Provider<int>((ref) {
  final items = ref.watch(uploadItemsProvider);

  return items
    .where((item) => item.status == UploadStatus.pending || item.status == UploadStatus.uploading )
    .toList().length;

});

final uploadsCompletedCountProvider = Provider<int>((ref) {
  final items = ref.watch(uploadItemsProvider);

  return items
    .where((item) => item.status == UploadStatus.done )
    .toList().length;

});

final uploadsErrorCountProvider = Provider<int>((ref) {
  final items = ref.watch(uploadItemsProvider);

  return items
    .where((item) => item.status == UploadStatus.error )
    .toList().length;

});


final filteredItemsProvider = Provider<List<UploadItem>>((ref) {
  
  final selectedFilter = ref.watch(uploadsFilterProvider);
  final uploadItems = ref.watch(uploadItemsProvider);

  switch (selectedFilter) {
    case UploadsFilter.all:
      return uploadItems;
    case UploadsFilter.pending:
      return uploadItems.where((item) => item.status == UploadStatus.pending || item.status == UploadStatus.uploading ).toList();
    case UploadsFilter.completed:
      return uploadItems.where((item) => item.status == UploadStatus.done ).toList();
    case UploadsFilter.error:
      return uploadItems.where((item) => item.status == UploadStatus.error ).toList();
  }

});