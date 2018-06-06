//
//  RequestsTableViewController.swift
//  biblos
//
//  Created by Taylor Simpson on 2/8/18.
//  Copyright © 2018 Taylor Simpson. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import Kingfisher
import FBSDKCoreKit
import PMAlertController
import DZNEmptyDataSet

class RequestsTableViewController: UITableViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {


    var bookRequestors: [String] = []
    var bookID = ""
  
    var myDict: [String:AnyObject] = [:]
    
    var userInfoArray: [[String: AnyObject]] = []
    
    var nameArray:[String] = []
    var pictureArray: [String] = []
    
    
    var approvedRequestorID = ""
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "Your book hasn't been requested yet"
        let attrs = [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "Your requestors will show up here and you can approve them"
        let attrs = [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "UpLoadBook.png")
    }
    
    func backgroundColor(forEmptyDataSet scrollView: UIScrollView) -> UIColor {
        return UIColor(red: 59/255, green: 89/255, blue: 152/255, alpha: 1.0)
        
    }
   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        title = "Requestors"
    }
    
    
    func grabUsers(){
        //print(bookRequestors)
        for requests in bookRequestors{
       
            
        
        let usersRef = Database.database().reference().child("users").child(requests)
            
            
            let userPicRef = usersRef.child("profileImageUrl")
            let userNameRef = usersRef.child("name")
            
            userPicRef.observeSingleEvent(of: .value, with: { (snapshot) in
                self.pictureArray.append(snapshot.value as! String)
                
                userNameRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    self.nameArray.append(snapshot.value as! String)
                    
                    self.tableView.reloadData()
                })
            })
            
