import 'package:flutter/material.dart';
import 'package:saig_app/src/widgets/menu_widget.dart';
import 'package:saig_app/src/widgets/upload_button.dart';

class UploadMultiplePage extends StatefulWidget {
  
  @override
  _UploadMultiplePageState createState() => _UploadMultiplePageState();
}

class _UploadMultiplePageState extends State<UploadMultiplePage> {
  
  late final UploadController _uploadController;
  
  @override
  void initState() { 
    super.initState();
    _uploadController = new SimulatedUploadController();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carga de imagen y coordenadas'),
      ),
      drawer: MenuWidget(),
      body: ListView.separated(
        itemBuilder: (context, index) => _buildListItem(context, index), 
        separatorBuilder: (context, index) => Divider(), 
        itemCount: 1
      )
    );
  }
  
  _buildListItem(BuildContext context, int index) {

    return ListTile(
      leading: CircleAvatar(),
      title: Text('Imagen #$index'),
      subtitle: Text('Info acerca de la imagen $index'),
      trailing: SizedBox(
        width: 96.0,
        child: AnimatedBuilder(
          animation: _uploadController,
          builder: (BuildContext context, Widget? child) {
            return UploadButton(
              uploadStatus: _uploadController.uploadStatus,
              onUpload: _uploadController.startUpload,
            );
          },
        ),
      ),
    );
  }

}


abstract class UploadController implements ChangeNotifier {
  
  UploadStatus get uploadStatus;
  double get progress;

  void startUpload();
  void stopUpload();
  void openUpload();

}


class SimulatedUploadController extends UploadController with ChangeNotifier {
  

  SimulatedUploadController({
    UploadStatus uploadStatus = UploadStatus.pending,
    double progress = 0.0
  }): _uploadStatus = uploadStatus,
      _progress = progress;


  UploadStatus _uploadStatus;
  @override
  UploadStatus get uploadStatus => _uploadStatus;

  double _progress;
  @override
  double get progress => _progress;



  @override
  void openUpload() {
    // TODO: implement openUpload
  }



  @override
  void startUpload() async {
    if( uploadStatus == UploadStatus.pending ) {

      _uploadStatus = UploadStatus.uploading;
      notifyListeners();

      await Future<void>.delayed(const Duration(seconds: 2));
      _uploadStatus = UploadStatus.done;
      notifyListeners();
    }
  }



  @override
  void stopUpload() {
    // TODO: implement stopUpload
  }


  

  
}
