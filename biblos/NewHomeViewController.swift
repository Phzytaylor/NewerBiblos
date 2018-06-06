//
//  HomeViewController.swift
//  biblos
//
//  Created by Taylor Simpson on 6/8/16.
//  Copyright © 2016 Taylor Simpson. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FBSDKCoreKit
import FirebaseStorage
import DeviceKit




//let ProfilePicRef = Database.database().reference(fromURL: "https://biblos-1.firebaseio.com/userPhototURL")




class NewHomeViewController: UIViewController, GADBannerViewDelegate {
    
    lazy var aivLoadingSpinner: UIActivityIndicatorView = {
        
        let mySpinner = UIActivityIndicatorView()
        
        
        mySpinner.color = .blue
        
        mySpinner.translatesAutoresizingMaskIntoConstraints = false
        
        return mySpinner
        
    }()
    
    
    
    func setupMySpinner (){
        
        aivLoadingSpinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        aivLoadingSpinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        aivLoadingSpinner.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        aivLoadingSpinner.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        
    }
    
    var modelName = Device()
    
    //var modelName = Devices.IPhone5
    
    
    
    lazy var uiimvProfilePic: UIImageView = {
        
        let imageView = UIImageView()
        
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        
        
        
        //imageView.contentMode = .scaleAspectFill
        
        
        
        return imageView
        
        
    }()
    
    
    
    func setupProfileImageView() {
        switch modelName {
        case .iPhone7Plus, .simulator(.iPhone7Plus), .iPhone8Plus, .simulator(.iPhone8Plus), .iPhone6Plus, .simulator(.iPhone6Plus), .iPhone6sPlus, .iPhoneX, .simulator(.iPhoneX):
            //need x, y, width, height constraints
            uiimvProfilePic.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            //profileImageView.bottomAnchor.constraint(equalTo: loginRegisterSegmentedControl.topAnchor, constant: -30).isActive = true
            uiimvProfilePic.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant:-250).isActive = true
            
            
            uiimvProfilePic.widthAnchor.constraint(equalToConstant: 200).isActive = true
            uiimvProfilePic.heightAnchor.constraint(equalToConstant: 200).isActive = true
            
            
            //self.profileImageView.layer.frame = profileImageView.layer.frame.insetBy(dx: 0, dy: 0)
            
        case .iPhone5, .simulator(.iPhone5), .iPhone5s, .simulator(.iPhone5s), .iPhone4, .simulator(.iPhone4), .iPhone4s, .simulator(.iPhone4s), .iPhoneSE, .simulator(.iPhoneSE):
            
            //need x, y, width, height constraints
            uiimvProfilePic.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            //profileImageView.bottomAnchor.constraint(equalTo: loginRegisterSegmentedControl.topAnchor, constant: -30).isActive = true
            uiimvProfilePic.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant:-200).isActive = true
            
            
            uiimvProfilePic.widthAnchor.constraint(equalToConstant: 130).isActive = true
            uiimvProfilePic.heightAnchor.constraint(equalToConstant: 130).isActive = true
            
        case .iPhone6, .simulator(.iPhone6), .iPhone6s, .simulator(.iPhone6s), .iPhone7, .simulator(.iPhone7), .iPhone8, .simulator(.iPhone8):
            
