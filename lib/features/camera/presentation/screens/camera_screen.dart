import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:scansplit/features/camera/services/camera_service.dart';

class CameraScreen extends StatefulWidget {
  final Function(String imagePath)? onImageCaptured;

  const CameraScreen({super.key, this.onImageCaptured});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver {
  final CameraService _cameraService = CameraService();
  bool _isLoading = true;
  bool _isCapturing = false;
  String? _errorMessage;
  bool _isSwitchingCamera = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraService.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Handle app lifecycle changes
    if (!_cameraService.isInitialized) return;

    if (state == AppLifecycleState.inactive) {
      _cameraService.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  Future<void> _initializeCamera() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _cameraService.initialize();
      setState(() => _isLoading = false);
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to initialize camera: ${e.toString()}';
      });
    }
  }

  Future<void> _takePicture() async {
    if (_isCapturing) return;

    setState(() => _isCapturing = true);

    try {
      final imagePath = await _cameraService.takePicture();
      setState(() => _isCapturing = false);

      if (imagePath != null && widget.onImageCaptured != null) {
        widget.onImageCaptured!(imagePath); // This will trigger navigation
      }
    } catch (e) {
      if (mounted) {
        // Show error to user
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to navigate: $e')));
      }
      setState(() {
        _isCapturing = false;
        _errorMessage = 'Failed to capture image: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Camera')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _initializeCamera,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Camera')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // If we're on a simulator, show a mock camera interface
    if (_cameraService.isSimulator) {
      return _buildMockCameraInterface();
    }

    return Scaffold(
      body: Stack(
        children: [
          // Enhanced camera preview with loading state
          _buildCameraPreview(),

          // Camera controls (updated switch camera button)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              color: Colors.black45,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Flash toggle button
                  IconButton(
                    icon: const Icon(Icons.flash_on, color: Colors.white),
                    onPressed: _cameraService.toggleFlash,
                  ),

                  // Capture button
                  GestureDetector(
                    onTap: _isCapturing ? null : _takePicture,
                    child: Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                        color: _isCapturing ? Colors.grey : Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                      ),
                    ),
                  ),

                  // Updated switch camera button
                  _isSwitchingCamera
                      ? const Padding(
                        padding: EdgeInsets.all(12),
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        ),
                      )
                      : IconButton(
                        icon: const Icon(
                          Icons.flip_camera_ios,
                          color: Colors.white,
                        ),
                        onPressed: _switchCamera,
                      ),
                ],
              ),
            ),
          ),

          // Back button
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => back(),
            ),
          ),

          // Receipt overlay guide
          Center(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Align Receipt Within Frame',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Mock camera interface for simulator
  Widget _buildMockCameraInterface() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera (Simulator Mode)'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => back(),
        ),
      ),
      body: Stack(
        children: [
          // Mock camera viewfinder
          Container(
            color: Colors.black87,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.receipt_long,
                    size: 100,
                    color: Colors.white54,
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white30),
                    ),
                    child: const Text(
                      'SIMULATOR MODE - No real camera available',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.camera),
                    label: const Text('Take Mock Photo'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    onPressed: _isCapturing ? null : _takePicture,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'This will use a sample receipt image for testing',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),

          // Receipt overlay guide
          Center(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.6,
              width: MediaQuery.of(context).size.width * 0.7,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white30, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraPreview() {
    if (_cameraService.isSimulator) {
      return Container(color: Colors.black);
    }

    if (_isCapturing) {
      return CameraPreview(_cameraService.controller!);
    }

    return FutureBuilder(
      future: _cameraService.controller?.initialize(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return CameraPreview(_cameraService.controller!);
        } else {
          return Container(
            color: Colors.black,
            child: const Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }

  Future<void> _switchCamera() async {
    if (_isSwitchingCamera) return;

    setState(() => _isSwitchingCamera = true);
    try {
      await _cameraService.switchCamera();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to switch camera: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSwitchingCamera = false);
    }
  }

  void back() {
    if (context.canPop()) {
      context.pop();
    } else {
      // Handle case where there's nothing to pop
      context.go('/home');
    }
  }
}
