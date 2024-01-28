import 'package:flutter/material.dart';
import 'package:saig_app/domain/enums/upload_status.dart';


class UploadButton extends StatelessWidget {
  
  UploadButton({
    Key? key,
    required this.uploadStatus,
    required this.onPending,
    this.transitionDuration = const Duration(milliseconds: 500),
  }) : super(key: key);

  final UploadStatus uploadStatus;
  final Duration transitionDuration;
  final VoidCallback onPending;

  // bool get _isPending => uploadStatus == UploadStatus.pending;
  bool get _isUploading => uploadStatus == UploadStatus.uploading;
  // bool get _isError => uploadStatus == UploadStatus.error;
  // bool get _isDone => uploadStatus == UploadStatus.done;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      _buildUploadingProgress(),
      AnimatedContainer(
        duration: const Duration(milliseconds: 2000),
        curve: Curves.ease,
        width: double.infinity,
        child: _buildIconButton(),
      ),
    ]);
  }

  Widget _buildIconButton() {
    switch (uploadStatus) {
      case UploadStatus.pending:
        return IconButton(
          onPressed: onPending,
          icon: const Icon(Icons.upload)
        );
      case UploadStatus.uploading:
        return Container();
      case UploadStatus.done:
        return const IconButton(onPressed: null, icon: Icon(Icons.done, color: Colors.green));
      case UploadStatus.error:
        return IconButton(
          onPressed: onPending,
          icon: const Icon(Icons.replay)
        );
      case UploadStatus.archived:
        return IconButton(
          onPressed: onPending,
          icon: const Icon(Icons.done),
        );
    }
  }

  _buildUploadingProgress() {
    return Positioned.fill(
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 1000),
        opacity: _isUploading ? 1.0 : 0.0,
        curve: Curves.ease,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CircularProgressIndicator(
              backgroundColor: Colors.white.withOpacity(0.0),
              valueColor: const AlwaysStoppedAnimation(Colors.lightBlue),
              strokeWidth: 2.0,
              value: null,
            ),
          ],
        ),
      ),
    );
  }
}
