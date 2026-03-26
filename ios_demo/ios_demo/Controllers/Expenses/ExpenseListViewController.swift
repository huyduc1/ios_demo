import UIKit

class ExpenseListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    let viewModel = ExpenseViewModel()
    
    private let searchBar = UISearchBar()
    private let tableView = UITableView()
    
    private let totalLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Expenses"
        view.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        
        setupUI()
        setupBindings()
        viewModel.loadExpenses()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadExpenses()
    }
    
    private func setupUI() {
        searchBar.delegate = self
        searchBar.placeholder = "Search expenses..."
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        let stack = UIStackView(arrangedSubviews: [totalLabel, searchBar, tableView])
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupBindings() {
        viewModel.onDataUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                let total = self?.viewModel.totalExpenses() ?? 0
                self?.totalLabel.text = "Total: $\(String(format: "%.2f", total))"
            }
        }
    }
    
    @objc private func addTapped() {
        let vc = AddEditExpenseViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - TableView Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.expenses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let expense = viewModel.expenses[indexPath.row]
        cell.textLabel?.text = "\(expense.title) - $\(String(format: "%.2f", expense.amount))"
        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        cell.detailTextLabel?.text = "\(expense.category) | \(formatter.string(from: expense.date))"
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteExpense(at: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = AddEditExpenseViewController()
        vc.expenseToEdit = viewModel.expenses[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - SearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filterExpenses(query: searchText)
    }
}
