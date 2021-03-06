//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Vedik Munukutla on 3/5/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    var tweetsArray = [NSDictionary]()
    var numberofTweets: Int!
    let myRefreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadTweet()
        myRefreshControl.addTarget(self, action:#selector(loadTweet), for: .valueChanged)
        tableView.refreshControl = myRefreshControl

    }
    
    @objc func loadTweet(){
        
        
        
        numberofTweets = 20
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myParams = ["count": numberofTweets]
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myParams, success: { (tweets:[NSDictionary]) in
            self.tweetsArray.removeAll()
            for tweet in tweets{
                self.tweetsArray.append(tweet)
            }
            
            self.tableView.reloadData()
            self.myRefreshControl.endRefreshing()
            
        }, failure: { (Error) in
            print("could not retrieve tweets!")
        })
    }
    
    func loadMoreTweets(){
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        numberofTweets = numberofTweets + 20
        let myParams = ["count": numberofTweets]
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myParams, success: { (tweets:[NSDictionary]) in
            self.tweetsArray.removeAll()
            for tweet in tweets{
                self.tweetsArray.append(tweet)
            }
            
            self.tableView.reloadData()
            
        }, failure: { (Error) in
            print("could not retrieve tweets!")
        })
    }
    
    override func tableView(_ tableView:UITableView,willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        if indexPath.row + 1 == tweetsArray.count {
            loadMoreTweets()
        }
    }
    
    
    
    
    
    
    
    

    @IBAction func onLogout(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        self.dismiss(animated: true, completion: nil)
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCell
        
        let user = tweetsArray[indexPath.row]["user"] as! NSDictionary
        cell.userNameLabel.text = user["name"] as! String
        cell.tweetContent.text = tweetsArray[indexPath.row]["text"] as! String
        let imageUrl = URL(string: (user["profile_image_url_https"] as? String)!)
        let data = try? Data(contentsOf: imageUrl!)
        
        if let imageData = data{
            cell.profileImageView.image = UIImage(data: imageData)
        }
        
        return cell
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetsArray.count
    }

    

}
