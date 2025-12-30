import 'dart:convert';
import 'dart:io';
import 'package:mohd_neodocs_test/data/models/range_section_model.dart';

class RangeRepository {
  final HttpClient _client = HttpClient();

  Future<List<RangeSection>> fetchRanges() async {
    final uri = Uri.parse('https://nd-assignment.azurewebsites.net/api/get-ranges');
    final request = await _client.getUrl(uri);
    request.headers.set(
      HttpHeaders.authorizationHeader,
      'Bearer eb3dae0a10614a7e719277e07e268b12aeb3af6d7a4655472608451b321f5a95',
    );

    final response = await request.close();
    if (response.statusCode != 200) {
      throw HttpException('Failed with status ${response.statusCode}');
    }

    final body = await response.transform(utf8.decoder).join();
    final decoded = jsonDecode(body) as List<dynamic>;
    
    return decoded
        .map((e) => RangeSection.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
