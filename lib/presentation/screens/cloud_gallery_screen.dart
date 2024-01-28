import 'package:flutter/material.dart';
import 'package:saig_app/domain/entities/gallery_item.dart';
import 'package:saig_app/infrastructure/datasources/cloudinary/datasources/cloudinary_gallery_datasource.dart';
import 'package:saig_app/infrastructure/datasources/faker/mock_gallery_datasource.dart';
import 'package:saig_app/infrastructure/repositories/gallery_repository_impl.dart';
import 'package:saig_app/presentation/menu_widget.dart';
import 'package:saig_app/presentation/widgets/error_indicator_widget.dart';

class CloudGalleryScreen extends StatelessWidget {
  
  CloudGalleryScreen({super.key});

  // final galleryRepository = GalleryRepositoryImpl( datasource: MockGalleryDatasource() );
  final galleryRepository = GalleryRepositoryImpl( datasource: CloudinaryGalleryDatasource() );


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contenido de la nube'),
      ),
      drawer: const MenuWidget(),
      body: FutureBuilder(
        future: galleryRepository.getAllItems(),
        builder: (BuildContext context, AsyncSnapshot<List<GalleryItem>> snapshot) {

          if(snapshot.hasData) {
            return ListViewGalleryWidget(
              items: snapshot.data! 
            );
          }

          if(snapshot.hasError) {
            return ErrorIndicatorWidget(message: snapshot.error.toString() );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}


///
/// Gallery items using ListView
///
class ListViewGalleryWidget extends StatelessWidget {

  final List<GalleryItem> items;

  const ListViewGalleryWidget({
    super.key, required this.items,
  });

  @override
  Widget build(BuildContext context) {

    if(items.isEmpty) {
      return const Text('No items');
    }

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, i) => Container(
        padding: const EdgeInsets.only(top: 5, bottom: 5),
        child: Row(children: <Widget>[
          Image(
            width: 50,
            height: 50,
            image: NetworkImage( items[i].thumbUrl ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 5),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(items[i].filename, 
                    textAlign: TextAlign.left
                  ),
                  Text( '${items[i].coordLat} ${items[i].coordLng}'
                  ),
                  Text(items[i].description,
                      overflow: TextOverflow.ellipsis
                  )
                ]),
          ),
        ]),
      ),
    );
  }
}