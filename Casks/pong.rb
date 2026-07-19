cask "pong" do
  arch arm: "aarch64", intel: "x64"

  version "0.0.1"
  sha256 arm:   "3f3fe89949de643a00bb83df5707151bb99306e9e398f8dba0c1a4061ae0c7c7",
         intel: "ceb84e7db1057c7238fe348715d3425e0efe0eef39712d2cca6f29596459d772"

  url "https://github.com/neochaotic/pong/releases/download/v#{version}/Pong_#{version}_#{arch}.dmg"
  name "Pong"
  desc "Menu-bar companion that keeps your Claude.ai session warm and shows live usage"
  homepage "https://github.com/neochaotic/pong"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates false
  depends_on :macos

  app "Pong.app"

  # Pong isn't code-signed or notarized yet (no paid Apple Developer account) — a
  # plain .dmg install hits Gatekeeper's "damaged" warning on first launch. Strip
  # the quarantine flag here so a `brew install` just works. Then launch it: Pong
  # is tray-only (no Dock icon, no window), so without this, "brew install"
  # finishing gives no visible sign anything happened at all — same silence as a
  # manual install, just via a different path.
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-cr", "#{appdir}/Pong.app"],
                   sudo: false
    system_command "/usr/bin/open",
                   args: ["-a", "#{appdir}/Pong.app"],
                   sudo: false
  end

  # Pong is tray-only (no Dock icon), so replacing the app bundle while it's
  # still running is a silent no-op from the user's side — the old process
  # keeps running the old build, nothing signals it to relaunch. `quit:` makes
  # `install`/`upgrade`/`uninstall` terminate it first, every time.
  uninstall quit: "com.pongllm.monitor"

  zap trash: [
    "~/Library/Application Support/com.pongllm.monitor",
    "~/Library/HTTPStorages/pongllm.binarycookies",
    "~/Library/LaunchAgents/Pong.plist",
    "~/Library/Logs/com.pongllm.monitor",
  ]

  caveats <<~EOS
    Pong is not code-signed or notarized yet — this Cask strips the quarantine
    flag automatically so it launches without a Gatekeeper warning. See
    https://github.com/neochaotic/pong#install for details.

    Pong just launched itself and is now running — but it's a menu-bar-only
    app (no Dock icon, no window), so there's nothing on screen to confirm
    that. Look for its icon in the menu bar at the top-right of your screen.
  EOS
end
