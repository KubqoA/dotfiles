{config, ...}: {
  sops.secrets."storage-box/ssh-key" = {};

  fileSystems."/mnt/storagebox" = {
    device = "u451930@u451930.your-storagebox.de:/";
    fsType = "fuse.sshfs";
    options = [
      # BASIC CONNECTION
      "allow_other" # Allow other users to access mount
      "default_permissions" # Use standard file permissions
      "reconnect" # Auto-reconnect on connection loss
      "ServerAliveInterval=15" # Send keepalive every 15 seconds
      "ServerAliveCountMax=3" # Drop connection after 3 failed keepalives

      # PERFORMANCE & CACHING
      "cache=yes" # Enable attribute and data caching
      "kernel_cache" # Use kernel page cache for better performance
      "compression=no" # Disable SSH compression (faster on good connections)
      "noatime" # Improve performance by disabling atime updates

      # BUFFER SIZES
      "max_read=131072" # 128KB read buffer (good for streaming)
      "max_write=131072" # 128KB write buffer (good for downloads)

      # SSH CONNECTION OPTIMIZATION
      "BatchMode=yes" # Non-interactive mode
      "TCPKeepAlive=yes" # Enable TCP keepalive
      "ControlMaster=auto" # Reuse SSH connections when possible
      "ControlPath=/tmp/sshfs-%r@%h:%p" # Socket path for connection sharing
      "ControlPersist=600" # Keep connection alive for 10 minutes after last use

      # SYMLINK HANDLING
      "follow_symlinks" # Follow symlinks on remote side
      "transform_symlinks" # Convert absolute symlinks to relative
      "idmap=user" # Map remote UID/GID to local user

      # SYSTEMD INTEGRATION
      "_netdev" # Mark as network filesystem
      "x-systemd.after=network-online.target" # Wait for network
      "x-systemd.wants=network-online.target" # Require network target
      "nofail" # Don't fail boot if mount fails

      # AUTHENTICATION
      "IdentityFile=${config.sops.secrets."storage-box/ssh-key".path}"
      "StrictHostKeyChecking=no" # Skip host key verification (use carefully)
    ];
  };
}
