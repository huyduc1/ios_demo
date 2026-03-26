import Foundation

struct Expense: Codable, Identifiable {
    var id: String
    var title: String
    var amount: Double
    var date: Date
    var category: String
    var note: String?
    
    init(id: String = UUID().uuidString, title: String, amount: Double, date: Date, category: String, note: String? = nil) {
        self.id = id
        self.title = title
        self.amount = amount
        self.date = date
        self.category = category
        self.note = note
    }
}
