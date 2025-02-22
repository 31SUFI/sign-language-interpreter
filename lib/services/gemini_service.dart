import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:camera/camera.dart';
import 'dart:io';

class GeminiService {
  static const String apiKey =
      'AIzaSyCzTZij2CyUTpZghqOZczn8eu-Rfd2EtLU'; // Replace with your API key
  late final GenerativeModel _model;

  GeminiService() {
    _model = GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: apiKey,
    );
  }

  Future<String> interpretSignLanguage(XFile image) async {
    try {
      // Read the image file as bytes
      final imageBytes = await File(image.path).readAsBytes();

      // Define the prompt for interpreting sign language
      final prompt = '''
        Act as a sign language interpreter. Analyze this image and interpret the sign language gesture shown.
        Provide a clear and concise interpretation of the meaning.
        If you're not confident about the interpretation, please indicate that.
      ''';

      // Create the content list, specifying the MIME type for the image
      final response = await _model.generateContent([
        Content.text(prompt),
        Content.data('image/jpeg', imageBytes),
      ]);

      return response.text ?? 'No interpretation available';
    } catch (e) {
      throw Exception('Failed to interpret sign language: $e');
    }
  }
}
