import SwiftUI
import WidgetKit

/// Shared with the app (Runner), which writes the days and their photos.
private let appGroup = "group.dev.gkcoding.lifeThreads"
private let payloadKey = "home_widget_payload"
private let containerFolder = "home_widget"

/// One day as the app wrote it; see `HomeWidgetSync` in the Flutter code.
struct WidgetDay: Decodable {
  let date: String?
  /// "memory", "empty" (no memory yet) or "locked".
  let kind: String?
  let title: String
  let subtitle: String
  let memoryId: String?
  let image: String?
}

private struct WidgetPayload: Decodable {
  let days: [WidgetDay]
  let addLabel: String?
  let photoLabel: String?
}

struct MemoryEntry: TimelineEntry {
  let date: Date
  let day: WidgetDay?
  let image: UIImage?
  var addLabel = "Add a memory"
  var photoLabel = "Take photo"

  var isEmpty: Bool { day?.kind == "empty" }
}

struct MemoryProvider: TimelineProvider {
  func placeholder(in context: Context) -> MemoryEntry {
    MemoryEntry(
      date: Date(),
      day: WidgetDay(
        date: nil,
        kind: "memory",
        title: WidgetText.placeholderTitle,
        subtitle: WidgetText.placeholderSubtitle,
        memoryId: nil,
        image: nil
      ),
      image: nil
    )
  }

  func getSnapshot(in context: Context, completion: @escaping (MemoryEntry) -> Void) {
    guard let payload = loadPayload(), !payload.days.isEmpty else {
      // The sample memory only in the widget gallery; on the home screen an
      // unfilled widget says to open the app (as on Android).
      completion(context.isPreview ? placeholder(in: context) : notFilled(at: Date()))
      return
    }
    completion(entry(on: Date(), at: Date(), from: payload))
  }

  /// Before the app wrote anything for the widget (not opened since it was
  /// added, or installed fresh).
  private func notFilled(at date: Date) -> MemoryEntry {
    MemoryEntry(
      date: date,
      day: WidgetDay(
        date: nil,
        kind: "memory",
        title: WidgetText.notFilledTitle,
        subtitle: WidgetText.notFilledSubtitle,
        memoryId: nil,
        image: nil
      ),
      image: nil
    )
  }

  /// One entry per day the app prepared, switching at midnight; after the
  /// last one the widget asks again (the app refreshes it whenever it runs).
  func getTimeline(in context: Context, completion: @escaping (Timeline<MemoryEntry>) -> Void) {
    guard let payload = loadPayload(), !payload.days.isEmpty else {
      // The app fills it (and reloads the timeline) when it next runs.
      completion(Timeline(entries: [notFilled(at: Date())], policy: .never))
      return
    }
    let calendar = Calendar.current
    let today = calendar.startOfDay(for: Date())
    var entries = [entry(on: today, at: Date(), from: payload)]
    for offset in 1..<7 {
      guard let day = calendar.date(byAdding: .day, value: offset, to: today) else { continue }
      entries.append(entry(on: day, at: day, from: payload))
    }
    let refresh = calendar.date(byAdding: .day, value: 7, to: today) ?? today
    completion(Timeline(entries: entries, policy: .after(refresh)))
  }

  private func entry(on day: Date, at date: Date, from payload: WidgetPayload?) -> MemoryEntry {
    let chosen = pick(day, from: payload?.days ?? [])
    var entry = MemoryEntry(date: date, day: chosen, image: chosen.flatMap(loadImage))
    if let label = payload?.addLabel { entry.addLabel = label }
    if let label = payload?.photoLabel { entry.photoLabel = label }
    return entry
  }

  /// The day's own entry, else the latest earlier one, else the first (a
  /// locked app leaves one entry for every day).
  private func pick(_ day: Date, from days: [WidgetDay]) -> WidgetDay? {
    let key = Self.dateKey(day)
    if let exact = days.first(where: { $0.date == key }) { return exact }
    if let earlier = days.last(where: { ($0.date ?? "") <= key && $0.date != nil }) {
      return earlier
    }
    return days.first
  }

  private static func dateKey(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.calendar = Calendar(identifier: .gregorian)
    formatter.timeZone = .current
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter.string(from: date)
  }

  private func loadPayload() -> WidgetPayload? {
    guard
      let json = UserDefaults(suiteName: appGroup)?.string(forKey: payloadKey),
      let data = json.data(using: .utf8)
    else { return nil }
    return try? JSONDecoder().decode(WidgetPayload.self, from: data)
  }

  private func loadImage(_ day: WidgetDay) -> UIImage? {
    guard
      let name = day.image,
      let container = FileManager.default.containerURL(
        forSecurityApplicationGroupIdentifier: appGroup
      )
    else { return nil }
    let url = container.appendingPathComponent(containerFolder).appendingPathComponent(name)
    return UIImage(contentsOfFile: url.path)
  }
}

struct LifeThreadsWidgetView: View {
  let entry: MemoryEntry
  @Environment(\.widgetFamily) private var family

