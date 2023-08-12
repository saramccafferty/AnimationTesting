//
//  ViewController.swift
//  Spinner annimation testing
//
//  Created by Sara on 3/3/2023.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var exampleButton: UIButton!
    
    lazy var containerView: UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        v.frame = CGRect(x: 0, y: 0, width: 120, height: 120)
        v.center.x = self.view.center.x
        v.center.y = self.view.center.y
        return v
    }()
    
    var circle1: UIView = {
        let v = UIView()
        v.backgroundColor = .systemPurple
        v.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        return v
    }()
    
    var circle2: UIView = {
        let v = UIView()
        v.backgroundColor = .systemPink
        v.frame = CGRect(x: 120-50, y: 0, width: 50, height: 50)
        return v
    }()
    
    var circle3: UIView = {
        let v = UIView()
        v.backgroundColor = .systemTeal
        v.frame = CGRect(x: 120-50, y: 120-50, width: 50, height: 50)
        return v
    }()
    
    var circle4: UIView = {
        let v = UIView()
        v.backgroundColor = .systemCyan
        v.frame = CGRect(x: 0, y: 120-50, width: 50, height: 50)
        return v
    }()
    
    lazy var circles: [UIView] = [circle1, circle2, circle3, circle4]
    var circle = 0
    var colours: [UIColor] = [.systemCyan, .systemTeal, .systemPink, .systemPurple, .systemMint, .systemIndigo, .systemYellow, .systemRed, .systemBlue, .systemGreen]
    lazy var random = Int.random(in: 0...colours.count-1)
    
    
    lazy var blur: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return blurEffectView
    }()
    
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(containerView)
        
        for circle in circles {
            containerView.addSubview(circle)
        }
        
        setupCircles()
        
    }
    
    func setupCircles() {
        containerView.isUserInteractionEnabled = false
        circles.forEach { circle in
            circle.layer.cornerRadius = circle.frame.height / 2
            circle.backgroundColor = .clear
            circle.isUserInteractionEnabled = false
        }
    }
    
    func blurView(completion: @escaping (_ success: Bool) -> ()) {
        self.view.addSubview(blur)
        self.view.bringSubviewToFront(blur)
        self.view.bringSubviewToFront(containerView)
        UIView.animate(withDuration: 0.6) {
            self.blur.alpha = 0.5
            completion(true)
        }
    }
    
    func nextCircle() {
        random = Int.random(in: 0...colours.count-1)
        if circle == circles.count-1 {
            circle = 0
        } else {
            circle += 1
        }
    }
    
    func circlesAnimation() {
        circles[circle].backgroundColor = colours[random].withAlphaComponent(0)
        
        UIView.animate(withDuration: 0.5) {
            self.circles[self.circle].backgroundColor = self.colours[self.random].withAlphaComponent(0.70)
        } completion: { success in
            self.circles[self.circle].backgroundColor = self.colours[self.random].withAlphaComponent(0)
            self.nextCircle()
            if let timer = self.timer, timer.isValid {
                self.circlesAnimation()
            }
        }
    }
    
    func loadingView() {
        blurView { success in
            self.timer = Timer.scheduledTimer(withTimeInterval: 4.0, repeats: false, block: { _ in
                self.timer?.invalidate()
                self.timer = nil
                self.blur.removeFromSuperview()
                self.setupCircles()
            })
            self.circlesAnimation()
        }
    }
    
    
    @IBAction func exampleButtonTapped(_ sender: UIButton) {
        loadingView()
    }
}

