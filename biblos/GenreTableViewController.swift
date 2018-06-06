//
//  GenreTableViewController.swift
//  biblos
//
//  Created by Taylor Simpson on 6/14/16.
//  Copyright © 2016 Taylor Simpson. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FBSDKCoreKit
import DeviceKit


class GenreTableViewController: UITableViewController, UISearchBarDelegate{
    let dataBase = Database.database()
    
    var modelName = Device()
    
    
     let searchBar = UISearchBar()
    
    var genreArray = ["DRAMA","CLASSIC,COMIC/GRAPHIC NOVEL","CRIME/DETECTIVE","FABLE,FAIRY TALE","FANTASY","FICTION NARRATIVE", "FICTION IN VERSE","FOLKLORE","HISTORICAL FICTION","HORROR","HUMOUR","LEGEMD","MAGICAL REALISM","METAFICTION","MYSTERY","MYTHOLOGY","MYTHOPOEIA","REALISTIC FICTION","SCIENCE FICTION","SHORT STORY","SUSPENSE/THRILLER","TALL TALE","WESTERN,BIOGRAPHY","AUTOBIOGRAPHY","ESSAY","NARRATIVE", "NONFICTION/PERSONAL NARRATIVE","MEMOIR","SPEECH","TEXTBOOK","REFERENCE BOOK","SELF-HELP BOOK","JOURNALISM", "RELIGON","MANGA","GENERAL AGRICULTURE","AGRICULTURE PRODUCTION AND MANAGEMENT",
        "AGRICULTURAL ECONOMICS","ANIMAL SCIENCES", "FOOD SCIENCE","PLANT SCIENCE AND AGRONOMY","SOIL SCIENCE", "MISCELLANEOUS AGRICULTURE",
        "FORESTRY",
        "NATURAL RESOURCES MANAGEMENT", "FINE ARTS", "DRAMA AND THEATER ARTS", "MUSIC",
        "VISUAL AND PERFORMING ARTS",
        "COMMERCIAL ART AND GRAPHIC DESIGN",
        "FILM VIDEO AND PHOTOGRAPHIC ARTS",
        "STUDIO ARTS",
        "MISCELLANEOUS FINE ARTS",
        "ENVIRONMENTAL SCIENCE",
        "BIOLOGY",
        "BIOCHEMICAL SCIENCES",
        "BOTANY",
        "MOLECULAR BIOLOGY",
        "ECOLOGY",
        "GENETICS",
        "MICROBIOLOGY",
        "PHARMACOLOGY",
        "PHYSIOLOGY",
        "ZOOLOGY",
        "NEUROSCIENCE",
        "MISCELLANEOUS BIOLOGY",
        "COGNITIVE SCIENCE AND BIOPSYCHOLOGY",
        "GENERAL BUSINESS",
        "ACCOUNTING",
        "ACTUARIAL SCIENCE",
        "BUSINESS MANAGEMENT AND ADMINISTRATION",
        "OPERATIONS LOGISTICS AND E-COMMERCE",
        "BUSINESS ECONOMICS",
        "MARKETING AND MARKETING RESEARCH",
        "FINANCE",
        "HUMAN RESOURCES AND PERSONNEL MANAGEMENT",
        "INTERNATIONAL BUSINESS",
        "HOSPITALITY MANAGEMENT",
        "MANAGEMENT INFORMATION SYSTEMS AND STATISTICS",
        "MISCELLANEOUS BUSINESS & MEDICAL ADMINISTRATION",
        "COMMUNICATIONS",
        "JOURNALISM",
        "MASS MEDIA",
        "ADVERTISING AND PUBLIC RELATIONS",
        "COMMUNICATION TECHNOLOGIES",
        "COMPUTER AND INFORMATION SYSTEMS",
        "COMPUTER PROGRAMMING AND DATA PROCESSING",
        "COMPUTER SCIENCE",
        "INFORMATION SCIENCES",
        "COMPUTER ADMINISTRATION MANAGEMENT AND SECURITY",
        "COMPUTER NETWORKING AND TELECOMMUNICATIONS",
        "MATHEMATICS",
        "APPLIED MATHEMATICS",
        "STATISTICS AND DECISION SCIENCE",
        "MATHEMATICS AND COMPUTER SCIENCE",
        "GENERAL EDUCATION",
        "EDUCATIONAL ADMINISTRATION AND SUPERVISION",
        "SCHOOL STUDENT COUNSELING",
        "ELEMENTARY EDUCATION",
        "MATHEMATICS TEACHER EDUCATION",
        "PHYSICAL AND HEALTH EDUCATION TEACHING",
        "EARLY CHILDHOOD EDUCATION",
        "SCIENCE AND COMPUTER TEACHER EDUCATION",
        "SECONDARY TEACHER EDUCATION",
        "SPECIAL NEEDS EDUCATION",
        "SOCIAL SCIENCE OR HISTORY TEACHER EDUCATION",
        "TEACHER EDUCATION: MULTIPLE LEVELS",
        "LANGUAGE AND DRAMA EDUCATION",
        "ART AND MUSIC EDUCATION",
       " MISCELLANEOUS EDUCATION",
        "LIBRARY SCIENCE",
        "ARCHITECTURE",
        "GENERAL ENGINEERING",
        "AEROSPACE ENGINEERING",
        "BIOLOGICAL ENGINEERING",
        "ARCHITECTURAL ENGINEERING",
        "BIOMEDICAL ENGINEERING",
        "CHEMICAL ENGINEERING",
        "CIVIL ENGINEERING",
        "COMPUTER ENGINEERING",
        "ELECTRICAL ENGINEERING",
        "ENGINEERING MECHANICS PHYSICS AND SCIENCE",
        "ENVIRONMENTAL ENGINEERING",
        "GEOLOGICAL AND GEOPHYSICAL ENGINEERING",
        "INDUSTRIAL AND MANUFACTURING ENGINEERING",
        "MATERIALS ENGINEERING AND MATERIALS SCIENCE",
        "MECHANICAL ENGINEERING",
        "METALLURGICAL ENGINEERING",
        "MINING AND MINERAL ENGINEERING",
        "NAVAL ARCHITECTURE AND MARINE ENGINEERING",
        "NUCLEAR ENGINEERING",
        "PETROLEUM ENGINEERING",
        "MISCELLANEOUS ENGINEERING",
        "ENGINEERING TECHNOLOGIES",
        "ENGINEERING AND INDUSTRIAL MANAGEMENT",
        "ELECTRICAL ENGINEERING TECHNOLOGY",
        "INDUSTRIAL PRODUCTION TECHNOLOGIES",
        "MECHANICAL ENGINEERING RELATED TECHNOLOGIES",
        "MISCELLANEOUS ENGINEERING TECHNOLOGIES",
        "MATERIALS SCIENCE",
        "NUTRITION SCIENCES",
        "GENERAL MEDICAL AND HEALTH SERVICES",
        "COMMUNICATION DISORDERS SCIENCES AND SERVICES",
        "HEALTH AND MEDICAL ADMINISTRATIVE SERVICES",
        "MEDICAL ASSISTING SERVICES",
        "MEDICAL TECHNOLOGIES TECHNICIANS",
        "HEALTH AND MEDICAL PREPARATORY PROGRAMS",
        "NURSING",
        "PHARMACY PHARMACEUTICAL SCIENCES AND ADMINISTRATION",
        "TREATMENT THERAPY PROFESSIONS",
        "COMMUNITY AND PUBLIC HEALTH",
        "MISCELLANEOUS HEALTH MEDICAL PROFESSIONS",
        "AREA ETHNIC AND CIVILIZATION STUDIES",
        "LINGUISTICS AND COMPARATIVE LANGUAGE AND LITERATURE",
        "FRENCH GERMAN LATIN AND OTHER COMMON FOREIGN LANGUAGE STUDIES",
        "OTHER FOREIGN LANGUAGES",
        "ENGLISH LANGUAGE AND LITERATURE",
        "COMPOSITION AND RHETORIC",
        "LIBERAL ARTS",
        "HUMANITIES",
        "INTERCULTURAL AND INTERNATIONAL STUDIES",
        "PHILOSOPHY AND RELIGIOUS STUDIES",
        "THEOLOGY AND RELIGIOUS VOCATIONS",
        "ANTHROPOLOGY AND ARCHEOLOGY",
        "ART HISTORY AND CRITICISM",
        "HISTORY",
        "UNITED STATES HISTORY",
        "COSMETOLOGY SERVICES AND CULINARY ARTS",
        "FAMILY AND CONSUMER SCIENCES",
        "MILITARY TECHNOLOGIES",
        "PHYSICAL FITNESS PARKS RECREATION AND LEISURE",
        "CONSTRUCTION SERVICES",
        "ELECTRICAL, MECHANICAL, AND PRECISION TECHNOLOGIES AND PRODUCTION",
        "TRANSPORTATION SCIENCES AND TECHNOLOGIES",
        "MULTI/INTERDISCIPLINARY STUDIES",
        "COURT REPORTING",
        "PRE-LAW AND LEGAL STUDIES",
        "CRIMINAL JUSTICE AND FIRE PROTECTION",
        "PUBLIC ADMINISTRATION",
        "PUBLIC POLICY",
            "PHYSICAL SCIENCES",
            "ASTRONOMY AND ASTROPHYSICS",
            "ATMOSPHERIC SCIENCES AND METEOROLOGY",
            "CHEMISTRY",
            "GEOLOGY AND EARTH SCIENCE",
            "GEOSCIENCES",
            "OCEANOGRAPHY",
            "PHYSICS",
            "MULTI-DISCIPLINARY OR GENERAL SCIENCE",
            "NUCLEAR, INDUSTRIAL RADIOLOGY, AND BIOLOGICAL TECHNOLOGIES",
            "PSYCHOLOGY",
            "EDUCATIONAL PSYCHOLOGY",
            "CLINICAL PSYCHOLOGY",
            "COUNSELING PSYCHOLOGY",
            "INDUSTRIAL AND ORGANIZATIONAL PSYCHOLOGY",
            "SOCIAL PSYCHOLOGY",
            "MISCELLANEOUS PSYCHOLOGY",
            "HUMAN SERVICES AND COMMUNITY ORGANIZATION",
            "SOCIAL WORK",
            "INTERDISCIPLINARY SOCIAL SCIENCES",
            "GENERAL SOCIAL SCIENCES",
            "ECONOMICS",
            "CRIMINOLOGY",
            "GEOGRAPHY",
            "INTERNATIONAL RELATIONS",
            "POLITICAL SCIENCE AND GOVERNMENT",
            "SOCIOLOGY",
            "MISCELLANEOUS SOCIAL SCIENCES"
].sorted()
    