//            usersRef.observe(.value, with: { (snapshot) in
//
//                var myDict:[String: AnyObject] = [:]
//
//                myDict = snapshot.value as! [String:AnyObject]
//
//                self.userInfoArray.append(myDict)
//
//                self.tableView.reloadData()
//            })
            
            
        }

    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        //tableView.backgroundColor = .black
        tableView.tableFooterView = UIView()
        
       grabUsers()
        
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        print("MY COUNT IS: \(userInfoArray.count)")
        return nameArray.count
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "people", for: indexPath) as! RequestTableViewCell

        // Configure the cell...
    
    // var users = self.userInfoArray[indexPath.row]
     
        var myPic = self.pictureArray[indexPath.row]
        var myName = self.nameArray[indexPath.row]
        
      //  var myName = users["name"]
      //  var myPic = users["profileImageUrl"]
        
        
        let user = User()
        print("This is a count: \(self.bookRequestors.count)")
        
        print ("the index is: \(indexPath)")
        user.id = self.bookRequestors[indexPath.row]
        
        
        
        cell.userImage.layer.cornerRadius = 20.0
        cell.contentView.layer.shadowColor = UIColor.black.cgColor
        cell.contentView.layer.shadowOpacity = 0.60
        cell.contentView.layer.shadowOffset = .zero
        cell.contentView.layer.shadowRadius = 10.0
        
        //cell.userImage?.setRounded()
        cell.userImage.clipsToBounds = true
        
        
        
        
        
        
        let processor = RoundCornerImageProcessor(cornerRadius: 100)
        
        DispatchQueue.main.async {

            cell.userImage.loadImageUsingCacheWithUrlString(myPic as! String, gradient: true)
            
        }
        
        
        cell.userName.text = myName as! String
     
            if user.id == approvedRequestorID{
                cell.wasApproved.image = UIImage(named: "icons8-checked_filled.png")
                cell.approvedLabel.text = "You agreed to swap with this user "
            } else{
                cell.wasApproved.image = nil
                cell.approvedLabel.text = nil
        }
        

        cell.backgroundColor = .clear
      
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: Create an alertView that asks if they want to chat to the user.
        let alertVC = PMAlertController(title: "Send A Message?", description: "Are you sure you want to contact this user?", image: UIImage(named: "booksandcoffee.jpg"), style: .alert)
        
        alertVC.addAction(PMAlertAction(title: "Message", style: .default, action: { () in
            print("Capture action OK")
            
            let user = User()
            
            user.id = self.bookRequestors[indexPath.row]
            
            var users = self.userInfoArray[indexPath.row]
            
            var userMessagedPushId = users["pushID"]
            
            user.name = users["name"] as! String
            
            user.pushID = userMessagedPushId as! String
            
            self.showChatControllerForUser(user)
        }))
        
        alertVC.addAction(PMAlertAction(title: "Approve this users request", style: .default, action: {
            print("Book Approved")
            let user = User()
            
            user.id = self.bookRequestors[indexPath.row]
            
            //var users = self.userInfoArray[indexPath.row]
            
            var bookRef = Database.database().reference().child("books").child("-" + self.bookID)
            
            bookRef.observeSingleEvent(of: .value, with: { (snapshot) in
                var tempDict = snapshot.value as! [String:AnyObject]
                
               
                
                if tempDict["RequestApproved"] == nil || tempDict["RequestApproved"] as! String == "false"{
                    
                    //bookRef.updateChildValues(["RequestApproved": "true", "ApprovedRequestor": user.id])
                    bookRef.updateChildValues(["RequestApproved": "true", "ApprovedRequestor": user.id], withCompletionBlock: { (error, ref) in
                        
                        let userRef = Database.database().reference().child("users").child(user.id!).child("requestedBooks")
                        // true meaning this book has been approved for this user
                        userRef.updateChildValues(["-" + self.bookID:"true"])
                        
                        self.approvedRequestorID = user.id!
                        self.tableView.reloadData()
                    })
                    
                } else{
                    
                    print("Already Approved!")
                    
                     let alertVC = PMAlertController(title: "Sorry?", description: "You Already Approved that book for someone Else", image: UIImage(named: "booksandcoffee.jpg"), style: .alert)
                    
                    alertVC.addAction(PMAlertAction(title: "Ok", style: .default))
                    
                    self.present(alertVC, animated: true, completion: nil)
                    
                }
                
            })
            
            
        }))
        
        alertVC.addAction(PMAlertAction(title: "Remove Approval", style: .default, action: {
            
            
            
            let myUser = User()
            myUser.id = self.bookRequestors[indexPath.row]
            
            //var users = self.userInfoArray[indexPath.row]
            
            var bookRef = Database.database().reference().child("books").child("-" + self.bookID)
            
            
            bookRef.updateChildValues(["RequestApproved": "false", "ApprovedRequestor": "none"], withCompletionBlock: { (error, ref) in
                
                let userRef = Database.database().reference().child("users").child(myUser.id!).child("requestedBooks")
                // true meaning this book has been approved for this user
              //  userRef.updateChildValues(["-" + self.bookID:"false"])
                
                userRef.updateChildValues(["-" + self.bookID:"false"], withCompletionBlock: { (error, ref) in
                    
                    print("it's happening")
                    self.approvedRequestorID = " "
                    self.tableView.reloadData()
                })
                
//                self.bookRequestors.removeAll()
//
//
//                self.myDict.removeAll()
//
//                self.userInfoArray.removeAll()
//
//                self.nameArray.removeAll()
//                self.pictureArray.removeAll()
//
//                self.grabUsers()
            })
            
        }))
        
        alertVC.addAction(PMAlertAction(title: "Cancel", style: .cancel, action: { () -> Void in
            print("Capture action Cancel")
        }))
        
      
        
        self.present(alertVC, animated: true, completion: nil)
        
        
    }
    
    
    func showChatControllerForUser(_ user: User) {
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.user = user
        chatLogController.pushToUser = user.pushID
        
        
        
        if Auth.auth().currentUser?.uid == user.id {
            
            print("IT's TRUE")
        }
        
        
        //print("TRY THIS", userBeingPushedMSG)
        navigationController?.pushViewController(chatLogController, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(true)
        title = nil
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
  /*  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let desitnationVC = segue.destination as! ChatLogController
        
    } */
    

}
