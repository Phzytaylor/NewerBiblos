//
//  RequestTableViewCell.swift
//  biblos
//
//  Created by Taylor Simpson on 2/10/18.
//  Copyright © 2018 Taylor Simpson. All rights reserved.
//

import UIKit

class RequestTableViewCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var approvedLabel: UILabel!
    @IBOutlet weak var wasApproved: UIImageView!
}
