//
//  ItemView.swift
//  OnTheMap
//
//  Created by Mike Huffaker on 9/30/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import Foundation
import UIKit

// MARK: - FavoritesTableViewController: UITableViewController

class ItemViewController: UITableViewController {
    
    var common : Common!
    var parse : ParseClient!
    
    var appDelegate: AppDelegate!
    var students : [StudentInformation] = [StudentInformation]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        common = Common()
        common.debug( message: "ItemView::viewDidLoad()" )
        
        // Get shared instance of parse client class
        parse = ParseClient()

        // get the app delegate
        //appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // create and set logout button
        //navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .reply, target: self, action: #selector(logout))
        //let tempDictionary = StudentInformation.hardCodedLocationData()
        //students = StudentInformation.loadDictionaryFromResults(tempDictionary)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        common.debug( message: "ItemView::viewWillAppear()" )
        
        parse.loadStudentInformation()
        students = parse.students
       
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return students.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        common.debug( message: "ItemView::tableView():cellForRowAt" )
        
        // get cell type
        //let cellReuseIdentifier = "StudentTableViewCell"
        let cellID = "StudentCell"
        let cell:StudentCell = tableView.dequeueReusableCell( withIdentifier: cellID, for: indexPath ) as! StudentCell

        let student = students[(indexPath as NSIndexPath).row]
        
        cell.txtStudent.text = student.firstName + " " + student.lastName

        return cell
    }
    
}
