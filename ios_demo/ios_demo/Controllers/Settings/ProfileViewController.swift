import UIKit

class ProfileViewController: UIViewController {
    
    private let nameField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Full Name"
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    private let budgetField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Target Budget ($)"
        tf.borderStyle = .roundedRect
        tf.keyboardType = .decimalPad
        return tf
    }()
    
    private let saveBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Save Profile", for: .normal)
        btn.backgroundColor = .systemGreen
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 8
        return btn
    }()
    
    private let logoutBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Logout", for: .normal)
        btn.backgroundColor = .systemRed
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 8
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        view.backgroundColor = .systemBackground
        
        setupUI()
        loadProfileData()
    }
    
    private func setupUI() {
        let stack = UIStackView(arrangedSubviews: [nameField, budgetField, saveBtn, logoutBtn])
        stack.axis = .vertical
        stack.spacing = 15
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            saveBtn.heightAnchor.constraint(equalToConstant: 50),
            logoutBtn.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        saveBtn.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        logoutBtn.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
    }
    
    private func loadProfileData() {
        if let user = AuthService.shared.currentUser {
            nameField.text = user.name
            budgetField.text = String(user.targetBudget)
        }
    }
    
    @objc private func handleSave() {
        guard let name = nameField.text, let budgetStr = budgetField.text, let budget = Double(budgetStr) else { return }
        if var user = AuthService.shared.currentUser {
            user.name = name
            user.targetBudget = budget
            AuthService.shared.updateProfile(user: user)
            
            let alert = UIAlertController(title: "Success", message: "Profile updated successfully.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
    
    @objc private func handleLogout() {
        AuthService.shared.logout()
        
        if let sceneDelegate = view.window?.windowScene?.delegate as? SceneDelegate {
            sceneDelegate.window?.rootViewController = LoginViewController()
            sceneDelegate.window?.makeKeyAndVisible()
        }
    }
}
