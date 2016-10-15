//
//  ShowTableViewCell.swift
//  TVShowsReminder
//
//  Created by Javier Laguna on 11/03/2016.
//
//

import Foundation
import PureLayout

/**
 Actions from the cell.
 */
protocol ShowTableViewCellDelegate {
    
    /**
     User pressed on the favorites button.
     
     - Parameter show: show cell is showing.
     */
    func didPressFavoritesButton(show: Show)
    
    /**
     User pressed on the comments button.
     
     - Parameter show: show cell is showing.
     */
    func didPressCommentsButton(show: Show)
}

/**
 Representation for a show.
 */
class ShowTableViewCell: UITableViewCell {
    
    /**
     Constant to indicate the distance to the lower margin
     */
    private let kBottomConstraint = 8.0 as CGFloat
    
    /**
     Constant to inidicate the margin between components and sides
     */
    private let kMarginConstraint = 10.0 as CGFloat
    
    /**
     Constant for the dimmensions of the images to display in the cell.
     */
    private let kShowAvatardimension = 25.0 as CGFloat

    
    /**
     Show represented in the cell.
     */
    private var show: Show?
    
    /**
     Delegate of the protocol ShowTableViewCellDelegate.
     */
    var delegate:ShowTableViewCellDelegate?
    
    /**
     Identifies the cell type.
     */
    class func reuseIdentifier() -> String {
        
        return NSStringFromClass(self)
    }
    
    //MARK: Init
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .None
        
        self.backgroundColor = UIColor.lightGrayColor()
        
        self.contentView.addSubview(self.baseContentView)
        
        self.baseContentView.addSubview(self.nameLabel)
        self.baseContentView.addSubview(self.avatar)
        self.baseContentView.addSubview(self.avatarLoadingView)
        self.baseContentView.addSubview(self.statusLabel)
        self.baseContentView.addSubview(self.lastUpdatedLabel)
        self.baseContentView.addSubview(self.favoritesButton)
        self.baseContentView.addSubview(self.favoritesCountLabel)
        self.baseContentView.addSubview(self.commentsButton)
        self.baseContentView.addSubview(self.commentsCountLabel)
        
        self.updateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Subviews
    
    /**
    View on which the content is located, we need it to be on top of the edit options.
    */
    lazy var baseContentView: UIView = {
        
        let _baseContentView = UIView.newAutoLayoutView()
        
        _baseContentView.backgroundColor = .whiteColor()
        
        return _baseContentView
    }()
    
    /**
     Content of the show.
     */
    lazy var nameLabel: UILabel = {
        
        let _nameLabel = UILabel.newAutoLayoutView()
        
        _nameLabel.textColor = .blackColor()
        _nameLabel.font = .boldSystemFontOfSize(14.0)
        _nameLabel.numberOfLines = 0
        _nameLabel.textAlignment = .Left
        
        return _nameLabel;
    }()
    
    /**
     Image for the author of the show.
     */
    lazy var avatar: UIImageView = {
        
        let _avatar = UIImageView.newAutoLayoutView()
        
        _avatar.contentMode = .ScaleToFill
        _avatar.clipsToBounds = true
        _avatar.image = UIImage.init(named: "avatarPlaceHolderIcon")
        
        return _avatar
    }()
    
    /**
     Spinner to show activity while downloading.
     */
    lazy var avatarLoadingView: UIActivityIndicatorView = {
        
        let _avatarLoadingView = UIActivityIndicatorView.newAutoLayoutView()
        
        _avatarLoadingView.activityIndicatorViewStyle = .White
        _avatarLoadingView.hidesWhenStopped = true
        
        return _avatarLoadingView
    }()
    
    /*
    Status of the show.
    */
    lazy var statusLabel: UILabel = {
        
        let _statusLabel = UILabel.newAutoLayoutView()
        
        _statusLabel.textColor = .blackColor()
        _statusLabel.font = .systemFontOfSize(12.0)
        
        return _statusLabel
    }()
    
    /*
     Date the show was updated in the source.
     */
    lazy var lastUpdatedLabel: UILabel = {
        
        let _lastUpdatedLabel = UILabel.newAutoLayoutView()
        
        _lastUpdatedLabel.textColor = .blackColor()
        _lastUpdatedLabel.font = .systemFontOfSize(12.0)
        
        return _lastUpdatedLabel
    }()
    
