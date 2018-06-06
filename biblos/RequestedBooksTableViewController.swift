//
//  RequestedBooksTableViewController.swift
//  biblos
//
//  Created by Taylor Simpson on 2/14/18.
//  Copyright © 2018 Taylor Simpson. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import DZNEmptyDataSet
import PMAlertController
import Kingfisher

/* The idea is this. A user will have a list of books they have requested Then there will be a cell detail/decorater that will display a red X for declined, a green check mark for approved and a question mark for neither approved nor denied*/

class RequestedBooksTableViewController: UITableViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    var requestedBooks:[String:AnyObject] = [:]
    var requestedBookPhotos:[String] = []
    var requestedBookTitle:[String] = []
    var approved:[String] = []
    var keyArray:[String] = []
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "You haven't requested a book yet"
        let attrs = [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "Look for some books!"
        let attrs = [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "OpenBook.png")
    }
    
    func backgroundColor(forEmptyDataSet scrollView: UIScrollView) -> UIColor {
        return UIColor(red: 59/255, green: 89/255, blue: 152/255, alpha: 1.0)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        title = "Your Requests"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        //tableView.backgroundColor = .black
        tableView.tableFooterView = UIView()
        getRequestedBooks(userID: (Auth.auth().currentUser?.uid)!)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func getRequestedBooks(userID:String){
        
        
        var userBookRef = Database.database().reference().child("users").child(userID).child("requestedBooks")
        
        userBookRef.observeSingleEvent(of: .value) { (snapshot) in
            guard let requestedBooksDic = snapshot.value as? [String:AnyObject] else {return}
            
            self.requestedBooks = requestedBooksDic
            
            for (keys,values) in requestedBooksDic{
                let bookRef = Database.database().reference().child("books").child(keys).child("bookPhoto")
                
                bookRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    if snapshot.exists(){
                        self.requestedBookPhotos.append(snapshot.value as! String)}
                    
                    
                   
                })
                
                let titleRef = Database.database().reference().child("books").child(keys).child("title")
                titleRef.observeSingleEvent(of: .value, with: { (snapshot) in
                   
                    if snapshot.exists(){
                        self.requestedBookTitle.append(snapshot.value as! String)
                        
                        self.approved.append(values as! String)
                        self.keyArray.append(keys)
                        
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                    
                })
                
                
                
            }
            
            
        }
        
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
        return requestedBookTitle.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "requests", for: indexPath) as! RequestedTableViewCell

        // Configure the cell...
         cell.backgroundColor = UIColor.clear
        var picture = self.requestedBookPhotos[indexPath.row]
        var title = self.requestedBookTitle[indexPath.row]
        var approved = self.approved[indexPath.row]
        
        
        
        let processor = OverlayImageProcessor(overlay: .black, fraction: 0.75)
        cell.requestedBookImage.kf.indicatorType = .activity
        cell.requestedBookImage.kf.setImage(with: URL(string: picture), placeholder: UIImage(named:"old-books-436498_640.jpg"), options: [.transition(.fade(0.2)), .processor(processor)])
        
//        DispatchQueue.main.async {
//
//            cell.requestedBookImage.loadImageUsingCacheWithUrlString(picture, gradient: true)
//        }
        cell.requestedBookImage.layer.cornerRadius = 20.0
        cell.requestedBookImage.clipsToBounds = true
        cell.bookTitleLabel.textColor = .white
        cell.bookTitleLabel.text = title
        cell.contentView.layer.shadowColor = UIColor.black.cgColor
        cell.contentView.layer.shadowOpacity = 0.60
        cell.contentView.layer.shadowOffset = .zero
        cell.contentView.layer.shadowRadius = 10.0
        
        
        if approved == "true"{
            cell.isApprovedImage.image = UIImage(named: "icons8-checked_filled.png")
            cell.grantedLabel.text = "Request Approved"
            cell.grantedLabel.textColor = .white
        } else {
            cell.isApprovedImage.image = nil
            cell.grantedLabel.text = nil
            cell.grantedLabel.textColor = .white
        }

        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var myAlert = PMAlertController(title: "Remove", description: "Would you like to remove your request?", image: nil, style: .alert)
        
        myAlert.addAction(PMAlertAction(title: "Yes", style: .default, action: {
            var picture = self.requestedBookPhotos[indexPath.row]
            var title = self.requestedBookTitle[indexPath.row]
            var approved = self.approved[indexPath.row]
            
            var removeRequestID = self.keyArray[indexPath.row]
            
            var removeRequestRef = Database.database().reference().child("books").child(removeRequestID).child("Requests").child((Auth.auth().currentUser?.uid)!)
            
            removeRequestRef.removeValue()
            
            var userBookRef = Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).child("requestedBooks").child(removeRequestID)
            
            userBookRef.removeValue()
            
//            var RequestApproved: String?
//            var ApprovedRequestor: String?
            
            if approved == "true"{
                let approvedRemoval = Database.database().reference().child("books").child(removeRequestID).child("ApprovedRequestor")
                
                approvedRemoval.removeValue()
                
                let notApproved = Database.database().reference().child("books").child(removeRequestID).child("RequestApproved")
                
                notApproved.removeValue()
            }
            
            
            self.requestedBooks.removeAll()
            self.requestedBookPhotos.removeAll()
            self.requestedBookTitle.removeAll()
            self.approved.removeAll()
            self.keyArray.removeAll()
            
            self.getRequestedBooks(userID: (Auth.auth().currentUser?.uid)!)
            
            
            
        }))
        
        myAlert.addAction(PMAlertAction(title: "Cancel", style: .cancel))
        
         self.present(myAlert, animated: true, completion: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
