import SwiftUI

struct HomeView: View {
    @StateObject private var vm = HomeViewModel()
    @ObservedObject private var favorites = FavoritesStore.shared

    @State private var showFavoritesOnly = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {

                // ✅ Featured banner (Zapis style)
                FeaturedBannerView()

                // ✅ Search bar
                TextField("Search classes, teacher, location...", text: $vm.searchText)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)

                // ✅ Filter row: Levels + Favorites toggle
                HStack {
                    // Levels
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(vm.levels, id: \.self) { level in
                                Button {
                                    vm.selectedLevel = level
                                } label: {
                                    Text(level)
                                        .font(.subheadline)
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 14)
                                        .background(vm.selectedLevel == level ? Color.blue : Color.gray.opacity(0.15))
                                        .foregroundStyle(vm.selectedLevel == level ? .white : .primary)
                                        .clipShape(Capsule())
                                }
                            }
                        }
                        .padding(.leading)
                    }

                    // Favorites toggle
                    Button {
                        showFavoritesOnly.toggle()
                    } label: {
                        Image(systemName: showFavoritesOnly ? "heart.fill" : "heart")
                            .padding(10)
                            .background(Color.gray.opacity(0.15))
                            .clipShape(Circle())
                    }
                    .padding(.trailing)
                }

                // ✅ Content
                Group {
                    if vm.isLoading {
                        Spacer()
                        ProgressView("Loading...")
                        Spacer()
                    } else if let msg = vm.errorMessage {
                        Spacer()
                        VStack(spacing: 12) {
                            Text("Error").font(.headline)
                            Text(msg)
                                .font(.caption)
                                .multilineTextAlignment(.center)

                            Button("Try Again") {
                                Task { await vm.load() }
                            }
                        }
                        .padding()
                        Spacer()
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(finalList) { item in
                                    NavigationLink {
                                        ClassDetailsView(danceClass: item)
                                    } label: {
                                        ClassCardView(item: item)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
            .navigationTitle("Dance Studio")
            .task { await vm.load() }
        }
    }

    // ✅ Apply Favorites filter on top of ViewModel filters
    private var finalList: [DanceClass] {
        let base = vm.filteredClasses
        if showFavoritesOnly {
            return base.filter { favorites.isFavorite($0.id) }
        } else {
            return base
        }
    }
}

// MARK: - Featured Banner
struct FeaturedBannerView: View {
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Book in 2 taps")
                    .font(.headline)
                    .foregroundStyle(.white)
                Text("Choose a class • Choose time • Confirm")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.9))
            }

            Spacer()

            Image(systemName: "sparkles")
                .font(.title)
                .foregroundStyle(.white)
        }
        .padding()
        .background(Color.blue)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal)
    }
}

// MARK: - Card
struct ClassCardView: View {
    let item: DanceClass
    @ObservedObject private var favorites = FavoritesStore.shared

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(item.title)
                        .font(.headline)

                    Text("\(item.level) • \(item.location)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 6) {
                    Text("\(item.price) ₸")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    // ❤️ Favorite button
                    Button {
                        favorites.toggle(item.id)
                    } label: {
                        Image(systemName: favorites.isFavorite(item.id) ? "heart.fill" : "heart")
                            .foregroundStyle(favorites.isFavorite(item.id) ? Color.red : Color.primary)
                    }
                    .buttonStyle(.plain)
                }
            }

            Text("Teacher: \(item.instructorName)")
                .font(.caption)
                .foregroundStyle(.secondary)

            HStack {
                Text("Capacity: \(item.capacity)")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                Spacer()
                Text("Tap to book →")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.12))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
