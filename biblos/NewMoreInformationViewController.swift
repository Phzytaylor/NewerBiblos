//
//  NewMoreInformationViewController.swift
//  biblos
//
//  Created by Taylor Simpson on 5/14/17.
//  Copyright © 2017 Taylor Simpson. All rights reserved.
//

import UIKit
import Firebase
import MessageUI
import PMAlertController


class NewMoreInformationViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    
   // @IBOutlet weak var summaryView: UIView!
    @IBOutlet weak var summaryViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var summaryTextView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var messageUserButton: UIButton!
    
   
    
    
    @IBAction func messageUserButton(_ sender: AnyObject) {
        
        /* TODO: Want to some how alert the user that their book has been requested. I can probably put this in the my books section. I also need to add another node to the database. The book it self will have another child node which states the number of requests and then under the user books section and the book a subnode of requests the user who wants the book will have their ID stored so as to easily access the book :)
         *
         */
        
        let user = User()
        
        user.id = UserContactedID
        
        user.name = UserToBeContacted
        
        let alertVC = PMAlertController(title: "Select one or cancel", description: "Would you like to message the owner, request a book and message the owner, or just request the book? ", image: UIImage(named: "booksandcoffee.jpg"), style: .alert)
        
        alertVC.addAction(PMAlertAction(title: "Message and request book", style: .default, action: {
            self.showChatControllerForUser(user)
        }))
        
        alertVC.addAction(PMAlertAction(title: "Message only", style: .default, action: {
            let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
            chatLogController.user = user
            chatLogController.pushToUser = self.userBeingPushedMSG
            
            self.navigationController?.pushViewController(chatLogController, animated: true)
            
            
        }))
        
        alertVC.addAction(PMAlertAction(title: "Request book only", style: .default, action: {
            let bookRef = Database.database().reference().child("books").child(self.bookRequestedId).child("Requests")
            
            bookRef.updateChildValues([(Auth.auth().currentUser?.uid)! : 1])
            
            
            
            let userRef = Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).child("requestedBooks")
            
            userRef.observeSingleEvent(of: .value) { (snapshot) in
                if snapshot.exists(){
                    let checkDict = snapshot.value as! [String:AnyObject]
                    
                    
                    
                    if checkDict[self.bookRequestedId] != nil{
                        
                        print("no")
                        
                         let newAlertVC = PMAlertController(title: "Error", description: "You have already requested this book.", image: UIImage(named: "booksandcoffee.jpg"), style: .alert)
                        
                        newAlertVC.addAction(PMAlertAction(title: "Ok", style: .default))
                        
                         self.present(newAlertVC, animated: true, completion: nil)
                        
                    } else{
                        userRef.updateChildValues([self.bookRequestedId: "false"])
                    }
                } else{
                    //false meaning this book has not yet been approved.
                    userRef.updateChildValues([self.bookRequestedId: "false"])
                    
                    
                }
            }
        }))
        
        alertVC.addAction(PMAlertAction(title: "Cancel", style: .cancel))
        
        self.present(alertVC, animated: true, completion: nil)
        
        
        
        
        
        

        
    }
    
    
    
