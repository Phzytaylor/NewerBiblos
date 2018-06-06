//
//  UserSettingsViewController.swift
//  biblos
//
//  Created by Taylor Simpson on 1/22/18.
//  Copyright © 2018 Taylor Simpson. All rights reserved.
//

import UIKit
import Eureka
import FirebaseAuth
import FBSDKLoginKit
import PMAlertController


class UserSettingsViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.backgroundColor = .black
        
        form +++ Section("Choose Your User Type")
        
            <<< LabelRow() {row in
                row.title = "Change User Type"
                
                }.onCellSelection({ (cell, row) in
                    self.performSegue(withIdentifier: "userType", sender: UserSettingsViewController())
                })
        
        form +++ Section("App Tutorial")
        
            <<< LabelRow() { row in
                row.title = "Tap to view any of the tutorials"
                }.onCellSelection({ (cell, row) in
                   
                     var tutboard = UIStoryboard(name: "Tutorials", bundle: nil)
                    
                    let tutAlert = PMAlertController(title: "Tutorial", description: "Select the tutorial you would like to see.", image: nil, style: .alert)
                    
                    tutAlert.addAction(PMAlertAction(title: "Search tutorial", style: PMAlertActionStyle.default , action: {
                        self.present(tutboard.instantiateViewController(withIdentifier: "SearchTut"), animated: true, completion: nil)
                    }))
                    
                    tutAlert.addAction(PMAlertAction(title: "Messaging tutorial", style: PMAlertActionStyle.default , action: {
                        self.present(tutboard.instantiateViewController(withIdentifier: "chatTut"), animated: true, completion: nil)
                    }))
                    
                    tutAlert.addAction(PMAlertAction(title: "Book actions tutorial", style: PMAlertActionStyle.default , action: {
                        self.present(tutboard.instantiateViewController(withIdentifier: "bookTut"), animated: true, completion: nil)
                    }))
                    
                    tutAlert.addAction(PMAlertAction(title: "Book map tutorial", style: PMAlertActionStyle.default , action: {
                        self.present(tutboard.instantiateViewController(withIdentifier: "mapTut"), animated: true, completion: nil)
                    }))
                    
                    tutAlert.addAction(PMAlertAction(title: "Uploading tutorial", style: PMAlertActionStyle.default , action: {
                        self.present(tutboard.instantiateViewController(withIdentifier: "uploadTut"), animated: true, completion: nil)
                    }))
                    
                    self.present(tutAlert, animated: true, completion: nil)
                    
                })
        
       
       form +++ Section("Logout?")
            <<< LabelRow() {row in
                row.title = "Logout"
                }.onCellSelection({ (cell, row) in
                    
                    //signs user out of firebase app
                    
                    try! Auth.auth().signOut()
                    
                    //sign user out of facebook app
                    
                    FBSDKAccessToken.setCurrent(nil)
                    
                    let mainStoryboard: UIStoryboard = UIStoryboard(name:"Main", bundle: nil)
                    
                    let viewController: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "LoginView")
                    
                    self.present(viewController, animated: true, completion: nil)
                })
        
        // Do any additional setup after loading the view.
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
