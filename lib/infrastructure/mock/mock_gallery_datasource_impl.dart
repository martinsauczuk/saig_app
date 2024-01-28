import 'package:faker_dart/faker_dart.dart';
import 'package:saig_app/domain/datasources/gallery_datasource.dart';
import 'package:saig_app/domain/entities/gallery_item.dart';

class MockGalleryDatasource implements GalleryDatasource {

  @override
  Future<List<GalleryItem>> getAllItems() {

    final faker = Faker.instance;


    final item1 = GalleryItem(
      coordLat: faker.address.latitude(), 
      coordLng: faker.address.longitude(), 
      description: faker.commerce.productName(), 
      thumbUrl: 'https://upload.wikimedia.org/wikipedia/commons/9/9e/Ours_brun_parcanimalierpyrenees_1.jpg', 
      filename: faker.company.companyName()
    );

    final item2 = GalleryItem(
      coordLat: faker.address.latitude(), 
      coordLng: faker.address.longitude(), 
      description: faker.commerce.productName(), 
      thumbUrl: 'https://www.oakhurstvet.com/blog/wp-content/uploads/2020/10/iStock-173748770.jpg', 
      filename: faker.company.companyName()
    );

    final item3 = GalleryItem(
      coordLat: faker.address.latitude(), 
      coordLng: faker.address.longitude(), 
      description: faker.commerce.productName(), 
      thumbUrl: faker.internet.url(), 
      filename: 'https://www.purina.co.uk/sites/default/files/2020-12/Dog_1098119012_Teaser.jpg'
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