//
//  LoginViewController.swift
//  ExploreUW
//
//  Created by iguest on 6/7/22.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var PasswordField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginAuthentication(_ sender: Any) {
        if loginField.text?.isEmpty == true {
            let settings = UIAlertController(title: "Enter email", message: "Missing email field", preferredStyle: .alert)
            settings.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(settings, animated: true)
            return
        }
        if PasswordField.text?.isEmpty == true {
            let settings = UIAlertController(title: "Enter password", message: "Missing password field", preferredStyle: .alert)
            settings.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(settings, animated: true)
            return
        }
        if isValidEmail(loginField.text!) == false {
            let settings = UIAlertController(title: "Enter correct domain", message: "Email needs to be @uw.edu", preferredStyle: .alert)
            settings.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(settings, animated: true)
            return
        }
        login()
    }
    
    func login() {
        Auth.auth().signIn(withEmail: loginField.text!, password: PasswordField.text!) { (authResult, error) in
            guard let user = authResult?.user, error == nil else  {
                print("Error \(error!.localizedDescription)")
                return
            }
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "tabView")
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
    func isValidEmail(_ email: String) -> Bool {
      let emailRegEx = "[A-Z0-9a-z._%+-]+@uw.edu"
      let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
      return emailPred.evaluate(with: email)
    }
    
    @IBAction func creatUser(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "signUp")
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
    
}
