import 'package:flutter/material.dart';
import 'package:saig_app/src/models/search_response.dart';
import 'package:saig_app/src/providers/cloudinary_provider.dart';
import 'package:saig_app/src/widgets/menu_widget.dart';

class CloudGalleryPage extends StatefulWidget {
  
  @override
  _CloudGalleryPageState createState() => _CloudGalleryPageState();

}

class _CloudGalleryPageState extends State<CloudGalleryPage> {
  final _uploadProvider = new CloudinaryProvider();

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
              itemBuilder: ( context, i) => Container(
                padding: EdgeInsets.only(top: 5, bottom: 5),
                child: Row(
                  children: <Widget>[
                    Image(
                      width: 50,
                      height: 50,
                      image: NetworkImage(  _uploadProvider.getThumbUrl(items[i]) ), 
                    ),
                    Container(
                      padding: EdgeInsets.only(left:5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text( items[i].filename, textAlign: TextAlign.left ),
                          Text( '${items[i].metadata.coordLat} ${items[i].metadata.coordLng}'),
                          Text( '${items[i].metadata.descripcion}', overflow: TextOverflow.ellipsis )
                      ]),
                    ), 
                  ]),
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
          
        },
      ),
       
    );
  }
}