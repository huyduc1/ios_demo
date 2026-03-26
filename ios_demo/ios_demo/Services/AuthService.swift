import Foundation

class AuthService {
    static let shared = AuthService()
    
    private let userKey = "current_user"
    private let isLoggedInKey = "is_logged_in"
    
    var currentUser: User? {
        guard let data = UserDefaults.standard.data(forKey: userKey),
              let user = try? JSONDecoder().decode(User.self, from: data) else {
            return nil
        }
        return user
    }
    
    var isLoggedIn: Bool {
        return UserDefaults.standard.bool(forKey: isLoggedInKey)
    }
    
    func register(name: String, email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        // Mock register logic.
        // In a real app we'd hash the password and store it securely. For demo, we just simulate success.
        let user = User(id: UUID().uuidString, name: name, email: email, targetBudget: 5000)
        
        if let data = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(data, forKey: userKey)
        }
        // Save mock password in user defaults for demo purposes
        UserDefaults.standard.set(password, forKey: "mock_password_\(email)")
        completion(true, nil)
    }
    
    func login(email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        let storedPassword = UserDefaults.standard.string(forKey: "mock_password_\(email)")
        if storedPassword == password {
            UserDefaults.standard.set(true, forKey: isLoggedInKey)
            completion(true, nil)
        } else {
            completion(false, "Invalid credentials")
        }
    }
    
    func logout() {
        UserDefaults.standard.set(false, forKey: isLoggedInKey)
    }
    
    func changePassword(email: String, oldPass: String, newPass: String, completion: @escaping (Bool, String?) -> Void) {
        let storedPassword = UserDefaults.standard.string(forKey: "mock_password_\(email)")
        if storedPassword == oldPass {
            UserDefaults.standard.set(newPass, forKey: "mock_password_\(email)")
            completion(true, nil)
        } else {
            completion(false, "Incorrect old password")
        }
    }
    
    func updateProfile(user: User) {
        if let data = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(data, forKey: userKey)
        }
    }
}
