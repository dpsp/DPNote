//
//  NoteListViewController.swift
//  DPNote
//
//  Created by Peng Dong on 2018/8/28.
//  Copyright © 2018年 Peng Dong. All rights reserved.
//

import UIKit
import CoreData

import MJRefresh
import Toast

class NoteListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var list: [NyanNote] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        let footer = MJRefreshAutoNormalFooter()
        footer.isAutomaticallyRefresh = false
        footer.setRefreshingTarget(self, refreshingAction: #selector(load))
        tableView.mj_footer = footer

        DispatchQueue.global().async {
            self.load()
        }
    }
    
    @objc func load() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NyanNote")
        let sortDescriptor = NSSortDescriptor(key: "timestamp", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.fetchOffset = list.count
        fetchRequest.fetchLimit = 10
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: (DPPersistentContainer.instance.persistentContainer?.viewContext)!, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        DispatchQueue.main.async {
            do {
                try fetchedResultsController.performFetch()
                if let notes = fetchedResultsController.fetchedObjects as? [NyanNote] {
                    self.list.append(contentsOf: notes)
                    self.tableView.reloadData()
                    
                    if notes.count == 0 {
                        self.tableView.mj_footer.endRefreshingWithNoMoreData()
                    } else {
                        self.tableView.mj_footer.endRefreshing()
                    }
                }
            } catch {
                self.tableView.mj_footer.endRefreshing()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let note = sender as? NyanNote {
            if let vc = segue.destination as? NoteDetailViewController {
                vc.note = note
            }
        }
    }
    
    deinit {
        print("deinit \(self.classForCoder)")
    }
    
}

extension NoteListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let note = list[indexPath.row]
        cell.textLabel?.text = "\(indexPath.row) \(note.title ?? "")"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let note = list[indexPath.row]
        performSegue(withIdentifier: "segueToDetail", sender: note)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let note = list.remove(at: indexPath.row)
        
        do {
            if let name = note.photo {
                let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
                let imagePath = path.appendingPathComponent("\(name).jpg")
                try FileManager().removeItem(atPath: imagePath)
            }
        } catch {
            view.makeToast(error.localizedDescription)
        }
        
        if let context = DPPersistentContainer.instance.persistentContainer?.viewContext {
            context.delete(note)
            do {
                try context.save()
                
                view.makeToast("删除成功")
            } catch {
                view.makeToast(error.localizedDescription)
            }
        }
        
        tableView.reloadData()
    }
    
}

extension NoteListViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            return
        case .insert:
            return
        case .move:
            return
        case .update:
            return
        }
    }
    
}
