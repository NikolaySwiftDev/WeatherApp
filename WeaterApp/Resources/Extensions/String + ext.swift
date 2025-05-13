import Foundation

extension String {
    func getTime() -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy-MM-dd HH:mm"
        formatter.locale = Locale(identifier: "en_US_POSIX")

        guard let date = formatter.date(from: self) else { return nil }

        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
    func getDate() -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy-MM-dd HH:mm"
        formatter.locale = Locale(identifier: "en_US_POSIX")

        guard let date = formatter.date(from: self) else { return nil }

        formatter.dateFormat = "d MMMM"
        return formatter.string(from: date)
    }
    
    func getFullDate() -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")

        guard let date = formatter.date(from: self) else { return nil }

        formatter.locale = Locale(identifier: "en_US")
        formatter.dateStyle = .medium

        return formatter.string(from: date)
    }
}
