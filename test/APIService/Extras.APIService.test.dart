import 'package:bp_tablet_app/models/extra.model.dart';
import 'package:bp_tablet_app/services/APIService/APIService.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bp_tablet_app/services/APIService/Extras/Extras.APIService.dart';

void main() {
  group('ExtrasAPIService', () {
    ExtrasAPIService extrasAPIService = ExtrasAPIService();
    BPExtra? extra;
    test('addExtra should add a new extra', () async {
      String extraName = 'Test Extra';
      var response = await extrasAPIService.addExtra(extraName);
      expect(response.isSuccess, true);
      expect(APIService.data.extras.last.Name, extraName);
    });

    test('getExtras should return a list of extras', () async {
      var response = await extrasAPIService.getExtras();
      expect(response.isSuccess, true);
      expect(APIService.data.extras.length, greaterThan(0));
    });

    test('updateExtra should update an existing extra', () async {
      String extraName = 'Updated Test Extra';
      extra = APIService.data.extras[0];
      var response =
          await extrasAPIService.updateExtra(extra!, name: extraName);
      expect(response.isSuccess, true);
      expect(APIService.data.extras[0].Name, extraName);
    });

    test('deleteExtra should delete an existing extra', () async {
      var response = await extrasAPIService.deleteExtra(extra!);
      expect(response.isSuccess, true);
      expect(APIService.data.extras.firstWhere((x) => x.ID == extra!.ID),
          throwsA(isA<Exception>()));
    });
  });
}
