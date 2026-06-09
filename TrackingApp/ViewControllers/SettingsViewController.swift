//
//  SettingsViewController.swift
//  TrackingApp
//
//  Created by Tardes on 5/6/26.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SettingsViewController: UITableViewController {
    
    var user: User? = nil
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!

    @IBOutlet weak var signOutCell: UITableViewCell!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageView.setProfileStyle()
        
        fetchUserData()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
    }
    
    func fetchUserData() {
        
        let userId = Auth.auth().currentUser!.uid
        
        Task {
            let db = Firestore.firestore()
            let docRef = db.collection("Users").document(userId)
            
            do {
                user = try await docRef.getDocument(as: User.self)
                
                DispatchQueue.main.async {
                    guard let user = self.user else { return }
                    
                    self.usernameLabel.text = user.fullName()
                    
                    if let url = user.profileImageUrl {
                        self.profileImageView.loadFrom(url: url)
                    }
                }
                
            } catch {
                print("Error decoding user: \(error)")
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Error signing out: \(error)")
        }
        navigationController?.navigationController?.popToRootViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let action = (indexPath.section, indexPath.row)
        
        switch action {
        case (0, 0):
            break
        case (1, 0):
            signOut()
            break
        default:
            break
        }
        
        // TODO: Si este codigo crece, considera calcular las coordenadas de las celdas (indexPath) dinamicamente usando el siguiente método:
        // tableView.indexPath(for: signOutCell)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NavigateToEditProfile" {
            let editProfileViewController = (segue.destination as! UINavigationController).viewControllers[0] as! ProfileEditViewController
            editProfileViewController.user = user
        }
    }
    
    @IBAction func endEditing(_ sender: UIStoryboardSegue) {
        fetchUserData()
    }


}

