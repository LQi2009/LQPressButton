//
//  LZPressButton.swift
//  LZPressButton
//
//  Created by Artron_LQQ on 2017/2/15.
//  Copyright © 2017年 Artup. All rights reserved.
//

import UIKit

enum LDProgressButtonStyle {
    
    case White
    case Gray
    case Black
}

enum LDProgressButtonState {
    case Begin
    case Moving
    case WillCancel
    case DidCancel
    case End
    case Click
}

typealias actionState = (_ state: LDProgressButtonState) -> Void

class LDPressButton: UIView {

    var interval: Float = 10.0
    
    var style: LDProgressButtonStyle = .White {
        
        didSet{
            switch style {
            case .White:
                self.centerLayer.fillColor = UIColor.white.cgColor
                self.ringLayer.fillColor = UIColor.init(displayP3Red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.8).cgColor
            case .Gray:
                self.centerLayer.fillColor = UIColor.gray.cgColor
                self.ringLayer.fillColor = UIColor.init(displayP3Red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.8).cgColor
            case .Black:
                self.centerLayer.fillColor = UIColor.black.cgColor
                self.ringLayer.fillColor = UIColor.init(displayP3Red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.8).cgColor
            }
        }
    }
    var centerColor: UIColor! {
        
        didSet {
            self.centerLayer.fillColor = centerColor.cgColor
        }
    }
    var ringColor: UIColor! {
        
        didSet {
            self.ringLayer.fillColor = ringColor.cgColor
        }
    }
    var progressColor: UIColor! {
        
        didSet {
            self.progressLayer.strokeColor = progressColor.cgColor
        }
    }
    
    
    private var buttonAction: actionState?
    
    private lazy var centerLayer: CAShapeLayer = {
        
        let layer = CAShapeLayer()
        layer.frame = self.bounds
        layer.fillColor = UIColor.white.cgColor
        return layer
    }()
    
    private lazy var ringLayer: CAShapeLayer = {
        
        let layer = CAShapeLayer()
        layer.frame = self.bounds
        layer.fillColor = UIColor.init(displayP3Red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.8).cgColor
        return layer
    }()
    
    private lazy var progressLayer: CAShapeLayer = {
        
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.init(displayP3Red: 31/255.0, green: 185/255.0, blue: 34/255.0, alpha: 1.0).cgColor
        layer.lineWidth = 4
        layer.lineCap = kCALineCapRound
        return layer
    }()
    
    private lazy var link: CADisplayLink = {
        let link = CADisplayLink.init(target: self, selector: #selector(linkRun))
        link.preferredFramesPerSecond = 60
        link.add(to: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
        link.isPaused = true
        return link
    }()
    
    private var tempInterval: Float = 0.0
    private var progress: Float = 0.0
    private var isTimeOut: Bool = false
    private var isPressed: Bool = false
    private var isCancel: Bool = false
    private var ringFrame: CGRect = .zero
    
    
    deinit {
        print("deinit LZPressButton")
        self.link.invalidate()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.addSublayer(ringLayer)
        self.layer.addSublayer(centerLayer)
        
        self.backgroundColor = UIColor.clear
        let longPress = UILongPressGestureRecognizer.init(target: self, action: #selector(longPressGesture))
        self.addGestureRecognizer(longPress)
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapGesture))
        self.addGestureRecognizer(tap)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func actionWithClosure(_ closure: @escaping actionState) {
        
        self.buttonAction = closure
    }
    
    @objc private func tapGesture() {
        
        if let closure = self.buttonAction {
            closure(.Click)
        }
    }
    
    @objc private func longPressGesture(_ gesture: UILongPressGestureRecognizer) {
        
        switch gesture.state {
        case .began:
            
            self.link.isPaused = false
            self.isPressed = true
            self.layer.addSublayer(self.progressLayer)
            if let closure = self.buttonAction {
                closure(.Begin)
            }
        case .changed:
            let point = gesture.location(in: self)
            if self.ringFrame.contains(point) {
                self.isCancel = false
                if let closure = self.buttonAction {
                    closure(.Moving)
                }
            } else {
                self.isCancel = true
                if let closure = self.buttonAction {
                    closure(.WillCancel)
                }
            }
        case .ended:
            self.stop()
            if self.isCancel {
                if let closure = self.buttonAction {
                    closure(.DidCancel)
                }
            } else if self.isTimeOut == false {
                if let closure = self.buttonAction {
                    closure(.End)
                }
            }
            
            self.isTimeOut = false
        default:
            self.stop()
            self.isCancel = true
            if let closure = self.buttonAction {
                closure(.DidCancel)
            }
        }
        
        self.setNeedsDisplay()
    }
    
    @objc private func linkRun() {
        
        tempInterval += 1/60.0
        progress = tempInterval/interval
        
        if tempInterval >= interval {
            
            self.stop()
            isTimeOut = true
            if let closure = self.buttonAction {
                closure(.End)
            }
        }
        
//        print(">>>>> \(progress)")
        self.setNeedsDisplay()
    }

    func stop() {
        
        isPressed = false
        tempInterval = 0.0
        progress = 0.0
        
        self.progressLayer.strokeEnd = 0;
        self.progressLayer.removeFromSuperlayer()
        self.link.isPaused = true
        self.setNeedsDisplay()
        
    }
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        let width = self.bounds.width
        
        var mainWidth = width/2.0
        
        var mainFrame = CGRect(x: mainWidth/2.0, y: mainWidth/2.0, width: mainWidth, height: mainWidth)
        
        
        var ringFrame = mainFrame.insetBy(dx: -0.2*mainWidth/2.0, dy: -0.2*mainWidth/2.0);
        self.ringFrame = ringFrame
        if self.isPressed {
            ringFrame = mainFrame.insetBy(dx: -0.4*mainWidth/2.0, dy: -0.4*mainWidth/2.0)
        }
        
        let ringPath = UIBezierPath.init(roundedRect: ringFrame, cornerRadius: ringFrame.width/2.0)
        self.ringLayer.path = ringPath.cgPath
        
        if self.isPressed {
            mainWidth *= 0.8
            mainFrame = CGRect.init(x: (width - mainWidth)/2.0, y: (width - mainWidth)/2.0, width: mainWidth, height: mainWidth)
        }
        
        let mainPath = UIBezierPath.init(roundedRect: mainFrame, cornerRadius: mainWidth/2.0)
        self.centerLayer.path = mainPath.cgPath
        
        if self.isPressed {
            
            let progressFrame = ringFrame.insetBy(dx: 2.0, dy: 2.0)
            let progressPath = UIBezierPath.init(roundedRect: progressFrame, cornerRadius: progressFrame.width/2.0)
            self.progressLayer.path = progressPath.cgPath
            self.progressLayer.strokeEnd = CGFloat(self.progress)
        }
    }
}
