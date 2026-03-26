import UIKit

class AddEditExpenseViewController: UIViewController {
    
    var expenseToEdit: Expense?
    let viewModel = ExpenseViewModel()
    
    private let titleField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Title"
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    private let amountField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Amount"
        tf.borderStyle = .roundedRect
        tf.keyboardType = .decimalPad
        return tf
    }()
    
    private let categoryField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Category"
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    private let noteField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Notes (Optional)"
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    private let saveBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Save Expense", for: .normal)
        btn.backgroundColor = .systemBlue
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 8
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = expenseToEdit == nil ? "Add Expense" : "Edit Expense"
        
        setupUI()
        populateData()
    }
    
    private func setupUI() {
        let stack = UIStackView(arrangedSubviews: [titleField, amountField, categoryField, noteField, saveBtn])
        stack.axis = .vertical
        stack.spacing = 15
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            saveBtn.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        saveBtn.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
    }
    
    private func populateData() {
        if let exp = expenseToEdit {
            titleField.text = exp.title
            amountField.text = String(exp.amount)
            categoryField.text = exp.category
            noteField.text = exp.note
        }
    }
    
    @objc private func handleSave() {
        guard let titleTxt = titleField.text, !titleTxt.isEmpty,
              let amtTxt = amountField.text, let amount = Double(amtTxt),
              let catTxt = categoryField.text, !catTxt.isEmpty else {
            return
        }
        
        if var exp = expenseToEdit {
            exp.title = titleTxt
            exp.amount = amount
            exp.category = catTxt
            exp.note = noteField.text
            viewModel.updateExpense(exp)
        } else {
            let newExp = Expense(title: titleTxt, amount: amount, date: Date(), category: catTxt, note: noteField.text)
            viewModel.addExpense(newExp)
        }
        navigationController?.popViewController(animated: true)
    }
}
