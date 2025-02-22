import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../services/gemini_service.dart';
import '../widgets/camera_view.dart';
import '../widgets/interpretation_result.dart';

class SignLanguageInterpreterScreen extends StatefulWidget {
  const SignLanguageInterpreterScreen({super.key});

  @override
  State<SignLanguageInterpreterScreen> createState() =>
      _SignLanguageInterpreterScreenState();
}

class _SignLanguageInterpreterScreenState
    extends State<SignLanguageInterpreterScreen> {
  final GeminiService _geminiService = GeminiService();
  final List<String> _interpretationHistory = [];
  bool _isProcessing = false;
  bool _isInterpreting = false;

  Future<void> processImage(XFile image) async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      final result = await _geminiService.interpretSignLanguage(image);
      setState(() {
        if (result.isNotEmpty) {
          _interpretationHistory.insert(0, result);
        }
      });
    } catch (e) {
      debugPrint('Error processing image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error processing image')),
      );
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  void _toggleInterpreting() {
    setState(() {
      _isInterpreting = !_isInterpreting;
      if (_isInterpreting) {
        _interpretationHistory.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sign Language Interpreter',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 2,
      ),
      body: Container(
        color: Colors.grey[100],
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: CameraView(
                    onImageCaptured: processImage,
                    isProcessing: _isProcessing,
                    isInterpreting: _isInterpreting,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: InterpretationResult(
                  interpretationHistory: _interpretationHistory,
                  isProcessing: _isProcessing,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _toggleInterpreting,
        icon: Icon(
          _isInterpreting ? Icons.stop_circle : Icons.play_circle_fill,
          size: 28,
        ),
        label: Text(
          _isInterpreting ? 'Stop' : 'Start',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: _isInterpreting ? Colors.red[400] : Colors.blue[600],
        elevation: 4,
      ),
    );
  }
}
