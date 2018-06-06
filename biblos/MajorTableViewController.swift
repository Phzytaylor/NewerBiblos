//
//  MajorTableViewController.swift
//  biblos
//
//  Created by Taylor Simpson on 1/26/18.
//  Copyright © 2018 Taylor Simpson. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import Kingfisher
import DZNEmptyDataSet

class MajorTableViewController: UITableViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {

    
    var userTobeMessaged: String!
    
    var userToBeMessagedId: String!
    
    var toBeUserId: String!
    
    var bookInfoSender: String!
    
    
    var userPictureURL : String!
    
    var postID: String!
    
    var bookdIdArray = [String]()
    var books: [[String:AnyObject]] = []
    var major = String()
    
     var keyArray = [String]()
    
    func loadBooks(){
        let bookRef = Database.database().reference().child("majors").child(major)
        
        bookRef.observe(.value) { (snapshot) in
            //print(snapshot.key)
            
            print("I Think two times?")
            
            // print("I've Been Fired")
            
            
            self.bookdIdArray.append(snapshot.key)
            
            
            
            for child in self.bookdIdArray {
                
                //print(snapshot.value)
                
                guard let bookID = snapshot.value as? Dictionary<String, AnyObject> else {
                    
                    return}
                
                for keys in bookID.keys {
                    
                    self.keyArray.append(keys)
                    print("I went!")
                    var bookRef = Database.database().reference().child("books").child(keys)
                    
                    bookRef.observeSingleEvent(of: .value, with: { (snapshot) in
                        self.books.append(snapshot.value as! [String : AnyObject])
                        
                        // print(self.books[0])
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                        
                        
                        
                    })
                    
                    
                    
                }
                
                print("1,2,3...")
                
            }
            
            
            
            
            //print(self.schoolsArray.count)
            
            
            
            
            
            
            
        }
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "There are no books here yet, but users like you can change that!"
        let attrs = [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "Tap Below To Add A Book"
        let attrs = [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "OpenBook.png")
    }
    
    func backgroundColor(forEmptyDataSet scrollView: UIScrollView) -> UIColor {
        return UIColor(red: 59/255, green: 89/255, blue: 152/255, alpha: 1.0)
        
    }
    
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView, for state: UIControlState) -> NSAttributedString? {
        let str = "Tap Me To Upload Your Book"
        let attrs = [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: UIFontTextStyle.callout), NSAttributedStringKey.foregroundColor: UIColor.white]
        
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func emptyDataSet(_ scrollView: UIScrollView, didTap button: UIButton) {
        /*let ac = UIAlertController(title: "Button tapped!", message: nil, preferredStyle: .alert)
         ac.addAction(UIAlertAction(title: "Hurray", style: .default))
         present(ac, animated: true)
         */
        
        self.performSegue(withIdentifier: "majorsToUpload", sender: AnyObject.self)
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
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = major
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tableView.backgroundView = UIImageView(image: imageWithGradient(img: UIImage(named: "nicelib.jpeg")))
        tableView.backgroundColor = .white
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView()
        //tableView.backgroundColor = .black
        
        loadBooks()

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
        return books.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "major Books", for: indexPath) as! MajorCell

        print("The count of books is \(self.books.count)")
        
        let book = self.books[indexPath.row]
        
        let Author = book["Author"] as! String!
        let Comment = book["Comment"] as! String!
        let Genre = book["Genre"] as! String!
        let User = book["User"] as! String!
        let title = book["title"] as! String!
        let bookPhoto = book["bookPhoto"] as! String!
        let userID = book["userID"] as! String!
        let userLocation = book["userLocation"] as! String!
        let bookRate = book["bookRating"] as! String!
        let userToBePushed = book["pushingID"] as! String!
        let bookLat = book["bookLat"] as! String!
        let bookLng = book["bookLng"] as! String!
        let coditionOfBook = book["Condition"] as! String!
        
        let url = URL(string: bookPhoto!)
        
        print(url)
        let p = Bundle.main.path(forResource: "book009", ofType: "gif")!
        let datas = try! Data(contentsOf: URL(fileURLWithPath: p))
        
        cell.bookImageView.kf.indicatorType = .image(imageData: datas)
        
        //cell.bookImageView.setRounded()
        
