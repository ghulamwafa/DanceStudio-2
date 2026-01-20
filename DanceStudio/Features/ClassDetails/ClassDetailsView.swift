// DanceStudio/Features/ClassDetails/ClassDetailsView.swift

import SwiftUI

struct ClassDetailsView: View {
    let danceClass: DanceClass

    @ObservedObject private var session = SessionStore.shared
    @State private var showAuthSheet = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                // Title + basic info
                Text(danceClass.title)
                    .font(.title)
                    .bold()

                HStack(spacing: 8) {
                    Text(danceClass.level)
                        .font(.caption)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 10)
                        .background(levelColor(for: danceClass.level).opacity(0.15))
                        .foregroundColor(levelColor(for: danceClass.level))
                        .clipShape(Capsule())

                    Text(danceClass.location)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                HStack(spacing: 12) {
                    Label(danceClass.instructorName, systemImage: "person.fill")
                    Label("₸\(danceClass.price)", systemImage: "tenge.sign")
                    Label("Cap \(danceClass.capacity)", systemImage: "person.3.fill")
                }
                .font(.caption)
                .foregroundColor(.secondary)

                Divider()

                // ✅ Description (non-optional String)
                let desc = danceClass.description.trimmingCharacters(in: .whitespacesAndNewlines)
                if !desc.isEmpty {
                    Text(desc)
                        .font(.body)
                        .foregroundColor(.primary)
                } else {
                    Text("Join this class and improve your skills with professional instruction.")
                        .font(.body)
                        .foregroundColor(.primary)
                }

                Spacer(minLength: 24)

                // MARK: - Booking section
                if session.isLoggedIn {
                    Text("Booking")
                        .font(.headline)

                    Text("Select a time in the next screen and we will send a WhatsApp verification to you and the admin. No payment is required.")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    NavigationLink {
                        PickTimeView(danceClass: danceClass)
                    } label: {
                        Text("Book this class")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }

                } else {
                    Text("Login required to book")
                        .font(.headline)

                    Text("Please login or sign up to book this class. You can still view all class details without logging in.")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    Button {
                        showAuthSheet = true
                    } label: {
                        Text("Login / Sign Up")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                }

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Class Details")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showAuthSheet) {
            AuthView {
                showAuthSheet = false
            }
        }
    }

    private func levelColor(for level: String) -> Color {
        switch level {
        case "Beginner": return .green
        case "Intermediate": return .orange
        case "Advanced": return .purple
        default: return .blue
        }
    }
}
