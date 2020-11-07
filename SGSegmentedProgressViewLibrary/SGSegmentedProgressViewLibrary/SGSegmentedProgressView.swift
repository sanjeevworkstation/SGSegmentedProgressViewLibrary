//
//  SGSegmentedProgressView.swift
//  SGSegmentedProgressViewLibrary
//
//  Created by Sanjeev Gautam on 07/11/20.
//

import Foundation
import UIKit

public final class SGSegmentedProgressView: UIView {
    
    private weak var delegate: SGSegmentedProgressViewDelegate?
    private weak var dataSource: SGSegmentedProgressViewDataSource?
    
    private var numberOfSegments: Int { get { return self.dataSource?.numberOfSegments ?? 0 } }
    private var segmentDuration: TimeInterval { get { return self.dataSource?.segmentDuration ?? 5 } }
    private var paddingBetweenSegments: CGFloat { get { return self.dataSource?.paddingBetweenSegments ?? 5 } }
    private var trackColor: UIColor { get { return self.dataSource?.trackColor ?? UIColor.red.withAlphaComponent(0.3) } }
    private var progressColor: UIColor { get { return self.dataSource?.progressColor ?? UIColor.red } }
    
    private var segments = [UIProgressView]()
    private var timer: Timer?
    
    private let PROGRESS_SPEED: Double = 1000
    private var PROGRESS_INTERVAL: Float {
        let value = (self.segmentDuration * PROGRESS_SPEED)
        let result = (Float(1/value))
        return result
    }
    private var TIMER_TIMEINTERVAL: Double {
        return (1/PROGRESS_SPEED)
    }
    
    // MARK:- Properties
    public private (set) var isPaused: Bool = false
    public private (set) var currentIndex: Int = 0

    // MARK:- Initializer
    internal required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    
    public init(frame: CGRect, delegate: SGSegmentedProgressViewDelegate, dataSource: SGSegmentedProgressViewDataSource) {
        super.init(frame : frame)
        
        self.delegate = delegate
        self.dataSource = dataSource
        
        self.drawSegments()
    }
    
    // MARK:- Private
    private func drawSegments() {
        
        let remainingWidth = self.frame.size.width - (self.paddingBetweenSegments * CGFloat(self.numberOfSegments-1))
        let widthOfSegment = remainingWidth/CGFloat(self.numberOfSegments)
        let heightOfSegment = self.frame.size.height
        
        var originX: CGFloat = 0
        let originY: CGFloat = 0
        
        for index in 0..<self.numberOfSegments {
            originX = (CGFloat(index) * widthOfSegment) + (CGFloat(index) * self.paddingBetweenSegments)
            
            let frame = CGRect(x: originX, y: originY, width: widthOfSegment, height: heightOfSegment)
            let progressView = self.createProgressView()
            progressView.frame = frame
            progressView.transform = CGAffineTransform(scaleX: 1.0, y: heightOfSegment)
            self.addSubview(progressView)
            self.segments.append(progressView)
            
            if let cornerType = self.dataSource?.roundCornerType {
                switch cornerType {
                case .roundCornerSegments(let cornerRadious):
                    progressView.borderAndCorner(cornerRadious: cornerRadious, borderWidth: 0, borderColor: nil)
                case .roundCornerBar(let cornerRadious):
                    if index == 0 {
                        progressView.roundCorners(corners: [.topLeft, .bottomLeft], radius: cornerRadious)
                    } else if index == self.numberOfSegments-1 {
                        progressView.roundCorners(corners: [.topRight, .bottomRight], radius: cornerRadious)
                    }
                case .none:
                    break
                }
            }
        }
    }
    
    private func createProgressView() -> UIProgressView {
        let progressView = UIProgressView(progressViewStyle: .bar)
        progressView.setProgress(0, animated: false)
        progressView.trackTintColor = self.trackColor
        progressView.tintColor = self.progressColor
        return progressView
    }
    
    // MARK:- Timer
    private func setUpTimer() {
        if self.timer == nil {
            self.timer = Timer.scheduledTimer(timeInterval: TIMER_TIMEINTERVAL, target: self, selector: #selector(animationTimerMethod), userInfo: nil, repeats: true)
        }
    }
    
    @objc private func animationTimerMethod() {
        if self.isPaused { return }
        self.animateSegment()
    }
    
    // MARK:- Animate Segment
    private func animateSegment() {
        if self.currentIndex < self.segments.count {
            let progressView = self.segments[self.currentIndex]
            let lastProgress = progressView.progress
            let newProgress = lastProgress + PROGRESS_INTERVAL
            
            progressView.setProgress(newProgress, animated: false)
            
            if newProgress >= 1 {
                if self.currentIndex == self.numberOfSegments-1 {
                    self.delegate?.segmentedProgressViewFinished(finishedIndex: self.currentIndex, isLastIndex: true)
                } else {
                    self.delegate?.segmentedProgressViewFinished(finishedIndex: self.currentIndex, isLastIndex: false)
                }
                
                if self.currentIndex < self.numberOfSegments-1 {
                    self.currentIndex = self.currentIndex + 1
                    
                    let progressView = self.segments[self.currentIndex]
                    progressView.setProgress(0, animated: false)
                    
                } else {
                    self.timer?.invalidate()
                    self.timer = nil
                }
            }
        }
    }
    
    // MARK:- Actions
    public func start() {
        self.setUpTimer()
    }
    
    public func pause() {
        self.isPaused = true
    }
    
    public func resume() {
        self.isPaused = false
    }
    
    public func restart() {
        self.reset()
        self.start()
    }
    
    public func nextSegment() {
        if self.currentIndex < self.segments.count-1 {
            self.isPaused = true
            
            let progressView = self.segments[self.currentIndex]
            progressView.setProgress(1, animated: false)
            
            self.currentIndex = self.currentIndex + 1
            
            self.isPaused = false
            
            if self.timer == nil {
                self.start()
            } else {
                self.animateSegment()
            }
        }
    }
    
    public func previousSegment() {
        
        if self.currentIndex > 0 {
            self.isPaused = true
            
            let currentProgressView = self.segments[self.currentIndex]
            currentProgressView.setProgress(0, animated: false)
            
            self.currentIndex = self.currentIndex - 1
            
            let progressView = self.segments[self.currentIndex]
            progressView.setProgress(0, animated: false)
            
            self.isPaused = false
            
            if self.timer == nil {
                self.start()
            } else {
                self.animateSegment()
            }
        }
    }
    
    public func restartCurrentSegment() {
        self.isPaused = true
        
        let currentProgressView = self.segments[self.currentIndex]
        currentProgressView.setProgress(0, animated: false)
        
        self.isPaused = false
        
        if self.timer == nil {
            self.start()
        } else {
            self.animateSegment()
        }
    }
    
    public func reset() {
        self.isPaused = true
        
        self.timer?.invalidate()
        self.timer = nil
        
        for index in 0..<numberOfSegments {
            let progressView = self.segments[index]
            progressView.setProgress(0, animated: false)
        }
        
        self.currentIndex = 0
        self.isPaused = false
    }
    
    // MARK:- Set Progress Manually
    public func setProgressManually(index: Int, progressPercentage: CGFloat) {
        
        if index < self.segments.count && index >= 0 {
            self.timer?.invalidate()
            self.timer = nil
            
            self.currentIndex = index
            var percentage = progressPercentage
            if progressPercentage > 100 {
                percentage = 100
            }
            
            // converting into 0 to 1 for UIProgressView range
            percentage = percentage / 100
            
            let progressView = self.segments[self.currentIndex]
            progressView.setProgress(Float(percentage), animated: false)
        }
    }
}
