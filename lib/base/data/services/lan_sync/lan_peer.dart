/// A peer discovered on the local network via mDNS or reverse peer learning.
class LanPeer {
  final String deviceId;
  final String host;
  final int port;

  /// Whether this peer responded to the last HTTP `/ping`.
  final bool reachable;

  const LanPeer(this.deviceId, this.host, this.port, {this.reachable = false});

  LanPeer withReachable(bool value) =>
      LanPeer(deviceId, host, port, reachable: value);
}
