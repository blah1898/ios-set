//
//  CardCollectionView.swift
//  Set
//
//  Created by comp05A on 10/24/18.
//  Copyright © 2018 Universidad Autonoma de Baja California. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class CardCollectionView : UIView {
    
    private var grid = Grid(layout: Grid.Layout.aspectRatio(CGFloat(5.0/7.0)))
    
    override func addSubview(_ view: UIView) {
        super.addSubview(view);
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        grid.frame = bounds
        grid.cellCount = subviews.count
        for viewIndex in 0..<subviews.count {
            let view = subviews[viewIndex]
            let frame = grid[viewIndex]
            
            view.frame = frame ?? CGRect.zero
        }
    }
    
}
