//
//  CustomActivityIndicator.swift
//  dStudioTest
//
//  Created by Vladyslav Palamarchuk on 30.03.2020.
//  Copyright © 2020 Vladyslav Palamarchuk. All rights reserved.
//

import UIKit
import Foundation

extension UIActivityIndicatorView {
    
    private static var blockView: UIView?

    // MARK: - show
    func show(parentVC: UIViewController) {
        
        UIActivityIndicatorView.blockView = getBlockView(parentVC)
        guard let blockView = UIActivityIndicatorView.blockView else { return }
        parentVC.view.addSubview(blockView)
        
        self.color = .systemBlue
        self.hidesWhenStopped = true
        self.center = parentVC.view.center
        self.startAnimating()
        
        parentVC.view.addSubview(self)
    }
    
    private func getBlockView(_ parentVC: UIViewController) -> UIView? {

        let parentFrame = parentVC.view.frame
        let maxValue = max(parentFrame.width, parentFrame.height)
        let width = maxValue * 10
        let height = maxValue * 10
        
        let view = UIView(frame: CGRect(x: 0, y: 0,
                                        width: width,
                                        height: height))
        
        view.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 0.2672035531)
        
        return view
    }
    
    // MARK: - hide
    func hide() {
        self.stopAnimating()
        UIActivityIndicatorView.blockView?.removeFromSuperview()
        UIActivityIndicatorView.blockView = nil
    }
}
