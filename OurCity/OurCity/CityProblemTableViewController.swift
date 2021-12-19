//
//  ViewController.swift
//  OurCity
//
//  Created by user195143 on 12/17/21.
//

import UIKit
import CoreData

class CityProblemTableViewController: UITableViewController {

    var fetchedResultsController: NSFetchedResultsController<Problem>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadProblems()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cityProblemViewController = segue.destination as? CityProblemViewController,
           let indexPath = tableView.indexPathForSelectedRow {
            cityProblemViewController.problem = fetchedResultsController.object(at: indexPath)
        }
    }
    
    func loadProblems () {
        
        let fetchedRequest: NSFetchRequest<Problem> = Problem.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        
        fetchedRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchedRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CityProblemTableViewCell else {
            return UITableViewCell()
        }
        
        let cityProblem = fetchedResultsController.object(at: indexPath)
        cell.configureWith(problem: cityProblem)
        
        return cell
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let cityProblem = fetchedResultsController.object(at: indexPath)
            
            context.delete(cityProblem)
            
            try? context.save()
        }
    }
}

extension CityProblemTableViewController:  NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        tableView.reloadData()
    }
}
