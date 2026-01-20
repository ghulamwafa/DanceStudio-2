// DanceStudio/Features/Home/HomeViewModel.swift

import Foundation
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var classes: [DanceClass] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let classStore = AdminClassStore.shared

    /// Load classes from the same store that Admin Panel uses
    func load() async {
        isLoading = true
        errorMessage = nil

        // No network, just copy from AdminClassStore
        let currentClasses = classStore.classes

        // Optional: tiny delay so UI looks smoother
        try? await Task.sleep(nanoseconds: 200_000_000) // 0.2s

        classes = currentClasses
        isLoading = false
    }
}
