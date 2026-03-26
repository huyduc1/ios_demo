import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let expensesVC = UINavigationController(rootViewController: ExpenseListViewController())
        expensesVC.tabBarItem = UITabBarItem(title: "Expenses", image: UIImage(systemName: "list.bullet"), tag: 0)
        
        let reportsVC = UINavigationController(rootViewController: ReportsViewController())
        reportsVC.tabBarItem = UITabBarItem(title: "Reports", image: UIImage(systemName: "chart.bar"), tag: 1)
        
        let profileVC = UINavigationController(rootViewController: ProfileViewController())
        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.circle"), tag: 2)
        
        let settingsVC = UINavigationController(rootViewController: SettingsViewController())
        settingsVC.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), tag: 3)
        
        viewControllers = [expensesVC, reportsVC, profileVC, settingsVC]
        tabBar.backgroundColor = .systemBackground
    }
}
