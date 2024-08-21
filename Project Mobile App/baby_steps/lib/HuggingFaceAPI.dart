import 'dart:convert';
import 'package:http/http.dart' as http;

const String apiUrl = "https://api-inference.huggingface.co/models/meta-llama/Meta-Llama-3-8B-Instruct";
const String apiToken = "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";

Future<List<dynamic>> query(String payload) async {
  final response = await http.post(
    Uri.parse(apiUrl),
    headers: {
      "Authorization": "Bearer $apiToken",
      "Content-Type": "application/json"
    },
    body: jsonEncode({"inputs": payload}),
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body) as List<dynamic>;
  } else {
    throw Exception('Failed to load data');
  }
}