//
//  WeatherTVCell.swift
//  WeatherApp
//
//  Created by Mohd Zulhilmi Mohd Zain on 28/12/2017.
//  Copyright © 2017 MZMZ. All rights reserved.
//

import UIKit

class WeatherTVCell: UITableViewCell {
    
    @IBOutlet weak var uilWTVCTimeDate: UILabel!
    @IBOutlet weak var uilWTVCTemp: UILabel!
    @IBOutlet weak var uilTVCWeatherStat: UILabel!
    
    @IBOutlet weak var uilWTVCSubTimeDate: UILabel!
    @IBOutlet weak var uilWTVCSubTemp: UILabel!
    @IBOutlet weak var uilWTVCSubWeatherStat: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateMain(data: WeatherTVC.Condition) {
        uilWTVCTimeDate.text = data.date
        uilWTVCTemp.text = data.temp
        uilTVCWeatherStat.text = data.text
    }
    
    func updateSub(data: WeatherTVC.Forecast) {
        uilWTVCSubTimeDate.text = data.date
        uilWTVCSubTemp.text = String.init(format: "%@ - %@", data.high, data.low)
        uilWTVCSubWeatherStat.text = data.text
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
