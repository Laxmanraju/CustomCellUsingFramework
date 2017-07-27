//
//  ViewController.swift
//  LBBVAAssignMent
//
//  Created by laxman penmetsa on 7/26/17.
//  Copyright © 2017 com.laxman. All rights reserved.
//

import UIKit
import  UniversalCustomCellFramework


class ViewController:UITableViewController {
    let CELL_IDENTIFIER =  "CellID"
    let dataModel  = LBBVADataModel()

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(CustomCell.self, forCellReuseIdentifier: CELL_IDENTIFIER)
        dataModel.delegate = self
        self.activityIndicator.startAnimating()
        dataModel.fetchDataFromServer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return (self.dataModel.cellModelArray?.count)!
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER, for: indexPath)  as! CustomCell
        if ((self.dataModel.cellModelArray?.count) == 0){
            return cell
        }else{
            if let dataForIndex = self.dataModel.cellModelArray?[indexPath.row]{
                guard let area = dataForIndex.area,
                let name = dataForIndex.name,
                let capital = dataForIndex.capital,
                let largestCity = dataForIndex.largestCity else {
                
                    return cell
                }
                
                cell.setAreaLabelText(area)
                cell.setNameLabelText(name)
                cell.setCapitalLabelText(capital)
                cell.setLargestCityLabelText(largestCity)

            }
        }
      return cell
    }
    
    override func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

}


extension ViewController: DataModelDelegate{
    
    func dataParsingCompleted()
    {
        if ((self.dataModel.cellModelArray?.count) != nil) {
            self.activityIndicator.stopAnimating()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}
