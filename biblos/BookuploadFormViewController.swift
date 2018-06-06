//
//  BookuploadFormViewController.swift
//  biblos
//
//  Created by Taylor Simpson on 1/3/18.
//  Copyright © 2018 Taylor Simpson. All rights reserved.
//

import UIKit
import Eureka
import ImageRow
import PostalAddressRow
import CoreLocation
import Firebase

class BookuploadFormViewController: FormViewController, CLLocationManagerDelegate {
   
    @IBOutlet weak var mySpinner: UIActivityIndicatorView!
    @IBOutlet weak var bluredSpinner: UIVisualEffectView!
    var usersName: String!
    var usersPhoto: String!
    var usersPhotoChoice: String!
    var userPushID = ""
   
    
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
    "MISCELLANEOUS SOCIAL SCIENCES"]
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(true)
        self.tabBarController?.navigationItem.title = "Upload Your Book"
        
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: "Helvetica", size: 20)!, NSAttributedStringKey.foregroundColor: UIColor.white]
        
        
        self.tabBarController?.navigationItem.titleView = nil
        
        tabBarController?.navigationItem.rightBarButtonItem = nil
       
        
        tabBarController?.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        
        
        
        
        
        //self.view.backgroundColor = UIColor.purpleColor()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var tutboard = UIStoryboard(name: "Tutorials", bundle: nil)
        
        if(!UserDefaults.standard.bool(forKey: "Uploadfirstlaunch1.0")){
            //Put any code here and it will be executed only once.
            present(tutboard.instantiateViewController(withIdentifier: "uploadTut"), animated: true, completion: nil)
            print("Is a first launch")
            UserDefaults.standard.set(true, forKey: "Uploadfirstlaunch1.0")
            UserDefaults.standard.synchronize();
            
        }
        
        
      navigationController?.navigationBar.barTintColor = .black
        
        self.tableView.backgroundColor = .black
        
        form +++ Section(header:"Picture Section", footer: "Tap cell to add an image of your book"){ section in
            section.header = {
                
                var header = HeaderFooterView<UIImageView>( .callback({
                    
                    let view = UIImageView(frame: CGRect(x: 0, y: 0 , width: 100, height: 100))

                    view.image = UIImage(named: "nicelib.jpeg")
                    return view
                }))
                
                header.height = {100}

                return header
                
            }()
            
            
        
            
            }
            <<< ImageRow() { row in
                row.title = "Book Image"
               // row.cell.backgroundColor = .black
               // row.cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 25)
               
                row.sourceTypes = [.PhotoLibrary, .SavedPhotosAlbum, .Camera]
                row.clearAction = .yes(style: .destructive)
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnChange
                row.tag = "bookImage"
                
        }
                .cellUpdate{ cell, row in
                    cell.accessoryView?.layer.cornerRadius = 17
                    cell.accessoryView?.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
                    cell.textLabel?.textColor = .black
                    cell.clipsToBounds = false
                    if !row.isValid {
                        cell.textLabel?.textColor = .red
                    }

                   
                    

        }
            
        
            +++ Section("Enter Book Information")
        
            <<< PickerInputRow<String> { row in
                row.title = "Pick A Genre"
                row.options = genreArray.sorted()
                row.tag = "genreTag"
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnChange
               
               // row.cell.textLabel?.text = "Select A Genre"
        }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.textLabel?.textColor = .red
                    }
            }
        
            <<< TextRow(){ row in
                
                row.title = "Add Title"
                row.placeholder = "Lord of The Flies"
                row.tag = "titleTag"
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnChange
        }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
            }
            
            <<< TextRow() { row in
                row.title = "Add Author"
                row.placeholder = "J.R.R. Tolkin"
                row.tag = "authorTag"
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnChange
        }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
            }
            
            <<< TextAreaRow() { row in
                row.title = "Type a summary/review of the book"
                row.placeholder = "Type a summary/review of the book"
                row.tag = "summaryTag"
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnChange
            }
                .cellUpdate { cell, row in
                    if !row.isValid {
                       cell.backgroundColor = .red
                    }
            }
        form +++ Section("Enter the condition of the book")
            <<< TextAreaRow() { row in
                row.title = "Describe the condition of the book"
                row.placeholder = "My book is in great condition."
                row.tag = "conditionTag"
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnChange
                }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.backgroundColor = .red
                    }
        }
            form +++ Section("Select a category")
           
                <<< PickerInputRow<String>() { row in
                    
                    row.title = "Category"
                    row.options = ["Children", "Teen", "Adult", "Textbook"]
                    row.tag = "catergoryTag"
                    row.add(rule: RuleRequired())
                    row.validationOptions = .validatesOnChange
                    }  .cellUpdate { cell, row in
                        if !row.isValid {
                            cell.textLabel?.textColor = .red
                        }
                }
                
                <<< TextRow() { row in
                    
                    row.title = "Enter Major"
                    row.placeholder = "Physics"
                    row.tag = "majorTag"
                    row.hidden = Condition.function(["catergoryTag"], { (form) in
                        let catergoryRow: PickerInputRow<String> = form.rowBy(tag: "catergoryTag")!
                        
                        let catVal = catergoryRow.value
                        
                        if catVal == "Textbook" {
                            
                            return false
                        } else { return true
                            
                            
                        }
                        
                        
                    })
                    }.cellSetup({ (cell, row) in
                        let catergoryRow: PickerInputRow<String> = self.form.rowBy(tag: "catergoryTag")!
                        
                        let catVal = catergoryRow.value
                        
                        if catVal == "Textbook" {
                            
                            row.add(rule: RuleRequired())
                            row.validationOptions = .validatesOnChange
                        }
                    })
                
                <<< TextRow() { row in
                    
                    row.title = "Enter Your College"
                    row.placeholder = "Stanford"
                    row.tag = "collegeTag"
                    row.hidden = Condition.function(["catergoryTag"], { (form) in
                        let catergoryRow: PickerInputRow<String> = form.rowBy(tag: "catergoryTag")!
                        
                        let catVal = catergoryRow.value
                        
                        if catVal == "Textbook" {
                            
                            return false
                        } else { return true
                            
                            
                        }
                        
                        
                    })
                    }.cellSetup({ (cell, row) in
                        let catergoryRow: PickerInputRow<String> = self.form.rowBy(tag: "catergoryTag")!
                        
                        let catVal = catergoryRow.value
                        
                        if catVal == "Textbook" {
                            
                            row.add(rule: RuleRequired())
                            row.validationOptions = .validatesOnChange
                        }
                    })
                
            
        +++ Section("Enter the adress of the book")
            <<< TextRow(){ row in
                row.title = "City"
                row.placeholder = "Sacramento"
                row.tag = "cityTag"
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnChange
                
                }.cellUpdate({ (cell, row) in
                    if !row.isValid {
                        cell.textLabel?.textColor = .red
                    }
                })
            
            <<< TextRow(){ row in
                row.title = "State"
                row.placeholder = "California"
                row.tag = "stateTag"
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnChange
                
                }.cellUpdate({ (cell, row) in
                    if !row.isValid {
                        cell.textLabel?.textColor = .red
                    }
                })
            
            <<< ZipCodeRow(){ row in
                row.title = "Zipcode"
                row.placeholder = "12345"
                row.tag = "zipTag"
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnChange
                
                }.cellUpdate({ (cell, row) in
                    if !row.isValid {
                        cell.textLabel?.textColor = .red
                    }
                })
            
