//
//  WeatherTVC.swift
//  WeatherApp
//
//  Created by Mohd Zulhilmi Mohd Zain on 28/12/2017.
//  Copyright © 2017 MZMZ. All rights reserved.
//

import UIKit
import RestEssentials

class WeatherTVC: UITableViewController {
    
    struct HttpBinResponse: Codable {
        let query: Query
    }

    struct Query: Codable {
        let results: Results
    }
    
    struct Results: Codable {
        let channel: Channel
    }
    
    struct Channel: Codable {
        let location: Location
        let item: Item
    }
    
    struct Location: Codable {
        let city: String
        let country: String
        let region: String
    }
    
    struct Item: Codable {
        let condition: Condition
        let forecast: [Forecast]
    }
    
    struct Condition: Codable {
        let date: String
        let temp: String
        let text: String
    }
    
    struct Forecast: Codable {
        let date: String
        let low: String
        let high: String
        let text: String
    }
    
    var dataAcquired: NSDictionary = [:]
    var dataRefreshed: Bool = false
    
    //var getDbase: Database
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 130.0
        
        self.settingUpNavBar()
        self.getData()
        
    }
    
    func settingUpNavBar() {
        
        self.navigationController?.navigationBar.barTintColor = UIColor.init(red: 255.0/255.0, green: 81.0/255.0, blue: 81.0/255.0, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationItem.title = "Loading city..."
        
    }
    
    func getData() {
        
        let urlString: String = "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20weather.forecast%20where%20woeid%20in%20(select%20woeid%20from%20geo.places(1)%20where%20text%3D%22singapore%2C%20sg%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys"
        guard let restApi: RestController = RestController.make(urlString: urlString) else {
            print("Failed to retrieve URL")
            return
        }
        restApi.get(HttpBinResponse.self, callback: { result, HTTPResponse in
        do {
            
            let response = try result.value()
            
            self.dataAcquired = ["CITY":response.query.results.channel.location.city, "COUNTRY":response.query.results.channel.location.country, "COND_DICT":response.query.results.channel.item.condition, "FORE_ARRAY":response.query.results.channel.item.forecast]
            
            self.dataRefreshed = true
            
            DispatchQueue.main.async {
                self.navigationItem.title = String.init(format: "%@, %@", self.dataAcquired.value(forKey: "CITY") as! String, self.dataAcquired.value(forKey: "COUNTRY") as! String)
                self.tableView.reloadData()
            }
            
            
        }
        catch {
            print("error occured: \(error)")
        }
            
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if(self.dataRefreshed == false) { return 1 }
        else { return 2 }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if(self.dataRefreshed == false) { return 1 }
        else {
            if(section == 0) {
                return 1
            } else {
                return (self.dataAcquired.value(forKey: "FORE_ARRAY") as! [Forecast]).count
            }
            
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(self.dataRefreshed == false) {
            
            tableView.separatorStyle = UITableViewCellSeparatorStyle.none
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "LoadingCellID")
            
            return cell!
        }
        else {
            
            tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
            
            if(indexPath.section == 0) {
                let cell: WeatherTVCell = tableView.dequeueReusableCell(withIdentifier: "BigTitleCellID") as! WeatherTVCell
            
                // Configure the cell...
                let exactCondition: Condition? = self.dataAcquired.value(forKey: "COND_DICT") as? Condition
                cell.updateMain(data: exactCondition!)
            
                return cell
            }
            else {
            
                let cell: WeatherTVCell = tableView.dequeueReusableCell(withIdentifier: "SubTitleCellID") as! WeatherTVCell

                // Configure the cell...
                let exactForecast: Forecast? = (self.dataAcquired.value(forKey: "FORE_ARRAY") as! [Forecast])[indexPath.row]
                cell.updateSub(data: exactForecast!)

                return cell
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.section == 0) {
            return 130.0
        }
        else {
            return UITableViewAutomaticDimension
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
