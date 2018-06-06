//
//  MyBooksTableViewController.swift
//  biblos
//
//  Created by Taylor FIckle Simpson on 7/26/16.
//  Copyright © 2016 Taylor Simpson. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import DZNEmptyDataSet

import Kingfisher



let dataBase = Database.database()

 var refreshControl: UIRefreshControl = UIRefreshControl()


class MyBooksTableViewController: UITableViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    
    
    
    var keyArray: [String] = []
    var dictionaryArray: [[String:AnyObject]] = []
    var selectedCell: Int = 0
    
    var myBooksArray: [Book] = []
   
    
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
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "You Haven't Uploaded A Book Yet!"
        let attrs = [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "Tap The Upload Tab To Add A Book!"
        let attrs = [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "UpLoadBook.png")
    }
    
    func backgroundColor(forEmptyDataSet scrollView: UIScrollView) -> UIColor {
        return UIColor(red: 59/255, green: 89/255, blue: 152/255, alpha: 1.0)
        
    }
    
    
   /* func buttonTitle(forEmptyDataSet scrollView: UIScrollView, for state: UIControlState) -> NSAttributedString? {
        let str = "Tap Me To Upload Your Book"
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.callout), NSForegroundColorAttributeName: UIColor.white]
        
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func emptyDataSet(_ scrollView: UIScrollView, didTap button: UIButton) {
        /*let ac = UIAlertController(title: "Button tapped!", message: nil, preferredStyle: .alert)
         ac.addAction(UIAlertAction(title: "Hurray", style: .default))
         present(ac, animated: true)
         */
        
        performSegue(withIdentifier: "upLoadThings", sender: AnyObject.self)
    }
