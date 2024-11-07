import Foundation
import UIKit

extension UIView {
    fileprivate static var DEFAULT_DURATION: TimeInterval               = 0.5
    fileprivate static var DEFAULT_DISTANCE_FADE: CGFloat               = 100
    fileprivate static var DEFAULT_DISTANCE_SLIDE_HORIZONTAL: CGFloat   = UIScreen.main.bounds.width
    fileprivate static var DEFAULT_DISTANCE_SLIDE_VERTIAL: CGFloat      = UIScreen.main.bounds.height
    
    fileprivate func showAlphaIfNeed() {
        if alpha <= 0 {
            alpha = 1
        }
    }
}

// MARK: - Fade In
extension UIView {
    func fadeIn(duration: TimeInterval = DEFAULT_DURATION, delay: Double = 0, option: AnimationOptions = .curveEaseInOut) {
        alpha = 0
        isHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now() + delay ,  execute: {
            UIView.animate(withDuration: duration, delay: 0, animations: {
                self.alpha = 1
                self.isHidden = false
            })
        })
    }
    
    func fadeInUp(duration: TimeInterval = DEFAULT_DURATION, delay: Double = 0, option: AnimationOptions = .curveEaseInOut) {
        alpha = 0
        isHidden = true
        transform = CGAffineTransform(translationX: 0, y: UIView.DEFAULT_DISTANCE_FADE)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay ,  execute: {
            UIView.animate(withDuration: duration, delay: 0, animations: {
                self.alpha = 1
                self.transform = CGAffineTransform(translationX: 0, y: 0)
                self.isHidden = false
            })
        })
    }
    
    func fadeInDown(duration: TimeInterval = DEFAULT_DURATION, delay: Double = 0, option: AnimationOptions = .curveEaseInOut) {
        alpha = 0
        isHidden = true
        transform = CGAffineTransform(translationX: 0, y: -UIView.DEFAULT_DISTANCE_FADE)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay ,  execute: {
            UIView.animate(withDuration: duration, delay: 0, animations: {
                self.alpha = 1
                self.transform = CGAffineTransform(translationX: 0, y: 0)
                self.isHidden = false
            })
        })
    }

    func fadeInLeft(duration: TimeInterval = DEFAULT_DURATION, delay: Double = 0, option: AnimationOptions = .curveEaseInOut) {
        alpha = 0
        isHidden = true
        transform = CGAffineTransform(translationX: UIView.DEFAULT_DISTANCE_FADE, y: 0)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay ,  execute: {
            UIView.animate(withDuration: duration, delay: 0, animations: {
                self.alpha = 1
                self.transform = CGAffineTransform(translationX: 0, y: 0)
                self.isHidden = false
            })
        })
    }
    
    func fadeInRight(duration: TimeInterval = DEFAULT_DURATION, delay: Double = 0, option: AnimationOptions = .curveEaseInOut) {
        alpha = 0
        isHidden = true
        transform = CGAffineTransform(translationX: 0, y: UIView.DEFAULT_DISTANCE_FADE)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay ,  execute: {
            UIView.animate(withDuration: duration, delay: 0, animations: {
                self.alpha = 1
                self.transform = CGAffineTransform(translationX: 0, y: 0)
                self.isHidden = false
            })
        })
    }
}

// MARK: - Fade Out
extension UIView {
    func fadeOut(duration: TimeInterval = DEFAULT_DURATION, delay: Double = 0, option: AnimationOptions = .curveEaseInOut) {
        isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
            UIView.transition(with: self, duration: duration, options: option) {
                self.alpha = 0
                self.isHidden = true
            }
        })
    }
    
    func fadeOutLeft(duration: TimeInterval = DEFAULT_DURATION, delay: Double = 0, option: AnimationOptions = .curveEaseInOut) {
        isHidden = false
        transform = CGAffineTransform(translationX: 0, y: 0)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
            UIView.transition(with: self, duration: duration, options: option) {
                self.alpha = 0
                self.transform = CGAffineTransform(translationX: -UIView.DEFAULT_DISTANCE_FADE, y: 0)
                self.isHidden = true
            }
        })
    }
    
    func fadeOutRight(duration: TimeInterval = DEFAULT_DURATION, delay: Double = 0, option: AnimationOptions = .curveEaseInOut) {
        isHidden = false
        transform = CGAffineTransform(translationX: 0, y: 0)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
            UIView.transition(with: self, duration: duration, options: option) {
                self.alpha = 0
                self.transform = CGAffineTransform(translationX: UIView.DEFAULT_DISTANCE_FADE, y: 0)
                self.isHidden = true
            }
        })
    }
    
    func fadeOutUp(duration: TimeInterval = DEFAULT_DURATION, delay: Double = 0, option: AnimationOptions = .curveEaseInOut) {
        isHidden = false
        transform = CGAffineTransform(translationX: 0, y: 0)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
            UIView.transition(with: self, duration: duration, options: option) {
                self.alpha = 0
                self.transform = CGAffineTransform(translationX: 0, y: -UIView.DEFAULT_DISTANCE_FADE)
                self.isHidden = true
            }
        })
    }
    
    func fadeOutDown(duration: TimeInterval = DEFAULT_DURATION, delay: Double = 0, option: AnimationOptions = .curveEaseInOut) {
        isHidden = false
        transform = CGAffineTransform(translationX: 0, y: 0)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
            UIView.transition(with: self, duration: duration, options: option) {
                self.alpha = 0
                self.transform = CGAffineTransform(translationX: 0, y: UIView.DEFAULT_DISTANCE_FADE)
                self.isHidden = true
            }
        })
    }
}

