//
//  SignUpViewController.swift
//  TrackingApp
//
//  Created by Tardes on 3/6/26.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var genderSegmenteControl: UISegmentedControl!
    @IBOutlet weak var birthdayPicker: UIDatePicker!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func signUp(_ sender: Any) {
        let username = usernameTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        let passwordConfirm = passwordConfirmTextField.text ?? ""
        
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
            
            createUser(withId: authResult!.user.uid)
            
            
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
    
    func createUser(withId id: String){
        let username = usernameTextField.text ?? ""
        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        let birthDate = birthdayPicker.date.millisecondsSince1970
        let gender = genderSegmenteControl.selectedSegmentIndex
        
        let user = User(id: id, username: username, firstName: firstName, lastName: lastName, gender: gender, birthDate: birthDate, profileImageUrl: nil)
        
        let db = Firestore.firestore()
        
        do {
            try db.collection("Users").document(id).setData(from: user)
        } catch let error {
            print("Error writing user to Firestore: \(error)")
        }
    }
    
    

}
