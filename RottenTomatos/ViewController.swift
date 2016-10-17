//
//  ViewController.swift
//  RottenTomatos
//
//  Created by Eden on 10/11/16.
//  Copyright © 2016 CodePath. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var movies: [NSDictionary]?
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // hide the error view
        
        getData()
        
    }
    
    // refresh button
    @IBAction func refreshData(sender: AnyObject) {
        getData()
    }
    
    func getData() {
        // make sure error view isn't hidden
        errorView.hidden = true
        
        // Display HUD right before the request is made
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        // ... Create the NSURLRequest (myRequest) ...
        let apiKey = "854bdffe3899c7cf64da5b4a1dd85ae7"
        let url = NSURL(string:"https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)&language=en-US")
        let request = NSURLRequest(URL: url!)
        
        // Configure session so that completion handler is executed on main UI thread
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) in
                                                                        
            // Hide HUD once the network request comes back (must be done on main UI thread)
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            
            // ... Remainder of response handling code ...
            if let data = data {
                if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSDictionary {
                    self.movies = responseDictionary["results"] as![NSDictionary]
                    // remember to reload the data
                    self.tableView.reloadData()
                }
            }
            else {
                print("getting here")
                self.errorView.hidden = false
                
                // Hide HUD once the network request comes back (must be done on main UI thread)
                MBProgressHUD.hideHUDForView(self.view, animated: true)
            }
            
                                                                        
        });
        task.resume()
        
        
    }
    
    
    // get data, also should refresh hopefully
    func getData2() {
        // make calls
        let apiKey = "854bdffe3899c7cf64da5b4a1dd85ae7"
        let url = NSURL(string:"https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)&language=en-US")
        let request = NSURLRequest(URL: url!)
        // toast test example
        
        let queue:NSOperationQueue = NSOperationQueue()
        
        // Display HUD right before the request is made
//        MBProgressHUD.showHUDAddedTo(self.view, animated: true)

        
        NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler:{ (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
            
            do {
                if data != nil {
                    if let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
                        
                        self.movies = jsonResult["results"] as![NSDictionary]
                        // remember to reload the data
                        self.tableView.reloadData()
                        // Hide HUD once the network request comes back (must be done on main UI thread)
                        
                    } }
                else {
                    print("getting here which is what we want")
                    self.errorView.hidden = false
                    // Hide HUD once the network request comes back (must be done on main UI thread)
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                }
                
            } catch let error as NSError {
                print(error.localizedDescription)
                
            }
            
            
        })
        MBProgressHUD.hideHUDForView(self.view, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        if let movies = movies {
            return movies.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("movies", forIndexPath: indexPath) as! MovieCell
        
        let movie = movies![indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        let base_url = "https://image.tmdb.org/t/p/w500"
        if let poster_path = movie["poster_path"] as?String {
            let image_url = NSURL(string: base_url + poster_path)
            cell.posterImageView.setImageWithURL(image_url!)
        }
        
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        print("prepare for segue called")
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPathForCell(cell)
        let movie = movies![indexPath!.row]
        let detailViewController = segue.destinationViewController as! DetailViewController
        
        detailViewController.movie = movie
    }
    

}

