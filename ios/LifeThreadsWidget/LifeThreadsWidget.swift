import SwiftUI
import WidgetKit

/// Shared with the app (Runner), which writes the days and their photos.
private let appGroup = "group.dev.gkcoding.lifeThreads"
private let payloadKey = "home_widget_payload"
private let containerFolder = "home_widget"

/// One day as the app wrote it; see `HomeWidgetSync` in the Flutter code.
struct WidgetDay: Decodable {
  let date: String?
  let title: String
  let subtitle: String
  let memoryId: String?
  let image: String?
}

private struct WidgetPayload: Decodable {
  let days: [WidgetDay]
}

struct MemoryEntry: TimelineEntry {
  let date: Date
  let day: WidgetDay?
  let image: UIImage?
}

struct MemoryProvider: TimelineProvider {
  func placeholder(in context: Context) -> MemoryEntry {
    MemoryEntry(
      date: Date(),
      day: WidgetDay(
        date: nil,
        title: WidgetText.placeholderTitle,
        subtitle: WidgetText.placeholderSubtitle,
        memoryId: nil,
        image: nil
      ),
      image: nil
    )
  }

  func getSnapshot(in context: Context, completion: @escaping (MemoryEntry) -> Void) {
    let days = loadDays()
    if days.isEmpty {
      completion(placeholder(in: context))
    } else {
      completion(entry(on: Date(), at: Date(), from: days))
    }
  }

  /// One entry per day the app prepared, switching at midnight; after the
  /// last one the widget asks again (the app refreshes it whenever it runs).
  func getTimeline(in context: Context, completion: @escaping (Timeline<MemoryEntry>) -> Void) {
    let days = loadDays()
    let calendar = Calendar.current
    let today = calendar.startOfDay(for: Date())
    var entries = [entry(on: today, at: Date(), from: days)]
    for offset in 1..<7 {
      guard let day = calendar.date(byAdding: .day, value: offset, to: today) else { continue }
      entries.append(entry(on: day, at: day, from: days))
    }
    let refresh = calendar.date(byAdding: .day, value: 7, to: today) ?? today
    completion(Timeline(entries: entries, policy: .after(refresh)))
  }

  private func entry(on day: Date, at date: Date, from days: [WidgetDay]) -> MemoryEntry {
    let chosen = pick(day, from: days)
    return MemoryEntry(date: date, day: chosen, image: chosen.flatMap(loadImage))
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

  private func loadDays() -> [WidgetDay] {
    guard
      let json = UserDefaults(suiteName: appGroup)?.string(forKey: payloadKey),
      let data = json.data(using: .utf8),
      let payload = try? JSONDecoder().decode(WidgetPayload.self, from: data)
    else { return [] }
    return payload.days
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
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
    .widgetURL(link)
    .widgetBackground(background)
  }

  private var link: URL? {
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
