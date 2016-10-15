//
//  COperation.swift
//  TVShowsReminder
//
//  Created by Javier Laguna on 15/03/2016.
//
//

import Foundation

/**
 Success closure type.
 */
typealias OperationOnSuccessCallback =  AnyObject? -> Void

/**
 Completion closure type.
 */
typealias OperationOnCompletionCallback =  AnyObject? -> Void

/**
 Failure closure type.
 */
typealias OperationOnFailureCallback =  NSError? -> Void

class Operation:  NSOperation {
    
    /**
     Identifies the operation.
     */
    var identifier: String?
    
    /**
     Current progress of the operation.
     */
    var progress: NSProgress?
    
    /**
     Is the Operation prepared to execute.
     */
    override var ready : Bool {
        
        get {
            
            return _ready
        }
        set {
            
            willChangeValueForKey("isReady")
            _ready = newValue
            didChangeValueForKey("isReady")
        }
    }
    
    private var _ready : Bool = true
    
    /**
     Is the operation running.
     */
    override var executing : Bool {
        
        get {
            
            return _executing
        }
        set {
            
            willChangeValueForKey("isExecuting")
            _executing = newValue
            didChangeValueForKey("isExecuting")
        }
    }
    
    private var _executing : Bool = false
    
    /**
    YES - The operation has executed.
    */
    override var finished : Bool {
        
        get {
            
            return _finished
        }
        set {
            
            willChangeValueForKey("isFinished")
            _finished = newValue
            didChangeValueForKey("isFinished")
        }
    }
    
    private var _finished : Bool = false
    
    /**
     Return value for the operation.
     */
    var result: AnyObject?
    
    /**
     Error occurred during execution.
     */
    var error: NSError?
    
    /**
     Queue for callbacks.
     */
    var callbackQueue: NSOperationQueue?
    
    /**
     Identifies the scheduler for the operation.
     */
    var targetSchedulerIdentifier: String?
    
    /**
     Callback called when the operation completes successfully.
     */
    var onSuccess: OperationOnSuccessCallback?
    
    /**
     Callback called when the operation completes with an error.
     */
    var onFailure: OperationOnFailureCallback?
    
    /**
     Callback called when the operation completes.
     
     The completion closure is used instead of the success/failure closures not alongside.
     */
    var onCompletion: OperationOnCompletionCallback?
    
    //MARK: Init
    
    required override init() {
        
        self.progress = NSProgress(totalUnitCount: -1)
        self.callbackQueue = NSOperationQueue.currentQueue()
        
        super.init()
        
        self.ready = true
    }
    
    //MARK: Name
    
    override var name : String? {
        
        get {
            return self.identifier
        }
        set {
            
            willChangeValueForKey("name")
            self.identifier = newValue
            didChangeValueForKey("name")
        }
    }
    
    //MARK: State
    
    override var asynchronous: Bool {
        
        return true
    }
    
    //MARK: Coalescing
    
    /**
    This method figures out if we can coalesce with another operation.
    
    @param operation - Operation to determaine if we can coalesce with.
    
    @return YES if we can coaslesce with it, NO if not.
    */
    func canCoalesceWithOperation(operation: Operation) -> Bool {
        
        return self.identifier == operation.identifier
    }
    
    /**
     This method coalesces another operation with this one, so that it
     is all performed in one operation.
     
     Perform any logic here to merge the actions together.
     
     @param operation - Operation to coalesce with.
     */
    func coalesceWithOperation(operation: Operation) {
        
        // Success coalescing
        let mySuccess = self.onSuccess
        let theirSuccess = operation.onSuccess
        
        if mySuccess != nil ||
            theirSuccess != nil {
            
            self.onSuccess = { result in
                
                mySuccess?(result)
                
                theirSuccess?(result)
            }
        }
        
        // Failure coalescing
        
        let myFailure = self.onFailure
        let theirFailure = operation.onFailure
        
        if myFailure != nil ||
            theirFailure != nil {
            
            self.onFailure = { error in
                
                myFailure?(error)
                
                theirFailure?(error)
            }
        }
        
        // Completion coalescing
        let myCompletion = self.onCompletion
        let theirCompletion = operation.onCompletion
        
        if myCompletion != nil ||
            theirCompletion != nil {
            
            self.onCompletion = { result in
                
                myCompletion?(result)
                
                theirCompletion?(result)
            }
        }
        
        /**
        We replace the other operation's progress object,
        so that anyone listening to that one, actually gets the
        progress of this operation which is doing the real work. */
        operation.progress = self.progress
    }
    
    //MARK: Control
    
    override func start() {
        
        if !self.executing {
            
            super.start()
            
            self.ready = false
            self.executing = true
            self.finished = false
            
            DLog("\(self.name!) Operation Started.");
        }
    }
    
    /**
     Finishes the execution of the operation.
     */
    func finish() {
        
        if self.executing {
            
            DLog("\(self.name!) Operation Finished.")
            
            self.executing = false
            self.finished = true
        }
    }
    
    //MARK: Callbacks
    
    /**
    Finishes the execution of the operation and calls the onSuccess callback.
    */
    func didSucceedWithResult(result: AnyObject?) {
        
        self.result = result
        
        self.finish()
        
        if self.onSuccess != nil {
            
            self.callbackQueue!.addOperationWithBlock({
                
                self.onSuccess!(result)
            })
        }
    }
    
    /**
     Finishes the execution of the operation and calls the onFailure callback.
     */
    func didFailWithError(error: NSError?) {
        
        self.error = error
        
        self.finish()
        
        if self.onFailure != nil {
            
            self.callbackQueue!.addOperationWithBlock({
                
                self.onFailure!(error)
            })
        }
    }
    
    /**
     Finishes the execution of the operation and calls the onCompletion callback.
     */
    func didCompleteWithResult(result: AnyObject?) {
        
        self.result = result
        
        self.finish()
        
        if self.onCompletion != nil {
            
            self.callbackQueue!.addOperationWithBlock({
                
                self.onCompletion!(result)
            })
        }
    }
}
