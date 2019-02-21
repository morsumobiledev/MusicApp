//
//  ViewController.swift
//  MusicList
//
//  Created by Morsu  sharat on 2/2/19.
//  Copyright © 2019 Morsu  Sharat. All rights reserved.
//

import UIKit

public extension UITableView {
    
    func registerCell<T>(a:T) {
        self.register(UINib(nibName: String(describing: T.self), bundle: nil), forCellReuseIdentifier: String(describing: T.self))
    }
}

public extension String {
    func toDate(format: String = "MM/dd/yyyy") -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let dateObj = dateFormatter.date(from: self)
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: dateObj ?? Date())
    }
}


class MusicListViewController: UIViewController {
    
    @IBOutlet weak var musicListHeader: UILabel!
    @IBOutlet weak var musicListTableView: UITableView!
    
    let activityView = UIActivityIndicatorView(style: .gray)
    
    lazy var musicInfoList = [MusicInfo]()
    var updatedDate: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.showLoadingView()
        self.registerCells()
        self.makeServiceCall()
    }
    
    func registerCells() {
        self.musicListTableView.registerCell(a: MusicInfoTableViewCell())
        self.musicListTableView.separatorStyle = .none
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            if let date = self.updatedDate {
                self.musicListHeader.text = "Apple New Music Releases for " + (date.toDate() ?? "")
            }
            self.musicListTableView.reloadData()
        }
    }
    
    func showLoadingView() {
        DispatchQueue.main.async {
            self.activityView.center = self.view.center
            self.activityView.startAnimating()
            self.view.addSubview(self.activityView)
        }
    }
    
    func hideLoadingView() {
        DispatchQueue.main.async {
            self.activityView.removeFromSuperview()
        }
    }
    
    func makeServiceCall() {
        NetworkManager.shared.callService(urlString: MUSIC_LIST_URL) { [weak self] (json, error) in
            self?.hideLoadingView()
            guard let json = json, let feed = json["feed"] as? [String: Any], let resultsArray = feed["results"] as? [[String: Any]] else {
                return
            }
            self?.updatedDate = (feed["updated"] as? String)?.components(separatedBy: "T").first
            
            for each in resultsArray {
                self?.musicInfoList.append(MusicInfo(musicInfoDict: each))
            }
            self?.reloadData()
        }
    }
    
}

extension MusicListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musicInfoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MusicInfoTableViewCell.self), for: indexPath) as? MusicInfoTableViewCell {
            cell.setUpUI(musicInfo: musicInfoList[indexPath.row])
            cell.selectionStyle = .none
            return cell
        }
        return MusicInfoTableViewCell()
    }
}

extension MusicListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}



