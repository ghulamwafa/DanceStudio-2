import Foundation
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var classes: [DanceClass] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    // ✅ Zapis-style features
    @Published var searchText: String = ""
    @Published var selectedLevel: String = "All"

    private let service = HomeService()

    // Levels for filter UI
    let levels: [String] = ["All", "Beginner", "Intermediate", "Advanced"]

    func load() async {
        isLoading = true
        errorMessage = nil
        do {
            classes = try await service.fetchClasses()
        } catch {
            errorMessage = "Failed to load classes: \(error)"
        }
        isLoading = false
    }

    // ✅ Filtered list shown in UI
    var filteredClasses: [DanceClass] {
        var result = classes

        // Filter by level
        if selectedLevel != "All" {
            result = result.filter { $0.level.lowercased() == selectedLevel.lowercased() }
        }

        // Filter by search
        let q = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if !q.isEmpty {
            result = result.filter {
                $0.title.localizedCaseInsensitiveContains(q) ||
                $0.location.localizedCaseInsensitiveContains(q) ||
                $0.instructorName.localizedCaseInsensitiveContains(q)
            }
        }

        return result
    }
}
