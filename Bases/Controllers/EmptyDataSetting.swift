//
//  EmptyDataSetting.swift
//  Distributed2020
//
//  Created by Minh Pham Ngoc on 18/11/2020.
//

import Foundation
import UIKit

enum ControlState: Int {
    case normal = 0
    case hightLight
    case disable
}

struct EmptyDataViewSettings {
    var titleAttributedString: NSAttributedString?
    var detailAttributedString: NSAttributedString?
    var image: UIImage?
    var buttonTitleForNormalState: NSAttributedString?
    var buttonBackgroundImageForNormalState: UIImage?
    var dataSetBackgroundColor: UIColor?
    var verticalOffset: CGFloat?
    var verticalSpace: CGFloat?
    var isTouchAllowed: Bool = false
    var isScrollAllowed: Bool = false
}
