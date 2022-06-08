//
//  signUpViewController.swift
//  ExploreUW
//
//  Created by iguest on 6/7/22.
//

import UIKit
import FirebaseAuth

class signUpViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func signUpClicked(_ sender: Any) {
        if emailField.text?.isEmpty == true {
            let settings = UIAlertController(title: "Enter email", message: "Missing email field", preferredStyle: .alert)
            settings.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

            self.present(settings, animated: true)
            return
        }
        if passwordField.text?.isEmpty == true {
            let settings = UIAlertController(title: "Enter password", message: "Missing password field", preferredStyle: .alert)
            settings.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(settings, animated: true)
            return
        }
        if isValidEmail(email: emailField.text!) == false {
            let settings = UIAlertController(title: "Enter correct domain", message: "Email needs to be @uw.edu", preferredStyle: .alert)
            settings.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(settings, animated: true)
            return
        }
        signUp()
        
        
    }
    
    func isValidEmail( email: String) -> Bool {
      let emailRegEx = "[A-Z0-9a-z._%+-]+@uw.edu"
      let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
      return emailPred.evaluate(with: email)
    }
    
    func signUp() {
        Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) { authResult, error in
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

}
