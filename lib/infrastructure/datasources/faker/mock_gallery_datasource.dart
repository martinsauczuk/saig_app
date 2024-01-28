import 'package:faker/faker.dart';

import 'package:saig_app/domain/datasources/gallery_datasource.dart';
import 'package:saig_app/domain/entities/gallery_item.dart';

class MockGalleryDatasource implements GalleryDatasource {

  @override
  Future<List<GalleryItem>> getAllItems() {

    final faker = Faker();


    final item1 = GalleryItem(
      coordLat: faker.geo.latitude(), 
      coordLng: faker.geo.longitude(), 
      description: faker.conference.name(), 
      thumbUrl: 'https://upload.wikimedia.org/wikipedia/commons/9/9e/Ours_brun_parcanimalierpyrenees_1.jpg', 
      filename: faker.image.image(),
    );

    final item2 = GalleryItem(
      coordLat: faker.geo.latitude(), 
      coordLng: faker.geo.longitude(), 
      description: faker.conference.name(), 
      thumbUrl: 'https://www.oakhurstvet.com/blog/wp-content/uploads/2020/10/iStock-173748770.jpg', 
      filename: faker.image.image()
    );

    final item3 = GalleryItem(
      coordLat: faker.geo.latitude(), 
      coordLng: faker.geo.longitude(), 
      description: faker.conference.name(), 
      thumbUrl: 'https://www.purina.co.uk/sites/default/files/2020-12/Dog_1098119012_Teaser.jpg', 
      filename: faker.image.image()
    );


    return Future.delayed(const Duration(seconds: 2), () {
      return [
        item1,
        item2,
        item3
      ];
    });

  }

}