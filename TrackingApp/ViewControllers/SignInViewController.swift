//
//  ViewController.swift
//  TrackingApp
//
//  Created by Tardes on 3/6/26.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import FirebaseFirestore

class SignInViewController: UIViewController {
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Si existe un usuario autenticado en Firebase,se salta la pantalla de Login y navega directamente al Home.
        if Auth.auth().currentUser != nil {
            performSegue(withIdentifier: "NavigateToHome", sender: nil)
        }
        
        //LogoImageView.layer.cornerRadius = 20
        //LogoImageView.layer.masksToBounds = true
    }
    
    
    @IBAction func signIn(_ sender: Any) {
        let username = usernameTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        Auth.auth().signIn(withEmail: username, password: password) { [unowned self] authResult, error in
            
            // Si ocurre un error durante el login.
            guard error == nil else {
                print ("Error signing user: \(error!)")
                
                // Muestra un Alert con la descripción del error devuelto por Firebase.
                let alert = UIAlertController(title: "Sign In error", message: error!.localizedDescription , preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true,completion: nil)
                
                return
            }
            
            // Si el login es correcto navega a la pantalla Home.
            performSegue(withIdentifier: "NavigateToHome", sender: nil)
        }
        
    }
    
    @IBAction func signInWithGoogle(_ sender: Any) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: self) {[unowned self] result, error in
            guard error == nil else {
                print ("Error signing in with Google: \(error!)")
                let alert = UIAlertController(title: "Sign In with Google error", message: error!.localizedDescription , preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true,completion: nil)
                return
            }
            
            guard let googleUser = result?.user, let idToken = googleUser.idToken?.tokenString else {
                print ("Error getting token from Google")
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,accessToken: googleUser.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { [unowned self] result, error in
                        guard error == nil else {
                    print ("Error signing user: \(error!)")
                    
                    // Muestra un Alert con la descripción del error devuelto por Firebase.
                    let alert = UIAlertController(title: "Sign In with Google error", message: error!.localizedDescription , preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true,completion: nil)
                    
                    return
                }
                
                // Inicio Firestore
                Task {
                    let userId = result!.user.uid
                    
                    let db = Firestore.firestore()
                    let docRef = db.collection("Users").document(userId)
                    
                    do {
                        let document = try await docRef.getDocument()
                        
                        if !document.exists {
                            let username = result!.user.email ?? result!.user.phoneNumber ?? "usuario\(userId)"
                            let firstName = googleUser.profile?.givenName ?? ""
                            let lastName = googleUser.profile?.familyName ?? ""
                            let profileImageUrl = googleUser.profile?.imageURL(withDimension: 400)?.absoluteString ?? ""
                            
                            
                            let user = User (id: userId,username: username, firstName: firstName, lastName: lastName, gender: -1, birthDate: nil, profileImageUrl: profileImageUrl)
                            
                            try db.collection( "Users" ).document( userId ).setData( from: user )
                        }
                        
                    }catch {
                        print("Error creating user from Google: \(error)")
                    }
                    
                    self.performSegue(withIdentifier: "NavigateToHome", sender: nil)
                }
                
                // Fin Firestore
                
            }
            
        }
    }
    
    
    @IBAction func signInWithFacebook(_ sender: Any) {
    }
    
    @IBAction func signInWithApple(_ sender: Any) {
    }
    
}