    /**
     Button for favorites.
     */
    lazy var favoritesButton: UIButton = {
        
        let _favoritesButton = UIButton.newAutoLayoutView()
        
        _favoritesButton.setImage(UIImage.init(named: "favoritesIcon"), forState: .Normal)
        
        _favoritesButton.addTarget(self, action: #selector(favoritesButtonPressed), forControlEvents : .TouchUpInside)
        
        return _favoritesButton;
    }()
    
    /**
     Shows the number of times show was made favourtie.
     */
    lazy var favoritesCountLabel: UILabel = {
        
        let _favoritesCountLabel = UILabel.newAutoLayoutView()
        
        _favoritesCountLabel.textColor = .blackColor()
        _favoritesCountLabel.font = .boldSystemFontOfSize(18.0)
        
        return _favoritesCountLabel
    }()
    
    /**
     Button for comments.
     */
    lazy var commentsButton: UIButton = {
        
        let _commentsButton = UIButton.newAutoLayoutView()
        
        _commentsButton.setImage(UIImage.init(named: "commentsIcon"), forState: .Normal)
        
        _commentsButton.addTarget(self, action: #selector(commentsButtonPressed), forControlEvents : .TouchUpInside)
        
        return _commentsButton
    }()
    
    /**
     Shows the number of comments.
     */
    lazy var commentsCountLabel: UILabel = {
        
        let _commentsCountLabel = UILabel.newAutoLayoutView()
        
        _commentsCountLabel.textColor = .blackColor()
        _commentsCountLabel.font = .boldSystemFontOfSize(18.0)
        
        return _commentsCountLabel
    }()
    
    //MARK: PrepareForReuse
    
    override func prepareForReuse(){
        
        super.prepareForReuse()
        
        avatar.image = nil;
    }
    
    //MARK: Constraints
    
    override func updateConstraints () {
        
        baseContentView.autoPinEdgesToSuperviewEdges()
        
        /*------------------*/
        
        nameLabel.autoPinEdgeToSuperviewEdge(.Top)
        
        nameLabel.autoPinEdge(.Left, toEdge:.Right, ofView: avatar, withOffset: 6.0)
        
        nameLabel.autoPinEdgeToSuperviewEdge (.Right, withInset: kMarginConstraint)
        
        /*------------------*/
        
        avatar.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 15.0)
        
        avatar.autoPinEdgeToSuperviewEdge(.Left, withInset: kMarginConstraint)
        
        avatar.autoSetDimensionsToSize(CGSizeMake(kShowAvatardimension, kShowAvatardimension))
        
        /*------------------*/
        
        avatarLoadingView.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 15.0)
        
        avatarLoadingView.autoPinEdgeToSuperviewEdge(.Left, withInset: kMarginConstraint)
        
        avatarLoadingView.autoSetDimensionsToSize(CGSizeMake(kShowAvatardimension, kShowAvatardimension))
        
         /*------------------*/
        
        statusLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: nameLabel)
        
        statusLabel.autoPinEdge(.Left, toEdge: .Right, ofView: avatar, withOffset: 6.0)
        
        statusLabel.autoPinEdgeToSuperviewEdge(.Bottom, withInset: kBottomConstraint)

        /*------------------*/
        
        lastUpdatedLabel.autoPinEdge(.Left, toEdge:.Right, ofView: statusLabel, withOffset: 6.0)
        
        lastUpdatedLabel.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: statusLabel)
        
        lastUpdatedLabel.autoPinEdge(.Top, toEdge: .Top, ofView: statusLabel)
        
        /*------------------*/
//        
//        self.commentsCountLabel.autoPinEdgeToSuperviewEdge(.Right, withInset: kMarginConstraint)
//        
//        self.commentsCountLabel.autoPinEdge(.Top, toEdge:.Top, ofView:self.avatar, withOffset:kBottomConstraint)
//        
//        /*------------------*/
//        
//        self.commentsButton.autoPinEdge(.Right, toEdge:.Left, ofView:self.commentsCountLabel, withOffset: -5.0)
//        
//        self.commentsButton.autoPinEdge(.Top, toEdge:.Top, ofView:self.avatar, withOffset:kBottomConstraint)
//        
//        /*------------------*/
//        
//        self.favoritesCountLabel.autoPinEdge(.Right, toEdge: .Left, ofView:self.commentsButton, withOffset: -kMarginConstraint)
//        
//        self.favoritesCountLabel.autoPinEdge(.Top, toEdge: .Top, ofView: self.avatar, withOffset: kBottomConstraint)
//        
//        /*------------------*/
//        
//        self.favoritesButton.autoPinEdge(.Right, toEdge: .Left, ofView: self.favoritesCountLabel, withOffset: -5.0)
//        
//        self.favoritesButton.autoPinEdge(.Top, toEdge: .Top, ofView: self.avatar, withOffset: kBottomConstraint)
        
        /*------------------*/
        
        super.updateConstraints()
    }
    
    
    //MARK: ButtonActions
    
    func favoritesButtonPressed() {
        
        delegate?.didPressFavoritesButton(self.show!)
    }
    
    func commentsButtonPressed() {
        
        delegate?.didPressCommentsButton(self.show!)
    }
    
    //MARK: UpdateWithShow
    
    /**
    Sets up the Cell with show data.
    
    - Parameter show: show to be displayed.
    */
    func updateWithShow(show: Show) {
        
        self.show = show;
        
        let dateFormatter = NSDateFormatter.tvr_dateFormatter() as NSDateFormatter
        dateFormatter.locale = NSLocale.init(localeIdentifier: NSLocale.preferredLanguages()[0])
        
        avatar.image = UIImage.init(named:"avatarPlaceHolderIcon")
//
//        MediaManager.retrieveMediaForShow(show, retrievalRequired: { [weak self] (showId) -> Void in
//            
//            if self!.show!.showId == showId {
//                
//                self!.avatarLoadingView.startAnimating()
//            }
//            }, success: { [weak self] (result, showId) -> Void in
//                
//                if self!.show!.showId == showId {
//                    
//                    self!.avatarLoadingView.stopAnimating()
//                    
//                    self!.avatar.image = result as? UIImage
//                }
//            }, failure: { [weak self] (error, showId) -> Void in
//                
//                if self!.show!.showId == showId {
//                    
//                    self!.avatarLoadingView.stopAnimating()
//                }
//                
//                if let error: NSError = error {
//                    
//                    NSLog("ERROR: \(error)")
//                }
//            })
//        
        nameLabel.text = show.name
        statusLabel.text = show.status
        lastUpdatedLabel.text = "\(NSLocalizedString("updated: ", comment: ""))\(dateFormatter.stringFromDate(show.lastUpdated!))"
//
//        self.favoritesCountLabel.text = "\(show.likeCount!)"
//        
//        self.commentsCountLabel.text = "\(show.commentCount!)"
    }
}