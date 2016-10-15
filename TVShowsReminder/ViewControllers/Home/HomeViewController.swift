//
//  HomeViewController.swift
//  TVShowsReminder
//
//  Created by Javier Laguna on 12/03/2016.
//
//

import Foundation

import SimpleTableView
import EasyAlert

/**
Constant to define the height of the navigation bar.
*/
let kTVRNavigationBarHeight = 44.0 as CGFloat

/**
 Landing viewController.
 */
class HomeViewController: UIViewController, HomeAdapterDelegate {
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationController!.navigationBar.tvr_setHeight(kTVRNavigationBarHeight)
        
        self.navigationController!.navigationBar.translucent = false
        self.navigationController!.navigationBar.barTintColor = .whiteColor()
        
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.blackColor()]
        
        self.title = NSLocalizedString("showsTitle", comment: "")
        
        self.view.backgroundColor = .blueColor()
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
    Displays the posts.
    */
    lazy var tableView: STVSimpleTableView! = {
        
        let _tableView = STVSimpleTableView.init(frame: CGRectMake(0.0, 0.0, self.view.bounds.size.width, self.view.bounds.size.height))
        
        _tableView.backgroundColor = .lightGrayColor()
        
        _tableView.separatorStyle = .SingleLine
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
    lazy var adapter: HomeAdapter = {
        
        let _adapter = HomeAdapter.init()
        
        _adapter.delegate = self
        _adapter.tableView = self.tableView
        
        return _adapter
    }()
    
    //MARK: HomeAdapterDelegate
    
    func didTapCellWithShow(show: Show) {
        
        let showViewController = ShowViewController()
        
        showViewController.show = show
        
        navigationController?.pushViewController(showViewController, animated: true)
    }
    
    func didPressCommentsButton(show: Show) {
        
        LEAAlertController.dismissibleAlertViewWithTitle(NSLocalizedString("CommentsMessageTitle", comment: ""), message: NSLocalizedString("CommentsMessageBody", comment: ""), cancelButtonTitle: NSLocalizedString("AcceptNav", comment: "")).showInViewController(self)
    }
    
    func didPressFavoritesButton(show: Show) {
        
        LEAAlertController.dismissibleAlertViewWithTitle(NSLocalizedString("FavoritesMessageTitle", comment: ""), message: NSLocalizedString("FavoritesMessageBody", comment: ""),
            cancelButtonTitle: NSLocalizedString("AcceptNav", comment: "")).showInViewController(self)
    }
}
