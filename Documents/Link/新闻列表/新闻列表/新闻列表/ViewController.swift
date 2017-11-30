//
//  ViewController.swift
//  新闻列表
//
//  Created by 殷子欣 on 2017/4/7.
//  Copyright © 2017年 yinzixin. All rights reserved.
//

import UIKit

extension Collection where Indices.Iterator.Element == Index {
    subscript (safe index: Index) -> Generator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var newsTitle: [String] = []
    var newsTime: [String] = []
    var newsModels : [NewsModel] = []
    
    
    
    @IBOutlet weak var MyTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //创建字典
        let params: [String: Any] = [
            "begin": 0,
            "num": 10
        ]
        
        //请求路径的说明
        //https://link.xjtu.edu.cn/api/2.0/campusInfo/getNewsList/
        //设置地址
        let urlDirection: String = "https://link.xjtu.edu.cn/api/2.0/campusInfo/getNewsList/"
        
        //根据会话对象创建task
        let url: NSURL = NSURL(string: urlDirection)!
        
        //创建可变的请求对象
        let request: NSMutableURLRequest = NSMutableURLRequest(url: url as URL)
        
        //修改请求方法为POST
        request.httpMethod = "POST"
        let session = URLSession.shared
        
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            //let strData = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            //print("Body: \(String(describing: strData))")
            let jsonData = try? JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as! NSDictionary
        //    print(jsonData)
        if let data = jsonData!["data"] as? NSDictionary {
            if let newsList = data["news_list"] as? NSArray {
                for i in 0 ..< (newsList.count){
                    let newsDictionary = newsList[i] as! NSDictionary
                    self.newsTitle.append(newsDictionary["news_title"] as! String)
                    let timeString = newsDictionary["published_date"] as! String
                    self.newsTime.append(timeString.substring(from: timeString.index(timeString.startIndex, offsetBy: 5)))
                }
            }
        }
        self.MyTableView.reloadData()
        })
        
        task.resume()
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NewsTableViewCell
        cell.labelTime.text? = newsTime[indexPath.row]
        cell.labelTitle.text? = newsTitle[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsTitle.count
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}

