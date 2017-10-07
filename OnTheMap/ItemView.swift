//
//  ItemView.swift
//  OnTheMap
//
//  Created by Mike Huffaker on 9/30/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import Foundation
import UIKit

class ItemViewController: UITableViewController {
    
    var common : Common!
    //var navigationBar : UINavigationBar!
    var parse = ParseClient.sharedInstance()
    
    var appDelegate: AppDelegate!
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
        
        //let navigationBar =         // create and set logout button
        //navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .reply, target: self, action: #selector(logout))
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        common.debug( message: "ItemView::viewWillAppear()" )
        
        refreshTable()
    }
    
    func refreshTable()
    {
        students = parse.students
        
        self.tableView.reloadData()
    }
    
    @IBAction func logout(_ sender: Any)
    {
        common.debug( message: "ItemView::logout()" )
        let loginVC = self.presentingViewController as! LoginView
        loginVC.resetUI()
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
