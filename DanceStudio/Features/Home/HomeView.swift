import SwiftUI

// MARK: - Hero tabs

enum HeroTab {
    case classes
    case trainers
    case studios
}

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @ObservedObject private var session = SessionStore.shared

    @State private var searchText: String = ""
    @State private var selectedLevel: String = "All"

    @State private var favoriteIds: Set<Int> = []
    @State private var showFavoritesOnly: Bool = false

    // ✅ Our own "window" for the three hero buttons
    @State private var activeHeroOverlay: HeroTab? = nil

    // Login / sign-up sheet
    @State private var showAuthSheet: Bool = false

    private let levels = ["All", "Beginner", "Intermediate", "Advanced"]

    // MARK: - Directory data (22 items each)

    private let directoryClasses: [String] = [
        "Urban Groove Basics",
        "Latin Fire – Salsa",
        "Contemporary Flow",
        "Hip-Hop Vibes",
        "Classic Ballet Intro",
        "Jazz Fusion",
        "Street Style Fundamentals",
        "Afro Beats Energy",
        "Modern Moves",
        "Salsa Nights",
        "Tango Passion",
        "K-Pop Choreo Class",
        "Heels & Confidence",
        "Breakdance Basics",
        "Stretch & Flex",
        "Power Cardio Dance",
        "Couples Social Dance",
        "Kids Creative Dance",
        "Dance & CrossFit",
        "Zumba Party",
        "House Groove",
        "Slow Contemporary"
    ]

    private let directoryTrainers: [String] = [
        "Amina Suleimenova",
        "Lucas Martinez",
        "Sara Kadyrova",
        "Dmitry Petrov",
        "Elena Rakhimova",
        "Arman Toktar",
        "Julia Brown",
        "Nikita Voronov",
        "Emily Carter",
        "Sophia Lee",
        "Daniel Harris",
        "Olga Nikitina",
        "Michael Johnson",
        "Layla Ahmed",
        "Kenji Yamamoto",
        "Fatima Dosanova",
        "Alex Petrenko",
        "Isabella Garcia",
        "Noah Fischer",
        "Mia Zhang",
        "Ethan Walker",
        "Hana Kim"
    ]

    private let directoryStudios: [(name: String, city: String)] = [
        ("Studio Pulse", "Almaty"),
        ("Urban Beat Studio", "Astana"),
        ("Rhythm House", "Shymkent"),
        ("Gravity Dance Loft", "Karaganda"),
        ("Light & Motion Studio", "Pavlodar"),
        ("Downtown Dance Hub", "Almaty"),
        ("Skyline Dance Center", "Astana"),
        ("Move & Groove Hall", "Shymkent"),
        ("Elite Dance Academy", "Almaty"),
        ("Sunrise Dance Studio", "Taraz"),
        ("Kinetic Arts Studio", "Aktobe"),
        ("Vibe Nation Studio", "Almaty"),
        ("Center Stage Dance", "Astana"),
        ("Momentum Dance Space", "Pavlodar"),
        ("Studio Eclipse", "Karaganda"),
        ("City Lights Dance", "Almaty"),
        ("Freedom Dance Loft", "Shymkent"),
        ("Galaxy Dance Center", "Astana"),
        ("Mirror Room Studio", "Almaty"),
        ("Heartbeat Dance Lab", "Aktobe"),
        ("Infinity Dance Base", "Astana"),
        ("Rhythm Factory", "Almaty")
    ]

    // MARK: - Filtered classes (bottom list)

    private var filteredClasses: [DanceClass] {
        var list = viewModel.classes

        if showFavoritesOnly {
            list = list.filter { favoriteIds.contains($0.id) }
        }

        if selectedLevel != "All" {
            list = list.filter { $0.level == selectedLevel }
        }

        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if !query.isEmpty {
            let q = query.lowercased()
            list = list.filter { c in
                c.title.lowercased().contains(q)
                || c.level.lowercased().contains(q)
                || c.location.lowercased().contains(q)
                || c.instructorName.lowercased().contains(q)
            }
        }

        return list
    }

    // MARK: - Body

    var body: some View {
        NavigationStack {
            ZStack {
                // Background image
                GeometryReader { geo in
                    Image("HomeBackground")
                        .resizable()
                        .scaledToFill()
                        .frame(width: geo.size.width, height: geo.size.height)
                        .clipped()
                        .blur(radius: 3)
                        .opacity(0.6)
                }
                .ignoresSafeArea()

                Color.black.opacity(0.35)
                    .ignoresSafeArea()

                content

                // ✅ Custom "window" overlay for hero buttons
                heroOverlay
            }
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
        }
        .searchable(text: $searchText, prompt: "Search classes")
        .task {
            await viewModel.load()
        }
        // Only Auth uses sheet now
        .sheet(isPresented: $showAuthSheet) {
            AuthView {
                showAuthSheet = false
            }
        }
    }

    // MARK: - Main content

    private var content: some View {
        Group {
            if viewModel.isLoading {
                VStack {
                    ProgressView()
                    Text("Loading classes...")
                        .foregroundColor(.white.opacity(0.9))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            } else if viewModel.classes.isEmpty {
                VStack(spacing: 10) {
                    Text("No classes yet")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text("Add classes in Admin Panel.")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.9))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            } else {
                List {
                    // LOGIN ROW + HERO + STATS
                    Section {
                        loginRow
                            .listRowBackground(Color.clear)

                        heroHeader
                            .listRowBackground(Color.clear)

                        statsRow
                            .listRowBackground(Color.clear)
                    }

                    // Filters + favourites
                    Section {
                        levelFilterRow
                            .listRowBackground(Color.clear)

                        HStack {
                            Spacer()
                            Button {
                                showFavoritesOnly.toggle()
                            } label: {
                                HStack(spacing: 6) {
                                    Image(systemName: showFavoritesOnly ? "heart.fill" : "heart")
                                    Text("Favourites")
                                        .font(.caption)
                                }
                                .padding(.vertical, 6)
                                .padding(.horizontal, 10)
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(showFavoritesOnly ? Color.red.opacity(0.2)
                                                                 : Color.white.opacity(0.92))
                                )
                                .foregroundColor(showFavoritesOnly ? .red : .blue)
                            }
                        }
                        .listRowBackground(Color.clear)
                    }

                    // Classes list
                    Section(showFavoritesOnly ? "Favourite Classes" : "Available Classes") {
                        if filteredClasses.isEmpty {
                            VStack(spacing: 12) {
                                if showFavoritesOnly {
                                    Text("No favourite classes yet")
                                        .font(.headline)
                                    Text("Tap the hearts to add favourites.")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                        .multilineTextAlignment(.center)
                                } else {
                                    Text("No classes found")
                                        .font(.headline)
                                    Text("Try another level or clear the search.")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                        .multilineTextAlignment(.center)
                                }

                                Button {
                                    showFavoritesOnly = false
                                    selectedLevel = "All"
                                    searchText = ""
                                } label: {
                                    Text("Show all classes")
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.orange)
                                        .foregroundColor(.white)
                                        .clipShape(RoundedRectangle(cornerRadius: 14))
                                }
                                .padding(.horizontal, 40)
                            }
                            .padding(.vertical, 20)
                            .listRowBackground(Color.clear)
                        } else {
                            ForEach(filteredClasses) { c in
                                NavigationLink {
                                    ClassDetailsView(danceClass: c)
                                } label: {
                                    classRow(for: c)
                                }
                                .listRowBackground(Color.clear)
                            }
                        }
                    }
                }
                .scrollContentBackground(.hidden)
            }
        }
    }

    // MARK: - Login / Sign Up row

    private var loginRow: some View {
        HStack {
            if session.isLoggedIn {
                // ✅ Build a nice display name from email
                let displayName: String = {
                    guard let email = session.email?
                        .trimmingCharacters(in: .whitespacesAndNewlines),
                          !email.isEmpty
                    else {
                        return "Dancer"
                    }

                    // Take part before @
                    let rawNamePart = email.split(separator: "@").first ?? Substring(email)

                    // Replace . and _ with spaces, then capitalize each word
                    let cleaned = rawNamePart
                        .replacingOccurrences(of: ".", with: " ")
                        .replacingOccurrences(of: "_", with: " ")

                    let words = cleaned.split(separator: " ")
                    let capitalized = words.map { word in
                        let lower = word.lowercased()
                        return lower.prefix(1).uppercased() + lower.dropFirst()
                    }.joined(separator: " ")

                    return capitalized.isEmpty ? "Dancer" : capitalized
                }()

                VStack(alignment: .leading, spacing: 4) {
                    Text("Welcome back, \(displayName)!")
                        .font(.headline)
                        .foregroundColor(.white)

                    Text("You can book and manage your classes.")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                }

                Spacer()

                Button("Logout") {
                    session.logout()
                }
                .font(.caption)
                .padding(.vertical, 6)
                .padding(.horizontal, 10)
                .background(
                    Capsule().fill(Color.white.opacity(0.9))
                )
                .foregroundColor(.red)

            } else {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Welcome to DanceStudio")
                        .font(.subheadline)
                        .foregroundColor(.white)

                    Text("You can explore classes without logging in.")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                }

                Spacer()

                HStack(spacing: 8) {
                    Button("Login") {
                        showAuthSheet = true
                    }
                    .font(.caption)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 10)
                    .background(Capsule().fill(Color.white.opacity(0.95)))
                    .foregroundColor(.blue)

                    Button("Sign Up") {
                        showAuthSheet = true
                    }
                    .font(.caption)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 10)
                    .background(Capsule().fill(Color.orange))
                    .foregroundColor(.white)
                }
            }
        }
        .padding(.vertical, 4)
    }

    // MARK: - HERO HEADER (buttons removed)

    private var heroHeader: some View {
        VStack(spacing: 16) {
            Text("Revolution in the dance world")
                .font(.caption)
                .padding(.vertical, 6)
                .padding(.horizontal, 14)
                .background(Capsule().fill(Color.orange))
                .foregroundColor(.white)

            HStack(spacing: 0) {
                Text("Dance")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(.white)
                Text("Link")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(.orange)
            }

            Text("A platform connecting dancers, trainers, and studios. Find your style, book classes, and grow with the community.")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(.white.opacity(0.9))
                .padding(.horizontal, 8)

            // ⬇️ ⛔️ HERE we removed the three taps (buttons)
            // Previously: HStack with three Button { Start dancing / Our trainers / Our studios }
            // Now: nothing else here – just clean text hero
        }
        .padding(.top, 24)
        .padding(.bottom, 8)
        .padding(.horizontal, 12)
    }

    // MARK: - Stats row

    private var statsRow: some View {
        HStack(spacing: 12) {
            statCard(number: "500+", label: "Dance studios")
            statCard(number: "1200+", label: "Professional trainers")
            statCard(number: "15k+", label: "Active dancers")
        }
        .padding(.horizontal, 4)
        .padding(.bottom, 12)
    }

    private func statCard(number: String, label: String) -> some View {
        VStack(spacing: 4) {
            Text(number)
                .font(.headline)
                .foregroundColor(.orange)
            Text(label)
                .font(.caption)
                .foregroundColor(.white.opacity(0.9))
                .multilineTextAlignment(.center)
        }
        .padding(12)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.white.opacity(0.12))
        )
    }

    // MARK: - Class row card

    private func classRow(for c: DanceClass) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Rectangle()
                .fill(levelColor(for: c.level))
                .frame(width: 4)
                .cornerRadius(2)

            VStack(alignment: .leading, spacing: 6) {
                Text(c.title)
                    .font(.title3)
                    .bold()

                HStack(spacing: 6) {
                    Text(c.level)
                        .font(.caption2)
                        .padding(.vertical, 3)
                        .padding(.horizontal, 8)
                        .background(levelColor(for: c.level).opacity(0.15))
                        .foregroundColor(levelColor(for: c.level))
                        .clipShape(Capsule())

                    Text("• \(c.location)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                HStack(spacing: 8) {
                    Label(c.instructorName, systemImage: "person.fill")
                    Label("₸\(c.price)", systemImage: "tenge.sign")
                    Label("Cap \(c.capacity)", systemImage: "person.3.fill")
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }

            Spacer()

            Button {
                toggleFavorite(for: c.id)
            } label: {
                Image(systemName: isFavorite(c.id) ? "heart.fill" : "heart")
                    .font(.title2)
                    .foregroundColor(isFavorite(c.id) ? .red : .gray)
                    .padding(6)
            }
            .buttonStyle(.plain)
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.92))
                .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
        )
        .padding(.vertical, 4)
    }

    private func levelColor(for level: String) -> Color {
        switch level {
        case "Beginner": return .green
        case "Intermediate": return .orange
        case "Advanced": return .purple
        default: return .blue
        }
    }

    // MARK: - Level filter row

    private var levelFilterRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(levels, id: \.self) { level in
                    Button {
                        selectedLevel = level
                    } label: {
                        Text(level)
                            .font(.caption)
                            .padding(.vertical, 6)
                            .padding(.horizontal, 12)
                            .background(
                                selectedLevel == level
                                ? Color.white
                                : Color.white.opacity(0.7)
                            )
                            .foregroundColor(selectedLevel == level ? .blue : .primary)
                            .clipShape(Capsule())
                            .shadow(
                                color: selectedLevel == level ? .black.opacity(0.12) : .clear,
                                radius: 4, x: 0, y: 2
                            )
                    }
                }
            }
            .padding(.vertical, 4)
        }
    }

    // MARK: - Favourites helpers

    private func isFavorite(_ id: Int) -> Bool {
        favoriteIds.contains(id)
    }

    private func toggleFavorite(for id: Int) {
        if favoriteIds.contains(id) {
            favoriteIds.remove(id)
        } else {
            favoriteIds.insert(id)
        }
    }

    // MARK: - Hero overlay window (our custom "sheet")

    @ViewBuilder
    private var heroOverlay: some View {
        if let tab = activeHeroOverlay {
            ZStack {
                // Dark background
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            activeHeroOverlay = nil
                        }
                    }

                // Center card
                VStack(spacing: 0) {
                    HStack {
                        Text(overlayTitle(for: tab))
                            .font(.headline)
                        Spacer()
                        Button {
                            withAnimation {
                                activeHeroOverlay = nil
                            }
                        } label: {
                            Image(systemName: "xmark")
                                .font(.subheadline)
                                .padding(6)
                        }
                    }
                    .padding()
                    .background(Color.orange.opacity(0.9))
                    .foregroundColor(.white)

                    Divider()

                    ScrollView {
                        VStack(alignment: .leading, spacing: 8) {
                            switch tab {
                            case .classes:
                                ForEach(directoryClasses, id: \.self) { name in
                                    Text("• \(name)")
                                        .font(.subheadline)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.vertical, 2)
                                }

                            case .trainers:
                                ForEach(directoryTrainers, id: \.self) { name in
                                    Text("• \(name)")
                                        .font(.subheadline)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.vertical, 2)
                                }

                            case .studios:
                                ForEach(directoryStudios, id: \.name) { studio in
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(studio.name)
                                            .font(.subheadline).bold()
                                        Text(studio.city)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.vertical, 4)
                                }
                            }
                        }
                        .padding()
                    }
                }
                .frame(maxWidth: 360, maxHeight: 480)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .shadow(radius: 20)
                .padding()
            }
            .transition(.opacity)
        }
    }

    private func overlayTitle(for tab: HeroTab) -> String {
        switch tab {
        case .classes: return "Start Dancing"
        case .trainers: return "Our Trainers"
        case .studios: return "Our Studios"
        }
    }
}