*/
    
    
    func trialFunc(){
        guard let userID = Auth.auth().currentUser?.uid else {return}
        
       let usersBookRef = Database.database().reference().child("user-books").child(userID)
        
        usersBookRef.observeSingleEvent(of: .value) { (snapshot) in
            guard let bookDictionary = snapshot.value as? [String:AnyObject] else {return}
            
            for (keys, values) in bookDictionary{
                
                let myBooksRef = Database.database().reference().child("books").child(keys)
                
                myBooksRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    if let dictionary = snapshot.value as? [String: AnyObject]{
                        
                        
                        let book = Book()
                        
                        book.setValuesForKeys(dictionary)
                        
                        
                        self.myBooksArray.append(book)
                        
                        print(book.Author)
                        
                        DispatchQueue.main.async(execute: {
                            self.tableView.reloadData()
                        })
                        
                        
                        
                        
                    }
                    
                })
                
                
            }
        }
    }
    
    
    @IBOutlet weak var myBanner: GADBannerView!
    
    var bookKey: String!
    
    var bookKeyArray:[String] = []
    
    var myKeys:[String] = []
   
    

    override func viewDidLoad() {
        self.tableView.separatorStyle = .none
        var tutboard = UIStoryboard(name: "Tutorials", bundle: nil)
      
        if(!UserDefaults.standard.bool(forKey: "MyBooksfirstlaunch1.0")){
            //Put any code here and it will be executed only once.
            present(tutboard.instantiateViewController(withIdentifier: "bookTut"), animated: true, completion: nil)
            print("Is a first launch")
            UserDefaults.standard.set(true, forKey: "MyBooksfirstlaunch1.0")
            UserDefaults.standard.synchronize();
            
        }
        
        
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView()
        
       // tableView.backgroundView = UIImageView( image: UIImage(named: "booksCoffee.jpg"))
        
        tableView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
       //navigationController!.navigationBar.barTintColor = UIColor(red: 59/255, green: 89/255, blue: 152/255, alpha: 1.0)
        
        navigationController?.navigationBar.barTintColor = .black
        
        
        refreshControl?.addTarget(self, action: #selector(MyBooksTableViewController.refreshData), for: UIControlEvents.valueChanged)
        
        refreshControl?.tintColor = UIColor.white
        refreshControl?.backgroundColor = UIColor.blue
        
        refreshControl?.attributedTitle = NSAttributedString(string:"Fetching Your Books", attributes: [NSAttributedStringKey.foregroundColor : refreshControl?.tintColor])
        
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.hidesBackButton = true
       
        if #available(iOS 10.0, *){
        
            tableView.refreshControl = refreshControl
        
        }else{
            
            tableView.addSubview(refreshControl!)}
        
        
        
      //observeUserBooks()
        
        trialFunc()
        
        myBooks()
        
       
        
        tabBarController?.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        self.tabBarController?.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: "Bradley Hand", size: 20)!, NSAttributedStringKey.foregroundColor: UIColor.white]
        
       
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 150
        
         UIApplication.shared.statusBarStyle = .lightContent
        
       

       
    }
    
    
    @objc func refreshData(){
    
        
        BookArray.removeAll()
        
       // books.removeAll()
        
        myBooksArray.removeAll()
        
        myBooks()
        
        //observeUserBooks()
        trialFunc()
        
        tableView.reloadData()
        
        refreshControl?.endRefreshing()
        
        

    
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
         self.tabBarController?.navigationItem.leftBarButtonItem = nil
         self.tabBarController?.navigationItem.rightBarButtonItem = nil
        
    }
    
    @objc func toMyRequests(){
        
        performSegue(withIdentifier: "myRequests", sender: self)
        
        
    }
  
    override func viewWillAppear(_ animated: Bool) {
        
         self.tabBarController?.navigationItem.titleView = nil
        self.tabBarController?.navigationItem.title = "My Books"
        
        self.tabBarController?.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "⚙️ Settings", style: .plain, target: self, action: #selector(showUserSettings))
        self.navigationItem.hidesBackButton = true
        
        self.tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "My requests", style: .plain, target: self, action: #selector(toMyRequests))
        
        self.tabBarController?.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        
    
        
    }
    
   
    
   // var books = [Book]()
    
    @objc func showUserSettings(){
        
        performSegue(withIdentifier: "userSettings", sender: MyBooksTableViewController())
        
    }
    
   var bookDictionary = [String: Book]()
    
    var BookArray: [DataSnapshot]! = []
    
    
    func myBooks(){
        
        guard let myUserID = Auth.auth().currentUser?.uid as String! else {
            return
        }
        
        let ref = Database.database().reference().child("user-books").child(myUserID)
        
        
        ref.observe(.value) { (snapshot) in
           
            if snapshot.exists(){ var newDict = snapshot.value as! Dictionary<String, AnyObject>
                
                for (keys,values) in newDict {
                    
                    // print("I AM A KEY: " + keys)
                    
                    
                    self.myKeys.append(keys)
                    //self.bookKeyArray.append(keys)
                    
                    print(self.bookKeyArray)
                    
                    
                }}
           
        }
        
    }
    
    
    func observeUserBooks() {
    
        guard let uid = Auth.auth().currentUser?.uid as String! else{
        
            return

        }
 
        let ref = Database.database().reference().child("user-books")
        
       
        ref.observe(.childAdded, with: { (snapshot) in
      
            let userId = snapshot.key
            print(snapshot.childrenCount)
            
            //print("This is interesting...", snapshot.value)
         
            print(userId)
            
            if userId == uid {

                let bookRef = Database.database().reference().child("user-books").child(userId)
          
            bookRef.observe(.childAdded, with: { (snapshot) in
                
                var bookID = snapshot.key
                
                print("This is new" ,snapshot.children)
                
                
                print(bookID,"sigh..")
                
                
                
                self.bookKey = snapshot.key
      
                
                let booksIDref = Database.database().reference().child("books").child(bookID)
              
                booksIDref.observe(.value, with: { (snapshot) in
                    
                    self.keyArray.append(snapshot.key)

                    if let dictionary = snapshot.value as? [String: AnyObject]{
                    
                    
                        let book = Book()
                        
                        book.setValuesForKeys(dictionary)
    
                        
                     //   self.books.append(book)
                        
                        print(book.Author)
                        
                        DispatchQueue.main.async(execute: {
                            self.tableView.reloadData()
                        })
                    
                   
                    
                    
                    }
                    
                   
                    
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                 
                    }, withCancel: nil)
                
                if snapshot.exists(){
                    
                    
                    
                    UIApplication.shared.isNetworkActivityIndicatorVisible = true
                    
                }

                }, withCancel: nil) }
        
        
        }, withCancel: nil)
  
    }
    
    
    
  
    fileprivate func attemptBookReloadOfTable() {
        self.timer?.invalidate()
        
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleBookReloadTable), userInfo: nil, repeats: false)
    }

    
    @objc func handleBookReloadTable() {
        
        
        //this will crash because of background thread, so lets call this on dispatch_async main thread
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
            
            
        })
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
        return myBooksArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myBookCell", for: indexPath) as! MyBooksTableViewCell

     
        
         cell.backgroundColor = UIColor.clear
       
       
        
      let book = myBooksArray[indexPath.row]
        
        
        
       
        
       // let books = dictionaryArray[indexPath.row]
        
        
        
        
        
       
        
       
        
        
        let Author = book.Author as String!
        let Comment = book.Comment as String!
        let Genre = book.Genre as String!
        let User = book.User as String!
        let title = book.title as String!
        let bookPhoto = book.bookPhoto as String!
        let userID = book.userID as String!
        let userLocation = book.userLocation as String!
        let major = book.major as String!
        let Requests = book.Requests as? Dictionary<String, Any>
        
        
       // let processor = RoundCornerImageProcessor(cornerRadius: 50)
        
        
        
        
        let url = URL(string: bookPhoto!)!
        //imageView.kf.setImage(with: url)
        
        
      
                 //let url = URL(string: bookPhoto!)
        
          // let data = try? Data(contentsOf: url) //make sure your image in this url does exist, otherwise unwrap in a if let check
           
        let p = Bundle.main.path(forResource: "book009", ofType: "gif")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: p))
     
        cell.myBookImageView.kf.indicatorType = .image(imageData: data)

      //cell.myBookImageView.setRounded()
        cell.myBookImageView.layer.cornerRadius = 20.0
        //cell.myBookImageView.layer.borderWidth = 3.0
        //cell.myBookImageView.layer.borderColor = #colorLiteral(red: 0.2050132155, green: 0.4215478003, blue: 0.1647726297, alpha: 1)
        cell.myBookImageView.clipsToBounds = true
        
        cell.contentView.layer.shadowColor = UIColor.black.cgColor
        cell.contentView.layer.shadowOpacity = 0.98
        cell.contentView.layer.shadowOffset = CGSize.zero
        cell.contentView.layer.shadowRadius = 5.0
       
        //cell.myBookLabel.layer.cornerRadius = 10.0
        //cell.myBookLabel.layer.borderWidth = 3.0
        //cell.myBookLabel.layer.borderColor = UIColor.white.cgColor
        
        
      let processor = OverlayImageProcessor(overlay: .black, fraction: 0.75)
        
        cell.myBookImageView.kf.setImage(with: url, placeholder: UIImage(named:"old-books-436498_640.jpg"), options: [.transition(.fade(0.2)), .processor(processor)])
        
        cell.myBookImageView.backgroundColor = .clear
                
                
                //cell.myBookImageView?.image = image?.circleMask
        
        
        
        //cell.myBookLabel?.numberOfLines = 0
        cell.myBookLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        
        
        
        
        
        
        
        cell.myBookLabel?.text = title! as String
        //cell.myBookLabel.sizeToFit()
        //cell.myBookLabel?.textColor = .white
        
       
        
        
       // cell.myBookLabel?.textColor = UIColor.white
        
        //cell.myBookLabel?.font = UIFont(name: "SanFranciscoDisplay", size: 36)
        

        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            
            
            guard let uid = Auth.auth().currentUser?.uid as String! else{
                
                
                return
                
                
            }
            
            
            //let book = books[indexPath.row]
            
            let book = myBooksArray[indexPath.row]
            
            
            
            
            
            
            
            let Author = book.Author as String!
            let Comment = book.Comment as String!
            let Genre = book.Genre as String!
            let User = book.User as String!
            let title = book.title as String!
            let bookPhoto = book.bookPhoto as String!
            let userID = book.userID as String!
            let userLocation = book.userLocation as String!
            let major = book.major as String!
            let college = book.college as String!
            let bookID = "-" + book.bookID! as String
            //let approvedUser = book.ApprovedRequestor as String!
            if let requests = book.Requests as? [String:AnyObject] {
                for (keys,values) in requests{
                    let removeThisBookRef = Database.database().reference().child("users").child(keys).child("requestedBooks").child(bookID)
                    
                    removeThisBookRef.removeValue()
                    
                }
            }
            
            
            
            
            let bookRef = dataBase.reference().child("books").child(bookID)
            
            let userBookRef = dataBase.reference().child("user-books").child(uid).child(bookID)
            
            let collegeAndMajorRef = dataBase.reference().child("colleges").child(college!).child(major!).child(bookID)
            
            let majorRef = dataBase.reference().child("majors").child(major!).child(bookID)
           
            let storage = Storage.storage()
            
             let storageRef = storage.reference(forURL: "gs://biblos-1.appspot.com")
            
            let filePath =  ("/biblos-1.appspot.com/bookPhoto"+book.title!+(Auth.auth().currentUser?.uid as String!))
            
            bookRef.removeValue()
            
            userBookRef.removeValue()
            
            collegeAndMajorRef.removeValue()
            majorRef.removeValue()
            
            bookKeyArray.removeAll()
            
                // Delete the file
            storageRef.child(filePath).delete { error in
                if let error = error {
                    // Uh-oh, an error occurred!
                    
                    print("Uh-oh, an error occurred!")
                    
                } else {
                    // File deleted successfully
                    
                    print("File deleted successfully")
                }
            }
            
            
            // Delete the row from the data source
            
           // books.remove(at: indexPath.row)
            
            myBooksArray.remove(at: indexPath.row)
            
        
            
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            
           BookArray.removeAll()
            
           // books.removeAll()
            myBooksArray.removeAll()
            
            myBooks()
            
            
            
           // observeUserBooks()
            
            trialFunc()
            
            self.tableView.reloadData()
            
            
 
           
            
           
            

        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //performSegue(withIdentifier: "userRequests", sender: self)
        
        self.selectedCell = indexPath.row
        
    }
    
    fileprivate func attemptReloadOfTable() {
        self.timer?.invalidate()
        
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
    }

 var timer: Timer?
    
    
    @objc func handleReloadTable() {
       
        
        //this will crash because of background thread, so lets call this on dispatch_async main thread
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
        })
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "userRequests"{
            
            var myArray:[String] = []
            
            let viewController = segue.destination as! RequestsTableViewController
            
            let indexPath : IndexPath = tableView.indexPathForSelectedRow!
        
          // let book = books[indexPath.row]
            
            let book = myBooksArray[indexPath.row]
            
            
            
            guard let Request = book.Requests as? Dictionary<String,AnyObject> else {return}
            
            for (keys,values) in Request{
                
                var mine = keys
                
                myArray.append(mine)
                
                
                
            }
            
            
             viewController.bookRequestors = myArray
            viewController.bookID = book.bookID!
            if book.ApprovedRequestor != nil{
                
                viewController.approvedRequestorID = book.ApprovedRequestor!
            }
            
            print("Testing me")
        }
    }
    
}



extension UIImageView {
    
    func setRounded() {
        let radius = self.frame.width / 2
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
}
