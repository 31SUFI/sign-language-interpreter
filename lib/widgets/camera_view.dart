import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../main.dart';

class CameraView extends StatefulWidget {
  final Function(XFile) onImageCaptured;
  final bool isProcessing;

  const CameraView({
    super.key,
    required this.onImageCaptured,
    required this.isProcessing,
  });

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  CameraController? _controller;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    if (cameras.isEmpty) return;

    _controller = CameraController(
      cameras[0],
      ResolutionPreset.medium,
      enableAudio: false,
    );

    try {
      await _controller!.initialize();
      setState(() {
        _isCameraInitialized = true;
      });

      // Start image stream for real-time processing
      await _controller!.startImageStream(_processImageStream);
    } catch (e) {
      debugPrint('Camera initialization error: $e');
    }
  }

  Future<void> _processImageStream(CameraImage image) async {
    if (widget.isProcessing) return;

    // Capture image every 2 seconds
    await _controller?.stopImageStream();
    final xFile = await _controller?.takePicture();
    if (xFile != null) {
      widget.onImageCaptured(xFile);
    }

    await Future.delayed(const Duration(seconds: 2));
    await _controller?.startImageStream(_processImageStream);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isCameraInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: CameraPreview(_controller!),
    );
  }
}
