//
//  SearchViewController.swift
//  biblos
//
//  Created by Taylor Simpson on 1/23/18.
//  Copyright © 2018 Taylor Simpson. All rights reserved.
//

/*
 
 Some Notes Here: I should let the user query on major, school, and genre.
 
 If the user wants the book by school and major you can grab it by having a parent node of schools, then have each school be a child node of that school (side note: The Full Name of that school must be typed.) each school will then have majors as their subnode with userID's as their nodes. Then I look specifically for the books from each user that match the major.
 
 for just major just create a seprate parent node called majors and have child nodes for each major. under each major node, just put the books that match that major. You can grab all the other data from just the book node itself.
 
 */

import UIKit
import Eureka
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import FBSDKCoreKit

class SearchViewController: FormViewController {

    var schoolsArray = [String]()
    let defaults = UserDefaults.standard
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.barTintColor = .black
        self.tabBarController?.navigationItem.titleView = nil
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: "Helvetica", size: 20)!, NSAttributedStringKey.foregroundColor: UIColor.white]
        self.tabBarController?.navigationItem.title = "Search"
        
        
       // present(SearchTutorialViewController(), animated: true, completion: nil)
       
      
        
        //        let alwaysFirstLaunch = FirstLaunch(getWasLaunchedBefore: { return false }, setWasLaunchedBefore: { _ in })
        //        if alwaysFirstLaunch.isFirstLaunch {
        //            // will always execute
        //            present(MoreUserInfoViewController(), animated: true, completion: nil)
        //        }
        
        
        
    }
    
    func imageWithGradient(img:UIImage!) -> UIImage {
        
        UIGraphicsBeginImageContext(img.size)
        let context = UIGraphicsGetCurrentContext()
        
        img.draw(at: CGPoint(x: 0, y: 0))
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let locations:[CGFloat] = [0.0, 1.0]
        
        let bottom = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
        let top = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
        
        let colors = [top, bottom] as CFArray
        
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: locations)
        
        let startPoint = CGPoint(x: img.size.width/2, y: 0)
        let endPoint = CGPoint(x: img.size.width/2, y: img.size.height)
        
        context!.drawLinearGradient(gradient!, start: startPoint, end: endPoint, options: CGGradientDrawingOptions(rawValue: UInt32(0)))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var tutboard = UIStoryboard(name: "Tutorials", bundle: nil)
        
        
        
        if(!UserDefaults.standard.bool(forKey: "Searchfirstlaunch1.0")){
            //Put any code here and it will be executed only once.
             present(tutboard.instantiateViewController(withIdentifier: "SearchTut"), animated: true, completion: nil)
            print("Is a first launch")
            UserDefaults.standard.set(true, forKey: "Searchfirstlaunch1.0")
            UserDefaults.standard.synchronize();
        }
        
        
        
        
        self.tableView.backgroundColor = .black
        navigationController?.navigationBar.barTintColor = .black
        tableView.backgroundView = UIImageView(image: imageWithGradient(img: UIImage(named: "nicelib.jpeg")))
        form +++ Section("Genre"){ section in
            var header = HeaderFooterView<UILabel>(.class)
            header.height = {35.0}
            header.onSetupView = { view, _ in
                view.textColor = .white
                view.text = "Search By Genre"
            }
            section.header = header
            }
            <<< LabelRow(){ row in
                row.title = "Tap me to search by genre"
                row.tag = "genreTag"
                }.onCellSelection({ (cell, row) in
                    self.performSegue(withIdentifier: "genreSearch", sender: self)
                })
            
            +++  Section("Search by school and major"){ section in
                var header = HeaderFooterView<UILabel>(.class)
                header.height = {35.0}
                header.onSetupView = { view, _ in
                    view.textColor = .white
                    view.text = "Search by school and major/subject"
                   
                    
                }
                section.header = header
            }
            <<< TextRow(){ row in
                row.title = "College"
                row.placeholder = "Stanford"
                if self.defaults.object(forKey: "isStudent") as? Bool == true {
                    
                    row.value = self.defaults.object(forKey: "College") as? String
                }
                row.tag = "collegeTag"
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnChange
                }
                
                <<< TextRow(){ row in
                    row.title = "Major"
                    row.placeholder = "Physics"
                    row.tag = "majorTag"
                    if self.defaults.object(forKey: "isStudent") as? Bool == true {
                        
                        row.value = self.defaults.object(forKey: "Major") as? String
                    }
                    row.add(rule: RuleRequired())
                    row.validationOptions = .validatesOnChange
                }
        
                <<< ButtonRow() { (row: ButtonRow) -> Void in
                    row.title = "Search"
                    
                    }
                    .cellSetup() {cell, row in
                        cell.backgroundColor = UIColor(red: 0.102, green: 0.5569, blue: 0, alpha: 1.0)
                        cell.tintColor = .white
                    }
                    .onCellSelection { [weak self] (cell, row) in
                       
                        guard let collegeRow: TextRow = self?.form.rowBy(tag: "collegeTag") else {return}
                        guard let collegeRowValue = collegeRow.value?.trimmingCharacters(in: .whitespaces) else {return}
                        guard let majorRow: TextRow = self?.form.rowBy(tag: "majorTag") else {
                            return
                        }
                        guard let majorRowValue = majorRow.value?.trimmingCharacters(in: .whitespaces) else {return}
                        
                        print("validating errors: \(row.section?.form?.validate().count)")
                        if row.section?.form?.validate().count == 0 && collegeRowValue.isAlpha == true && majorRowValue.isAlpha == true{
                            
                            self?.performSegue(withIdentifier: "collegeAndMajor", sender: self)
                            
                        }
                            
                        else {
                            var uploadAlert = UIAlertController(title: "Input Error", message: "All Fields Are Required or you have input numbers which are not allowed", preferredStyle: .alert)
                            uploadAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                            
                            self?.present(uploadAlert, animated: true, completion: nil)
                        }
        }
        
        
                
            +++ Section("Search by only major"){ section in
                var header = HeaderFooterView<UILabel>(.class)
                header.height = {35.0}
                header.onSetupView = { view, _ in
                    view.textColor = .white
                    view.text = "Search by only major"
                }
                section.header = header
            }
                <<< TextRow(){ row in
                    row.title = "Major"
                    row.placeholder = "Math"
                    row.tag = "justMajorTag"
                   
        }
            <<< ButtonRow() { (row: ButtonRow) -> Void in
                row.title = "Search"
                
                }
                .cellSetup() {cell, row in
                    cell.backgroundColor = UIColor(red: 0.102, green: 0.5569, blue: 0, alpha: 1.0)
                    cell.tintColor = .white
                }
                .onCellSelection { [weak self] (cell, row) in
                    print("validating errors: \(row.section?.form?.validate().count)")
                    guard let majorRow: TextRow = self?.form.rowBy(tag: "justMajorTag") else {return}
                    
                    let majorRowValue = majorRow.value?.trimmingCharacters(in: .whitespaces)
                    
                    
                    if majorRowValue != nil && majorRowValue?.isAlpha == true{
                        
                        self?.performSegue(withIdentifier: "toMajorBooks", sender: self)
                        
                    }
                        
                    else {
                        var uploadAlert = UIAlertController(title: "Input Error", message: "You must provide a major or you have input numbers which are not allowed", preferredStyle: .alert)
                        uploadAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                        
                        self?.present(uploadAlert, animated: true, completion: nil)
                    }
        }
        
        
        
              
        // Do any additional setup after loading the view.
    }

    func grabSchools(){
        self.schoolsArray = []
        
       
        
        //self.schoolsArray.removeAll()
        
        var ref = Database.database().reference().child("colleges")
        
        
        ref.observe(.childAdded) { (snapshot) in
            //print(snapshot.key)
            
            var count = snapshot.childrenCount
            
                self.schoolsArray.append(snapshot.key)
            //print(self.schoolsArray.count)
            self.form +++ Section(snapshot.key){ section in
                section.tag = String(self.schoolsArray.count)
                
                print("This is a tree" + " " + String(self.schoolsArray.count))
                
                print("The Section count is" + String(self.form.allSections.count))
            }
            self.tableView.reloadData()
            
            
        }
        
            
            
        
        
        
         //print(self.schoolsArray)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        if let view = view as? UITableViewHeaderFooterView {
            view.backgroundView?.backgroundColor = .clear
            view.textLabel?.backgroundColor = UIColor.clear
            view.textLabel?.textColor = UIColor.white
        }
        
    }
   
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
      
        if segue.identifier == "collegeAndMajor"{
        
        guard let collegeRow: TextRow = self.form.rowBy(tag: "collegeTag") else {return}
        guard let collegeRowValue = collegeRow.value else {return}
        guard let majorRow: TextRow = self.form.rowBy(tag: "majorTag") else {
            return
        }
        guard let majorRowValue = majorRow.value else {return}
        
        let destination = segue.destination as! CollegeandMajorTableViewController
        
        destination.college = collegeRowValue.lowercased().capitalized.trimmingCharacters(in: .whitespaces)
            destination.major = majorRowValue.lowercased().capitalized.trimmingCharacters(in: .whitespaces)
            
        }
        
        if segue.identifier == "toMajorBooks"{
            
            //do something
            
            guard let majorRow: TextRow = self.form.rowBy(tag: "justMajorTag") else {return}
            guard let majorRowValue = majorRow.value else {return}
            
            let desitnation = segue.destination as! MajorTableViewController
            
            desitnation.major = majorRowValue.lowercased().capitalized.trimmingCharacters(in: .whitespaces)
        }
        
    }
    

}
