import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:camera/camera.dart';
import 'dart:io';

class GeminiService {
  late final GenerativeModel _model;

  GeminiService() {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null) {
      throw Exception('GEMINI_API_KEY not found in environment variables');
    }

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
        Provide a clear and concise/breif as possible interpretation of the meaning.
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

  Future<String> generateSummary(List<String> interpretations) async {
    try {
      final prompt = '''
        Based on the following sign language interpretations, provide a clear and concise summary of the conversation or message:

        ${interpretations.join('\n')}

        Please summarize the main points and context of these interpretations in a coherent paragraph.
      ''';

      final response = await _model.generateContent([
        Content.text(prompt),
      ]);

      return response.text ?? 'Unable to generate summary';
    } catch (e) {
      throw Exception('Failed to generate summary: $e');
    }
  }
}
