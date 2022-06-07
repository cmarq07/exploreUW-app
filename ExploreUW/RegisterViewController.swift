//
//  RegisterViewController.swift
//  ExploreUW
//
//  Created by Jerry CH Wu on 6/6/22.
//

import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var typeInput: UITextField!
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var descriptionInput: UITextField!
    @IBOutlet weak var registerBtn: UIButton!
    
    var didRegisterRSO: ((_ item: RSO) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitViews()
        let tap = UITapGestureRecognizer(target: self, action: #selector(registerBtnTapped(sender:)))
        registerBtn.addGestureRecognizer(tap)
    }
    
    func setInitViews() {
        nameInput.becomeFirstResponder()
        typeInput.delegate = self
        nameInput.delegate = self
        emailInput.delegate = self
        descriptionInput.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @objc func registerBtnTapped(sender: UITapGestureRecognizer) {
        if (nameInput.text?.isEmpty ?? false || typeInput.text?.isEmpty ?? false || emailInput.text?.isEmpty ?? false ||  descriptionInput.text?.isEmpty ?? false) {
            let alert = UIAlertController(title: nil, message: "Please fill in all the details", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            let result = RSO(name: nameInput.text!, description: descriptionInput.text!, type: typeInput.text!, email: emailInput.text!)
            didRegisterRSO?(result)
            self.dismiss(animated: true, completion: nil)
        }
    }
}