//    var summaryViewHeight: CGFloat! {
//        /*
//         Here we're using a property observer to execute code whenever
//         this value is updated
//         */
//
//        didSet {
//            print("stackViewHeight updated to \(summaryViewHeight)")
//            UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseIn], animations: {
//                self.summaryViewHeightConstraint.constant = self.summaryViewHeight
//                self.view.layoutIfNeeded()
//            }) { _ in
//                self.summaryTextView.scrollRangeToVisible(NSRange(location: 0, length: 0))
//                print("animation complete")
//            }
//        }
//    }
    
    
    var user:User?
    
    var bookComment: String!
    var UserToBeContacted: String!
    var UserContactedID: String!
    var userPictureurl: String!
    var userLocate: String!
    var titleOfBook: String!
    var genreOfBook: String!
    var bookPictureLink: String!
    var userBeingPushedMSG: String!
    var bookCondition: String!
     var bookRequestedId: String = " "

    override func viewDidLoad() {
        super.viewDidLoad()
         UIApplication.shared.statusBarStyle = .lightContent
        
       // configureTapGesture()
        
        //messageUserButton.setTitle("Contact \(UserToBeContacted!) or request book", for: UIControlState())
        messageUserButton.layer.cornerRadius = 20.0
        messageUserButton.clipsToBounds = true
        messageUserButton.layer.opacity = 0.80
        navigationItem.title = titleOfBook
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        navigationController!.navigationBar.barTintColor = UIColor(red: 59/255, green: 89/255, blue: 152/255, alpha: 1.0)
        
        self.tabBarController?.navigationController!.navigationItem.backBarButtonItem?.tintColor = UIColor.white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Report", style: .plain, target: self, action: #selector(reportUser))
        
        self.tabBarController?.navigationController!.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        
        self.navigationItem.rightBarButtonItem?.tintColor = .white
        
        if bookCondition == nil {
            
            bookCondition = "The user did not state the condition of the book."
        }
        
        self.summaryTextView.text = bookComment + "\n\n" + "Book Condition: " + bookCondition
        
        
        
        let p = Bundle.main.path(forResource: "book009", ofType: "gif")!
        let datas = try! Data(contentsOf: URL(fileURLWithPath: p))
        
        
        if let checkedUrl = URL(string: bookPictureLink) {
            
            var placeHolderImage = UIImage(named: "largelib.jpeg")
            
            imageView.contentMode = .scaleToFill
            
            imageView.kf.indicatorType = .activity
            
            imageView.kf.setImage(with: checkedUrl, placeholder: placeHolderImage)
            imageView.layer.cornerRadius = 20.0
            imageView.clipsToBounds = true
            
           
           // downloadImage(url: checkedUrl)
        }
        
        summaryTextView.layer.cornerRadius = 20.0
        summaryTextView.clipsToBounds = true
        
    
//        imageView.layer.shadowColor = UIColor.black.cgColor
//        imageView.layer.shadowRadius = 10.0
//        imageView.layer.shadowOpacity = 0.95
//        imageView.layer.shadowOffset = .zero
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func showChatControllerForUser(_ user: User) {
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.user = user
        chatLogController.pushToUser = userBeingPushedMSG
        
        var bookRef = Database.database().reference().child("books").child(self.bookRequestedId).child("Requests")
        
        bookRef.updateChildValues([(Auth.auth().currentUser?.uid)! : 1])
        
       
        
        let userRef = Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).child("requestedBooks")
        
        userRef.observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists(){
                let checkDict = snapshot.value as! [String:AnyObject]
                
                if checkDict[self.bookRequestedId] != nil{
                    
                    print("no")
                    
                    let alertVC = PMAlertController(title: "Error", description: "You have already requested this book, but you can still chat. ", image: UIImage(named: "booksandcoffee.jpg"), style: .alert)
                    
                    alertVC.addAction(PMAlertAction(title: "Ok", style: .default))
                    
                    
                    self.present(alertVC, animated: true, completion: nil)
                    
                } else {
                    //false meaning this book has not yet been approved.
                    userRef.updateChildValues([self.bookRequestedId: "false"])
                }
            } else{
                //false meaning this book has not yet been approved.
                userRef.updateChildValues([self.bookRequestedId: "false"])

                
            }
        }
        
        if Auth.auth().currentUser?.uid == user.id {
            
            print("IT's TRUE")
        }
        
        
        print("TRY THIS", userBeingPushedMSG)
        navigationController?.pushViewController(chatLogController, animated: true)
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(false)
        navigationController!.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Report", style: .plain, target: self, action: #selector(reportUser))
        
        self.navigationController!.navigationItem.rightBarButtonItem?.tintColor = .white
        
        self.navigationController!.navigationItem.leftBarButtonItem?.tintColor = .white
        
        self.navigationController!.navigationItem.backBarButtonItem?.tintColor = .white
        
       // summaryViewHeight = summaryViewHeightConstraint.constant
        //summaryViewHeight = UIScreen.main.bounds.height/2
        
        navigationController?.navigationBar.barTintColor = .black
        
        
    }
    
//    func configureTapGesture() {
//    
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(toggleHeight(sender:)))
//        tapGestureRecognizer.numberOfTapsRequired = 1
//        
//        summaryView.addGestureRecognizer(tapGestureRecognizer)
//    
//    
//    }
    
    
//    @objc func toggleHeight(sender: UITapGestureRecognizer) {
//        if summaryViewHeightConstraint.constant == UIScreen.main.bounds.height / 2 {
//            // true
//            summaryViewHeight = UIScreen.main.bounds.height - 80 // gives space for status bar and navigation bar
//        } else {
//            // false
//            summaryViewHeight = UIScreen.main.bounds.height / 2
//        }
//    }
    
    @objc func reportUser() {
        
        
        
        //this function reports the user
        
        
        
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["biblosbooksapp@gmail.com"])
            mail.setMessageBody("<p>User \(UserToBeContacted) with id \(UserContactedID) with book title \(titleOfBook) image url: \(bookPictureLink) genre \(genreOfBook) and user photo url of \(userPictureurl)</p>", isHTML: true)
            
            present(mail, animated: true, completion: nil)
        } else {
            // show failure alert
        }
        
        
        
        
        
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    
  /*  func downloadImage(url: URL) {
        print("Download Started")
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() { () -> Void in
                self.imageView.image = UIImage(data: data)
            }
        }
    } */
    
    
}
