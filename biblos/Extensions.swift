//
//  Extensions.swift
//  biblos
//
//  Created by Taylor Simpson on 6/15/16.
//  Copyright © 2016 Taylor Simpson. All rights reserved.


import UIKit
import Eureka

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    
    func loadImageUsingCacheWithUrlString(_ urlString: String, gradient: Bool) {
        
        
        
        self.image = nil
        
        func imageWithGradient(img:UIImage!) -> UIImage {
            
            UIGraphicsBeginImageContext(img.size)
            let context = UIGraphicsGetCurrentContext()
            
            img.draw(at: CGPoint(x: 0, y: 0))
            
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let locations:[CGFloat] = [0.0, 1.0]
            
            let bottom = UIColor(red: 0, green: 0, blue: 0, alpha: 0.18).cgColor
            let top = UIColor(red: 0, green: 0, blue: 0, alpha: 0.18).cgColor
            
            let colors = [top, bottom] as CFArray
            
            let gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: locations)
            
            let startPoint = CGPoint(x: img.size.width/2, y: 0)
            let endPoint = CGPoint(x: img.size.width/2, y: img.size.height)
            
            context!.drawLinearGradient(gradient!, start: startPoint, end: endPoint, options: CGGradientDrawingOptions(rawValue: UInt32(0)))
            
            let image = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
            
            return image!
        }
        
        //check cache for image first
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            
            if gradient == false {
                self.image = cachedImage
                return
            } else{
                self.image = imageWithGradient(img: cachedImage)
                
                return
            }
            
            
        }
        
        //otherwise fire off a new download
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            
            //download hit an error so lets return out
            if error != nil {
                print(error)
                return
            }
            
            DispatchQueue.main.async(execute: {
                
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                    
                    if gradient == false {
                        self.image = downloadedImage
                        
                    } else{
                        self.image = imageWithGradient(img: downloadedImage)
                    }
                }
            })
            
        }).resume()
    }
    
    
    
    
    
    
}

var extensionPropertyStorage: [String: [String: Any]] = [:]

var maxLength_ = "maxLength"

extension Row {
    
    public var maxLength: Int? {
        get {
            return didSetMaxLength
        }
        set {
            didSetMaxLength = newValue
        }
    }
    
    private var didSetMaxLength: Int? {
        get {
            return extensionPropertyStorage[self.tag!]?[maxLength_] as? Int
        }
        set {
            var selfDictionary = extensionPropertyStorage[self.tag!] ?? [String: Any]()
            selfDictionary[maxLength_] = newValue
            extensionPropertyStorage[self.tag!] = selfDictionary
        }
    }
}




