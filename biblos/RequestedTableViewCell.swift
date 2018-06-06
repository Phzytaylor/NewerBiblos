//
//  RequestedTableViewCell.swift
//  biblos
//
//  Created by Taylor Simpson on 2/19/18.
//  Copyright © 2018 Taylor Simpson. All rights reserved.
//

import UIKit

class RequestedTableViewCell: UITableViewCell {

    @IBOutlet weak var bookTitleLabel: UILabel!
    @IBOutlet weak var isApprovedImage: UIImageView!
    
    @IBOutlet weak var requestedBookImage: UIImageView!
    
    @IBOutlet weak var grantedLabel: UILabel!
}
