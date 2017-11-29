//
//  RegisterViewController.swift
//  Treino
//
//  Created by Fernando Cortez on 29/11/17.
//  Copyright © 2017 Fernando Cortez. All rights reserved.
//

import UIKit
import SVProgressHUD
import FirebaseAuth

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var senhaTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()        
    }
    
    @IBAction func btnRegisterPressed(_ sender: UIButton) {
        
        SVProgressHUD.show()
        
        Auth.auth().createUser(withEmail: emailTextField.text!, password: senhaTextField.text!) { (user, error) in
            
            SVProgressHUD.dismiss()
            
            if let errorUser = error {
                print(errorUser)
            }
            else {
                print("Registration Sucesseful")
                
                self.performSegue(withIdentifier: "goToPrincipal", sender: self)
            }
        }
    }
}
