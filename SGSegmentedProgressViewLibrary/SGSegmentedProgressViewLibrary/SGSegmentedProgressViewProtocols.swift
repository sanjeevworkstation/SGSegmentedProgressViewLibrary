//
//  SGSegmentedProgressViewProtocols.swift
//  SGSegmentedProgressViewLibrary
//
//  Created by Sanjeev Gautam on 07/11/20.
//

//
//  SGSegmentedProgressViewProtocols.swift
//  SGSegmentedProgressView
//
//  Created by Sanjeev Gautam on 27/05/20.
//  Copyright © 2020 SG. All rights reserved.
//
import Foundation
import UIKit

public protocol SGSegmentedProgressViewDelegate: class {
    func segmentedProgressViewFinished(finishedIndex: Int, isLastIndex: Bool)
}

public protocol SGSegmentedProgressViewDataSource: class {
    var numberOfSegments: Int { get }
    var segmentDuration: TimeInterval { get }
    var paddingBetweenSegments: CGFloat { get }
    var trackColor: UIColor { get }
    var progressColor: UIColor { get }
    var roundCornerType: SGCornerType { get }
}

public enum SGCornerType {
    case roundCornerSegments(cornerRadious: CGFloat)
    case roundCornerBar(cornerRadious: CGFloat)
    case none
}