        cell.bookImageView.layer.cornerRadius = 20.0
        cell.bookImageView.contentMode = .scaleToFill
        cell.bookImageView.clipsToBounds = true
        cell.contentView.layer.shadowColor = UIColor.black.cgColor
        cell.contentView.layer.shadowRadius = 5.0
        cell.contentView.layer.shadowOpacity = 0.95
        cell.contentView.layer.shadowOffset = .zero
        
       // let processor = RoundCornerImageProcessor(cornerRadius: 100)
        
        
        //cell.bookImageView.kf.setImage(with: url, options: [.transition(.fade(0.2))])
        
        DispatchQueue.main.async {
            cell.bookImageView.loadImageUsingCacheWithUrlString(bookPhoto!, gradient: true)
        }

        cell.bookLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        cell.bookLabel?.text = title! as String
        
        cell.authorLabel.text = "Author: " + Author! as String
        
        
        
        
        
        cell.backgroundColor = .clear
        
        cell.bookLabel?.textColor = UIColor.white
        
        //cell.bookLabel?.font = UIFont(name: "Helvetica", size: 20)
        
        
        
        
        
        return cell
        
        
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "majorsToUpload"){
            
            // let viewController = segue.destination as! BookuploadFormViewController
            
            print("tree")
            
        }
        
        
        
        if (segue.identifier == "majorBookInfo") {
            
            
            //let navVC = segue.destinationViewController as! UINavigationController
            
            //This was before the major UI Update ---------
            
            //let viewController = segue.destination as! MoreInfoViewController
            
            
            //-------------------------------------
            
            let viewController = segue.destination as! NewMoreInformationViewController
            
            let indexPath : IndexPath = self.tableView.indexPathForSelectedRow!
            
            
            let book = self.books[indexPath.row]
            
            // let moreInfoCells = moreInfoSnaphot.value as! Dictionary<String, String>
            
            let AuthorInfo = book["Author"] as! String!
            let CommentInfo = book["Comment"] as! String!
            let GenreInfo = book["Genre"] as! String!
            let UserInfo = book["User"] as! String!
            let titleInfo = book["title"] as! String!
            let bookPhotoInfo = book["bookPhoto"] as! String!
            let userIDInfo = book["userID"] as! String!
            let userPIC = book["userPhoto"] as! String!
            let userLocation = book["userLocation"] as! String!
            let userToBePushed = book["pushingID"] as! String!
            let coditionOfBook = book["Condition"] as! String!
            let theBookID = keyArray[indexPath.row]
            
            print(userToBePushed)
            
            
            userPictureURL = userPIC
            
            
            
            
            // This posts the comment about the book in the info view
            
            bookInfoSender = CommentInfo
            
            //These two vars are to handel messageing and can be referenced later
            userTobeMessaged = UserInfo
            
            userToBeMessagedId = userIDInfo
            
            ////////////////////////////////////////
            
            // initialize new view controller and cast it as your view controller
            
            // your new view controller should have property that will store passed value
            viewController.bookComment = bookInfoSender
            viewController.UserToBeContacted = UserInfo
            viewController.UserContactedID = userToBeMessagedId
            viewController.userPictureurl = userPictureURL
            viewController.userLocate = userLocation
            viewController.bookPictureLink = bookPhotoInfo
            viewController.genreOfBook = GenreInfo
            viewController.titleOfBook = titleInfo
            viewController.userBeingPushedMSG = userToBePushed
            viewController.bookCondition = coditionOfBook
            viewController.bookRequestedId = theBookID
            
            print("THIS IS THE USER TO BE PUSHED \(userToBePushed)")
        }
        
        
        
        
        
        /* let navVc = segue.destinationViewController as! UINavigationController // 1
         let chatVc = navVc.viewControllers.first as! ChatViewController // 2
         chatVc.senderId = FIRAuth.auth()?.currentUser?.uid // 3
         chatVc.senderDisplayName = FIRAuth.auth()?.currentUser?.displayName // 4
         
         
         let userPingged = pinggedUser
         
         let userTochatWith = toBeUserId
         
         
         chatVc.userPingged = userPingged
         
         chatVc.userToBeChatted = userTochatWith
         
         */

        
        
    }
    

}
