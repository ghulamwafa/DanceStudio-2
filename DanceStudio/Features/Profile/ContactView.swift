import SwiftUI

struct ContactView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {

            Text("Support")
                .font(.title2)
                .bold()

            Text("If you have questions, contact the studio.")
                .foregroundStyle(.secondary)

            Divider()

            HStack(spacing: 10) {
                Image(systemName: "phone.fill")
                Text("+7 7076569630")
            }

            HStack(spacing: 10) {
                Image(systemName: "envelope.fill")
                Text("abbas.wafa2023@gmail.com")
            }

            HStack(spacing: 10) {
                Image(systemName: "location.fill")
                Text("Almaty, Kazakhstan")
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Contact")
        .navigationBarTitleDisplayMode(.inline)
    }
}
