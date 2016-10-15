//
//  HomeAdapter.swift
//  TVShowsReminder
//
//  Created by Javier Laguna on 12/03/2016.
//
//

import Foundation

import SimpleTableView
import CoreDataServices

/**
 Methods from the adapter.
 */
protocol HomeAdapterDelegate {
    
    /**
     User pressed on the favorites button.
     
     - Parameter post: post cell is showing.
     */
    func didPressFavoritesButton(show: Show)
    
    /**
     User pressed on the comments button.
     
     - Parameter post: post cell is showing.
     */
    func didPressCommentsButton(show: Show)
    
    func didTapCellWithShow(show: Show)
}

/**
 Manages the tableview for the HomeViewController.
*/
class HomeAdapter: NSObject, UITableViewDataSource, UITableViewDelegate, STVDataRetrievalTableViewDelegate, ShowTableViewCellDelegate {
    
    /**
     Delegate of the HomeAdapterDelegate protocol.
     */
    var delegate: HomeAdapterDelegate?
    
    //MARK: Init
    
    override init() {
        
        super.init()
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
            
            self.tableView!.registerClass(ShowTableViewCell.self, forCellReuseIdentifier: ShowTableViewCell.reuseIdentifier())
        }
    }
    
    //MARK: FetchedResultsController
    
    /**
    Fetch request for retrieving shows.
    */
    lazy var fetchedResultsController: NSFetchedResultsController = {
        
        let _fetchedResultsController = NSFetchedResultsController.init(fetchRequest: self.fetchRequest, managedObjectContext: ServiceManager.sharedInstance.mainManagedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            
            try _fetchedResultsController.performFetch()
        }
        catch {
            
            let nserror = error as NSError
            
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return _fetchedResultsController
    }()
    
    /**
     Used to connect the TableView with Core Data.
     */
    lazy var fetchRequest: NSFetchRequest = {
        
        let _fetchRequest = NSFetchRequest.init()
        
        _fetchRequest.entity = NSEntityDescription.entityFor(Show.self,
                                                             managedObjectContext: ServiceManager.sharedInstance.mainManagedObjectContext)
        
      //  _fetchRequest.predicate = self.showsPredicate;
        _fetchRequest.sortDescriptors = self.sortDescriptorsForFetchRequest
        
        return _fetchRequest
    }()
    
    lazy var sortDescriptorsForFetchRequest: Array <NSSortDescriptor> = {
        
        var postIdSort : NSSortDescriptor = NSSortDescriptor.init(key: "name", ascending: true, selector: #selector(NSString.localizedStandardCompare))

        return [postIdSort];
    }()
    
    lazy var showsPredicate: NSPredicate = {
        
        return NSPredicate(format: "" , argumentArray: [])
    }()
    
    //MARK: HomeAdapterDelegate
    
    /**
    Requests and updates the content.
    */
    func refresh() {
        
        ShowAPIManager.retrieveShow("janethevirgin", success: nil, failure: nil)
        ShowAPIManager.retrieveShow("izombie", success: nil, failure: nil)
        ShowAPIManager.retrieveShow("gameofthrones", success: nil, failure: nil)
        ShowAPIManager.retrieveShow("greysanatomy", success: nil, failure: nil)
        ShowAPIManager.retrieveShow("newgirl", success: nil, failure: nil)
        ShowAPIManager.retrieveShow("mindyproject", success: nil, failure: nil)
        ShowAPIManager.retrieveShow("howtogetawaywithmurder", success: nil, failure: nil)
        ShowAPIManager.retrieveShow("walkingdead", success: nil, failure: nil)
        ShowAPIManager.retrieveShow("deviousmaids", success: nil, failure: nil)
        ShowAPIManager.retrieveShow("lastmanonearth", success: nil, failure: nil)
        ShowAPIManager.retrieveShow("youretheworst", success: nil, failure: nil)
        ShowAPIManager.retrieveShow("reign", success: nil, failure: nil)
        
        ShowAPIManager.retrieveShow("homeland", success: { [weak self] (result: AnyObject?) in
            
            let hasContent = self!.fetchedResultsController.fetchedObjects!.count > 0
            
            self!.tableView!.didRefreshWithContent(hasContent)
            self!.tableView!.reloadData()
            }, failure: { [weak self] (error: NSError?) in
                
                let hasContent = self!.fetchedResultsController.fetchedObjects!.count > 0
                
                self!.tableView!.didRefreshWithContent(hasContent)
            })
    }
    
    //MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let fetchedRowsCount = self.fetchedResultsController.fetchedObjects!.count
        
        return fetchedRowsCount
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(ShowTableViewCell.reuseIdentifier(), forIndexPath: indexPath) as! ShowTableViewCell
        
        cell.delegate = self
        
        self.configureCell(cell, indexPath: indexPath)
        
        return cell;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
        let show = self.fetchedResultsController.fetchedObjects![indexPath.row] as! Show
        
        delegate?.didTapCellWithShow(show)
    }
    
    //MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 60.0
    }
    
    //MARK: ShowTableViewCellDelegate
    
    func didPressCommentsButton(show: Show) {
        
        delegate!.didPressCommentsButton(show)
    }
    
    func didPressFavoritesButton(show: Show) {
        
        delegate!.didPressFavoritesButton(show)
    }
    
    //MARK: CDSTableViewFetchedResultsControllerDataDelegate
    
    func didUpdateItemAtIndexPath(indexPath: NSIndexPath) {
        
        configureCell(self.tableView!.cellForRowAtIndexPath(indexPath) as! ShowTableViewCell, indexPath: indexPath)
    }
    
    //MARK: CellSetup
    
    func configureCell(cell: ShowTableViewCell, indexPath: NSIndexPath) {
        
        let show = self.fetchedResultsController.fetchedObjects![indexPath.row] as! Show
        
        cell.updateWithShow(show)
    }
}
