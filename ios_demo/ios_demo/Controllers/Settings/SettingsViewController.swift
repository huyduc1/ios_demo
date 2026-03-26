import UIKit

class SettingsViewController: UIViewController {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Settings"
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private let languageBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Change Language", for: .normal)
        return btn
    }()
    
    private let exportBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Export Data to CSV", for: .normal)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        view.backgroundColor = .systemBackground
        
        setupUI()
    }
    
    private func setupUI() {
        let stack = UIStackView(arrangedSubviews: [titleLabel, languageBtn, exportBtn])
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        
        languageBtn.addTarget(self, action: #selector(handleLanguage), for: .touchUpInside)
        exportBtn.addTarget(self, action: #selector(handleExport), for: .touchUpInside)
    }
    
    @objc private func handleLanguage() {
        let alert = UIAlertController(title: "Language", message: "Select application language", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "English", style: .default, handler: { _ in
            // Localization logic would go here
            self.showToast(message: "Language set to English")
        }))
        alert.addAction(UIAlertAction(title: "Vietnamese", style: .default, handler: { _ in
            // Localization logic would go here
            self.showToast(message: "Language set to Vietnamese")
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    @objc private func handleExport() {
        let expenses = StorageService.shared.getExpenses()
        var csvText = "Type,Title,Amount,Date,Category,Note\n"
        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        
        for exp in expenses {
            let dateStr = formatter.string(from: exp.date)
            let row = "Expense,\(exp.title),\(String(format: "%.2f", exp.amount)),\(dateStr),\(exp.category),\(exp.note ?? "")\n"
            csvText.append(row)
        }
        
        // Save to document directory
        let fileName = "expenses_export.csv"
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(fileName)
        
        do {
            try csvText.write(to: path, atomically: true, encoding: .utf8)
            showToast(message: "Exported successfully to \(path.lastPathComponent)")
            
            // Allow sharing the exported file
            let activityVC = UIActivityViewController(activityItems: [path], applicationActivities: nil)
            present(activityVC, animated: true)
        } catch {
            showToast(message: "Failed to export data")
        }
    }
    
    private func showToast(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            alert.dismiss(animated: true)
        }
    }
}
