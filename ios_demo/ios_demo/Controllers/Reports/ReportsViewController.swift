import UIKit

class ReportsViewController: UIViewController {
    
    let viewModel = ExpenseViewModel()
    
    private let summaryLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Reports"
        view.backgroundColor = .systemBackground
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadExpenses()
        generateReport()
    }
    
    private func setupUI() {
        view.addSubview(summaryLabel)
        summaryLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            summaryLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            summaryLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            summaryLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func generateReport() {
        let total = viewModel.totalExpenses()
        let count = viewModel.expenses.count
        
        if count == 0 {
            summaryLabel.text = "No expenses recorded yet."
            return
        }
        
        // Group by category
        var categoryTotals: [String: Double] = [:]
        for expense in viewModel.expenses {
            categoryTotals[expense.category, default: 0] += expense.amount
        }
        
        var reportText = "Total Expenses: $\(String(format: "%.2f", total))\n"
        reportText += "Number of Transactions: \(count)\n\n"
        reportText += "--- By Category ---\n"
        for (cat, amt) in categoryTotals.sorted(by: { $0.value > $1.value }) {
            reportText += "\(cat): $\(String(format: "%.2f", amt))\n"
        }
        
        // Target Budget comparison logic
        let budget = AuthService.shared.currentUser?.targetBudget ?? 0
        reportText += "\nTarget Budget: $\(String(format: "%.2f", budget))\n"
        let diff = budget - total
        if diff >= 0 {
            reportText += "You are under budget by $\(String(format: "%.2f", diff))."
        } else {
            reportText += "You exceeded budget by $\(String(format: "%.2f", abs(diff)))."
        }
        
        summaryLabel.text = reportText
    }
}
