import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../context/room_context.dart';
import '../../../context/track_reference_context.dart';
import '../../../debug/logger.dart';

class FocusToggle extends StatelessWidget {
  const FocusToggle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final roomCtx = context.read<RoomContext>();
    var trackCtx = Provider.of<TrackReferenceContext?>(context);
    final String? sid = trackCtx?.sid;
    Debug.log('===>     FocusButton for $sid');
    if (trackCtx == null) {
      return const SizedBox();
    }
    var showBackToGridView =
        roomCtx.pinnedTracks.contains(sid) && sid == roomCtx.pinnedTracks.first;

    return Padding(
      padding: const EdgeInsets.all(2),
      child: IconButton(
        icon: Icon(showBackToGridView ? Icons.grid_view : Icons.open_in_full),
        color: Colors.white70,
        onPressed: () {
          if (sid == null) {
            return;
          }
          if (showBackToGridView) {
            roomCtx.clearPinnedTracks();
          } else {
            roomCtx.pinningTrack(sid);
          }
        },
      ),
    );
  }
}
