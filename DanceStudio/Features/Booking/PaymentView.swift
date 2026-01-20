// DanceStudio/Features/Booking/PaymentView.swift

import SwiftUI

struct PaymentView: View {
    let classId: Int
    let classTitle: String
    let dateTime: String
    let amount: Int   // ₸

    @ObservedObject private var bookingStore = BookingStore.shared
    @Environment(\.dismiss) private var dismiss

    @State private var cardNumber: String = ""
    @State private var expiry: String = ""   // MM/YY
    @State private var cvc: String = ""      // 3 digits

    @State private var isProcessing: Bool = false
    @State private var showSuccess: Bool = false
    @State private var errorMessage: String?

    // Simple detected brand text
    private var cardBrand: String {
        let digits = cardNumber.filter { $0.isNumber }
        if digits.hasPrefix("4") {
            return "VISA"
        } else if digits.hasPrefix("5") {
            return "MasterCard"
        } else if digits.isEmpty {
            return "Card"
        } else {
            return "Card"
        }
    }

    var body: some View {
        ZStack {
            content

            if isProcessing {
                Color.black.opacity(0.15)
                    .ignoresSafeArea()

                ProgressView("Processing payment…")
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white)
                            .shadow(radius: 6)
                    )
            }
        }
        .navigationTitle("Payment")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Payment Successful", isPresented: $showSuccess) {
            Button("OK") {
                dismiss()
            }
        } message: {
            Text("Your booking has been created and marked as paid.")
        }
    }

    // MARK: - Main content (without overlay)

    private var content: some View {
        VStack(spacing: 16) {

            // SUMMARY
            VStack(alignment: .leading, spacing: 6) {
                Text(classTitle)
                    .font(.title3).bold()
                Text(dateTime)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text("Amount: ₸\(amount)")
                    .font(.headline)
                    .foregroundColor(.blue)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.blue.opacity(0.08))
            )

            // CARD FORM
            Form {
                Section {
                    HStack {
                        Text(cardBrand)
                            .font(.caption)
                            .padding(.vertical, 4)
                            .padding(.horizontal, 8)
                            .background(Color.gray.opacity(0.15))
                            .clipShape(Capsule())

                        Spacer()
                    }

                    TextField("Card Number", text: $cardNumber)
                        .keyboardType(.numberPad)
                        // ✅ updated 2-parameter onChange to avoid deprecation warning
                        .onChange(of: cardNumber) { _, newValue in
                            formatCardNumber(input: newValue)
                        }

                    HStack {
                        TextField("MM/YY", text: $expiry)
                            .keyboardType(.numbersAndPunctuation)

                        TextField("CVC", text: $cvc)
                            .keyboardType(.numberPad)
                    }
                } header: {
                    Text("Card Details")
                }
            }
            .frame(maxHeight: 260)

            if let errorMessage {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding(.top, 4)
            }

            Button {
                pay()
            } label: {
                Text("Pay ₸\(amount)")
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            .background(Color.blue)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .padding(.horizontal)
            .disabled(isProcessing)

            Spacer()
        }
        .padding()
    }

    // MARK: - Payment logic

    private func pay() {
        errorMessage = nil

        let digitsOnly = cardNumber.filter { $0.isNumber }
        let exp = expiry.trimmingCharacters(in: .whitespacesAndNewlines)
        let code = cvc.trimmingCharacters(in: .whitespacesAndNewlines)

        // Very simple realistic validation
        guard digitsOnly.count >= 12 && digitsOnly.count <= 19 else {
            errorMessage = "Invalid card number"
            return
        }

        guard exp.count >= 4 else {
            errorMessage = "Invalid expiry date"
            return
        }

        guard code.count >= 3 && code.count <= 4 else {
            errorMessage = "Invalid CVC"
            return
        }

        isProcessing = true

        // Fake delay to simulate network payment
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
            // 1) Create booking
            bookingStore.addBooking(
                classId: classId,
                classTitle: classTitle,
                dateTime: dateTime,
                amount: amount
            )

            // 2) Mark last booking as paid
            if let first = bookingStore.bookings.first {
                bookingStore.markPaid(bookingId: first.id)
            }

            isProcessing = false
            showSuccess = true
        }
    }

    // MARK: - Formatting

    private func formatCardNumber(input: String) {
        // Keep only digits
        let digits = input.filter { $0.isNumber }

        // Limit length to 19 digits (max card length)
        let limited = String(digits.prefix(19))

        // Group into 4-4-4-4-3 etc.
        var result = ""
        for (index, char) in limited.enumerated() {
            if index != 0 && index % 4 == 0 {
                result.append(" ")
            }
            result.append(char)
        }

        // Avoid infinite loop in onChange
        if result != cardNumber {
            cardNumber = result
        }
    }
}
