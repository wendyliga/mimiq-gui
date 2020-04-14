//
//  NSImage+Extension.swift
//  mimiq
//
//  Created by Wendy Liga on 13/04/20.
//  Copyright © 2020 Wendy Liga. All rights reserved.
//

import Cocoa

extension NSImage {
    func resizeTo(_ newSize: NSSize) -> NSImage {
        let targetFrame = NSRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        let targetImage = NSImage(size: newSize)
        
        let ratioH = newSize.height / size.height
        let ratioW = newSize.width / size.width
        
        var cropRect = NSRect.zero
        
        if ratioH >= ratioW {
            cropRect.size.width = floor(newSize.width / ratioH)
            cropRect.size.height = size.height
        } else {
            cropRect.size.width = size.width
            cropRect.size.height = floor(newSize.height / ratioW)
        }
        
        cropRect.origin.x = floor((size.width - cropRect.size.width) / 2)
        cropRect.origin.y = floor((size.height - cropRect.size.height) / 2)
        
        targetImage.lockFocus()
        
        self.draw(in: targetFrame,
                  from: cropRect,
                  operation: .copy,
                  fraction: 1,
                  respectFlipped: true,
                  hints: [NSImageRep.HintKey.interpolation : NSNumber(value: NSImageInterpolation.low.rawValue)])
        
        targetImage.unlockFocus()
        
        return targetImage
    }
    
    /// https://stackoverflow.com/a/50074538/5901378
    func tint(color: NSColor) -> NSImage {
        let image = self.copy() as! NSImage
        image.lockFocus()

        color.set()

        let imageRect = NSRect(origin: NSZeroPoint, size: image.size)
        imageRect.fill(using: .sourceAtop)

        image.unlockFocus()

        return image
    }
}
