import Foundation

class ExpenseViewModel {
    
    var expenses: [Expense] = []
    var onDataUpdated: (() -> Void)?
    
    func loadExpenses() {
        expenses = StorageService.shared.getExpenses().sorted(by: { $0.date > $1.date })
        onDataUpdated?()
    }
    
    func filterExpenses(query: String) {
        if query.isEmpty {
            loadExpenses()
        } else {
            let all = StorageService.shared.getExpenses()
            expenses = all.filter { $0.title.lowercased().contains(query.lowercased()) || $0.category.lowercased().contains(query.lowercased()) }
            expenses.sort(by: { $0.date > $1.date })
            onDataUpdated?()
        }
    }
    
    func addExpense(_ expense: Expense) {
        StorageService.shared.addExpense(expense)
        loadExpenses()
    }
    
    func updateExpense(_ expense: Expense) {
        StorageService.shared.updateExpense(expense)
        loadExpenses()
    }
    
    func deleteExpense(at index: Int) {
        let expense = expenses[index]
        StorageService.shared.deleteExpense(id: expense.id)
        loadExpenses()
    }
    
    func totalExpenses() -> Double {
        return expenses.reduce(0) { $0 + $1.amount }
    }
}