// MARK: - Slide In
extension UIView {
    func slideInRight(duration: TimeInterval = DEFAULT_DURATION, delay: Double = 0, option: AnimationOptions = .curveEaseInOut) {
        isHidden = true
        showAlphaIfNeed()
        transform = CGAffineTransform(translationX: UIView.DEFAULT_DISTANCE_SLIDE_HORIZONTAL, y: 0)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
            UIView.transition(with: self, duration: duration, options: option) {
                self.transform = CGAffineTransform(translationX: 0, y: 0)
                self.isHidden = false
            }
        })
    }
    
    func slideInLeft(duration: TimeInterval = DEFAULT_DURATION, delay: Double = 0, option: AnimationOptions = .curveEaseInOut) {
        isHidden = true
        showAlphaIfNeed()
        transform = CGAffineTransform(translationX: -UIView.DEFAULT_DISTANCE_SLIDE_HORIZONTAL + bounds.width, y: 0)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
            UIView.transition(with: self, duration: duration, options: option) {
                self.transform = CGAffineTransform(translationX: 0, y: 0)
                self.isHidden = false
            }
        })
    }
    
    func slideInUp(duration: TimeInterval = DEFAULT_DURATION, delay: Double = 0, option: AnimationOptions = .curveEaseInOut) {
        isHidden = true
        showAlphaIfNeed()
        transform = CGAffineTransform(translationX: 0, y: -UIView.DEFAULT_DISTANCE_SLIDE_VERTIAL + bounds.height)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
            UIView.transition(with: self, duration: duration, options: option) {
                self.transform = CGAffineTransform(translationX: 0, y: 0)
                self.isHidden = false
            }
        })
    }
    
    func slideInDown(duration: TimeInterval = DEFAULT_DURATION, delay: Double = 0, option: AnimationOptions = .curveEaseInOut) {
        isHidden = true
        showAlphaIfNeed()
        transform = CGAffineTransform(translationX: 0, y: UIView.DEFAULT_DISTANCE_SLIDE_VERTIAL)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
            UIView.transition(with: self, duration: duration, options: option) {
                self.transform = CGAffineTransform(translationX: 0, y: 0)
                self.isHidden = false
            }
        })
    }
}

// MARK: Slide Out
extension UIView {
    func slideOutRight(duration: TimeInterval = DEFAULT_DURATION, delay: Double = 0, option: AnimationOptions = .curveEaseInOut) {
        isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
            UIView.transition(with: self, duration: duration, options: option) {
                self.transform = CGAffineTransform(translationX: UIView.DEFAULT_DISTANCE_SLIDE_HORIZONTAL, y: 0)
                self.isHidden = true
            }
        })
    }
    
    func slideOutLeft(duration: TimeInterval = DEFAULT_DURATION, delay: Double = 0, option: AnimationOptions = .curveEaseInOut) {
        isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
            UIView.transition(with: self, duration: duration, options: option) {
                self.transform = CGAffineTransform(translationX: -UIView.DEFAULT_DISTANCE_SLIDE_HORIZONTAL + self.bounds.width, y: 0)
                self.isHidden = true
            }
        })
    }
    
    func slideOutUp(duration: TimeInterval = DEFAULT_DURATION, delay: Double = 0, option: AnimationOptions = .curveEaseInOut) {
        isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
            UIView.transition(with: self, duration: duration, options: option) {
                self.transform = CGAffineTransform(translationX: 0, y: -UIView.DEFAULT_DISTANCE_SLIDE_VERTIAL + self.bounds.height)
                self.isHidden = true
            }
        })
    }
    
    func slideOutDown(duration: TimeInterval = DEFAULT_DURATION, delay: Double = 0, option: AnimationOptions = .curveEaseInOut) {
        isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
            UIView.transition(with: self, duration: duration, options: option) {
                self.transform = CGAffineTransform(translationX: UIView.DEFAULT_DISTANCE_SLIDE_VERTIAL + self.bounds.height, y: 0)
                self.isHidden = true
            }
        })
    }
}
