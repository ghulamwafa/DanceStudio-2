import Foundation
import UIKit

/// Opens WhatsApp (or browser → WhatsApp) with pre-filled message to the admin.
/// IMPORTANT: replace `adminPhone` with your REAL admin WhatsApp number (no +, no spaces).
func openWhatsAppToAdmin(with message: String) {
    // 👉 CHANGE THIS to your admin/teacher WhatsApp number
    let adminPhone = "77076569630"  // example: +7 700 123 45 67 → "77001234567"

    guard let encoded = message.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
        return
    }

    let urlString = "https://wa.me/\(adminPhone)?text=\(encoded)"

    if let url = URL(string: urlString) {
        UIApplication.shared.open(url)
    }
}