//            <<< PostalAddressRow() {row in
//                row.streetPlaceholder = "Street"
//                row.statePlaceholder = "State"
//                row.cityPlaceholder = "City"
//                row.countryPlaceholder = "Country"
//                row.postalCodePlaceholder = "Zip code"
//                row.tag = "postalTag"
//                row.add(rule: RuleRequired())
//                row.validationOptions = .validatesOnChange
//
//
//        }
//                .cellUpdate { cell, row in
//                    if !row.isValid {
//                        cell.backgroundColor = .red
//
//                    } else {
//                        cell.backgroundColor = .white
//                    }
//            }
            
            
            +++ Section()
            <<< ButtonRow() { (row: ButtonRow) -> Void in
                row.title = "Upload"
                
                }
                .cellSetup() {cell, row in
                    cell.backgroundColor = UIColor(red: 0.102, green: 0.5569, blue: 0, alpha: 1.0)
                    cell.tintColor = .white
                }
                .onCellSelection { [weak self] (cell, row) in
                    print("validating errors: \(String(describing: row.section?.form?.validate().count))")
                   
                    
                   
                    
                    if row.section?.form?.validate().count == 0 {
                        
                        
                        self?.uploadBook()
                    }
                       
                    else {
                        var uploadAlert = UIAlertController(title: "Input Error", message: "All Fields Are Required", preferredStyle: .alert)
                        uploadAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                        
                        self?.present(uploadAlert, animated: true, completion: nil)
                    }
        }
        
        let userIdForPic = Auth.auth().currentUser?.uid as String!
        
        let nameRef = Database.database().reference().child("users").child(userIdForPic!).child("name")
        
        
        nameRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            self.usersName = snapshot.value as! String!
            
            
        }, withCancel: nil)
        
        
        let picRef = Database.database().reference().child("users").child(userIdForPic!).child("profileImageUrl")
        
        
        picRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            self.usersPhoto = snapshot.value as! String!
            
        }, withCancel: nil)
        
        OneSignal.idsAvailable({ (userId, pushToken) in
            self.userPushID = userId!
            if (pushToken != nil) {
                NSLog("pushToken:%@", pushToken ?? "")
            }
        })
        
        
        // to do: add comment field, add location field

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func stateChecker (state: String) -> Bool {
        
        let fullStateName = Constants.states
        let shortStateName = Constants.stateAbbr
        
        if fullStateName.contains(state) || shortStateName.contains(state){
            
            return true
        } else {
            return false
        }
        
    }
    
    func inputStringChecker(theCity: String) -> Bool {
        
        if theCity.isAlpha == true {
            
            return true
        } else {
            return false
        }
    }
    
    func zipCodeChecker (zip: String) -> Bool {
        
        if zip.count > 5 || zip.count < 5 || zip.isNum == false{
            
            return false
        } else {
            return true
        }
        
    }
   
    
    @objc func uploadBook() {
        
       
        guard let bookRow: ImageRow = form.rowBy(tag: "bookImage") else {return}
        guard let bookRowValue = bookRow.value else {return}
        guard let bookTitleRow: TextRow = form.rowBy(tag: "titleTag") else {return}
        guard let bookTitleRowValue = bookTitleRow.value else {return}
        guard let bookAuthorRow: TextRow = form.rowBy(tag: "authorTag") else {return}
        guard let bookAuthorRowValue = bookAuthorRow.value else {return}
        guard let bookGenreRow: PickerInputRow<String> = form.rowBy(tag: "genreTag") else {return}
        guard let bookGenreRowValue = bookGenreRow.value else {return}
        guard let commentRow: TextAreaRow = form.rowBy(tag: "summaryTag") else {return}
        guard let commentRowValue = commentRow.value else {return}
        guard let conditionRow: TextAreaRow = form.rowBy(tag: "conditionTag") else {return}
        guard let conditionRowValue = conditionRow.value else {return}
        guard let ratingRow: PickerInputRow<String> = form.rowBy(tag: "catergoryTag") else {return}
        guard let ratingRowValue = ratingRow.value else {return}
        guard let cityRow: TextRow = form.rowBy(tag: "cityTag") else {return}
        guard let cityRowValue = cityRow.value else {return}
        let city = cityRowValue.trimmingCharacters(in: .whitespaces)
        
        guard let stateRow: TextRow = form.rowBy(tag: "stateTag") else {return}
        guard let stateRowValue = stateRow.value else {return}
        let state = stateRowValue.trimmingCharacters(in: .whitespaces)
        
        guard let zipRow: ZipCodeRow = form.rowBy(tag: "zipTag") else {return}
        guard let zipCode = zipRow.value else {return}
        guard let majorRow: TextRow = form.rowBy(tag: "majorTag") else {return}
        let majorRowValue = majorRow.value
        
        guard let collegeRow: TextRow = form.rowBy(tag: "collegeTag") else {return}
         let collegeRowValue = collegeRow.value
        
        var college = "none"
        
        var major = "none"
        
        if majorRowValue != nil {
            
            major = majorRowValue!
        }
        
        if collegeRowValue != nil {
            
            college = collegeRowValue!
        }
        
        
//        guard let addressRow: PostalAddressRow = form.rowBy(tag: "postalTag") else {return}
//        guard let addressRowValue = addressRow.value else {return}
//        guard let city = addressRowValue.city else{return}
//        guard let state = addressRowValue.state else {return}
//        guard let zipCode = addressRowValue.postalCode else {return}
//        guard let street = addressRowValue.street else {return}
        var rating = "All Ages"
       
//        if ratingRowValue == "Adult" {
//            rating = "Age Restricted"
//            print(rating)
//            
//        }
        
        if stateChecker(state: state) == false {
            let uploadAlert = UIAlertController(title: "Input Error", message: "you must spell out the state or use its two letter abbrivation", preferredStyle: .alert)
            uploadAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            
            self.present(uploadAlert, animated: true, completion: nil)
            return
        }
        
        if inputStringChecker(theCity: city) == false {
            
            let uploadAlert = UIAlertController(title: "Input Error", message: "The city can only contain letters and no numbers", preferredStyle: .alert)
            uploadAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            
            self.present(uploadAlert, animated: true, completion: nil)
            return
            
        }
        
        if zipCodeChecker(zip: zipCode) == false {
            let uploadAlert = UIAlertController(title: "Input Error", message: "A zip code contains only five numbers or you have input non numbers", preferredStyle: .alert)
            uploadAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            
            self.present(uploadAlert, animated: true, completion: nil)
            return
            
        }
        
        self.view.addSubview((self.bluredSpinner)!)
        self.mySpinner.startAnimating()
        
        let storage = Storage.storage()
        let storageRef = storage.reference(forURL: "gs://biblos-1.appspot.com")
        let user = Auth.auth().currentUser
        guard let name = user?.displayName else {
            return
        }
        
        var latString : String = ""
        var lngString: String = ""
        
        let adressInfo = "\(city), \(state), \(zipCode)"
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(adressInfo) { (placemarks, error) in
           
            if let error = error {
                
                var uploadAlert = UIAlertController(title: "Input Error", message: "All Fields Are Required", preferredStyle: .alert)
                uploadAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                
                self.present(uploadAlert, animated: true, completion: nil)
            }
            else{
            guard let placemarks = placemarks?.first, let lat = placemarks.location?.coordinate.latitude, let lon = placemarks.location?.coordinate.longitude else {return}
            
        print(city + "," + state + String(zipCode))
            latString = String (format: "%f", NSNumber(value: lat).doubleValue)
            
            
            lngString = String (format: "%f", NSNumber(value: lon).doubleValue)
            
            
        }
        
        }
        
        var imageData = Data()
        
        imageData = UIImageJPEGRepresentation(bookRowValue, 0.25)!
        
        let booksImageRef = storageRef.child("book_images")
        let filePath = ("/biblos-1.appspot.com/bookPhoto"+bookTitleRowValue+(Auth.auth().currentUser?.uid as String!))
        
        let metaData = StorageMetadata()
        
        metaData.contentType = "image/jpg"
        
        storageRef.child(filePath).putData(imageData, metadata: metaData){(metaData,error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }else{
                //store downloadURL
                let downloadURL = metaData!.downloadURL()!.absoluteString
                //store downloadURL at database
                
                
                
                let ref = Database.database().reference().child("books")
                
                let childRef = ref.childByAutoId()
                
                let id = Auth.auth().currentUser?.uid as String!
                
                if Auth.auth().currentUser?.photoURL?.absoluteString == nil {
                    
                    
                    self.usersPhotoChoice = self.usersPhoto
                    
                    
                } else{
                    
                    self.usersPhotoChoice = Auth.auth().currentUser?.photoURL?.absoluteString
                    
                    
                }
                
                let bookID:String = childRef.key.replacingOccurrences(of: "-", with: "")
                
                let books = ["title": bookTitleRowValue,
                             "Author": bookAuthorRowValue,
                             "Genre": bookGenreRowValue,
                             "Comment": commentRowValue,
                             "Condition": conditionRowValue,
                             "User": name,
                             "bookPhoto": downloadURL,
                             "userID": Auth.auth().currentUser?.uid as AnyObject!,
                             "userPhoto": self.usersPhotoChoice as String!,
                             "userLocation": city + "," + state,
                             "bookRating": ratingRowValue,
                             "pushingID": self.userPushID,
                             "bookLat": latString,
                             "bookLng": lngString,
                             "major": major,
                             "college": college,
                             "bookID" : bookID
                    ] as [String : Any]
                
                
                
                childRef.updateChildValues(books){(error,ref) in
                    
                    if error != nil {
                        
                        print(error)
                        
                        return
                        
                    }
                    
                    
                    
                    let userBooksRef = Database.database().reference().child("user-books").child(id!)
                    
                    
                    
                    
                    let bookId = childRef.key
                    
                    userBooksRef.updateChildValues([bookId : 1])
                    
                    
                    
                    let collegeRef = Database.database().reference().child("colleges").child(college.lowercased().capitalized).child(major.lowercased().capitalized)
                    
                    collegeRef.updateChildValues([bookId: major])
                    
                    
                    let majorRef = Database.database().reference().child("majors").child(major.lowercased().capitalized)
                    
                    majorRef.updateChildValues([bookId: major])
                    
                    
                }
                
                
                
                
            }
            
            var uploadAlert = UIAlertController(title: "Upload Complete", message: "Sucess", preferredStyle: .alert)
            uploadAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            
            self.present(uploadAlert, animated: true, completion: nil)
            self.bluredSpinner.isHidden = true
            
          
           self.form.setValues(["bookImage": nil, "titleTag": nil, "authorTag": nil, "genreTag": nil, "summaryTag": nil, "censorTag": false, "postaTag": nil])
            
//            addressRow.value?.state = nil
//            addressRow.value?.city = nil
//            addressRow.value?.country = nil
//            addressRow.value?.postalCode = nil
//            addressRow.value?.street = nil
           
           bookRow.removeAllRules()
           bookTitleRow.removeAllRules()
           bookAuthorRow.removeAllRules()
            bookGenreRow.removeAllRules()
            commentRow.removeAllRules()
            cityRow.removeAllRules()
            stateRow.removeAllRules()
            zipRow.removeAllRules()
           // addressRow.removeAllRules()
            
            
         self.tableView.reloadData()
            
            bookRow.add(rule: RuleRequired())
            bookTitleRow.add(rule: RuleRequired())
            bookAuthorRow.add(rule: RuleRequired())
            bookGenreRow.add(rule: RuleRequired())
            commentRow.add(rule: RuleRequired())
            cityRow.add(rule: RuleRequired())
            stateRow.add(rule: RuleRequired())
            zipRow.add(rule: RuleRequired())
           // addressRow.add(rule: RuleRequired())
            ///
            
            
           
            
            
            
            
            
            
            
        }
        
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
