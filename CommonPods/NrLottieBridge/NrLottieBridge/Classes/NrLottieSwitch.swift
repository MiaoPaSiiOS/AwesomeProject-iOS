//
//  NrLottieSwitch.swift
//  NrlottieBridge
//
//  Created by zhuyuhui on 2022/8/10.
//

import Foundation
import Lottie
import SnapKit

@objcMembers public class NrLottieSwitch: UIView {
    
    let switchButton = AnimatedSwitch()
    
    public var isOn: Bool {
      set {
        switchButton.isOn = newValue
      }
      get {
        return switchButton.isOn
      }
    }
    
    
    public init(frame: CGRect, name: String?, bundle: Bundle?, subdirectory: String?) {
        super.init(frame: frame)
        
        let animation = Animation.named(name ?? "", bundle: bundle ?? Bundle.main, subdirectory: subdirectory)
        switchButton.animation = animation
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
    
    
    /// Sets the play range for the given state. When the switch is toggled, the animation range is played.
    public func setProgressForState(fromProgress: CGFloat,
                                    toProgress: CGFloat,
                                    forOnState: Bool) {
        switchButton.setProgressForState(fromProgress: fromProgress, toProgress: toProgress, forOnState: forOnState)
    }
    
}