            //need x, y, width, height constraints
            uiimvProfilePic.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            
            uiimvProfilePic.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant:-200).isActive = true
            
            
            uiimvProfilePic.widthAnchor.constraint(equalToConstant: 170).isActive = true
            uiimvProfilePic.heightAnchor.constraint(equalToConstant: 170).isActive = true
            
        case .iPadAir, .simulator(.iPadAir), .iPadAir2, .simulator(.iPadAir2), .iPad2, .simulator(.iPad2), .iPad3, .simulator(.iPad3), .iPad4, .simulator(.iPad4), .iPadPro9Inch, .simulator(.iPadPro9Inch), .iPadPro10Inch, .simulator(.iPadPro10Inch), .iPadPro12Inch, .simulator(.iPadPro12Inch), .iPadPro12Inch2, .simulator(.iPadPro12Inch2), .iPadMini, .simulator(.iPadMini), .iPadMini2, .simulator(.iPadMini2), .iPadMini3, .simulator(.iPadMini3), . iPadMini4, .simulator(.iPadMini4):
            //need x, y, width, height constraints
            uiimvProfilePic.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            //profileImageView.bottomAnchor.constraint(equalTo: loginRegisterSegmentedControl.topAnchor, constant: -30).isActive = true
            uiimvProfilePic.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant:-250).isActive = true
            
            
            uiimvProfilePic.widthAnchor.constraint(equalToConstant: 200).isActive = true
            uiimvProfilePic.heightAnchor.constraint(equalToConstant: 200).isActive = true
            
            
        //self.profileImageView.layer.frame = profileImageView.layer.frame.insetBy(dx: 0, dy: 0)
        default:
            
            //need x, y, width, height constraints
            uiimvProfilePic.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            //profileImageView.bottomAnchor.constraint(equalTo: loginRegisterSegmentedControl.topAnchor, constant: -30).isActive = true
            uiimvProfilePic.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant:-250).isActive = true
            
            
            uiimvProfilePic.widthAnchor.constraint(equalToConstant: 200).isActive = true
            uiimvProfilePic.heightAnchor.constraint(equalToConstant: 200).isActive = true
            
            
            //self.profileImageView.layer.frame = profileImageView.layer.frame.insetBy(dx: 0, dy: 0)
            
        }
        
        
    }
    
    
    lazy var welcomeLabel: UILabel = {
        
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        
        label.text = "Welcome"
        label.textAlignment = .center
        
        label.textColor = .white
        
        
        
        
        return label
        
        
        
        
        
    }()
    
    func setUpWelcomeLabel(){
        
        welcomeLabel.topAnchor.constraint(equalTo: uiimvProfilePic.bottomAnchor, constant: 20).isActive = true
        welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        
        
        
    }
    
    
    /* override func viewDidAppear(_ animated: Bool) {
     super.viewDidAppear(animated)
     if needWalkthrough {
     self.tutorialButton()
     }
     } */
    
    
    
    lazy var uilName: UILabel = {
        
        let myNameLabel = UILabel()
        
        myNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        myNameLabel.textColor = .white
        
        return myNameLabel
        
        
        
    }()
    
    
    
    func setUpNameLabel(){
        
        uilName.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 20).isActive = true
        uilName.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        
    }
    
    
    lazy var continueButton: UIButton = {
        
        let moveOn = UIButton()
        
        
        
        moveOn.addTarget(self, action: #selector(collectUserPhoto), for: .touchUpInside)
        
        moveOn.backgroundColor = UIColor(red: 59/255, green: 89/255, blue: 152/255, alpha: 1.0)
        
        
        moveOn.translatesAutoresizingMaskIntoConstraints = false
        
        
        moveOn.setTitleColor(UIColor.white, for: UIControlState())
        
        
        
        
        
        
        moveOn.setTitle("Continue", for: UIControlState())
        
        
        
        moveOn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        
        
        return moveOn
        
        
    }()
    
    
    func setupContinueButton(){
        
        continueButton.topAnchor.constraint(equalTo: uilName.bottomAnchor, constant: 20).isActive = true
        continueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        continueButton.widthAnchor.constraint(equalToConstant: 226).isActive = true
        
        continueButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        continueButton.layer.cornerRadius = 5
        
        
        
        
    }
    
    
    lazy var conditionsButton: UIButton = {
        
        
        let conButt = UIButton()
        
        conButt.translatesAutoresizingMaskIntoConstraints = false
        
        conButt.setTitleColor(UIColor.white, for: UIControlState())
        
        
        conButt.setTitle("Terms and Conditions", for: UIControlState())
        
        
        conButt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        conButt.addTarget(self, action: #selector(termsAgreements), for: .touchUpInside)
        
        conButt.backgroundColor = UIColor(red: 59/255, green: 89/255, blue: 152/255, alpha: 1.0)
        
        conButt.setTitleColor(UIColor.white, for: UIControlState())
        
        return conButt
        
    }()
    
    
    func setupConditionsButt(){
        
        
        conditionsButton.topAnchor.constraint(equalTo: continueButton.bottomAnchor, constant: 20).isActive = true
        conditionsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        conditionsButton.widthAnchor.constraint(equalToConstant: 226).isActive = true
        
        conditionsButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        conditionsButton.layer.cornerRadius = 5
        
        
        
        
    }
    
    
    lazy var myBanner: GADBannerView = {
        
        let myBigBanner = GADBannerView()
        
        
        
        let requests = GADRequest()
        
        
        myBigBanner.adUnitID = "ca-app-pub-5816120790996944/8277953311"
        
        myBigBanner.delegate = self
        
        myBigBanner.rootViewController = self
        
        myBigBanner.load(requests)
        
        
        myBigBanner.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        return myBigBanner
        
        
        
    }()
    
    
    func setupMyGoogleAd(){
        
        switch modelName {
        case .iPhone6sPlus, .simulator(.iPhone6sPlus), .iPhone6Plus, .simulator(.iPhone6Plus), .iPhone7Plus, .simulator(.iPhone7Plus), .iPhone8Plus, .simulator(.iPhone8Plus), .iPhoneX, .simulator(.iPhoneX):
            myBanner.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant:300).isActive = true
            myBanner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            myBanner.widthAnchor.constraint(equalToConstant: 320).isActive = true
            
            myBanner.heightAnchor.constraint(equalToConstant: 100).isActive = true
            
        case .iPhone5, .simulator(.iPhone5), .iPhone5s, .simulator(.iPhone5s), .iPhone6, .simulator(.iPhone6), .iPhone6s, .simulator(.iPhone6s), .iPhone7, .simulator(.iPhone7), .iPhoneSE, .simulator(.iPhoneSE), .iPhone8, .simulator(.iPhone8):
            myBanner.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant:235).isActive = true
            myBanner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            myBanner.widthAnchor.constraint(equalToConstant: 320).isActive = true
            
            myBanner.heightAnchor.constraint(equalToConstant: 100).isActive = true
            
        case .iPadAir, .simulator(.iPadAir), .iPadAir2, .simulator(.iPadAir2), .iPad2, .simulator(.iPad2), .iPad3, .simulator(.iPad3), .iPad4, .simulator(.iPad4), .iPadPro9Inch, .simulator(.iPadPro9Inch), .iPadPro10Inch, .simulator(.iPadPro10Inch), .iPadPro12Inch, .simulator(.iPadPro12Inch), .iPadPro12Inch2, .simulator(.iPadPro12Inch2), .iPadMini, .simulator(.iPadMini), .iPadMini2, .simulator(.iPadMini2), .iPadMini3, .simulator(.iPadMini3), . iPadMini4, .simulator(.iPadMini4):
            
            myBanner.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant:435).isActive = true
            myBanner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            myBanner.widthAnchor.constraint(equalToConstant: 728).isActive = true
            
            myBanner.heightAnchor.constraint(equalToConstant: 90).isActive = true
        default:
            myBanner.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant:435).isActive = true
            myBanner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            myBanner.widthAnchor.constraint(equalToConstant: 728).isActive = true
            
            myBanner.heightAnchor.constraint(equalToConstant: 90).isActive = true
        }
    }
    
    
    lazy var bookCounter: UILabel = {
        
        
        let booksShared = UILabel()
        
        booksShared.translatesAutoresizingMaskIntoConstraints = false
        
        booksShared.textColor = .white
        
        return booksShared
        
        
        
    }()
    
    
    func setupBookCounter(){
        
        bookCounter.topAnchor.constraint(equalTo: conditionsButton.bottomAnchor, constant: 20).isActive = true
        bookCounter.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        
        
    }
    
    
    
    //@IBOutlet weak var bookCounter: UILabel!
    var usersPhotoLink:String? {
        
        
        didSet{
            
            
            
            
            print("I AM SET")
            
            
        }
        
        
        
        
    }
    
    let myBackGround: UIImageView = {
        
        
        let theBackImage = UIImageView()
        
        //let myImage = UIImage(named: "IMG_0570.png")
        
        theBackImage.translatesAutoresizingMaskIntoConstraints = false
        
        
        return theBackImage
        
        
    }()
    
    
    
    func setUpBackImageView(){
        
        self.myBackGround.image = UIImage(named: "old-books-436498_640.jpg")
        
        
        
        self.myBackGround.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        self.myBackGround.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        self.myBackGround.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        self.myBackGround.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    }
    
    
    
    var userPushID: String = ""
    
    //@IBOutlet weak var continueButton: UIButton!
    
    
    func profilePic(){
        
        
        let imageCache = NSCache<AnyObject, AnyObject>()
        
        let url = URL(string: self.usersPhotoLink as String! )
        
        
        print("THIS IS THE URL", url)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            
            //download hit an error so lets return out
            if error != nil {
                print("THIS IS THE ERROR",error)
                return
            }
            
            DispatchQueue.main.async(execute: {
                
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: self.usersPhotoLink as String! as AnyObject)
                    
                    print("THIS WORKS?", self.usersPhotoLink as String!)
                    
                    self.uiimvProfilePic.image = downloadedImage.circleMasked
                    
                    //
                    
                    
                    
                }
            })
            //
            
        }).resume()
        
        
        
        
    }
    
    
    // @IBOutlet weak var myBanner: GADBannerView!
    
    var UsersLoginInforef = Database.database().reference(fromURL: "https://biblos-1.firebaseio.com/")
    
    
    @objc func termsAgreements() {
        
        
        
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "popOverMan") as! PopOverViewController
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
        
        
        
    }
    
    @objc func collectUserPhoto() {
        
        if let providerData = Auth.auth().currentUser?.providerData {
            for userInfo in providerData {
                switch userInfo.providerID {
                case "facebook.com":
                    print("user is signed in with facebook")
                    
                    
                    let itemRef = ProfilePicRef.child("\(Auth.auth().currentUser?.displayName as String!) \(Auth.auth().currentUser?.uid as String!)") // 1
                    
                    
                    
                    
                    
                    
                    let messageItem = [ // 2
                        
                        "userProfilePic": Auth.auth().currentUser?.photoURL?.absoluteString as AnyObject!
                    ]
                    
                    
                    
                    itemRef.setValue(messageItem) // 3
                    
                    performSegue(withIdentifier: "showMyTab", sender: AnyObject.self)
                    
                    
                default:
                    print("user is signed in with \(userInfo.providerID)")
                    
                    performSegue(withIdentifier: "showMyTab", sender: AnyObject.self)
                }
            }
            
        }
        
        
        
        
    }
    
    //MARK:Properties
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let firstLaunch = FirstLaunch(userDefaults: .standard, key: "com.any-suggestion.FirstLaunch.WasLaunchedBefore")
        if firstLaunch.isFirstLaunch {
            // do things
            
            present(MoreUserInfoViewController(), animated: true, completion: nil)
        }
        
        //        let alwaysFirstLaunch = FirstLaunch(getWasLaunchedBefore: { return false }, setWasLaunchedBefore: { _ in })
        //        if alwaysFirstLaunch.isFirstLaunch {
        //            // will always execute
        //            present(MoreUserInfoViewController(), animated: true, completion: nil)
        //        }
        
        
        view.addSubview(myBanner)
        
        setupMyGoogleAd()
        
        
        view.addSubview(bookCounter)
        
        setupBookCounter()
    }
    
    func presentAlert() {
        let alertController = UIAlertController(title: "Username?", message: "Some how you got by without a username please enter one now:", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in
            if let field = alertController.textFields?[0] {
                // store your data
                var user = Auth.auth().currentUser?.createProfileChangeRequest()
                user?.displayName = field.text
                
                user?.commitChanges { error in
                    if let error = error {
                        // An error happened.
                    } else {
                        // Profile updated.
                    }
                }
                
                
            } else {
                // user did not fill field
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Taylor"
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        DispatchQueue.main.async {
            if Auth.auth().currentUser?.displayName == nil {
                self.presentAlert()
                
            }
        }
        
        
        
        
        
        
        view.addSubview(uiimvProfilePic)
        
        setupProfileImageView()
        
        view.addSubview(welcomeLabel)
        
        setUpWelcomeLabel()
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        view.addSubview(uilName)
        
        setUpNameLabel()
        
        
        
        view.addSubview(continueButton)
        
        setupContinueButton()
        
        
        view.addSubview(conditionsButton)
        
        setupConditionsButt()
        
        
        
        view.addSubview(aivLoadingSpinner)
        
        setupMySpinner()
        
        
        
        /*  continueButton.layer.cornerRadius = 5
         continueButton.backgroundColor = UIColor(red: 59/255, green: 89/255, blue: 152/255, alpha: 1.0)*/
        
        
        //requests.testDevices = [kGADSimulatorID]
        
        OneSignal.idsAvailable({ (userId, pushToken) in
            self.userPushID = userId!
            if (pushToken != nil) {
                NSLog("pushToken:%@", pushToken ?? "")
            }
        })
        
        
        if let providerData = Auth.auth().currentUser?.providerData {
            for userInfo in providerData {
                switch userInfo.providerID {
                case "facebook.com":
                    print("user is signed in with facebook")
                default:
                    uilName.isHidden = true
                }
            }
        }
        
        
        
        
        
        
        var bookCountRef = Database.database().reference().child("books")
        
        
        DispatchQueue.main.async(execute: {
            
            
            bookCountRef.observe(.value, with: { (snapshot) in
                
                print(snapshot.childrenCount)
                
                self.bookCounter.text = "\(snapshot.childrenCount) books have been shared by others"
                
                
                
                
            }, withCancel: nil)
            
            
        })
        
        
        
        
        
        // Do any additional setup after loading the view.
        
        
        //self.uiimvProfilePic.layer.cornerRadius = self.uiimvProfilePic.frame.size.width/2
        
        
        
        // self.uiimvProfilePic.clipsToBounds = true
        
        
        //circularImage(uiimvProfilePic)
        
        
        
        if let providerData = Auth.auth().currentUser?.providerData {
            for userInfo in providerData {
                switch userInfo.providerID {
                case "facebook.com":
                    print("user is signed in with facebook")
                    
                    if let user = Auth.auth().currentUser {
                        
                        // User is signed in.
                        
                        let name = user.displayName
                        var email = user.email
                        let photoUrl = user.photoURL
                        let uid = user.uid;
                        let PushingID = userPushID
                        
                        
                        self.uilName.text = name
                        
                        
                        print (email)
                        
                        //reference to firebase storage service
                        
                        let storage = Storage.storage()
                        
                        //refer your particular storage service
                        
                        let storageRef = storage.reference(forURL: "gs://biblos-1.appspot.com")
                        
                        let profilePicRef = storageRef.child(user.uid+"/profile_pic.jpg")
                        
                        
                        
                        
                        
                        
                        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
                        profilePicRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) -> Void in
                            if (error != nil) {
                                // Uh-oh, an error occurred!
                                
                                print("Unable to download image")
                                
                            } else {
                                
                                
                                if(data != nil){
                                    
                                    print ("User already has an image, no need to download from Facebook")
                                    
                                    self.uiimvProfilePic.image = UIImage(data:data!)?.circleMasked
                                    
                                    
                                    
                                    
                                    
                                    
                                }
                                
                                // Data for "images/island.jpg" is returned
                                // ... let islandImage: UIImage! = UIImage(data: data!)
                                
                                
                                
                                if (email != nil){
                                    
                                    
                                    email = user.email
                                    
                                    
                                    
                                    
                                }
                                    
                                    
                                    
                                else{
                                    
                                    let UserEmail = FBSDKGraphRequest.init(graphPath: "me", parameters: ["fields":"email"]).start { (connection, result, error) -> Void in
                                        
                                        
                                        let strEmail: String = ((result as AnyObject).object(forKey: "email") as? String)!
                                        
                                        let userEducation = FBSDKGraphRequest.init(graphPath: "me", parameters: ["fields":"education"])
                                        
                                        print(userEducation)
                                        
                                        
                                        
                                        
                                        
                                        
                                        
                                        //  print (strEmail)
                                        
                                        //print ((FIRAuth.auth()?.currentUser?.photoURL?.absoluteString) as String!)
                                        
                                        let values = ["name": Auth.auth().currentUser?.displayName as String!, "email": strEmail, "profileImageUrl":(Auth.auth().currentUser?.photoURL?.absoluteString) as String! , "pushID": PushingID]
                                        
                                        
                                        
                                        
                                        self.registerUserIntoDatabaseWithUID(Auth.auth().currentUser?.uid as String!, values: values as [String : AnyObject])
                                        
                                        
                                        
                                    }
                                    
                                    
                                    
                                    
                                }
                                
                            }
                        }
                        
                        
                        /*   if(self.uiimvProfilePic.image == nil) {
                         
                         
                         
                         let profilePic = FBSDKGraphRequest(graphPath: "me/picture", parameters: ["height":300, "width":300,"redirect":false], httpMethod: "GET")
                         profilePic?.start(completionHandler: {(connection, result, error) -> Void in
                         // Handle the result
                         
                         
                         if (error == nil){
                         
                         let dictionary = result as? NSDictionary
                         
                         let data = dictionary?.object(forKey: "data")
                         
                         let urlPic = ((data as AnyObject).object(forKey: "url"))! as! String
                         
                         if let imagedata = try? Data(contentsOf: URL(string: urlPic)!){
                         
                         let uploadTask = profilePicRef.putData(imagedata, metadata:nil){
                         
                         
                         metadata,error in
                         
                         if (error == nil){
                         
                         let downloadUrl = metadata!.downloadURL
                         
                         }
                         
                         else{
                         
                         
                         print("ERROR IN DOWNLOAIND IMAGE")
                         
                         }
                         }
                         
                         self.uiimvProfilePic.image = UIImage(data:imagedata)?.circleMasked
                         }
                         
                         }
                         })
                         
                         
                         } *///end if
                        
                        
                    } else {
                        // No user is signed in.
                    }
                    
                    
                    let values = ["name": Auth.auth().currentUser?.displayName as String!, "email": Auth.auth().currentUser?.email as String!, "profileImageUrl":(Auth.auth().currentUser?.photoURL?.absoluteString) as String!] //"pushID": self.userPushID ]
                    
                    
                    
                    
                    self.registerUserIntoDatabaseWithUID(Auth.auth().currentUser?.uid as String!, values: values as [String : AnyObject])
                    
                    
                    
                    
                default:
                    print("user is signed in with \(userInfo.providerID)")
                    
                    print("this is empty?", Auth.auth().currentUser?.photoURL)
                    
                    let userIdForPic = Auth.auth().currentUser?.uid as String!
                    
                    let picRef = Database.database().reference().child("users").child(userIdForPic!).child("profileImageUrl")
                    
                    picRef.observe(.value, with: { (snapshot) in
                        
                        // print("This is it!",snapshot.value as! String!)
                        
                        
                        self.usersPhotoLink = snapshot.value as! String!
                        
                        
                        
                        let imageCache = NSCache<AnyObject, AnyObject>()
                        
                        let url = URL(string: self.usersPhotoLink as String! )
                        
                        
                        print("THIS IS THE URL", url)
                        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                            
                            //download hit an error so lets return out
                            if error != nil {
                                print("THIS IS THE ERROR",error)
                                return
                            }
                            
                            DispatchQueue.main.async(execute: {
                                
                                if let downloadedImage = UIImage(data: data!) {
                                    imageCache.setObject(downloadedImage, forKey: self.usersPhotoLink as String! as AnyObject)
                                    
                                    print("THIS WORKS?", self.usersPhotoLink as String!)
                                    
                                    self.uiimvProfilePic.image = downloadedImage.circleMasked
                                    
                                    
                                    
                                    
                                }
                            })
                            
                        }).resume()
                        
                        
                        // self.usersPhotoLink.append(FIRDataSnapshot)
                        
                        
                        
                        
                    }, withCancel: nil)
                    
                    
                    
                    
                    
                    let userNameRef = Database.database().reference().child("users").child(userIdForPic!).child("name")
                    
                    userNameRef.observeSingleEvent(of: .value, with: { (snapshot) in
                        
                        self.uilName.text = snapshot.value as! String!
                        self.uilName.isHidden = false
                        
                        
                    }, withCancel: nil)
                    
                    
                }
            }
            
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
    }
    
    
    /*  override var shouldAutorotate : Bool {
     return false
     }
     
     override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
     return UIInterfaceOrientationMask.portrait
     } */
    
    
    fileprivate func registerUserIntoDatabaseWithUID(_ uid: String, values: [String: AnyObject]) {
        let ref = Database.database().reference()
        let usersReference = ref.child("users").child(uid)
        
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            if err != nil {
                print(err)
                return
            }
            
            
        })
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}