  private static let gold = Color(red: 0.82, green: 0.64, blue: 0.29)
  private static let ink = Color(red: 0.04, green: 0.03, blue: 0.04)
  private static let warm = Color(red: 0.16, green: 0.12, blue: 0.13)

  var body: some View {
    VStack(alignment: .leading, spacing: 3) {
      Spacer(minLength: 0)
      Text(entry.day?.subtitle ?? WidgetText.placeholderSubtitle)
        .font(.system(size: family == .systemSmall ? 11 : 12, weight: .heavy))
        .foregroundColor(Self.gold)
        .lineLimit(1)
        .shadow(color: .black.opacity(0.7), radius: 2, y: 1)
      Text(entry.day?.title ?? WidgetText.placeholderTitle)
        .font(.system(size: family == .systemSmall ? 15 : 18, weight: .heavy))
        .foregroundColor(.white)
        .lineLimit(2)
        .shadow(color: .black.opacity(0.5), radius: 3, y: 1)
      // No memory yet: ways to add the first one (buttons need a medium or
      // large widget; a small one opens "add" as a whole).
      if entry.isEmpty && family != .systemSmall {
        HStack(spacing: 8) {
          actionButton(entry.addLabel, systemImage: "plus", url: Self.addURL)
          actionButton(entry.photoLabel, systemImage: "camera.fill", url: Self.cameraURL)
        }
        .padding(.top, 8)
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
    .widgetURL(link)
    .widgetBackground(background)
  }

  private static let addURL = URL(string: "lifethreads://add")!
  private static let cameraURL = URL(string: "lifethreads://add?camera=1")!

  private func actionButton(_ title: String, systemImage: String, url: URL) -> some View {
    Link(destination: url) {
      Label(title, systemImage: systemImage)
        .font(.system(size: 13, weight: .heavy))
        .lineLimit(1)
        .minimumScaleFactor(0.8)
        .foregroundColor(Self.ink)
        .padding(.horizontal, 12)
        .padding(.vertical, 7)
        .background(Capsule().fill(Self.gold))
    }
  }

  private var link: URL? {
    if entry.isEmpty { return Self.addURL }
    if let id = entry.day?.memoryId,
       let encoded = id.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) {
      return URL(string: "lifethreads://memory/\(encoded)")
    }
    return URL(string: "lifethreads://wall")
  }

  private var background: some View {
    ZStack {
      LinearGradient(
        colors: [Self.warm, Self.ink],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
      )
      if let image = entry.image {
        GeometryReader { geometry in
          Image(uiImage: image)
            .resizable()
            .scaledToFill()
            .frame(width: geometry.size.width, height: geometry.size.height)
            .clipped()
        }
      }
      // Keeps the text readable on bright photos.
      LinearGradient(
        stops: [
          .init(color: .clear, location: 0.25),
          .init(color: .black.opacity(0.45), location: 0.6),
          .init(color: .black.opacity(0.85), location: 1),
        ],
        startPoint: .top,
        endPoint: .bottom
      )
    }
  }
}

private extension View {
  @ViewBuilder
  func widgetBackground<Background: View>(_ background: Background) -> some View {
    if #available(iOSApplicationExtension 17.0, *) {
      containerBackground(for: .widget) { background }
    } else {
      padding().background(background)
    }
  }
}

/// The widget gallery's texts in the app's languages.
enum WidgetText {
  private static var language: String {
    let preferred = Locale.preferredLanguages.first ?? "en"
    return String(preferred.prefix(2))
  }

  static var name: String { "LifeThreads" }

  static var description: String {
    switch language {
    case "de": return "Jeden Tag eine Erinnerung von deiner Wand."
    case "ar": return "ذكرى من جدارك كل يوم."
    default: return "A memory from your wall, every day."
    }
  }

  static var placeholderTitle: String {
    switch language {
    case "de": return "Sommer in Split"
    case "ar": return "صيف في سبليت"
    default: return "Summer in Split"
    }
  }

  static var notFilledTitle: String {
    switch language {
    case "de": return "Deine Erinnerungen"
    case "ar": return "ذكرياتك"
    default: return "Your memories"
    }
  }

  static var notFilledSubtitle: String {
    switch language {
    case "de": return "Öffne LifeThreads einmal, um dieses Widget zu füllen."
    case "ar": return "افتح LifeThreads مرة لملء هذه الأداة."
    default: return "Open LifeThreads once to fill this widget."
    }
  }

  static var placeholderSubtitle: String {
    switch language {
    case "de": return "Heute vor 3 Jahren"
    case "ar": return "قبل 3 سنوات في مثل هذا اليوم"
    default: return "3 years ago today"
    }
  }
}

@main
struct LifeThreadsWidget: Widget {
  var body: some WidgetConfiguration {
    StaticConfiguration(kind: "LifeThreadsWidget", provider: MemoryProvider()) { entry in
      LifeThreadsWidgetView(entry: entry)
    }
    .configurationDisplayName(WidgetText.name)
    .description(WidgetText.description)
    .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
  }
}
