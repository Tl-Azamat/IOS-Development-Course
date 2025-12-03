import Foundation

struct Persistence {
    private static let lastHeroKey = "lastHero_v1"

    // Сохраняем весь объект героя как JSON Data (надёжно, легко восстанавливать)
    static func saveLastHero(_ hero: Hero) {
        do {
            let data = try JSONEncoder().encode(hero)
            UserDefaults.standard.set(data, forKey: lastHeroKey)
        } catch {
            print("Failed to encode hero for persistence: \(error)")
        }
    }

    static func loadLastHero() -> Hero? {
        guard let data = UserDefaults.standard.data(forKey: lastHeroKey) else { return nil }
        do {
            let hero = try JSONDecoder().decode(Hero.self, from: data)
            return hero
        } catch {
            print("Failed to decode hero from persistence: \(error)")
            return nil
        }
    }

    static func clearLastHero() {
        UserDefaults.standard.removeObject(forKey: lastHeroKey)
    }
}


