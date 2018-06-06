//
//  ChatTutorialViewController.swift
//  biblos
//
//  Created by Taylor Simpson on 2/19/18.
//  Copyright © 2018 Taylor Simpson. All rights reserved.
//

import UIKit
import paper_onboarding
import DeviceKit

class ChatTutorialViewController: UIViewController {
    
    @IBOutlet weak var skipButton: UIButton!
    var modelName = Device()
    
    @IBAction func skipButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    let items = [
        OnboardingItemInfo(informationImage: UIImage(named: "Messages.PNG")!,
                           title: "Your Inbox",
                           description: "Your messages are listed here. Just click on one to see your message history with a user.",
                           pageIcon: UIImage(named: "checkMark.png")!,
                           color: UIColor(red: 0.40, green: 0.56, blue: 0.71, alpha: 1.00),
                           titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont:  UIFont(name: "Helvetica", size: 20)!, descriptionFont:  UIFont(name: "Helvetica", size: 25)!),
        OnboardingItemInfo(informationImage: UIImage(named: "Chat.PNG")!,
                           title: "Lets Chat",
                           description: "Just click on the text box to start chating!.",
                           pageIcon: UIImage(named: "checkMark.png")!,
                           color: UIColor(red: 0.40, green: 0.56, blue: 0.71, alpha: 1.00),
                           titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont:  UIFont(name: "Helvetica", size: 20)!, descriptionFont:  UIFont(name: "Helvetica", size: 25)!),
        
        
        ]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        setupPaperOnboardingView()
         view.bringSubview(toFront: skipButton)
        
        // Do any additional setup after loading the view.
    }
    
    private func setupPaperOnboardingView() {
        let onboarding = PaperOnboarding()
        onboarding.delegate = self
        onboarding.dataSource = self
        onboarding.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(onboarding)
        
        // Add constraints
        for attribute: NSLayoutAttribute in [.left, .right, .top, .bottom] {
            let constraint = NSLayoutConstraint(item: onboarding,
                                                attribute: attribute,
                                                relatedBy: .equal,
                                                toItem: view,
                                                attribute: attribute,
                                                multiplier: 1,
                                                constant: 0)
            view.addConstraint(constraint)
        }
    }
}
// MARK: PaperOnboardingDataSource

extension ChatTutorialViewController: PaperOnboardingDataSource {
    
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        return items[index]
    }
    
    func onboardingItemsCount() -> Int {
        return 2
    }
    
}

extension ChatTutorialViewController: PaperOnboardingDelegate {
    
    //    func onboardingWillTransitonToIndex(_ index: Int) {
    //        skipButton.isHidden = index == 2 ? false : true
    //    }
    
    func onboardingDidTransitonToIndex(_: Int) {
    }
    
    func onboardingConfigurationItem(_ item: OnboardingContentViewItem, index: Int) {
        switch modelName {
        case .iPhoneSE,.simulator(.iPhoneSE), .iPhone5s, .simulator(.iPhone5s), .iPhone6, .simulator(.iPhone6), .iPhone6s, .simulator(.iPhone6s), .iPhone7, .simulator(.iPhone7), .iPhone8, .simulator(.iPhone8):
            item.descriptionLabel?.font =  UIFont(name: "Helvetica", size: 15)!
            item.informationImageHeightConstraint?.constant = 300
            item.informationImageWidthConstraint?.constant = 400
            item.imageView?.contentMode = .scaleAspectFit
        default:
            item.informationImageHeightConstraint?.constant = 400
            item.informationImageWidthConstraint?.constant = 300
            item.imageView?.contentMode = .scaleAspectFit
        }
        
        
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



