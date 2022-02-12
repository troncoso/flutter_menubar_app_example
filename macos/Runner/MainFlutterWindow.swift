import Cocoa
import FlutterMacOS
import bitsdojo_window_macos

class MainFlutterWindow: BitsdojoWindow {
  override func bitsdojo_window_configure() -> UInt {
    return BDW_HIDE_ON_STARTUP
  }

  override func awakeFromNib() {
    let flutterViewController = FlutterViewController.init()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    // Remove the default black square border
    self.isOpaque = false;
    self.backgroundColor = NSColor.clear;

    // Round the corners of the window
    self.contentView?.wantsLayer = true;
    self.contentView?.layer?.backgroundColor = NSColor.clear.cgColor;
    self.contentView?.layer?.masksToBounds = true;
    self.contentView?.layer?.cornerRadius = 8.0;

    // Ensure this app is always on top when it is visible
    self.level = .floating;

    // TODO: when this is enabled, the app will properly hide if it loses focus. However, clicking
    // the tray icon again will not open the app anymore
    // self.hidesOnDeactivate = true;

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}
