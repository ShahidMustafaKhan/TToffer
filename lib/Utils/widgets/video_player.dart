import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoPath;
  final bool networkVideo;
  final double? playBtnSize;

  const VideoPlayerWidget({
    super.key,
    required this.videoPath,
    this.networkVideo = false,
    this.playBtnSize,
  });

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;
  bool _showButton = true;
  Timer? _buttonVisibilityTimer;

  @override
  void initState() {
    super.initState();
    // Initialize controller based on the networkVideo flag
    _controller = widget.networkVideo
        ? VideoPlayerController.networkUrl(Uri.parse(widget.videoPath))
        : VideoPlayerController.file(File(widget.videoPath));

    _controller.initialize().then((_) {
      setState(() {});
      _controller.setLooping(true);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _buttonVisibilityTimer?.cancel();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_isPlaying) {
        _controller.pause();
        _showButton = true;
      } else {
        _controller.play();
        _showButton = true;
        _startButtonVisibilityTimer();
      }
      _isPlaying = !_isPlaying;
    });
  }

  void _startButtonVisibilityTimer() {
    _buttonVisibilityTimer?.cancel();
    _buttonVisibilityTimer = Timer(const Duration(seconds: 2), () {
      setState(() {
        _showButton = false;
      });
    });
  }

  void _onScreenTap() {
    setState(() {
      if (_isPlaying) {
        _controller.pause();
        _isPlaying = false;
        _showButton = true;
      } else {
        _controller.play();
        _isPlaying = true;
        _startButtonVisibilityTimer();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return GestureDetector(
      onTap: _onScreenTap,
      child: Stack(
        children: [
          Positioned.fill(
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
          ),
          if (_showButton)
            Center(
              child: IconButton(
                iconSize: widget.playBtnSize ?? 50.0,
                icon: Icon(
                  _isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                ),
                onPressed: _togglePlayPause,
              ),
            ),
        ],
      ),
    );
  }
}
