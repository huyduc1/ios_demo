import UIKit

class RegisterViewController: UIViewController {
    
    let viewModel = AuthViewModel()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Register"
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private let nameField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Full Name"
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    private let emailField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.borderStyle = .roundedRect
        tf.keyboardType = .emailAddress
        return tf
    }()
    
    private let passwordField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    private let registerBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Register", for: .normal)
        btn.backgroundColor = .systemGreen
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 8
        return btn
    }()
    
    private let backBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Back to Login", for: .normal)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        setupBindings()
    }
    
    private func setupUI() {
        let stack = UIStackView(arrangedSubviews: [titleLabel, nameField, emailField, passwordField, registerBtn, backBtn])
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            registerBtn.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        registerBtn.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        backBtn.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
    }
    
    private func setupBindings() {
        viewModel.onLoginSuccess = { [weak self] in
            DispatchQueue.main.async {
                let mainTabBar = MainTabBarController()
                mainTabBar.modalPresentationStyle = .fullScreen
                self?.present(mainTabBar, animated: true)
            }
        }
        
        viewModel.onError = { [weak self] errorMsg in
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Error", message: errorMsg, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(alert, animated: true)
            }
        }
    }
    
    @objc private func handleRegister() {
        guard let name = nameField.text, let email = emailField.text, let pass = passwordField.text else { return }
        viewModel.register(name: name, email: email, pass: pass)
    }
    
    @objc private func handleBack() {
        dismiss(animated: true)
    }
}
