import UIKit

class LoginViewController: UIViewController {
    
    let viewModel = AuthViewModel()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Expense Tracker"
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textAlignment = .center
        return label
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
    
    private let loginBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Login", for: .normal)
        btn.backgroundColor = .systemBlue
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 8
        return btn
    }()
    
    private let registerBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Don't have an account? Register", for: .normal)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        setupBindings()
    }
    
    private func setupUI() {
        let stack = UIStackView(arrangedSubviews: [titleLabel, emailField, passwordField, loginBtn, registerBtn])
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            loginBtn.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        loginBtn.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        registerBtn.addTarget(self, action: #selector(goToRegister), for: .touchUpInside)
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
    
    @objc private func handleLogin() {
        guard let email = emailField.text, let pass = passwordField.text else { return }
        viewModel.login(email: email, pass: pass)
    }
    
    @objc private func goToRegister() {
        let vc = RegisterViewController()
        present(vc, animated: true)
    }
}
