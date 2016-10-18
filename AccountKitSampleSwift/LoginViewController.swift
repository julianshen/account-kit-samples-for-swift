//
//  LoginTableViewController.swift
//  AccountKitSampleSwift
//
//  Created by Julian Shen on 2016/10/9.
//  Copyright © 2016年 cowbay.wtf. All rights reserved.
//

import UIKit
import AccountKit

extension AKFButtonType {
    var label:String  {
        get {
            switch (self) {
            case .default:
                return "Default"
            case .begin:
                return "Begin"
            case .confirm:
                return "Confirm"
            case .continue:
                return "Continue"
            case .logIn:
                return "Log In"
            case .next:
                return "Next"
            case .OK:
                return "OK"
            case .send:
                return "Send"
            case .start:
                return "Start"
            case .submit:
                return "Submit"
            }
        }
    }
}

class LoginViewController: UITableViewController, AKFViewControllerDelegate, ConfigOptionListViewControllerDelegate {
    var _accountKit:AKFAccountKit?
    
    var _theme:AKFTheme?
    var _themeType: ThemeType?
    var _advancedUIManager: AdvancedUIManager?
    
    var _showAccountOnAppear:Bool = false
    var _enableSendToFacebook:Bool = true
    var _useAdvancedUIManager:Bool = false {
        didSet {
            if(_useAdvancedUIManager) {
                _ensureAdvancedUIManager()
            }
            _updateCells()
        }
    }
    
    var _inputState:String?
    var _outputState:String?
    var _authorizationCode:String?
    
    
    var _pendingLoginViewController:AKFViewController?
    
    private let _themeOptions:[ConfigOption] = {
        var configOptions = [ConfigOption]()
        
        for i in 0 ..< ThemeType.count {
            let type = ThemeType(rawValue: i)
            configOptions.append(ConfigOption(i, (type?.description)!))
        }
        
        return configOptions
    }()
    
    private let _buttonTypeOptions:[ConfigOption] = {
        var configOptions = [ConfigOption]()
        for var i in 0..<AKFButtonTypeCount {
            let type = AKFButtonType(rawValue: UInt(i))!
            let option = ConfigOption(Int(i), type.label)
            configOptions.append(option)
        }
        
        return configOptions
    }()

    @IBOutlet weak var currentThemeLabel: UILabel!
    
    @IBOutlet weak var currentEntryButtonLabel: UILabel!
    
    @IBOutlet weak var currentConfirmButtonLabel: UILabel!
    
    @IBOutlet var unselectableCells: [UITableViewCell]!
    
    @IBOutlet var advancedUICells: [UITableViewCell]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if _accountKit == nil {
            _accountKit = AKFAccountKit(responseType: .accessToken)
        }

        _showAccountOnAppear = (_accountKit?.currentAccessToken != nil)
        _pendingLoginViewController = _accountKit?.viewControllerForLoginResume() as! AKFViewController?
        _enableSendToFacebook = true
        
        
        _updateThemeType(themeType: _themeType)
        _updateEntryButtonType(_advancedUIManager?.entryButtonType)
        _updateConfirmButtonType(_advancedUIManager?.confirmButtonType)
        _updateCells()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if _showAccountOnAppear {
            _showAccountOnAppear = false
            performSegue(withIdentifier: "showAccount", sender: nil)
        } else if let pendingViewController = _pendingLoginViewController {
            _prepareLoginViewController(pendingViewController)
            present(pendingViewController as! UIViewController, animated: animated, completion: nil)
            _pendingLoginViewController = nil
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if ["showEntryButtonTypeList", "showConfirmButtonTypeList"].contains(identifier) {
            return _useAdvancedUIManager
        }
        
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController = segue.destination
        let identifier = segue.identifier
        
        if destinationViewController is AccountViewController {
            (destinationViewController as! AccountViewController).accountKitState = _outputState
        } else if destinationViewController is AuthorizationCodeViewController {
            let authCodeViewController = destinationViewController as! AuthorizationCodeViewController
            authCodeViewController.accountKitAuthorizationCode = _authorizationCode
            authCodeViewController.accountKitState = _outputState
        } else if identifier == "showThemeList" {
            _prepareConfigOptionListViewController(destinationViewController as! ConfigOptionListViewController, withType: .theme, options: _themeOptions, selectedValue: _themeType?.rawValue)
        } else if identifier == "showEntryButtonTypeList" {
            let selectedValue = _advancedUIManager?.entryButtonType?.rawValue ?? 0
            _prepareConfigOptionListViewController(destinationViewController as! ConfigOptionListViewController, withType: .entryButton, options: _buttonTypeOptions, selectedValue: Int(selectedValue))
        } else if identifier == "showConfirmButtonTypeList" {
            let selectedValue = _advancedUIManager?.confirmButtonType?.rawValue ?? 0
            _prepareConfigOptionListViewController(destinationViewController as! ConfigOptionListViewController, withType: .confirmButton, options: _buttonTypeOptions, selectedValue: Int(selectedValue))
        }
    }
    
    private func _prepareLoginViewController(_ loginViewController:AKFViewController) {
        loginViewController.advancedUIManager = _useAdvancedUIManager ? _advancedUIManager:nil
        loginViewController.delegate = self
        loginViewController.theme = _theme
    }
    
    private func _present(withSegueIdentifier segueIdentifier:String, animated:Bool) {
        if animated {
            self.performSegue(withIdentifier: segueIdentifier, sender: nil)
        } else {
            UIView.performWithoutAnimation {
                self.performSegue(withIdentifier: segueIdentifier, sender: nil)
            }
        }
    }
    
