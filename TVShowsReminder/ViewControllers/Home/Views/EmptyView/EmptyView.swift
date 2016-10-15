//
//  EmptyView.swift
//  TVShowsReminder
//
//  Created by Javier Laguna on 11/03/2016.
//
//

import Foundation
import PureLayout

/**
 Empty View for the tableView.
 */
class EmptyView: UIView {
    
    //MARK: Init
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.backgroundColor = .whiteColor()
        
        self.addSubview(self.messageLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    //Mark Subviews
    
    /**
    Label for displaying a customizable message.
    */
    lazy var messageLabel: UILabel = {
        
        let _messageLabel = UILabel.newAutoLayoutView()
        
        _messageLabel.textColor = .blackColor()
        _messageLabel.font = .boldSystemFontOfSize(18.0)
        
        return _messageLabel;
    }()
    
    //MARK: Constraints
    
    override func updateConstraints() {
        
        self.messageLabel.autoCenterInSuperview()
        
        /*------------------*/
        
        super.updateConstraints()
    }
}