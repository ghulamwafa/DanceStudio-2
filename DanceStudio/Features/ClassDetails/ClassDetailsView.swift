import SwiftUI

struct ClassDetailsView: View {
    let danceClass: DanceClass

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {

                Text(danceClass.title)
                    .font(.title2)
                    .bold()

                Text("\(danceClass.level) • \(danceClass.location)")
                    .foregroundStyle(.secondary)

                Text("Teacher: \(danceClass.instructorName)")
                Text("Price: \(danceClass.price) ₸")
                Text("Capacity: \(danceClass.capacity)")

                Divider()

                Text(danceClass.description)

                Spacer(minLength: 20)

                // ✅ Go to PickTimeView (Booking Flow)
                NavigationLink {
                    PickTimeView(classId: danceClass.id, classTitle: danceClass.title)
                } label: {
                    Text("Book Now")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.blue)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
            }
            .padding()
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
