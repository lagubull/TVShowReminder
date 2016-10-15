//
//  LoadingView.swift
//  TVShowsReminder
//
//  Created by Javier Laguna on 11/03/2016.
//
//

import Foundation
import PureLayout

/**
 Loading View for the tableView.
 */
class LoadingView: UIView {
    
    //MARK: Init
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.addSubview(self.loadingIndicator)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Subviews
    
    /*
    Animating activity indicator.
    */
    lazy var loadingIndicator: UIActivityIndicatorView  = {
        
        let _loadingIndicator = UIActivityIndicatorView.newAutoLayoutView()
        
        _loadingIndicator.activityIndicatorViewStyle = .WhiteLarge
        
        _loadingIndicator.startAnimating()
        
        return _loadingIndicator;
    }()
    
    //MARK: Constraints
    
    override func updateConstraints() {
        
        self.loadingIndicator.autoCenterInSuperview()
        
        /*------------------*/
        
        super.updateConstraints()
    }
}