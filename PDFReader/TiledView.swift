//
//  TiledView.swift
//  PDFReader
//
//  Created by ALUA KINZHEBAYEVA on 4/22/15.
//  Copyright (c) 2015 AK. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

class TiledView: UIView{
    

    var myScale: CGFloat?
    var leftPdfPage: CGPDFPageRef?
   
    init(frame:CGRect, scale:CGFloat){
        super.init(frame: frame)
        self.myScale = scale
        var tiledLayer = self.layer as! CATiledLayer;
        /*
        levelsOfDetail and levelsOfDetailBias determine how the layer is rendered at different zoom levels. This only matters while the view is zooming, because once the the view is done zooming a new TiledPDFView is created at the correct size and scale.
        */
        tiledLayer.levelsOfDetail = 4;
        tiledLayer.levelsOfDetailBias = 3;
        tiledLayer.tileSize = CGSizeMake(512.0, 512.0);
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override class func layerClass () -> AnyClass {
        return CATiledLayer.self;
    }
    
    
    // Set the CGPDFPageRef for the view.
    func setLeftPage(newPage: CGPDFPageRef)
    {
        leftPdfPage = newPage
    }
    
    override func drawRect(r: CGRect)
    {
        /*
        UIView uses the existence of -drawRect: to determine if it should allow its CALayer to be invalidated, which would then lead to the layer creating a backing store and -drawLayer:inContext: being called.
        Implementing an empty -drawRect: method allows UIKit to continue to implement this logic, while doing the real drawing work inside of -drawLayer:inContext:.
        */
    }
    
    
    // Draw the CGPDFPageRef into the layer at the correct scale.
    override func drawLayer(layer: CALayer, inContext con: CGContext)
    {
        // Fill the background with white.
        CGContextSetRGBFillColor(con, 1.0,1.0,1.0,1.0);
        CGContextFillRect(con, self.bounds);
    
        CGContextSaveGState(con);
        // Flip the context so that the PDF page is rendered right side up.
        CGContextTranslateCTM(con, 0.0, self.bounds.size.height);
        CGContextScaleCTM(con, 1.0, -1.0);
    
        // Scale the context so that the PDF page is rendered at the correct size for the zoom level.
        CGContextScaleCTM(con, myScale!, myScale!);
        CGContextDrawPDFPage(con, self.leftPdfPage);
        CGContextRestoreGState(con);
    }
}