//
//  SignUpViewController.swift
//  TrackingApp
//
//  Created by Tardes on 3/6/26.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var PasswordConfirmTextField: UITextField!
    @IBOutlet weak var UsernameTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func signUp(_ sender: Any) {
        let username = UsernameTextField.text ?? ""
        let password = PasswordTextField.text ?? ""
        let passwordConfirm = PasswordConfirmTextField.text ?? ""
        
        if password != passwordConfirm {
            let alert = UIAlertController(title: "Sign Up error", message: "Passwords do not match" , preferredStyle: .alert)
            present(alert, animated: true,completion: nil)
            return
        }
        
        Auth.auth().createUser(withEmail: username, password: password) { [unowned self] authResult, error in
            
            guard error == nil else {
                print ("Error creating user: \(error!)")
                
                let alert = UIAlertController(title: "Sign Up error", message: error!.localizedDescription , preferredStyle: .alert)
                  alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                  self.present(alert, animated: true,completion: nil)
                
                return
            }
          let alert = UIAlertController(title: "Sign Up", message:"Account created sucessfully" , preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in
                self.navigationController?.popViewController(animated: true)
                // Hay 3 formas principales de volver atrás en un UINavigationController:
                //
                // 1. popViewController(animated:)
                //    Cierra la pantalla actual y vuelve a la pantalla anterior.
                //
                // 2. popToViewController(_:animated:)
                //    Vuelve a una pantalla específica del Navigation Stack,
                //    saltándose las pantallas intermedias.
                //
                // 3. popToRootViewController(animated:)
                //    Vuelve directamente a la pantalla inicial (Root View Controller),
                //    cerrando todas las pantallas abiertas en la navegación.
                
            }))
            self.present(alert, animated: true,completion: nil)
        }
    }

}
