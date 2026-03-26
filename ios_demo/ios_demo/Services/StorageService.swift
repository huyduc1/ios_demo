import Foundation

class StorageService {
    static let shared = StorageService()
    
    private let expensesKey = "expenses_list"
    
    func getExpenses() -> [Expense] {
        guard let data = UserDefaults.standard.data(forKey: expensesKey),
              let expenses = try? JSONDecoder().decode([Expense].self, from: data) else {
            return []
        }
        return expenses
    }
    
    func saveExpenses(_ expenses: [Expense]) {
        if let data = try? JSONEncoder().encode(expenses) {
            UserDefaults.standard.set(data, forKey: expensesKey)
        }
    }
    
    func addExpense(_ expense: Expense) {
        var expenses = getExpenses()
        expenses.append(expense)
        saveExpenses(expenses)
    }
    
    func updateExpense(_ expense: Expense) {
        var expenses = getExpenses()
        if let index = expenses.firstIndex(where: { $0.id == expense.id }) {
            expenses[index] = expense
            saveExpenses(expenses)
        }
    }
    
    func deleteExpense(id: String) {
        var expenses = getExpenses()
        expenses.removeAll(where: { $0.id == id })
        saveExpenses(expenses)
    }
}
