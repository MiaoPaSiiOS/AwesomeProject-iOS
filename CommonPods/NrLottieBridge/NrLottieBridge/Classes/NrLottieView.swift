//
//  NrLottieView.swift
//  NrlottieBridge
//
//  Created by zhuyuhui on 2022/8/10.
//

import Foundation
import Lottie
import SnapKit

@objcMembers public class NrLottieView: UIView {
    
    let animationView = AnimationView()
    
    public init(frame: CGRect, name: String, bundle: Bundle = Bundle.main) {
        super.init(frame: frame)
        self.backgroundColor = .clear;
        
        let animation = Animation.named(name, bundle: bundle, subdirectory: nil)
        animationView.animation = animation
        animationView.imageProvider = BundleImageProvider(bundle: bundle, searchPath: nil)
        animationView.contentMode = .scaleAspectFill;
                
        addSubview(animationView)
        animationView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("deinit %s",self)
    }
    
    /**
     Plays the animation from its current state to the end.
     
     - Parameter completion: An optional completion closure to be called when the animation completes playing.
     */
    public func play(completion: ((Bool) -> Void)? = nil) {
        animationView.play(completion:completion)
    }

    public func stop() {
        animationView.stop()
    }

    public func pause() {
        animationView.pause()
    }
}