    var filteredArray = [String]()
    var shouldShowSearchResults = false
    
    //Functions for adding search
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredArray = genreArray.filter({ (genres: String) -> Bool in
        
        return (genres.lowercased().range(of: searchText.lowercased()) != nil)
            
        
        
        })
        
        if searchText != ""{
            
            shouldShowSearchResults = true
            
            self.tableView.reloadData()
        
        
        }
        else {
        
            shouldShowSearchResults = false
            
            self.tableView.reloadData()
        
        
        }
    }
    
    
    
    // End of functions for adding search
    
    
    var ResultArray: [NSObject] = []
    var infoArray:[AnyObject] = []
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.title = "Select A Genre"
        
       
        //self.navigationItem.titleView = searchBar
        tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(didLogOut))
        
        createSearchBar()
        
       
       
        
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
    
    
     @objc func didLogOut(){
        
        
        //signs user out of firebase app
        
        try! Auth.auth().signOut()
        
        //sign user out of facebook app
        
        FBSDKAccessToken.setCurrent(nil)
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name:"Main", bundle: nil)
        
        let viewController: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "LoginView")
        
        self.present(viewController, animated: true, completion: nil)
        
        
        
        
    }
    
    func createSearchBar (){
    
       
        searchBar.showsCancelButton = false
        searchBar.placeholder = "Select a Genre"
        searchBar.delegate = self
        //self.tabBarController?.navigationItem.titleView = searchBar
        
        self.navigationItem.titleView = searchBar
    
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
      createSearchBar()
        
       tableView.backgroundView = UIImageView(image: imageWithGradient(img: UIImage(named: "nicelib.jpeg")))
        
         UIApplication.shared.statusBarStyle = .lightContent

    
       // navigationController!.navigationBar.barTintColor =  UIColor(red: 59/255, green: 89/255, blue: 152/255, alpha: 1.0)
        
        navigationController?.navigationBar.barTintColor = .black

          tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(didLogOut))
        
        tabBarController?.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        
    }
    
    
    func booksNearBy (){
    
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name:"Main", bundle: nil)
        
        let viewController: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "mapTime")
        
        self.present(viewController, animated: true, completion: nil)

    
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

   override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if shouldShowSearchResults {
        
            return filteredArray.count
        
        
        }
        
        else {
        return genreArray.count
            
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        // Configure the cell...
        cell.backgroundColor = UIColor.clear
        
        if shouldShowSearchResults{
        
            cell.textLabel?.text = filteredArray[indexPath.row]
             cell.textLabel?.textColor = .white
            
             cell.textLabel?.font = UIFont(name: "Helvetica", size: 16)
            
            return cell
        
        
        }
        else{
        
        cell.textLabel?.text = genreArray[indexPath.row]
            
            cell.textLabel?.textColor = .white
            
            
            
            cell.textLabel?.font = UIFont(name: "Helvetica", size: 16)

            
            
            
            return cell
        
        }

        
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        shouldShowSearchResults = true
        
        searchBar.endEditing(true)
        
        self.tableView.reloadData()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        
        
       // let navVC = segue.destinationViewController as! UINavigationController
        
        let viewController = segue.destination as! ResultTableViewController
        
      
        
        
        //let DestViewController: ResultTableViewController = segue.destinationViewController as! ResultTableViewController
        
        
        
        if segue.identifier == "letsGo" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                
                if shouldShowSearchResults {
                
                    let tappedItem = self.filteredArray[indexPath.row]
                    
                    viewController.someString = tappedItem
                    
                    
                
                }
                else{
                    let tappedItem = self.genreArray[indexPath.row]
                    
                    viewController.someString = tappedItem
                    
                
                
                }
                
                
                
        
                
            }
            
            
            
        }
        
    }
   
    

}







