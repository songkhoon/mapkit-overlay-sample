//
//  AttractionAnnotationView.swift
//  Park View
//
//  Created by Niv Yahel on 2014-10-30.
//  Copyright (c) 2014 Chris Wagner. All rights reserved.
//

import UIKit
import MapKit

class AttractionAnnotationView: MKAnnotationView {
    // Called when drawing the AttractionAnnotationView
    
    // Required for MKAnnotationView
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        let attractionAnnotation = self.annotation as! AttractionAnnotation
        switch (attractionAnnotation.type) {
            
        case .attractionFirstAid:
            image = UIImage(named: "firstaid")
        case .attractionFood:
            image = UIImage(named: "food")
        case .attractionRide:
            image = UIImage(named: "ride")
        default:
            image = UIImage(named: "star")
        }
    }
}
