//
//  MainTableViewController.swift
//  FaceIt
//
//  Created by Roder Hu on 2017/5/16.
//  Copyright © 2017年 Roder Hu. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {
    
    public struct Segues{
        static let FaceIt = "Show Face View"
        static let DropIt = "Show Drop It"
    }
    
    public struct Pages{
        static let FaceIt = "Show Face View"
        static let DropIt = "Show Drop It"
    }
    
    private let pages : [String] = [
        Pages.FaceIt,
        Pages.DropIt
    ]

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return pages.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Page Item", for: indexPath)

        cell.textLabel?.text = pages[indexPath.section]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Page Item", for: indexPath)
        
        if indexPath.section <= pages.count {
            
            let page = pages[indexPath.section]
            switch page{
                case Pages.FaceIt:
                    self.performSegue(withIdentifier: Segues.FaceIt, sender: cell)
                
                case Pages.DropIt: break
                
            default:
                cell.setSelected(false, animated: false)
                break

            }
        }
        
        
    }

}
