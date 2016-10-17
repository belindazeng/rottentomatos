//
//  DetailViewController.swift
//  RottenTomatos
//
//  Created by Eden on 10/11/16.
//  Copyright © 2016 CodePath. All rights reserved.
//

import UIKit


class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var infoView: UIView!
    
    @IBOutlet weak var watchTrailerButton: UIButton!
    var movie: NSDictionary!

    
    // review variables
    var reviews = [NSDictionary]()
    @IBOutlet weak var tableView: UITableView!
    
    let NUM_REVIEWS_TO_DISPLAY = 2
    
    // view animation related variables
    var animator:UIDynamicAnimator? = nil;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        let pageWidth = scrollView.bounds.width
        let pageHeight = scrollView.bounds.height

        
        scrollView.addSubview(tableView)
        
        scrollView.contentSize = CGSizeMake(pageWidth, 2*pageHeight)
        print(scrollView.contentSize.height)
        //
        print(movie)
        
        let title = movie["title"] as? String
        let overview = movie["overview"] as? String
        
        let vote_average = movie["vote_average"] as? Float
        
        
        if let poster_path = movie["poster_path"] as?String {
            let base_url = "https://image.tmdb.org/t/p/w500"
            let image_url = NSURL(string: base_url + poster_path)
            posterImageView.setImageWithURL(image_url!)

        }
        

        titleLabel.text = title
        overviewLabel.text = overview
        overviewLabel.sizeToFit()
        self.title = title
        // Do any additional setup after loading the view.
        if let movie_id = movie["id"] as? Int {
            getReviewData(String(movie_id))
        }
    }
    
    // page view controller functions

    // 
    
    
    // tableview for review data
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if reviews.count < NUM_REVIEWS_TO_DISPLAY {
            return reviews.count
        }
        return NUM_REVIEWS_TO_DISPLAY
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("review", forIndexPath: indexPath) as! ReviewCell
        // cell.contentLabel.text = String(indexPath.row)
        let review = reviews[indexPath.row]
        if let review_description = review["content"] as? String{
            cell.contentLabel.text = review_description
        }
        if let author = review["author"] as? String{
            cell.authorLabel.text = author
        }
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Reviews"
    }
    
    // review data
    func getReviewData(movie_id: String) -> (){
        let apiKey = "854bdffe3899c7cf64da5b4a1dd85ae7"
        let url = NSURL(string:"https://api.themoviedb.org/3/movie/\(movie_id)/reviews?api_key=\(apiKey)&language=en-US")
    
        getData(url!)
//        
//        handleReviewData()
    }
    
    func handleReviewData() {
        
    }
    
    func populateReviewData() {
        
    }
    func getData(url: NSURL){
        
        // ... Create the NSURLRequest (myRequest) ...
        let request = NSURLRequest(URL: url)
        
        // Configure session so that completion handler is executed on main UI thread
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) in
            
            // ... Remainder of response handling code ...
            if let data = data {
                
                if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSDictionary {
                    
                    self.reviews = responseDictionary["results"] as![NSDictionary]
                    self.tableView.reloadData()
                }
            }
            
        });
        task.resume()
        
        
    }

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // snap the alert to middle of screen
        animator = UIDynamicAnimator(referenceView:self.view);
        // snap movie details to correct position
        let x = view.frame.size.width / 2
        let y = view.frame.size.height - infoView.frame.size.height/2
        let point = CGPoint(x: x, y: y)
        snapToPoint(point, view: infoView)
    
    }

    
    func snapToPoint(point: CGPoint, view: UIView) {
        let snap = UISnapBehavior(item: view, snapToPoint: point)
        animator?.addBehavior(snap);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.

    }
    
    // watch trailer
    
    @IBAction func watchTrailerButton(sender: AnyObject) {
        let url = NSURL(string:"https://www.youtube.com/watch?v=B9yV4YeEmNA")
        UIApplication.sharedApplication().openURL(url!)
    }
    

}
