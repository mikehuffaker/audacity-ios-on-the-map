//
//  ItemView.swift
//  OnTheMap
//
//  Created by Mike Huffaker on 9/30/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import Foundation
import UIKit

class ItemViewController: UITableViewController
{   
    // Classes
    var common : Common!
    var parse = ParseClient.sharedInstance()
    
    // Variables
    var students : [StudentInformation] = [StudentInformation]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        common = Common()
        common.debug( message: "ItemView::viewDidLoad()" )
        
        // Get shared instance of parse client class and initiate load of student data if needed
        // the map view should already have loaded it, but adding this in case later the app
        // needs to go straight to the table view.
        if parse.students.isEmpty
        {
            parse.loadStudentInformation()
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear( animated )
        common.debug( message: "ItemView::viewWillAppear()" )
        refreshTable()
    }
    
    func refreshTable()
    {
        common.debug( message: "ItemView::refreshTable()" )
        students = parse.students
        self.tableView.reloadData()
    }
    
    // Logout pressed - go back to login view and have it complete the logout
    @IBAction func logout(_ sender: Any)
    {
        common.debug( message: "ItemView::logout()" )
        let loginVC = self.presentingViewController as! LoginView
        loginVC.initiateLogout()
        dismiss( animated: true, completion: nil )
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
