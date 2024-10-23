import 'package:flutter/material.dart';

import 'package:livekit_client/livekit_client.dart';
import 'package:provider/provider.dart';

import '../../context/track.dart';
import '../debug/logger.dart';

class VideoTrackWidget extends StatelessWidget {
  const VideoTrackWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var trackCtx = Provider.of<TrackContext?>(context);
    final String? sid = trackCtx?.sid;
    Debug.log('===>     VideoTrackWidget for $sid');
    return VideoTrackRenderer(trackCtx!.videoTrack!);
  }
}