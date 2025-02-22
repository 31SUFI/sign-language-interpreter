import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:math';
import '../main.dart';

class CameraView extends StatefulWidget {
  final Function(XFile) onImageCaptured;
  final bool isProcessing;
  final bool isInterpreting;

  const CameraView({
    super.key,
    required this.onImageCaptured,
    required this.isProcessing,
    required this.isInterpreting,
  });

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  CameraController? _controller;
  bool _isCameraInitialized = false;
  bool _isStreaming = false;
  DateTime _lastProcessedTime = DateTime.now();
  List<double>? _previousLuminances;
  static const double _motionThreshold =
      20.0; // Adjust this value based on testing
  static const Duration _minProcessingInterval = Duration(seconds: 3);

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void didUpdateWidget(CameraView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isInterpreting != oldWidget.isInterpreting) {
      if (widget.isInterpreting) {
        _startInterpreting();
      } else {
        _stopInterpreting();
      }
    }
  }

  Future<void> _startInterpreting() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      debugPrint('Camera controller not initialized');
      return;
    }

    if (_isStreaming) {
      debugPrint('Image stream already running');
      return;
    }

    try {
      await _controller!.startImageStream(_processImageStream);
      _isStreaming = true;
    } catch (e) {
      debugPrint('Error starting image stream: $e');
    }
  }

  Future<void> _stopInterpreting() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    if (!_isStreaming) return;

    try {
      await _controller!.stopImageStream();
      _isStreaming = false;
    } catch (e) {
      debugPrint('Error stopping image stream: $e');
    }
  }

  Future<void> _initializeCamera() async {
    if (cameras.isEmpty) {
      debugPrint('No cameras available');
      return;
    }

    _controller = CameraController(
      cameras[0],
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );

    try {
      await _controller!.initialize();
      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
        if (widget.isInterpreting) {
          await _startInterpreting();
        }
      }
    } catch (e) {
      debugPrint('Camera initialization error: $e');
    }
  }

  bool _shouldProcessFrame() {
    final now = DateTime.now();
    return now.difference(_lastProcessedTime) > _minProcessingInterval;
  }

  double _calculateAverageLuminance(CameraImage image) {
    if (image.planes.isEmpty) return 0;

    final luminances =
        List<double>.filled((image.width * image.height / 64).round(), 0);
    var idx = 0;

    // Sample every 8th pixel for performance
    for (var y = 0; y < image.height; y += 8) {
      for (var x = 0; x < image.width; x += 8) {
        final pixel = image.planes[0].bytes[y * image.width + x];
        luminances[idx++] = pixel.toDouble();
      }
    }
    return luminances.reduce((a, b) => a + b) / luminances.length;
  }

  bool _hasSignificantMotion(List<double> currentLuminances) {
    if (_previousLuminances == null) {
      _previousLuminances = currentLuminances;
      return true;
    }

    var totalDifference = 0.0;
    for (var i = 0; i < currentLuminances.length; i++) {
      totalDifference += (currentLuminances[i] - _previousLuminances![i]).abs();
    }

    final averageDifference = totalDifference / currentLuminances.length;
    _previousLuminances = currentLuminances;

    return averageDifference > _motionThreshold;
  }

  Future<void> _processImageStream(CameraImage image) async {
    if (widget.isProcessing || !_shouldProcessFrame()) return;

    final luminances =
        List<double>.filled((image.width * image.height / 64).round(), 0);
    var idx = 0;

    for (var y = 0; y < image.height; y += 8) {
      for (var x = 0; x < image.width; x += 8) {
        final pixel = image.planes[0].bytes[y * image.width + x];
        luminances[idx++] = pixel.toDouble();
      }
    }

    if (_hasSignificantMotion(luminances)) {
      await _controller?.stopImageStream();
      final xFile = await _controller?.takePicture();
      if (xFile != null) {
        _lastProcessedTime = DateTime.now();
        widget.onImageCaptured(xFile);
      }
      await _controller?.startImageStream(_processImageStream);
    }
  }

  @override
  void dispose() {
    _stopInterpreting();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isCameraInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: CameraPreview(_controller!),
        ),
        if (!widget.isInterpreting)
          Container(
            color: Colors.black54,
            child: const Center(
              child: Text(
                'Press start to begin interpretation',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
      ],
    );
  }
}
