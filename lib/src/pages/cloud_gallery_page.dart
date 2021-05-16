import 'package:flutter/material.dart';
import 'package:saig_app/src/models/search_response.dart';
import 'package:saig_app/src/providers/upload_provider.dart';
import 'package:saig_app/src/widgets/menu_widget.dart';

class CloudGalleryPage extends StatefulWidget {
  
  @override
  _CloudGalleryPageState createState() => _CloudGalleryPageState();

}

class _CloudGalleryPageState extends State<CloudGalleryPage> {
  final _uploadProvider = new UploadProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contenido de la nube'),
      ),
      drawer: MenuWidget(),
      body: FutureBuilder(
        future: _uploadProvider.getAllImages(),
        // initialData: InitialData,
        builder: (BuildContext context, AsyncSnapshot<SearchResponse> snapshot) {

          if(snapshot.hasData) {

            List<Resource> items = snapshot.data!.resources;

            print('cant: ${snapshot.data!.totalCount}');
            return ListView.builder(
              itemCount: snapshot.data!.totalCount,
              itemBuilder: ( context, i) => ListTile(
                leading: Image(
                  // placeholder: Container(),
                  image: NetworkImage(  items[i].getUrlThumb() ), 
                 ),
                title: Text( items[i].filename ),
                subtitle: Text( '${items[i].metadata.coordLat} ${items[i].metadata.coordLng}' ),
                // isThreeLine: true,
                dense: true,
                // trailing: Icon(Icons.item, color: Colors.grey),
                onTap: () => { }
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
          
        },
      ),
       
    );
  }
}