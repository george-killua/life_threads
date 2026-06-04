import Contacts
import ContactsUI
import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  private var contactPickerHandler: LifeThreadsContactPickerHandler?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)

    guard let registrar = engineBridge.pluginRegistry.registrar(
      forPlugin: "LifeThreadsContactPicker"
    ) else { return }
    contactPickerHandler = LifeThreadsContactPickerHandler(
      messenger: registrar.messenger()
    )
  }
}

private final class LifeThreadsContactPickerHandler: NSObject, CNContactPickerDelegate {
  private let channel: FlutterMethodChannel
  private var pendingResult: FlutterResult?

  init(messenger: FlutterBinaryMessenger) {
    channel = FlutterMethodChannel(
      name: "dev.gkcoding.lifethreads/contact_picker",
      binaryMessenger: messenger
    )
    super.init()
    channel.setMethodCallHandler(handle)
  }

  private func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard call.method == "pickContact" else {
      result(FlutterMethodNotImplemented)
      return
    }

    DispatchQueue.main.async {
      guard self.pendingResult == nil else {
        result(FlutterError(
          code: "contact_picker_busy",
          message: "A contact picker is already open.",
          details: nil
        ))
        return
      }

      guard let presenter = self.topViewController() else {
        result(FlutterError(
          code: "no_view_controller",
          message: "No active view controller is available.",
          details: nil
        ))
        return
      }

      self.pendingResult = result
      let picker = CNContactPickerViewController()
      picker.delegate = self
      picker.displayedPropertyKeys = [
        CNContactPhoneNumbersKey,
        CNContactEmailAddressesKey,
      ]
      picker.predicateForSelectionOfContact = NSPredicate(value: true)
      presenter.present(picker, animated: true)
    }
  }

  func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
    complete(with: contactPayload(contact))
  }

  func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
    complete(with: nil)
  }

  private func complete(with value: Any?) {
    pendingResult?(value)
    pendingResult = nil
  }

  private func contactPayload(_ contact: CNContact) -> [String: String] {
    var payload: [String: String] = [:]
    payload["name"] = CNContactFormatter.string(from: contact, style: .fullName)
      ?? [contact.givenName, contact.familyName]
        .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        .filter { !$0.isEmpty }
        .joined(separator: " ")

    if let phone = contact.phoneNumbers.first?.value.stringValue,
       !phone.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
      payload["phone"] = phone
    }

    if let email = contact.emailAddresses.first?.value as String?,
       !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
      payload["email"] = email
    }

    return payload
  }

  private func topViewController() -> UIViewController? {
    let windowScene = UIApplication.shared.connectedScenes
      .compactMap { $0 as? UIWindowScene }
      .first { $0.activationState == .foregroundActive }
    let root = windowScene?.windows.first { $0.isKeyWindow }?.rootViewController
    return topViewController(from: root)
  }

  private func topViewController(from root: UIViewController?) -> UIViewController? {
    if let navigation = root as? UINavigationController {
      return topViewController(from: navigation.visibleViewController)
    }

    if let tab = root as? UITabBarController {
      return topViewController(from: tab.selectedViewController)
    }

    if let presented = root?.presentedViewController {
      return topViewController(from: presented)
    }

    return root
  }
}
