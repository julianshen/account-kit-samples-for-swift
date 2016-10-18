//
//  AdvancedUIManager.swift
//  AccountKitSampleSwift
//
//  Created by Julian Shen on 2016/10/10.
//  Copyright © 2016年 cowbay.wtf. All rights reserved.
//

import Foundation
import AccountKit

class AdvancedUIManager: NSObject, AKFAdvancedUIManager {

    var _actionController:AKFAdvancedUIActionController?
    var confirmButtonType:AKFButtonType?
    var entryButtonType:AKFButtonType?
    var _error:Error?

    func actionBarView(for state: AKFLoginFlowState) -> UIView? {
        let view = _view(for: state, "Action Bar", 64.0)
        view?.contentInset = UIEdgeInsetsMake(20.0, 0.0, 0.0, 0.0)
        view?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(_back)))
        return nil
    }
    
    func bodyView(for state: AKFLoginFlowState) -> UIView? {
        return _view(for: state, "Body", 80.0)
    }
    
    func buttonType(for state: AKFLoginFlowState) -> AKFButtonType {
        switch state {
        case .codeInput:
            return confirmButtonType ?? .default
        case .emailInput:
            return entryButtonType ?? .default
        case .phoneNumberInput:
            return entryButtonType ?? .default
        default:
            return .default
        }
    }
    
    func footerView(for state: AKFLoginFlowState) -> UIView? {
        return _view(for: state, "Footer", 120.0)
    }
    
    func headerView(for state: AKFLoginFlowState) -> UIView? {
        if state == .error {
            let errorMessage = (_error as! NSError).userInfo[AKFErrorUserMessageKey] ?? "An error has occurred."
            return _view(with: errorMessage as! String, 80.0)
        }
        
        return _view(for: state, "Header", 80.0)
    }
    
    func setActionController(_ actionController: AKFAdvancedUIActionController) {
        _actionController = actionController
    }
    
    func setError(_ error: Error) {
        _error = error
    }
    
    private func _view(with text: String, _ intrinsicHeight:CGFloat) -> PlaceholderView {
        let view = PlaceholderView(frame: CGRect.zero)
        view.intrinsicHeight = intrinsicHeight
        view.text = text
        
        //default inset
        view.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
        
        return view
    }
    
    private func _view(for state: AKFLoginFlowState, _ suffix: String, _ intrinsicHeight: CGFloat) -> PlaceholderView? {
        var prefix = ""
        
        switch(state) {
        case .phoneNumberInput:
            prefix = "Custom Phone Number"
        case .emailInput:
            prefix = "Custom Email"
        case .emailVerify:
            prefix = "Custom Email Verify"
        case .sendingCode:
            prefix = "Custom Sending Code"
        case .sentCode:
            prefix = "Custom Sent Code"
        case .codeInput:
            prefix = "Custom Code Input"
        case .verifyingCode:
            prefix = "Custom Verifying Code"
        case .verified:
            prefix = "Custom Verified"
        case .error:
            prefix = "Custom Error"
        default:
            return nil
        }
        
        return _view(with: "\(prefix) \(suffix)", intrinsicHeight)
    }
    
    func _back(_ sender:Any) {
        _actionController!.back()
    }
}
