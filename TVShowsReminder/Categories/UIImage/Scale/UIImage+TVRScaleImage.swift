//
//  UIImage+JSCScaleImage.swift
//  TVShowsReminder
//
//  Created by Javier Laguna on 18/03/2016.
//
//

import Foundation
import UIKit

/**
 Category to scale an image.
 */
extension UIImage {
    
    //Mark: Scale
    
    /**
    Reduces the dimensions of an image.
    
    - Parameter image: image to transform.
    
    - Returns: smaller image.
    */
    class func jsc_scaleImage(image: UIImage) -> UIImage {
        
        let aspectFitCroppedImage = UIImage.jsc_aspectFitImage(image)
        
        // We need the device's screen scale to know what sort of fedelity to crop at
        let deviceScale = UIScreen.mainScreen().scale
        
        let scaledRect = CGRectMake(0.0, 0.0, (kJSCShowAvatardimension * deviceScale), (kJSCShowAvatardimension * deviceScale))
        
        // Then draw the crop into our smaller dimension size
        UIGraphicsBeginImageContext(scaledRect.size)
        aspectFitCroppedImage.drawInRect(scaledRect)
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
    
    //MARK: Crop
    
    /**
    Crops the image to ensure that when is scaled it doesn't appear stretched

    - Parameter image: image to transform.
    
    - Returns: cropped image.
    */
    class func jsc_aspectFitImage(image: UIImage) -> UIImage {
        
        let aspectFitDimension = UIImage.jsc_aspectFitDimensionForCroppingImage(image)
        
        let croppedRect = CGRectMake((image.size.width - aspectFitDimension) / 2.0, (image.size.height - aspectFitDimension) / 2.0, aspectFitDimension, aspectFitDimension)
        
        // Crop the portion we want
        let imageRef = CGImageCreateWithImageInRect(image.CGImage, croppedRect)
        
        let aspectFitCroppedImage = UIImage.init(CGImage: imageRef!, scale: 1.0, orientation: image.imageOrientation)
        
        return aspectFitCroppedImage
    }
    
    /**
    Calculates the dimensions the image needs to be cropped to.
     
     - Parameter image: image to transform.
     
     - Returns: dimension to crop the image to.
     */
    class func jsc_aspectFitDimensionForCroppingImage(image: UIImage) -> CGFloat {
        
        var aspectFitDimesionForCroppingImage = image.size.width;
        
        if image.size.width > image.size.height {
            
            aspectFitDimesionForCroppingImage = image.size.width;
        }
        
        return aspectFitDimesionForCroppingImage;
    }
    
    
}