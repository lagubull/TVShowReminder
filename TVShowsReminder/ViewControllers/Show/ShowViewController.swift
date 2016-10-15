//
//  ShowViewController.swift
//  TVShowsReminder
//
//  Created by Javier Laguna on 11/10/2016.
//  Copyright © 2016 Lagusoft. All rights reserved.
//

import UIKit

import SimpleTableView
import EasyAlert

/**
 Show viewController.
 */
class ShowViewController: UIViewController {
    
    var show: Show?
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        navigationController!.navigationBar.tvr_setHeight(kTVRNavigationBarHeight)
        
        navigationController!.navigationBar.translucent = false
        navigationController!.navigationBar.barTintColor = .whiteColor()
        
        navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.blackColor()]
        
        navigationController!.navigationBar.topItem!.title = ""
        
        title = show!.name
        
        view.backgroundColor = .blueColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.navigationController!.navigationBarHidden = false
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
        self.view.addSubview(self.tableView)
        
        self.adapter.refresh()
    }
    
    //MARK: Subviews
    
    /**
     Displays the episodes.
     */
    lazy var tableView: STVSimpleTableView! = {
        
        let _tableView = STVSimpleTableView.init(frame: CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height))
        
        _tableView.backgroundColor = .lightGrayColor()
        
        _tableView.separatorStyle = .None
        _tableView.allowsSelection = false
        _tableView.loadingView = self.loadingView
        _tableView.emptyView = self.emptyView
        
        return _tableView
    }()
    
    /**
     View to show when no data is available.
     */
    lazy var emptyView: EmptyView = {
        
        let _emptyView = EmptyView.init(frame: CGRectMake(0.0, 0.0, self.view.bounds.size.width, self.view.bounds.size.height))
        
        _emptyView.messageLabel.text = NSLocalizedString("NoContentBody", comment: "")
        
        return _emptyView
    }()
    
    /**
     View to show while data is being loaded.
     */
    lazy var loadingView: LoadingView = {
        
        let _loadingView = LoadingView.init(frame: CGRectMake(0.0, 0.0, self.view.bounds.size.width, self.view.bounds.size.height))
        
        return _loadingView
    }()
    
    //MARK: Getters
    
    /**
     Handles the tableView.
     */
    lazy var adapter: ShowAdapter = {
        
        let _adapter = ShowAdapter.init(show: self.show!)

        _adapter.tableView = self.tableView
        
        return _adapter
    }()
}
