//
//  UIImage+JSCRoundImage.swift
//  TVShowsReminder
//
//  Created by Javier Laguna on 18/03/2016.
//
//

import Foundation
import UIKit

/**
 Category to round an image.
 */
extension UIImage {
    
    //MARK: Mask
    
    /**
    Changes an image to be become a circle.
    - Paameter image - image to transform.
    
    - Returns: rounded image.
    */
    class func jsc_roundImage(image: UIImage) -> UIImage
    {
        var finalImage:UIImage?
        
        autoreleasepool {
            
            let deviceScale = UIScreen.mainScreen().scale as CGFloat
            
            let finalDimension = ceil(kJSCShowAvatardimension * deviceScale)
            
            let contextSize = CGSizeMake(finalDimension, finalDimension)
            
            var context: CGContextRef?
            
            // Create circle mask to use for the rounding:
            var imageMask: CGImageRef?
            UIGraphicsBeginImageContextWithOptions(contextSize, false, 0.0)
            
            context = UIGraphicsGetCurrentContext();
            CGContextBeginPath(context);
            
            // Draw the white box that'll be filtered out by the mask:
            CGContextSetFillColorWithColor(context, UIColor.whiteColor().CGColor);
            
            let contextRect = CGRectMake(0.0, 0.0, contextSize.width, contextSize.height)
            
            CGContextFillRect(context, contextRect)
            
            // Draw the black circle you'll see "through" via the mask, we have to inset the circle
            // a little so that it's very edges aren't cut off:
            let elipseRect = CGRectInset(contextRect, 1.0, 1.0)
            
            CGContextSetFillColorWithColor(context, UIColor.blackColor().CGColor)
            
            CGContextFillEllipseInRect(context, elipseRect)
            
            let circleMask = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            let maskReference = circleMask.CGImage
            imageMask = CGImageMaskCreate(CGImageGetWidth(maskReference),
                CGImageGetHeight(maskReference),
                CGImageGetBitsPerComponent(maskReference),
                CGImageGetBitsPerPixel(maskReference),
                CGImageGetBytesPerRow(maskReference),
                CGImageGetDataProvider(maskReference),
                nil, // Decode is null
                true); // Should interpolate
            
            // Combine the mask & the preview image:
            let maskedReference = CGImageCreateWithMask(image.CGImage, imageMask)
            let maskedImage = UIImage.init(CGImage: maskedReference!)
            
            // Draw the actual final image:
            UIGraphicsBeginImageContextWithOptions(contextSize, false, 0.0)
            
            maskedImage.drawInRect(CGRectMake(0.0, 0.0, finalDimension, finalDimension))
            
            finalImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
        
        return finalImage!
    }
    
}