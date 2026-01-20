import SwiftUI

struct AuthView: View {
    let onLoginSuccess: () -> Void
    private let auth = AuthService()

    // Toggle Login/Register
    @State private var isRegister = false

    // Login fields
    @State private var loginEmail = ""
    @State private var loginPassword = ""

    // Register fields
    @State private var name = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var password = ""

    // Role + Level + Interests
    @State private var role: String = "student" // student/admin
    @State private var danceLevel: String = "Beginner"
    @State private var interests: Set<String> = []

    // Admin code (only when role=admin)
    @State private var adminCode = ""

    // UI state
    @State private var errorMessage: String?
    @State private var isLoading = false
    @State private var showSuccess = false

    private let levels = ["Beginner", "Intermediate", "Advanced"]
    private let interestOptions = ["Hip-Hop", "Salsa", "Ballet", "K-Pop", "Contemporary", "Breakdance"]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 14) {

                    Text("Dance Studio")
                        .font(.largeTitle)
                        .bold()

                    Picker("", selection: $isRegister) {
                        Text("Login").tag(false)
                        Text("Register").tag(true)
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)

                    if isRegister {
                        registerForm
                    } else {
                        loginForm
                    }

                    if let errorMessage {
                        Text(errorMessage)
                            .font(.caption)
                            .foregroundStyle(.red)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }

                    Spacer(minLength: 30)
                }
                .padding(.top, 20)
            }
            .navigationTitle("")
            .navigationBarHidden(true)
            .alert("Registered ✅", isPresented: $showSuccess) {
                Button("Go to Login") {
                    isRegister = false
                }
            } message: {
                Text("Now login with your email and password.")
            }
        }
    }

    // MARK: - Login
    private var loginForm: some View {
        VStack(spacing: 12) {
            TextField("Email", text: $loginEmail)
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)

            SecureField("Password", text: $loginPassword)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)

            Button {
                Task { await doLogin() }
            } label: {
                Text(isLoading ? "Loading..." : "Login")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.blue)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .disabled(isLoading)
            .padding(.horizontal)

            Text("Admin demo login: admin@demo.com / admin")
                .font(.caption2)
                .foregroundStyle(.secondary)
                .padding(.horizontal)
        }
    }

    private func doLogin() async {
        errorMessage = nil
        isLoading = true
        do {
            try await auth.login(email: loginEmail, password: loginPassword)
            onLoginSuccess()
        } catch {
            errorMessage = "\(error)"
        }
        isLoading = false
    }

    // MARK: - Register
    private var registerForm: some View {
        VStack(spacing: 12) {

            TextField("Full Name", text: $name)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)

            TextField("Email", text: $email)
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)

            TextField("Phone", text: $phone)
                .keyboardType(.phonePad)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)

            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)

            // Role picker
            Picker("Role", selection: $role) {
                Text("Student").tag("student")
                Text("Admin").tag("admin")
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)

            if role == "admin" {
                SecureField("Admin Code (example: 1234)", text: $adminCode)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
            }

            // Level picker
            VStack(alignment: .leading, spacing: 6) {
                Text("Dance Level")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal)

                Picker("Dance Level", selection: $danceLevel) {
                    ForEach(levels, id: \.self) { Text($0) }
                }
                .pickerStyle(.menu)
                .padding(.horizontal)
            }

            // Interests multi-select
            VStack(alignment: .leading, spacing: 8) {
                Text("Interests")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal)

                WrapChipsView(options: interestOptions, selected: $interests)
                    .padding(.horizontal)
            }

            Button {
                Task { await doRegister() }
            } label: {
                Text(isLoading ? "Loading..." : "Create Account")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.blue)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .disabled(isLoading)
            .padding(.horizontal)
        }
    }

    private func doRegister() async {
        errorMessage = nil
        isLoading = true

        let req = RegisterRequest(
            name: name,
            email: email,
            phone: phone,
            password: password,
            role: role,
            danceLevel: danceLevel,
            interests: Array(interests)
        )

        do {
            try await auth.register(req, adminCodeInput: adminCode)
            showSuccess = true

            // clear fields
            name = ""; email = ""; phone = ""; password = ""
            role = "student"; danceLevel = "Beginner"; interests = []; adminCode = ""
        } catch {
            errorMessage = "\(error)"
        }

        isLoading = false
    }
}

// MARK: - Chips UI (simple + stable)
struct WrapChipsView: View {
    let options: [String]
    @Binding var selected: Set<String>

    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 110), spacing: 10)], spacing: 10) {
            ForEach(options, id: \.self) { item in
                Button {
                    if selected.contains(item) {
                        selected.remove(item)
                    } else {
                        selected.insert(item)
                    }
                } label: {
                    Text(item)
                        .font(.subheadline)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .frame(maxWidth: .infinity)
                        .background(selected.contains(item) ? Color.blue : Color.gray.opacity(0.15))
                        .foregroundStyle(selected.contains(item) ? .white : .primary)
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)
            }
        }
    }
}
