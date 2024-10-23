import 'package:flutter/material.dart';

import 'package:livekit_client/livekit_client.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../context/media_device.dart';
import '../../context/room.dart';
import '../../types/theme.dart';

class AudioOutputSelectButton extends StatelessWidget {
  const AudioOutputSelectButton({super.key, this.showLabel = false});
  final bool showLabel;
  @override
  Widget build(BuildContext context) {
    return Consumer<RoomContext>(
      builder: (context, roomCtx, child) {
        return Consumer<MediaDeviceContext>(
          builder: (context, deviceCtx, child) {
            var deviceScreenType = getDeviceType(MediaQuery.of(context).size);
            return Row(mainAxisSize: MainAxisSize.min, children: [
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      WidgetStateProperty.all(Colors.grey.withOpacity(0.6)),
                  foregroundColor: WidgetStateProperty.all(Colors.white),
                  shape: WidgetStateProperty.all(const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          bottomLeft: Radius.circular(20.0)))),
                  padding: WidgetStateProperty.all(
                      deviceScreenType == DeviceScreenType.desktop ||
                              lkPlatformIsDesktop()
                          ? const EdgeInsets.fromLTRB(10, 20, 10, 20)
                          : const EdgeInsets.all(12)),
                ),
                onPressed: () {},
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.volume_up),
                    const SizedBox(width: 2),
                    if (deviceScreenType != DeviceScreenType.mobile ||
                        showLabel)
                      const Text(
                        'Audio Output',
                        style: TextStyle(fontSize: 14),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 0.2),
              Selector<RoomContext, String?>(
                selector: (context, roomCtx) =>
                    deviceCtx.selectedAudioOutputDeviceId,
                builder: (context, selectedAudioOutputDeviceId, child) {
                  return PopupMenuButton<MediaDevice>(
                    padding: const EdgeInsets.all(12),
                    icon: const Icon(Icons.arrow_drop_down),
                    offset: Offset(
                        0, ((deviceCtx.audioOutputs?.length ?? 1) * -55.0)),
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all(Colors.grey.withOpacity(0.6)),
                      foregroundColor: WidgetStateProperty.all(Colors.white),
                      overlayColor: WidgetStateProperty.all(Colors.grey),
                      elevation: WidgetStateProperty.all(20),
                      shape: WidgetStateProperty.all(
                          const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20.0),
                                  bottomRight: Radius.circular(20.0)))),
                    ),
                    itemBuilder: (BuildContext context) {
                      return [
                        if (deviceCtx.audioOutputs != null)
                          ...deviceCtx.audioOutputs!.map((device) {
                            return PopupMenuItem<MediaDevice>(
                              value: device,
                              child: ListTile(
                                selected: (device.deviceId ==
                                    selectedAudioOutputDeviceId),
                                selectedColor: LKColors.lkBlue,
                                leading: (device.deviceId ==
                                        selectedAudioOutputDeviceId)
                                    ? Icon(
                                        Icons.check_box_outlined,
                                        color: (device.deviceId ==
                                                selectedAudioOutputDeviceId)
                                            ? LKColors.lkBlue
                                            : Colors.white,
                                      )
                                    : const Icon(
                                        Icons.check_box_outline_blank,
                                        color: Colors.white,
                                      ),
                                title: Text(device.label),
                              ),
                              onTap: () => deviceCtx.selectAudioOutput(device),
                            );
                          })
                      ];
                    },
                  );
                },
              ),
            ]);
          },
        );
      },
    );
  }
}
