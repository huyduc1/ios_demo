import Foundation

class AuthViewModel {
    
    var onLoginSuccess: (() -> Void)?
    var onError: ((String) -> Void)?
    
    func login(email: String, pass: String) {
        AuthService.shared.login(email: email, password: pass) { [weak self] success, errorMsg in
            if success {
                self?.onLoginSuccess?()
            } else {
                self?.onError?(errorMsg ?? "Unknown Error")
            }
        }
    }
    
    func register(name: String, email: String, pass: String) {
        AuthService.shared.register(name: name, email: email, password: pass) { [weak self] success, errorMsg in
            if success {
                self?.onLoginSuccess?()
            } else {
                self?.onError?(errorMsg ?? "Unknown Error")
            }
        }
    }
}
