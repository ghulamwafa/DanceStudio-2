import Foundation
import Combine

final class TabRouter: ObservableObject {
    static let shared = TabRouter()
    private init() {}

    // 0 = Home, 1 = Bookings, 2 = Profile
    @Published var selectedTab: Int = 0
}
