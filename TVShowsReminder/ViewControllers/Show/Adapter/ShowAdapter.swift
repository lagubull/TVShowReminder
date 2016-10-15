//
//  ShowAdapter.swift
//  TVShowsReminder
//
//  Created by Javier Laguna on 11/10/2016.
//  Copyright © 2016 Lagusoft. All rights reserved.
//

import Foundation

import SimpleTableView
import CoreDataServices

/**
 Manages the tableview for the HomeViewController.
 */
class ShowAdapter: NSObject, UITableViewDataSource, UITableViewDelegate, STVDataRetrievalTableViewDelegate {
    
    var show: Show?
    
    /**
     Delegate of the ShowAdapterDelegate protocol.
     */
    var delegate: HomeAdapterDelegate?
    
    //MARK: Init
    
    convenience init(show: Show) {
        
        self.init()
        
        self.show = show
    }
    
    //MARK: TableView
    
    /**
     Shows the content.
     */
    var tableView: STVSimpleTableView? {
        
        didSet {
            
            self.tableView!.dataSource = self
            self.tableView!.delegate = self
            self.tableView!.dataRetrievalDelegate = self
            self.tableView!.fetchedResultsController = self.fetchedResultsController
            
            self.tableView!.registerClass(EpisodeTableViewCell.self, forCellReuseIdentifier: EpisodeTableViewCell.reuseIdentifier())
        }
    }
    
    //MARK: FetchedResultsController
    
    /**
     Fetch request for retrieving episodes.
     */
    lazy var fetchedResultsController: NSFetchedResultsController = {
        
        let _fetchedResultsController = NSFetchedResultsController.init(fetchRequest: self.fetchRequest, managedObjectContext: ServiceManager.sharedInstance.mainManagedObjectContext, sectionNameKeyPath: "season", cacheName: nil)
        
        return _fetchedResultsController
    }()
    
    /**
     Used to connect the TableView with Core Data.
     */
    lazy var fetchRequest: NSFetchRequest = {
        
        let _fetchRequest = NSFetchRequest.init()
        
        _fetchRequest.entity = NSEntityDescription.entityFor(Episode.self,
                                                             managedObjectContext: ServiceManager.sharedInstance.mainManagedObjectContext)
        
        _fetchRequest.predicate = Episode.episodesPredicateWithShow(self.show!)
        
        _fetchRequest.sortDescriptors = self.sortDescriptorsForFetchRequest
        
        return _fetchRequest
    }()
    
    lazy var sortDescriptorsForFetchRequest: Array <NSSortDescriptor> = {
        
        var postIdSort : NSSortDescriptor = NSSortDescriptor.init(key: "index", ascending: true)
      //  var seasonIdSort : NSSortDescriptor = NSSortDescriptor.init(key: "season", ascending: true)
        
        return [postIdSort];
    }()
    
    //MARK: HomeAdapterDelegate
    
    /**
     Requests and updates the content.
     */
    func refresh() {
        
        do {
            
            try fetchedResultsController.performFetch()
        }
        catch {
            
            let nserror = error as NSError
            
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    //MARK: UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        let fetchedSectionsCount = self.fetchedResultsController.sections!.count
        
        return fetchedSectionsCount
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let fetchedRowsCount = self.fetchedResultsController.sections![section].numberOfObjects
        
        return fetchedRowsCount
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(EpisodeTableViewCell.reuseIdentifier(), forIndexPath: indexPath) as! EpisodeTableViewCell
        
        configureCell(cell, indexPath: indexPath)
        
        return cell;
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let name = self.fetchedResultsController.sections![section].name
        
        return "Season : \(name)"
    }
    
    //MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 60.0
    }
    
    //MARK: CDSTableViewFetchedResultsControllerDataDelegate
    
    func didUpdateItemAtIndexPath(indexPath: NSIndexPath) {
        
        self.configureCell(self.tableView!.cellForRowAtIndexPath(indexPath) as! EpisodeTableViewCell, indexPath: indexPath)
    }
    
    //MARK: CellSetup
    
    func configureCell(cell: EpisodeTableViewCell, indexPath: NSIndexPath) {
        
        let episode = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Episode
        
        cell.updateWithEpisode(episode)
    }
}