    private func _updateThemeType(themeType:ThemeType?) {
        _themeType = themeType ?? .default
        let theme = _themeType?.theme
        
        if let t = _theme {
            theme?.headerTextType = t.headerTextType
        }
        
        _theme = theme
        currentThemeLabel.text = _themeType?.description
    }

    private func _updateEntryButtonType(_ buttonType:AKFButtonType?) {
        let type = buttonType ?? .default
        self.currentEntryButtonLabel.text = type.label
        
        if type != .default {
            _ensureAdvancedUIManager()
        }
        _advancedUIManager?.entryButtonType = type
    }
    
    private func _updateConfirmButtonType(_ buttonType:AKFButtonType?) {
        let type = buttonType ?? .default
        self.currentConfirmButtonLabel.text = type.label
        
        if type != .default {
            _ensureAdvancedUIManager()
        }
        _advancedUIManager?.confirmButtonType = type
    }
    
    private func _setCell(cell: UITableViewCell, enabled: Bool, selectable: Bool) {
        cell.selectionStyle = selectable ? .default:.none
        
        for view in cell.contentView.subviews {
            if view is UILabel {
                (view as! UILabel).isEnabled = enabled
            } else if view is UIControl {
                (view as! UIControl).isEnabled = enabled
            }
        }
    }
    
    private func _updateCells() {
        for cell in unselectableCells {
            _setCell(cell: cell, enabled: true, selectable: false)
        }
        
        for cell in advancedUICells {
            _setCell(cell: cell, enabled: _useAdvancedUIManager, selectable: _useAdvancedUIManager && !unselectableCells.contains(cell))
        }
    }
    
    private func _ensureAdvancedUIManager() {
        if _advancedUIManager == nil {
            _advancedUIManager = AdvancedUIManager()
        }
    }
    
    private func _prepareConfigOptionListViewController(_ viewController: ConfigOptionListViewController, withType type: ConfigOptionType, options: [ConfigOption], selectedValue: Int?) {
        viewController.configOptions = options
        viewController.configOptionType = type
        viewController.selectConfigOption(withValue: selectedValue)
        viewController.delegate = self
    }
    
    private func _generateState() -> String {
        let uuid = UUID.init().uuidString
        return uuid.substring(to: (uuid.range(of: "-")?.lowerBound)!)
    }
    
    func viewController(_ viewController: UIViewController!, didCompleteLoginWith accessToken: AKFAccessToken!, state: String!) {
        _outputState = state
        _present(withSegueIdentifier: "showAccount", animated: false)
    }
    
    func viewController(_ viewController: UIViewController!, didCompleteLoginWithAuthorizationCode code: String!, state: String!) {
        _authorizationCode = code
        _outputState = state
        _present(withSegueIdentifier: "showAuthorizationCode", animated: false)
    }
    
    func viewController(_ viewController: UIViewController!, didFailWithError error: Error!) {
        print("\(viewController) did fail with error: \(error)")
    }
    
    @IBAction func loginWithEmail(_ sender: AnyObject) {
        let viewController = _accountKit?.viewControllerForEmailLogin(withEmail: nil, state: _inputState) as! AKFViewController
        self._prepareLoginViewController(viewController)
        
        present(viewController as! UIViewController, animated: true, completion: nil)
    }
    
    
    @IBAction func loginWithPhone(_ sender: AnyObject) {
        let viewController = _accountKit?.viewControllerForPhoneLogin(with: nil, state: _inputState) as! AKFViewController
        viewController.enableSendToFacebook = _enableSendToFacebook
        
        self._prepareLoginViewController(viewController)
        
        present(viewController as! UIViewController, animated: true, completion: nil)
    }

    @IBAction func toggleTitle(_ sender: AnyObject) {
        let switchControl = sender as! UISwitch
        _theme?.headerTextType = switchControl.isOn ? .appName:.login
    }
    
    @IBAction func toggleAdvancedUI(_ sender: AnyObject) {
        let switchControl = sender as! UISwitch
        _useAdvancedUIManager = switchControl.isOn
    }
    
    @IBAction func toggleEnableClientAccessTokenFlow(_ sender: AnyObject) {
        let switchControl = sender as! UISwitch
        _accountKit = AKFAccountKit(responseType: switchControl.isOn ? .accessToken:.authorizationCode)
    }
    
    @IBAction func toggleSendState(_ sender: AnyObject) {
        let switchControl = sender as! UISwitch
        
        _inputState = switchControl.isOn ? _generateState():nil
    }
    
    @IBAction func toggleEnableSendToFacebook(_ sender: AnyObject) {
        let switchControl = sender as! UISwitch
        _enableSendToFacebook = switchControl.isOn
    }
    
    func configOptionListViewController(_ controller: ConfigOptionListViewController, _ configOption: ConfigOption) {
        if let type = controller.configOptionType {
            switch type {
            case ConfigOptionType.confirmButton:
                _updateConfirmButtonType(AKFButtonType(rawValue: UInt(configOption.val)))
            case .entryButton:
                _updateEntryButtonType(AKFButtonType(rawValue: UInt(configOption.val)))
            case .theme:
                _updateThemeType(themeType: ThemeType(rawValue: configOption.val))
            case .none:
                break
            }
        }
        
        _ = controller.navigationController?.popViewController(animated: true)
    }
}
