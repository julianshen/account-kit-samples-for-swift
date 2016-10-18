//
//  PlaceholderView.swift
//  AccountKitSampleSwift
//
//  Created by Julian Shen on 2016/10/10.
//  Copyright © 2016年 cowbay.wtf. All rights reserved.
//

import UIKit

class PlaceholderView: UIView {
    var _label:UILabel?
    var _outlineLayer:CAShapeLayer?
    var text:String? {
        didSet {
            if oldValue != text {
                _label?.text = text
                self.invalidateIntrinsicContentSize()
            }
        }
    }
    
    var contentInset:UIEdgeInsets? {
        didSet {
            if let old = oldValue, let new = contentInset {
                if !UIEdgeInsetsEqualToEdgeInsets(old, new) {
                    self.setNeedsLayout()
                }
            }
        }
    }
    
    var intrinsicHeight:CGFloat? {
        didSet {
            if oldValue != intrinsicHeight {
                self.invalidateIntrinsicContentSize()
            }
        }
    }
    
    override var intrinsicContentSize:CGSize {
        get {
            return CGSize(width: _label!.intrinsicContentSize.width, height: self.intrinsicHeight!)
        }
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let textSize = _label?.sizeThatFits(size)
        return CGSize(width: (textSize?.width)!, height: max((textSize?.height)!, self.intrinsicHeight!))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        _label = UILabel(frame: self.bounds)
        _label?.textAlignment = .center
        _label?.textColor = .white
        self.addSubview(_label!)
        
        _outlineLayer = CAShapeLayer()
        _outlineLayer?.backgroundColor = UIColor.clear.cgColor
        _outlineLayer?.fillColor = nil
        _outlineLayer?.lineDashPattern = [8.0, 4.0]
        _outlineLayer?.lineWidth = 2.0
        _outlineLayer?.isOpaque = false
        _outlineLayer?.strokeColor = UIColor(white: 204.0/255.0, alpha: 1.0).cgColor
        self.layer.addSublayer(_outlineLayer!)
        self.backgroundColor = UIColor(red: 224.0/255.0, green: 39.0/255.0, blue: 39.0/255.0, alpha: 1.0)
        
        intrinsicHeight = 100.0
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let bounds = UIEdgeInsetsInsetRect(self.bounds, self.contentInset!)
        
        _label?.frame = bounds
        let outlineFrame = self.bounds.insetBy(dx: 6.0, dy: 6.0)
        if !outlineFrame.equalTo((_outlineLayer?.frame)!) {
            _outlineLayer?.path = UIBezierPath(roundedRect: CGRect(x: 0.0, y: 0.0, width: outlineFrame.width, height: outlineFrame.height), cornerRadius: 6.0).cgPath
            _outlineLayer?.frame = outlineFrame
    
        }
        
    }
}
