import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraService {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  bool _isInitialized = false;
  bool _isSimulator = false;
  bool _isFrontCamera = false;

  bool get isInitialized => _isInitialized;

  CameraController? get controller => _controller;

  bool get isSimulator => _isSimulator;

  // Initialize camera service
  Future<void> initialize({bool useFrontCamera = false}) async {
    // Check if running on simulator
    _isSimulator =
        !kIsWeb &&
        (Platform.isIOS || Platform.isAndroid) &&
        !(await _isRealDevice());

    if (_isSimulator) {
      // Running on simulator, set up mock camera
      _isInitialized = true;
      debugPrint('Running on simulator, using mock camera');
      return;
    }

    // Running on a real device, initialize actual camera
    // Check camera permissions
    if (!await _checkPermissions()) {
      throw Exception('Camera permissions not granted');
    }

    try {
      // Get available cameras
      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        throw Exception('No cameras found on device');
      }

      // Find the appropriate camera
      final camera = useFrontCamera
          ? _cameras.firstWhere(
            (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => _cameras.first,
      )
          : _cameras.firstWhere(
            (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => _cameras.first,
      );

      // Initialize controller with the first (back) camera
      // await _controller?.dispose();
      _controller = CameraController(
        camera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      // Initialize camera
      await _controller!.initialize();
      _isInitialized = true;
      _isFrontCamera = useFrontCamera;
    } catch (e) {
      _isInitialized = false;
      rethrow;
    }
  }

  // Check if running on a real device
  Future<bool> _isRealDevice() async {
    try {
      // Try to get cameras - this typically fails in a specific way on simulators
      await availableCameras();
      return true; // If no exception, likely a real device
    } catch (e) {
      // Check error message that typically occurs on simulators
      return !e.toString().contains('camera plugin cannot get cameras');
    }
  }

  // Switch between front and back cameras
  Future<void> switchCamera() async {
    if (_isSimulator || _cameras.length < 2) return; // No-op on simulator

    try {
      await initialize(useFrontCamera: !_isFrontCamera);
    } catch (e) {
      debugPrint('Error switching camera: $e');
      // Fall back to back camera if front fails
      if (_isFrontCamera) {
        await initialize(useFrontCamera: false);
      }
    } finally {
      // do something
    }

    final lensDirection = _controller!.description.lensDirection;
    CameraDescription newCamera;

    if (lensDirection == CameraLensDirection.back) {
      newCamera = _cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
      );
    } else {
      newCamera = _cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
      );
    }

    await _controller!.dispose();
    _controller = CameraController(
      newCamera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    await _controller!.initialize();
  }

  // Take picture and return file path
  Future<String?> takePicture() async {
    if (_isSimulator) {
      // On simulator, provide a sample receipt image
      return await _provideMockReceiptImage();
    }

    if (!_isInitialized || _controller == null) {
      throw Exception('Camera not initialized');
    }

    try {
      // Ensure controller is initialized
      if (!_controller!.value.isInitialized) {
        return null;
      }

      // Take picture
      final XFile file = await _controller!.takePicture();

      // Save image to app directory for persistence
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String fileName = path.basename(file.path);
      final String savedPath = path.join(appDir.path, 'receipts', fileName);

      // Ensure directory exists
      await Directory(path.dirname(savedPath)).create(recursive: true);

      // Copy file to app directory
      File(file.path).copy(savedPath);

      return savedPath;
    } catch (e) {
      if (kDebugMode) {
        print('Error taking picture: $e');
      }
      return null;
    }
  }

  // Provide a mock receipt image for simulator testing
  Future<String> _provideMockReceiptImage() async {
    try {
      // Create a mock receipt image in app directory
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String fileName =
          'mock_receipt_${DateTime.now().millisecondsSinceEpoch}.png';
      final String savedPath = path.join(appDir.path, 'receipts', fileName);

      // Ensure receipts directory exists
      await Directory(path.dirname(savedPath)).create(recursive: true);

      // Either copy from assets or create a dummy file
      try {
        // Try to copy from assets if you have a sample receipt image
        // Add a sample receipt to your assets and reference it in pubspec.yaml:
        // assets:
        //   - assets/images/sample_receipt.png
        final ByteData data = await rootBundle.load(
          'assets/images/sample_receipt.png',
        );
        final bytes = data.buffer.asUint8List();
        await File(savedPath).writeAsBytes(bytes);
      } catch (e) {
        // If no asset available, create an empty file as fallback
        await File(savedPath).writeAsString('Mock receipt file');
        debugPrint(
          'Created fallback mock receipt. Consider adding a sample receipt image to assets.',
        );
      }

      return savedPath;
    } catch (e) {
      debugPrint('Error creating mock receipt: $e');
      rethrow;
    }
  }

  // Toggle flash mode
  Future<void> toggleFlash() async {
    if (_isSimulator || !_isInitialized || _controller == null) return;

    if (_controller!.value.flashMode == FlashMode.off) {
      await _controller!.setFlashMode(FlashMode.torch);
    } else {
      await _controller!.setFlashMode(FlashMode.off);
    }
  }

  // Check and request camera permissions
  Future<bool> _checkPermissions() async {
    var cameraStatus = await Permission.camera.status;

    if (!cameraStatus.isGranted) {
      cameraStatus = await Permission.camera.request();
    }

    return cameraStatus.isGranted;
  }

  // Dispose camera controller
  void dispose() {
    _controller?.dispose();
    _isInitialized = false;
  }
}
