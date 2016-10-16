//
//  MoviesViewController.swift
//  Flicks
//
//  Created by Phương Nguyễn on 10/11/16.
//  Copyright © 2016 Phương Nguyễn. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController,UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    //@IBOutlet weak var searchBar: UISearchBar!
    var movies = [NSDictionary]()
    let baseUrl = "https://image.tmdb.org/t/p/w342"
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = UIColor.white
        refreshControl.addTarget(self, action: #selector(MoviesViewController.loadMovies), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)
        loadMovies()

        // Do any additional setup after loading the view.
    }
    func loadMovies() {
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let request = URLRequest(
            url: url!,
            cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate: nil,
            delegateQueue: OperationQueue.main
        )
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let task: URLSessionDataTask =
            session.dataTask(with: request,
                             completionHandler: { (dataOrNil, response, error) in
                                MBProgressHUD.hide(for: self.view, animated: true)
                                if response == nil {
                                    self.showAlert(alert: "Network Error")
                                }
                                if let data = dataOrNil {
                                    if let responseDictionary = try! JSONSerialization.jsonObject(
                                        with: data, options:[]) as? NSDictionary {
                                        //print("response: \(responseDictionary)")
                                        self.movies = responseDictionary["results"] as! [NSDictionary]
                                        //print(self.movies)
                                            self.tableView.reloadData()
                                    }
                                }
    
                                if error != nil{
                                    self.showAlert(alert: "Something wrong with data")
                                }
                                self.refreshControl.endRefreshing()
            })
        task.resume()
    }
    /*func filterMovie(title: String){
        let count = movies.count
        for countMovie in 1...count {
            let titleMovie = movies[countMovie]["title"] as! String
            if title == titleMovie {
                self.movies = [movies[countMovie]]
                self.tableView.reloadData()
                break
            } else {
                self.tableView.reloadData()
            }
        }
        
    }*/
    
    func showAlert(alert: String){
        let alertController = UIAlertController(title: "Message", message: alert, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default , handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = UITableViewCell()
        //cell.textLabel?.text = movies[indexPath.row]["title"] as? String//String(indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell") as! MovieCell
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red: 235/250, green: 229/250, blue: 77/250, alpha: 1) //UIColor(red: 217/250, green: 254/250, blue: 186/250, alpha: 1)
        cell.selectedBackgroundView = backgroundView
        cell.titleLabel.text = movies[indexPath.row]["title"] as? String
        cell.overviewLabel.text = movies[indexPath.row]["overview"] as? String
        if let posterPath = movies[indexPath.row]["poster_path"] as? String {
            let posterUrl = baseUrl + posterPath
            fadeImage(imageView: cell.posterView, imageUrl: posterUrl)
            //cell.posterView.setImageWith(URL(string: posterUrl)!)
        } else {
            cell.posterView.image = nil
        }
        return cell
    }
    
    public func fadeImage(imageView: UIImageView,imageUrl: String){
        let imageRequest = URLRequest(url: URL(string: imageUrl)!)
        imageView.setImageWith(
        imageRequest,
        placeholderImage: nil,
        success: { (imageRequest, imageResponse, image) -> Void in
                
            // imageResponse will be nil if the image is cached
            if imageResponse != nil {
                imageView.alpha = 0.0
                imageView.image = image
                UIView.animate(withDuration: 0.3, animations: { () -> Void in
                    imageView.alpha = 1.0
                    })
            } else {
                imageView.image = image
            }
        },
        failure: { (imageRequest, imageResponse, error) -> Void in
                self.showAlert(alert: "Can't load image")
        })
    }
    /*func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        print("hello")
        let searchMovie = searchBar.text
        if searchMovie != nil && searchMovie != ""{
            filterMovie(title:searchMovie!)
        } else {
            self.tableView.reloadData()
        }

    }// called when text starts editing*/
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let nextVC = segue.destination as! DetailViewController
        let ip = tableView.indexPathForSelectedRow
        nextVC.overview = movies[(ip?.row)!]["overview"] as? String
        nextVC.titleMovie = movies[(ip?.row)!]["title"] as? String
        if let posterMoviePath = movies[(ip?.row)!]["poster_path"] as? String {
            nextVC.posterMovieUrl = baseUrl + posterMoviePath
        } else {
            nextVC.posterMovieUrl = ""
        }
        
    }
    

}
