/// Maximum age of a clip's timestamp before we reject it as a replay.
const kLanReplayWindowMs = 10000;

/// Maximum age of a binary clip's timestamp — larger to allow for big-file transfer time.
const kLanBinaryReplayWindowMs = 60000;

/// Maximum file size (bytes) that LAN sync will send or accept (100 MB).
const kLanMaxFileSizeBytes = 100 * 1024 * 1024;

/// Maximum text/URL payload size (bytes) accepted in a single /clip request.
const kLanMaxTextPayloadBytes = 512 * 1024;

/// How often all known peers are re-pinged to update reachability.
const kLanPingInterval = Duration(seconds: 20);

/// How often mDNS discovery is re-run to recover removed/stale peers.
const kLanDiscoveryInterval = Duration(seconds: 60);

/// Minimum gap between two discovery attempts.
const kLanDiscoveryCooldown = Duration(seconds: 10);

/// Fast retry cadence used while no peers have been discovered yet.
const kLanDiscoveryWarmupInterval = Duration(seconds: 8);

/// Number of consecutive ping failures before a peer is evicted from the registry.
const kLanMaxPeerFailures = 10;
