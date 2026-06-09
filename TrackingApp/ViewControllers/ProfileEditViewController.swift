//
//  ProfileEditViewController.swift
//  TrackingApp
//
//  Created by Tardes on 8/6/26.
//

import UIKit
import FirebaseFirestore

class ProfileEditViewController: UITableViewController {
    
    var user: User!
    
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var birthDatePicker: UIDatePicker!
    @IBOutlet weak var genderButton: UIButton!
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let menu = UIMenu(children: [
            
            UIAction(
                title: "Not specified",
                state: user.gender == -1 ? .on : .off
            ) { _ in
                self.user.gender = -1
            },
            
            UIMenu(options: .displayInline, children: [
                
                UIAction(
                    title: "Male",
                    state: user.gender == 0 ? .on : .off
                ) { _ in
                    self.user.gender = 0
                },
                
                UIAction(
                    title: "Female",
                    state: user.gender == 1 ? .on : .off
                ) { _ in
                    self.user.gender = 1
                },
                
                UIAction(
                    title: "Other",
                    state: user.gender == 2 ? .on : .off
                ) { _ in
                    self.user.gender = 2
                }
                
            ])
        ])
        
        genderButton.menu = menu
        
        /*genderButton.menu = UIMenu(children: ["Male", "Female", "Other"].map({ s in
         return UIAction(title: s) { [weak self] _ in
         print("user selected \(s)")
         }
         }))*/
        
        profileImageView.setProfileStyle()
        if let url = user.profileImageUrl {
            profileImageView.loadFrom(url: url)
        }
        
        firstNameTextField.text = user.firstName
        lastNameTextField.text = user.lastName
        //genderSegmentedControl.selectedSegmentIndex = user.gender == -1 ? 2 : user.gender
        if let birthDate = user.birthDate {
            birthDatePicker.date = Date(milliseconds: birthDate)
        }
        
        usernameTextField.text = user.username
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                if let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) {
                    // Método más agresivo: ocultar la línea
                    for subview in cell.subviews {
                        if subview.frame.height <= 2 && subview.frame.minY > 0 {
                            subview.isHidden = true
                        }
                    }
                }
            }
    }
    
    @IBAction func saveProfile(_ sender: Any) {
        user.firstName = firstNameTextField.text ?? ""
        user.lastName = lastNameTextField.text ?? ""
        //user.gender = genderSegmentedControl.selectedSegmentIndex
        user.birthDate = birthDatePicker.date.millisecondsSince1970
        
        do {
            let db = Firestore.firestore()
            try db.collection("Users").document(user.id).setData(from: user)
        } catch let error {
            print("Error writing user to Firestore: \(error)")
        }
        
        performSegue(withIdentifier: "UnwindSegue", sender: self)
    }
    
}
