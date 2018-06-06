//
//  InboxTableViewController.swift
//  biblos
//
//  Created by Taylor FIckle Simpson on 7/7/16.
//  Copyright © 2016 Taylor Simpson. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FBSDKCoreKit
import DZNEmptyDataSet
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


let DataReference = Database.database().reference(fromURL: "https://biblos-1.firebaseio.com/")


class MessagesController: UITableViewController,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "You have no messages yet."
        let attrs = [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "You can send new messages by selecting a book or looking at people who have requested your book"
        let attrs = [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "OpenBook.png")
    }
    
    func backgroundColor(forEmptyDataSet scrollView: UIScrollView) -> UIColor {
        return UIColor(red: 59/255, green: 89/255, blue: 152/255, alpha: 1.0)
        
    }
    
//    
//    func buttonTitle(forEmptyDataSet scrollView: UIScrollView, for state: UIControlState) -> NSAttributedString? {
//        let str = "Tap Me To Upload Your Book"
//        let attrs = [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: UIFontTextStyle.callout), NSAttributedStringKey.foregroundColor: UIColor.white]
//        
//        return NSAttributedString(string: str, attributes: attrs)
//    }
    
    func emptyDataSet(_ scrollView: UIScrollView, didTap button: UIButton) {
        /*let ac = UIAlertController(title: "Button tapped!", message: nil, preferredStyle: .alert)
         ac.addAction(UIAlertAction(title: "Hurray", style: .default))
         present(ac, animated: true)
         */
        
        //self.performSegue(withIdentifier: "uploadBook", sender: AnyObject.self)
    }

    let cellId = "cellId"
    
    
    @objc func didLogOut(){
        
        
        //signs user out of firebase app
        
        try! Auth.auth().signOut()
        
        //sign user out of facebook app
        
        FBSDKAccessToken.setCurrent(nil)
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name:"Main", bundle: nil)
        
        let viewController: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "LoginView")
        
        self.present(viewController, animated: true, completion: nil)
        
        
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var tutboard = UIStoryboard(name: "Tutorials", bundle: nil)
        
       
        
        
        
        if(!UserDefaults.standard.bool(forKey: "Messagefirstlaunch1.0")){
            //Put any code here and it will be executed only once.
             present(tutboard.instantiateViewController(withIdentifier: "chatTut"), animated: true, completion: nil)
            print("Is a first launch")
            UserDefaults.standard.set(true, forKey: "Messagefirstlaunch1.0")
            UserDefaults.standard.synchronize();
        
        }
        
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView()
        
         UIApplication.shared.statusBarStyle = .lightContent
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
        self.tabBarController!.navigationItem.title = "Messages"
        
        
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: "Helvetica", size: 20)!, NSAttributedStringKey.foregroundColor: UIColor.white]
        
        
        
        tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(didLogOut))
        

       // navigationController!.navigationBar.barTintColor = UIColor(red: 59/255, green: 89/255, blue: 152/255, alpha: 1.0)
        
        navigationController?.navigationBar.barTintColor = .black
        tabBarController?.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        
       observeUserMessages()
        
        tableView.allowsMultipleSelectionDuringEditing = true
    
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
        
        let message = self.messages[indexPath.row]
        
        
        
        if let chatPartnerId = message.chatPartnerId(){
        
            Database.database().reference().child("user-messages").child(uid).child(chatPartnerId).removeValue(completionBlock: { (error, ref) in
            
            if error != nil{
            
                print("Failed to delete message:", error)
                
                return
            
            
            }
            
            self.messagesDictionary.removeValue(forKey: chatPartnerId)
            self.attemptReloadOfTable()
            
        })
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
         self.tabBarController?.navigationItem.titleView = nil
        self.tabBarController?.navigationItem.title = " Messages"
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: "Helvetica", size: 20)!, NSAttributedStringKey.foregroundColor: UIColor.white]
        
       // present(ChatTutorialViewController(), animated: true, completion: nil)
    }
    
    var messages = [Message] ()
    
    var messagesDictionary = [String: Message]()
    
    
    func observeUserMessages() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let ref = Database.database().reference().child("user-messages").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            
            let userId = snapshot.key
            Database.database().reference().child("user-messages").child(uid).child(userId).observe(.childAdded, with: { (snapshot) in
                
                
                let messageId = snapshot.key
                
                
                print(messageId)
                
                self.fetchMessageWithMessageId(messageId)
                
                
                
                
              
                        
                    
                    
                    }, withCancel: nil)
                
                
                
                
                }, withCancel: nil)
        
        
        ref.observe(.childRemoved, with: { (snapshot) in
            
            self.messagesDictionary.removeValue(forKey: snapshot.key)
            self.attemptReloadOfTable()
            
            
            }, withCancel: nil)

    }
    
    
    
    
    
    
    fileprivate func fetchMessageWithMessageId(_ messageId: String) {
        let messagesReference = Database.database().reference().child("messages").child(messageId)
        
        messagesReference.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let message = Message()
                message.setValuesForKeys(dictionary)
                
                if let chatPartnerId = message.chatPartnerId() {
                    self.messagesDictionary[chatPartnerId] = message
                }
                
                self.attemptReloadOfTable()
            }
            
            }, withCancel: nil)
    }
    

    fileprivate func attemptReloadOfTable() {
        self.timer?.invalidate()
        
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
    }
    
    var timer: Timer?
    
    @objc func handleReloadTable() {
        self.messages = Array(self.messagesDictionary.values)
        self.messages.sort(by: { (message1, message2) -> Bool in
            
            return message1.timestamp?.int32Value > message2.timestamp?.int32Value
        })
        
        //this will crash because of background thread, so lets call this on dispatch_async main thread
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
        })
    }

   
    
    


    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        
        let message = messages[indexPath.row]
        cell.message = message
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let message = messages[indexPath.row]
        
        
        guard let chatPartnerId = message.chatPartnerId() else{
        
            return
            
        }
        
        
        let ref = Database.database().reference().child("users").child(chatPartnerId)
        
        
        ref.observe(.value, with: { (snapshot) in
            
            guard let dictionary = snapshot.value as? [String: AnyObject] else{
            
                return
                        }
            
            let user = User()
            
            user.id = chatPartnerId
            
            user.setValuesForKeys(dictionary)
            
            self.showChatControllerForUser(user)
            
            
            
            }, withCancel: nil)
        
        
        
    
    
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }

    func showChatControllerForUser(_ user: User) {
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.user = user
        navigationController?.pushViewController(chatLogController, animated: true)
    }
    

}
