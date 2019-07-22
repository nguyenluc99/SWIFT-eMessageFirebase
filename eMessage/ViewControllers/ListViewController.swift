//
//  ListViewController.swift
//  eMessage
//
//  Created by HoaPQ on 7/22/19.
//  Copyright © 2019 HoaPQ. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let cellID = "UserCell"
    
    var userRef: DatabaseReference!
    var ref: DatabaseReference!
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationItem.title = "Users"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(onLogout))
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        
        loadData()
    }
    
    func loadData() {

    }
    
    @objc func onLogout() {

    }

}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        cell.textLabel?.text = "Hello"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Tapped item \(indexPath.row)")
    }
}
