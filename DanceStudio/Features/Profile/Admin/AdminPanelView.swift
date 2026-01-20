// DanceStudio/Features/Profile/Admin/AdminPanelView.swift

import SwiftUI

struct AdminPanelView: View {
    @ObservedObject private var classStore = AdminClassStore.shared
    @ObservedObject private var timeStore = TimeSlotStore.shared
    @ObservedObject private var instructorStore = InstructorStore.shared
    @ObservedObject private var bookingStore = BookingStore.shared

    @State private var showAddClass = false
    @State private var showAddInstructor = false
    @State private var selectedClass: DanceClass?

    var body: some View {
        List {

            //  Payments (Admin actions)
            Section("Payments (Bookings)") {
                if bookingStore.bookings.isEmpty {
                    Text("No bookings yet.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(bookingStore.bookings) { b in
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text(b.classTitle)
                                    .font(.headline)
                                Spacer()
                                Text("\(b.amount) ₸")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }

                            Text(b.dateTime)
                                .font(.caption)
                                .foregroundStyle(.secondary)

                            HStack {
                                Text("Status: \(b.status)")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)

                                Spacer()

                                Text("Payment: \(b.paymentStatus.uppercased())")
                                    .font(.caption2)
                                    .foregroundStyle(b.paymentStatus == "paid" ? .green : .secondary)
                            }

                            HStack(spacing: 10) {
                                Button {
                                    bookingStore.markPaid(bookingId: b.id)
                                } label: {
                                    Text("Mark Paid")
                                }
                                .buttonStyle(.borderedProminent)
                                .disabled(b.paymentStatus == "paid" || b.paymentStatus == "refunded")

                                Button(role: .destructive) {
                                    bookingStore.refund(bookingId: b.id)
                                } label: {
                                    Text("Refund")
                                }
                                .buttonStyle(.bordered)
                                .disabled(b.paymentStatus != "paid")
                            }
                            .padding(.top, 4)
                        }
                        .padding(.vertical, 6)
                    }
                }
            }

            // ✅ Trainers
            Section("Trainers / Instructors") {
                ForEach(instructorStore.instructors) { t in
                    NavigationLink {
                        EditInstructorView(instructor: t)
                    } label: {
                        VStack(alignment: .leading, spacing: 3) {
                            Text(t.name).font(.headline)
                            Text(t.isIndependent ? "Independent" : "Studio-employed")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .onDelete { indexSet in
                    for i in indexSet {
                        instructorStore.delete(id: instructorStore.instructors[i].id)
                    }
                }

                Button {
                    showAddInstructor = true
                } label: {
                    Label("Add Trainer", systemImage: "plus")
                }
            }

            // ✅ Classes (tap -> edit)
            Section("Classes") {
                ForEach(classStore.classes) { c in
                    VStack(alignment: .leading, spacing: 6) {

                        NavigationLink {
                            // 🔧 FIXED LABEL HERE (was original:, now danceClass:)
                            EditClassView(danceClass: c)
                        } label: {
                            VStack(alignment: .leading, spacing: 3) {
                                Text(c.title).font(.headline)
                                Text("\(c.level) • \(c.location) • \(c.instructorName)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }

                        Button {
                            selectedClass = c
                        } label: {
                            Text(selectedClass?.id == c.id ? "✅ Selected for Time Slots" : "Select for Time Slots")
                                .font(.caption)
                                .foregroundStyle(.blue)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.vertical, 4)
                }
                .onDelete { indexSet in
                    for i in indexSet {
                        classStore.delete(id: classStore.classes[i].id)
                    }
                }

                Button {
                    showAddClass = true
                } label: {
                    Label("Add New Class", systemImage: "plus")
                }
            }

            // ✅ Time slots for selected class
            if let selectedClass {
                Section("Time Slots: \(selectedClass.title)") {
                    ForEach(timeStore.slots(for: selectedClass.id), id: \.self) { t in
                        HStack {
                            NavigationLink {
                                EditTimeSlotView(classId: selectedClass.id, oldText: t)
                            } label: {
                                Text(t)
                            }

                            Spacer()

                            Button(role: .destructive) {
                                timeStore.removeSlot(classId: selectedClass.id, timeText: t)
                            } label: {
                                Image(systemName: "trash")
                            }
                            .buttonStyle(.plain)
                        }
                    }

                    NavigationLink {
                        AddTimeSlotView(classId: selectedClass.id)
                    } label: {
                        Label("Add Time Slot", systemImage: "clock.badge.plus")
                    }
                }
            }

            // ✅ Students (delete)
            Section("Students") {
                let students = UserStore.shared.studentsOnly()
                if students.isEmpty {
                    Text("No students yet.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(students) { u in
                        VStack(alignment: .leading, spacing: 3) {
                            Text(u.name).font(.headline)
                            Text("\(u.email) • \(u.danceLevel)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            if !u.interests.isEmpty {
                                Text("Interests: \(u.interests.joined(separator: ", "))")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    .onDelete { indexSet in
                        for i in indexSet {
                            UserStore.shared.deleteUser(id: students[i].id)
                        }
                    }
                }
            }
        }
        .navigationTitle("Admin Panel")
        .sheet(isPresented: $showAddClass) {
            AddClassView()
        }
        .sheet(isPresented: $showAddInstructor) {
            AddInstructorView()
        }
    }
}
