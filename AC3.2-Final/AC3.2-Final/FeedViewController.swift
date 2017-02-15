//
//  FeedViewController.swift
//  AC3.2-Final
//
//  Created by Tong Lin on 2/15/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let ReuseIdentifierForCell = "FeedCellIdentifier"
    var posts: [Post] = []
    let databasePostReference = FIRDatabase.database().reference().child("posts")
    let storageReference = FIRStorage.storage().reference().child("images")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewHierarchy()
        configureConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
    }

    func fetchData(){
        databasePostReference.observe(.value, with: { (snapshot) in
            self.posts = []
            
            for child in snapshot.children{
                if let snap = child as? FIRDataSnapshot,
                    let valueDict = snap.value as? NSDictionary{
                    
                    if let post = Post(dict: valueDict, key: snap.key){
                        self.posts.append(post)
                    }
                }
            }
            self.feedTableView.reloadData()
        })
    }
    
    func setupViewHierarchy(){
        self.navigationItem.title = "Feed"
        self.edgesForExtendedLayout = UIRectEdge(rawValue: 0)
        
        feedTableView.rowHeight = UITableViewAutomaticDimension
        feedTableView.estimatedRowHeight = 200.0
        
        feedTableView.register(FeedTableViewCell.self, forCellReuseIdentifier: ReuseIdentifierForCell)
        self.view.addSubview(feedTableView)
    }
    
    func configureConstraints(){
        feedTableView.snp.makeConstraints { (view) in
            view.top.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    
    //MARK: - table view delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifierForCell, for: indexPath) as! FeedTableViewCell
        
        let post = posts[indexPath.row]
        cell.commentLabel.text = post.comment
        cell.mainImageView.image = nil
        self.storageReference.child(post.key).data(withMaxSize: 1 * 500 * 500) { (data, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            if let validData = data {
                print("got image")
                cell.mainImageView.image = UIImage(data: validData)
            }
            cell.layoutIfNeeded()
        }
        
        return cell
    }
    
    
    //MARK: - Lazy inits
    lazy var feedTableView: UITableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
}
