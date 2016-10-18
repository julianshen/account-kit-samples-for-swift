//
//  ConfigOptionListViewController.swift
//  AccountKitSampleSwift
//
//  Created by Julian Shen on 2016/10/9.
//  Copyright © 2016年 cowbay.wtf. All rights reserved.
//

import UIKit

enum ConfigOptionType:Int {
    case none, confirmButton, entryButton, theme
}

struct ConfigOption {
    var label:String
    var val:Int
    
    init(_ val:Int, _ label:String) {
        self.val = val
        self.label = label
    }
}

protocol ConfigOptionListViewControllerDelegate:class {
    func configOptionListViewController(_ controller: ConfigOptionListViewController, _ configOption: ConfigOption)
}

class ConfigOptionListViewController: UITableViewController {
    var _selectedConfigOptionValue:Int?
    
    var configOptionType:ConfigOptionType?
    
    var configOptions:[ConfigOption]? {
        didSet {
            if self.isViewLoaded {
                self.tableView.reloadData()
            }
        }
    }
    
    weak var delegate:ConfigOptionListViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self._highlightSelectedValue()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = configOptions?.count else {
            return 0
        }
        
        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "configOptionCell", for: indexPath)
        
        if let configOption = configOptions?[indexPath.row] {
            cell.textLabel?.text = configOption.label
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let configOption = configOptions?[indexPath.row] {
            _selectedConfigOptionValue = configOption.val
            self.delegate?.configOptionListViewController(self, configOption)
        }
    }
    
    func selectConfigOption(withValue val:Int?) {
        if _selectedConfigOptionValue != val {
            _selectedConfigOptionValue = val
            self._highlightSelectedValue()
        }
    }
    
    private func _highlightSelectedValue() {
        if !self.isViewLoaded {
            return
        }
        
        if let selectedConfigOptionValue = _selectedConfigOptionValue {
            self.tableView.selectRow(at: IndexPath(row: Int(selectedConfigOptionValue), section: 0), animated: false, scrollPosition: .none)
        }
    }
}
