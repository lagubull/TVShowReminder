//
//  EpisodeTableViewCell.swift
//  TVShowsReminder
//
//  Created by Javier Laguna on 11/10/2016.
//  Copyright © 2016 Lagusoft. All rights reserved.
//

import Foundation
import PureLayout

/**
 Representation for an Episode.
 */
class EpisodeTableViewCell: UITableViewCell {
    
    /**
     Constant to indicate the distance to the lower margin
     */
    private let kBottomConstraint = 8.0 as CGFloat
    
    /**
     Constant to inidicate the margin between components and sides
     */
    private let kMarginConstraint = 10.0 as CGFloat
    
    /**
     Show shown in the cell.
     */
    private var episode: Episode?
    
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
        
        self.baseContentView.addSubview(self.indexLabel)
        self.baseContentView.addSubview(self.titleLabel)
        self.baseContentView.addSubview(self.airDateLabel)
        
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
     Title of the episode.
     */
    lazy var titleLabel: UILabel = {
        
        let _titleLabel = UILabel.newAutoLayoutView()
        
        _titleLabel.textColor = .blackColor()
        _titleLabel.font = .boldSystemFontOfSize(14.0)
        _titleLabel.numberOfLines = 0
        _titleLabel.textAlignment = .Justified
        
        return _titleLabel
    }()
    
    /**
     Index of the episode in the season.
     */
    lazy var indexLabel: UILabel = {
        
        let _indexLabel = UILabel.newAutoLayoutView()
        
        _indexLabel.textColor = .blackColor()
        _indexLabel.font = .boldSystemFontOfSize(14.0)
        _indexLabel.numberOfLines = 1
        _indexLabel.textAlignment = .Left
        
        return _indexLabel
    }()
    
    /*
     Date it was first shown.
     */
    lazy var airDateLabel: UILabel = {
        
        let _airDateLabel = UILabel.newAutoLayoutView()
        
        _airDateLabel.textColor = .blackColor()
        _airDateLabel.font = .systemFontOfSize(12.0)
        _airDateLabel.textAlignment = .Left
        
        return _airDateLabel
    }()
    
    //MARK: Constraints
    
    override func updateConstraints () {
        
        baseContentView.autoPinEdgesToSuperviewEdges()
        
        /*------------------*/
        
        indexLabel.autoPinEdgeToSuperviewEdge(.Top)
        
        indexLabel.autoPinEdgeToSuperviewEdge(.Left, withInset: kMarginConstraint)
        
        indexLabel.autoPinEdge(.Right, toEdge: .Left, ofView: titleLabel, withOffset: -kMarginConstraint)
        
        indexLabel.autoPinEdgeToSuperviewEdge(.Bottom, withInset: kBottomConstraint)
        
        indexLabel.autoSetDimension(.Width, toSize: 20.0)
        
        /*------------------*/
        
        titleLabel.autoPinEdgeToSuperviewEdge(.Top, withInset: kBottomConstraint)
        
        titleLabel.autoPinEdgeToSuperviewEdge (.Right, withInset: kMarginConstraint)

        /*------------------*/
        
        airDateLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: titleLabel)
        
        airDateLabel.autoPinEdge(.Left, toEdge: .Left, ofView: titleLabel)
        
        airDateLabel.autoPinEdgeToSuperviewEdge (.Right, withInset: kMarginConstraint)
        
        airDateLabel.autoPinEdgeToSuperviewEdge(.Bottom, withInset: kBottomConstraint)

        
        /*------------------*/
        
        super.updateConstraints()
    }
    
    
    //MARK: ButtonActions
    
    //MARK: UpdateWithEpisode
    
    /**
     Sets up the Cell with show data.
     
     - Parameter show: show to be displayed.
     */
    func updateWithEpisode(episode: Episode) {
        
        self.episode = episode
        
        let dateFormatter = NSDateFormatter.tvr_dateFormatter() as NSDateFormatter
        dateFormatter.locale = NSLocale.init(localeIdentifier: NSLocale.preferredLanguages()[0])
        
        titleLabel.text = episode.title!
        indexLabel.text = "\(episode.index!)"
        
        guard let airdate = episode.airdate else { return }
        
        airDateLabel.text = dateFormatter.stringFromDate(airdate)
    }
}
