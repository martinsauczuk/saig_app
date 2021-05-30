import 'package:flutter/material.dart';


///
/// Estado de subida
///
enum UploadStatus{
  pending,
  uploading,
  error,
  done,
}


class UploadButton extends StatelessWidget {
  
  UploadButton({
    Key? key,
    required this.uploadStatus,
    required this.onUpload,
    this.transitionDuration = const Duration(milliseconds: 500),
  }) : super(key: key);

  final UploadStatus uploadStatus;
  final Duration transitionDuration;
  final VoidCallback onUpload;

  bool get _isUploading => uploadStatus == UploadStatus.uploading;

  bool get _isDone => uploadStatus == UploadStatus.done;

  @override
  Widget build(BuildContext context) {
    
    return IconButton(
      onPressed: onUpload,
      icon: _buildIcon(),
    );
     
  }

  Widget _buildIcon() {
    switch (uploadStatus) {
      case UploadStatus.pending:
        return Icon(Icons.pending);
      case UploadStatus.uploading:
        return Icon(Icons.arrow_circle_up_outlined);
      case UploadStatus.done:
        return Icon(Icons.done);
      case UploadStatus.error:
        return Icon(Icons.error);
    }
  }
}
  ///
  // Widget _buildButtonShape({
  //   required Widget child,
  // }) {
  //   return AnimatedContainer(
  //     duration: widget.transitionDuration,
  //     curve: Curves.ease,
  //     width: double.infinity,
  //     decoration: ShapeDecoration(
  //       shape: const CircleBorder(),
  //       color: Colors.lightBlueAccent,
  //     ),
  //     child: child,
  //   );
  // }


//   _buildUploadingProgress() {
    
//     return Positioned.fill(
//      child: AnimatedOpacity(
//        duration: widget.transitionDuration,
//        opacity: 1.0,
//       //  opacity: _isDownloading || _isFetching ? 1.0 : 0.0,
//        curve: Curves.ease,
//        child: Stack(
//          alignment: Alignment.center,
//          children: [
//             _buildProgressIndicator(),
//             const Icon(
//                Icons.stop,
//                size: 14.0,
//                color: Colors.lightBlueAccent,
//              ),
//          ],
//        ),
//      ),
//     );
//   }


//   Widget _buildProgressIndicator() {
//    return AspectRatio(
//      aspectRatio: 1.0,
//      child: CircularProgressIndicator(
//        backgroundColor: Colors.white.withOpacity(0.0),
//        valueColor: AlwaysStoppedAnimation(
//          Colors.lightBlue
//        ),
//        strokeWidth: 2.0,
//        value: null,
//      ),
//    );
//  }