import 'dart:convert';
import 'package:http/http.dart' as http;

class PaymentService {
  
  static const String secretKey = "sk_test_xxx";

  Future<String?> createPaymentLink(double amount) async {
    final url = Uri.parse("https://api.paymongo.com/v1/links");

    final body = {
      "data": {
        "attributes": {
          "amount": (amount * 100).toInt(), 
          "description": "Coffee Order",
        }
      }
    };

    final response = await http.post(
      url,
      headers: {
        "Authorization": "Basic ${base64Encode(utf8.encode('$secretKey:'))}",
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data']['attributes']['checkout_url'];
    } else {
      print("Payment error: ${response.body}");
      return null;
    }
  }
}
