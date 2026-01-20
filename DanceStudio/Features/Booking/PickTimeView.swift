// DanceStudio/Features/Booking/PickTimeView.swift

import SwiftUI

struct PickTimeView: View {
    let danceClass: DanceClass

    @ObservedObject private var session = SessionStore.shared
    @ObservedObject private var bookingStore = BookingStore.shared

    @State private var selectedDate = Date()
    @State private var selectedSlot: String? = nil
    @State private var showAlert = false
    @State private var alertMessage: String = ""

    // Admin WhatsApp is stored in the app (for your teacher explanation)
    private let adminWhatsAppNumber = "+77076569630"

    // Fixed time slots (change if you want)
    private let slotOptions = [
        "10:00", "12:00", "14:00", "16:00", "18:00", "20:00"
    ]

    var body: some View {
        Form {
            // CLASS INFO
            Section("Class") {
                Text(danceClass.title)
                    .font(.headline)
                Text("Instructor: \(danceClass.instructorName)")
                    .font(.subheadline)
                Text("Location: \(danceClass.location)")
                    .font(.subheadline)
            }

            // DATE
            Section("Select date") {
                DatePicker(
                    "Date",
                    selection: $selectedDate,
                    displayedComponents: [.date]
                )
            }

            // TIME SLOT
            Section("Select time slot") {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(slotOptions, id: \.self) { slot in
                            Button {
                                selectedSlot = slot
                            } label: {
                                Text(slot)
                                    .font(.caption)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 14)
                                    .background(
                                        selectedSlot == slot
                                        ? Color.orange
                                        : Color.gray.opacity(0.2)
                                    )
                                    .foregroundColor(selectedSlot == slot ? .white : .primary)
                                    .clipShape(Capsule())
                            }
                        }
                    }
                    .padding(.vertical, 4)
                }

                if selectedSlot == nil {
                    Text("Please select one of the available time slots.")
                        .font(.caption)
                        .foregroundColor(.red)
                }
            }

            // CONFIRM BUTTON
            Section("Confirm booking") {
                Button {
                    confirmBooking()
                } label: {
                    Text("Confirm Booking Automatically")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }

            // INFO
            Section {
                Text("After you confirm, the booking is automatically saved in the system and appears on the Bookings page. The admin WhatsApp number is stored inside the app.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .navigationTitle("Pick Time")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Booking Sent", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }

    // MARK: - Logic

    private func confirmBooking() {
        // 1) Must choose a time
        guard let slot = selectedSlot else {
            alertMessage = "Please select a time slot before confirming."
            showAlert = true
            return
        }

        // 2) Build "dateTime" string for your Booking model
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        let datePart = formatter.string(from: selectedDate)
        let dateTimeString = "\(datePart) at \(slot)"

        // 3) Amount from class price (Booking.amount is Int)
        let amountInt = Int(danceClass.price)

        // 4) Save booking using YOUR BookingStore API
        let newId = bookingStore.addBooking(
            classId: danceClass.id,
            classTitle: danceClass.title,
            dateTime: dateTimeString,
            amount: amountInt
        )

        // 5) For info only (student email)
        let studentEmail = session.email ?? "Guest user"

        // 6) Show confirmation
        alertMessage = """
        Your booking was sent to the admin automatically ✅

        Booking ID: \(newId)
        Class: \(danceClass.title)
        Date & Time: \(dateTimeString)

        Student: \(studentEmail)
        Admin WhatsApp (stored in app): \(adminWhatsAppNumber)
        """
        showAlert = true
    }
}
