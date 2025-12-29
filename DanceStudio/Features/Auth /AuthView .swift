import SwiftUI

struct AuthView: View {
    let onLoggedIn: () -> Void

    @State private var isLogin = true

    // Login
    @State private var email = ""
    @State private var password = ""

    // Register
    @State private var name = ""
    @State private var phone = ""
    @State private var danceLevel = "Beginner"
    @State private var interestsText = "Hip-Hop, Salsa"

    @State private var message: String?
    @State private var isLoading = false

    private let service = AuthService()

    var body: some View {
        NavigationStack {
            VStack(spacing: 14) {

                Text("Dance Studio")
                    .font(.largeTitle).bold()

                Picker("", selection: $isLogin) {
                    Text("Login").tag(true)
                    Text("Register").tag(false)
                }
                .pickerStyle(.segmented)

                if isLogin {
                    Group {
                        TextField("Email", text: $email)
                            .textInputAutocapitalization(.never)
                            .keyboardType(.emailAddress)
                            .textContentType(.username)

                        SecureField("Password", text: $password)
                            .textContentType(.password)
                    }
                    .textFieldStyle(.roundedBorder)

                } else {
                    Group {
                        TextField("Full Name", text: $name)
                        TextField("Phone", text: $phone)
                        TextField("Email", text: $email)
                            .textInputAutocapitalization(.never)
                            .keyboardType(.emailAddress)

                        SecureField("Password", text: $password)

                        TextField("Dance Level (Beginner/Intermediate/Advanced)", text: $danceLevel)
                        TextField("Interests (comma separated)", text: $interestsText)
                    }
                    .textFieldStyle(.roundedBorder)
                }

                Button {
                    Task { await submit() }
                } label: {
                    if isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .padding()
                    } else {
                        Text(isLogin ? "Login" : "Register")
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                }
                .background(.blue)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .disabled(isLoading)

                if let message {
                    Text(message)
                        .font(.footnote)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.red)
                        .padding(.top, 6)
                }

                Spacer()
            }
            .padding()
        }
    }

    private func submit() async {
        message = nil
        isLoading = true
        defer { isLoading = false }

        do {
            if isLogin {
                try await service.login(email: email, password: password)
                onLoggedIn()
            } else {
                let interests = interestsText
                    .split(separator: ",")
                    .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                    .filter { !$0.isEmpty }

                let req = RegisterRequest(
                    name: name,
                    email: email,
                    phone: phone,
                    password: password,
                    danceLevel: danceLevel,
                    interests: interests
                )

                try await service.register(req)
                message = "✅ Registered! Now login."
                isLogin = true
            }
        } catch {
            message = "❌ \(error)"
        }
    }
}
