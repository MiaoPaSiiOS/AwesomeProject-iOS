//
//  NrLottieButton.swift
//  NrlottieBridge
//
//  Created by zhuyuhui on 2022/8/10.
//

import Foundation
import UIKit
import Lottie
import SnapKit

@objcMembers public class NrLottieButton: UIView {

    let switchButton = AnimatedButton()
    
    public init(frame: CGRect, name: String?, bundle: Bundle?, subdirectory: String?) {
        super.init(frame: frame)
        
        let animation = Animation.named(name ?? "", bundle: bundle ?? Bundle.main, subdirectory: subdirectory)
        switchButton.animation = animation
        /// Turn off clips to bounds, as the animation goes outside of the bounds.
        switchButton.clipsToBounds = false
        addSubview(switchButton)
        
        switchButton.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }

    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("deinit %s",self)
    }
    
    /// Sets the play range for the given UIControlEvent.
    public func setPlayRange(fromProgress: CGFloat, toProgress: CGFloat, event: UIControl.Event) {
        switchButton.setPlayRange(fromProgress: fromProgress, toProgress: toProgress, event: event)
    }
    
    /// Sets the play range for the given UIControlEvent.
    public func setPlayRange(fromMarker fromName: String, toMarker toName: String, event: UIControl.Event) {
        switchButton.setPlayRange(fromMarker: fromName, toMarker: toName, event: event)
    }
    

}
