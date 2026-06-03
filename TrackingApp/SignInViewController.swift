//
//  ViewController.swift
//  TrackingApp
//
//  Created by Tardes on 3/6/26.
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController {

    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var UsernameTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Si existe un usuario autenticado en Firebase,se salta la pantalla de Login y navega directamente al Home.
        if Auth.auth().currentUser != nil {
            performSegue(withIdentifier: "NavigateToHome", sender: nil)
        }
    }


    @IBAction func signIn(_ sender: Any) {
        let username = UsernameTextField.text ?? ""
        let password = PasswordTextField.text ?? ""
        Auth.auth().signIn(withEmail: username, password: password) { [unowned self] authResult, error in
            
            // Si ocurre un error durante el login.
            guard error == nil else {
                print ("Error creating user: \(error!)")
                
                // Muestra un Alert con la descripción del error devuelto por Firebase.
                let alert = UIAlertController(title: "Sign In error", message: error!.localizedDescription , preferredStyle: .alert)
                  alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                  self.present(alert, animated: true,completion: nil)
                
                return
            }
            
            // Si el login es correcto navega a la pantalla Home.
            shouldPerformSegue(withIdentifier: "NavigateToHome", sender: nil)
        }
        
    }
    
}

