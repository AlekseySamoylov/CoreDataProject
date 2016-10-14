//
//  MainVC
//  CoreDataProject
//
//  Created by ALEKSEY SAMOYLOV on 10/7/16.
//  Copyright © 2016 ALEKSEY SAMOYLOV. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segment: UISegmentedControl!
    
    var controller: NSFetchedResultsController<Item>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
//        generateTestData()
        
//        ad.saveContext()

        attemptFetch()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
        return cell
    }
    
    func configureCell(cell: ItemCell, indexPath: NSIndexPath) {
        let item = controller.object(at: indexPath as IndexPath)
        cell.configureCell(item: item)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
        if let objects = controller.fetchedObjects, objects.count > 0 {
            let item = objects[indexPath.row]
            performSegue(withIdentifier: "ItemDetailsVC", sender: item)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(segue.identifier)
        if segue.identifier == "ItemDetailsVC" {
            if let destination = segue.destination as? ItemDetailsVC {
                if let item = sender as? Item {
                    destination.itemToEdit = item
                }
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = controller.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        } else {
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = controller.sections {
            return sections.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 150
    }
    
    func attemptFetch() {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        let dateSort = NSSortDescriptor(key: "created", ascending: false)
        let priceSort = NSSortDescriptor(key: "price", ascending: true)
        let titleSort = NSSortDescriptor(key: "title", ascending: true)
        
        if (segment.selectedSegmentIndex == 0) {
            
            fetchRequest.sortDescriptors = [dateSort]

        } else if (segment.selectedSegmentIndex == 1) {
            
            fetchRequest.sortDescriptors = [priceSort]

        } else if (segment.selectedSegmentIndex == 2) {
            
            fetchRequest.sortDescriptors = [titleSort]

        }
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        controller.delegate = self
        
        self.controller = controller
        do {
            
            try controller.performFetch()
            
        } catch {
            
            let error = error as NSError
            print("\(error)")
            
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        case.delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        case.update:
            if let indexPath = indexPath {
                let cell = tableView.cellForRow(at: indexPath) as! ItemCell
                configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
            }
            break
        case.move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        }
    }
    
    
    func generateTestData() {
        let item = Item(context: context)
        item.title = "MacBook Pro"
        item.price = 2200
        item.details = "I can't wait util the September event, I hope they release new MPBs"
        
        let item2 = Item(context: context)
        item2.title = "Play Station 4 Pro"
        item2.price = 500
        item2.details = "I want to play it now"
        
        let item3 = Item(context: context)
        item3.title = "Range Rover Voque"
        item3.price = 100000
        item3.details = "It is a beautiful car. And one day, I will own it"
        
        
    }
    
    
    @IBAction func changeSortType(_ sender: UISegmentedControl) {
        attemptFetch()
        tableView.reloadData()
    }
    
    
    
    
    
    
    
    
    
}

