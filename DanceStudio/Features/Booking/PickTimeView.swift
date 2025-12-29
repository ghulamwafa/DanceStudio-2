import SwiftUI

struct PickTimeView: View {
    let classId: Int
    let classTitle: String

    @State private var slots: [TimeSlot] = []
    @State private var selected: TimeSlot?

    @State private var showAlert = false

    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var store = BookingStore.shared
    @ObservedObject private var router = TabRouter.shared

    var body: some View {
        VStack(spacing: 12) {

            List {
                Section("Available Times") {
                    ForEach(slots.filter { $0.isAvailable }) { slot in
                        HStack {
                            Text(slot.dateTime)
                            Spacer()
                            if selected?.id == slot.id {
                                Image(systemName: "checkmark.circle.fill")
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selected = slot
                        }
                    }
                }
            }

            Button {
                if let selected {
                    store.addBooking(classId: classId, classTitle: classTitle, dateTime: selected.dateTime)
                    showAlert = true
                }
            } label: {
                Text("Confirm Booking")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(selected == nil ? .gray : .blue)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .disabled(selected == nil)
            .padding()
        }
        .navigationTitle("Choose Time")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            slots = MockSlots.slots(for: classId)
        }
        .alert("Booking Confirmed ✅", isPresented: $showAlert) {
            Button("Go to Bookings") {
                dismiss()
                router.selectedTab = 1
            }
            Button("OK") {
                dismiss()
            }
        } message: {
            Text("You booked \(classTitle).")
        }
    }
}
