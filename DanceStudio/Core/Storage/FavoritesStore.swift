import Foundation
import Combine

final class FavoritesStore: ObservableObject {
    static let shared = FavoritesStore()
    private init() {}

    @Published private(set) var favoriteIDs: Set<Int> = []

    func isFavorite(_ id: Int) -> Bool {
        favoriteIDs.contains(id)
    }

    func toggle(_ id: Int) {
        if favoriteIDs.contains(id) {
            favoriteIDs.remove(id)
        } else {
            favoriteIDs.insert(id)
        }
    }

    func clear() {
        favoriteIDs.removeAll()
    }
}
