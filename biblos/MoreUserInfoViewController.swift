//
//  TutorialViewOneViewController.swift
//  biblos
//
//  Created by Taylor Simpson on 1/17/18.
//  Copyright © 2018 Taylor Simpson. All rights reserved.
//

import UIKit
import Eureka
import FirebaseAuth
import FirebaseDatabase


class MoreUserInfoViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.backgroundColor = .black
        
        form +++ Section("Choose Your User Type")
            <<< SwitchRow() { row in
                row.title = "Are you a student?"
                row.tag = "isStudent"
                row.value = false
                
        }
        form +++ Section("Enter Your School") { section in
            section.tag = "studentInfo"
            section.hidden = Condition.function(["isStudent"], { (form) in
              return !((form.rowBy(tag: "isStudent") as? SwitchRow)?.value ?? false)
            })
            
            }
            <<< TextRow() {row in
                row.title = "College/Sc"
                row.placeholder = "California State University Sacramento"
                row.tag = "collegeTag"
            
                }.cellSetup({ (cell, row) in
                    let isStudentRow: SwitchRow? = self.form.rowBy(tag: "isStudent")
                    let isStudentValue = isStudentRow?.value
                    
                    if isStudentValue == true {
                        
                        row.add(rule: RuleRequired())
                        row.validationOptions = .validatesOnChange
                    }
                })
        
            <<< TextRow(){ row in
                row.title = "Choose Your Major"
                row.placeholder = "Physics"
                row.tag = "majorTag"
                }.cellSetup({ (cell, row) in
                    let isStudentRow: SwitchRow? = self.form.rowBy(tag: "isStudent")
                    let isStudentValue = isStudentRow?.value
                    
                    if isStudentValue == true {
                        
                        row.add(rule: RuleRequired())
                        row.validationOptions = .validatesOnChange
                    }
                })
        
        form +++ Section()
            <<< ButtonRow() { (row: ButtonRow) -> Void in
                row.title = "Upload"
                
                }
                .cellSetup() {cell, row in
                    cell.backgroundColor = UIColor(red: 0.102, green: 0.5569, blue: 0, alpha: 1.0)
                    cell.tintColor = .white
                }
                .onCellSelection { [weak self] (cell, row) in
                    print("validating errors: \(row.section?.form?.validate().count)")
                    if row.section?.form?.validate().count == 0{
                        
                        self?.userType()
                        
                    }
                        
                    else {
                        var uploadAlert = UIAlertController(title: "Input Error", message: "All Fields Are Required", preferredStyle: .alert)
                        uploadAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                        
                        self?.present(uploadAlert, animated: true, completion: nil)
                    }
        }

        // Do any additional setup after loading the view.
    }
    
    
    func userType(){
        
        guard let isStudentRow: SwitchRow = form.rowBy(tag: "isStudent") else {return}
        
        guard let isStudentRowValue = isStudentRow.value else {return}
        
        var studentSchool = "none"
        var studentMajor = "none"
        
        guard let schoolRow: TextRow = form.rowBy(tag: "collegeTag") else {return}
        
        let schoolRowValue = schoolRow.value
        
        guard let majorRow: TextRow = form.rowBy(tag: "majorTag") else {return}
        let majorRowValue = majorRow.value
        
        if schoolRowValue != nil && majorRowValue != nil {
            
            studentSchool = schoolRowValue!
            studentMajor = majorRowValue!
        }
        
        var ref: DatabaseReference!
        
        ref = Database.database().reference()
        
       let updateRef = ref.child("users").child((Auth.auth().currentUser?.uid)!)
        
        let values = ["isStudent": String(isStudentRowValue), "College": studentSchool, "Major" : studentMajor]
        
        let defaults = UserDefaults.standard
        defaults.set(isStudentRowValue, forKey: "isStudent")
        defaults.set(studentSchool, forKey: "College")
        defaults.set(studentMajor, forKey: "Major")
        
        updateRef.updateChildValues(values)
        
        //self.dismiss(animated: true, completion: nil)
        let story = UIStoryboard(name: "Main", bundle: nil)
        let destination = story.instantiateViewController(withIdentifier: "bob")
        self.present(destination, animated: true, completion: nil)
        
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
