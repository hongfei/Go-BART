//
// Created by Zhou, Hongfei on 10/30/18.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import UIKit
import PinLayout

class AdvisoryViewController: UITableViewController {
    var advisories: [Advisory] = []

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        self.tabBarItem = UITabBarItem(tabBarSystemItem: .more, tag: 2)
        self.view.backgroundColor = .white
        self.title = "More"
        self.navigationItem.rightBarButtonItem?.tintColor = .white
        self.tableView.tableFooterView = UIView(frame: .zero)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(AdvisoryCell.self, forCellReuseIdentifier: "AdvisoryCell")
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(refreshTable), for: .valueChanged)

        self.refreshTable()
    }

    @IBAction func refreshTable() {
        AdvisoryService.getLatestAdvisories { advisories in
            self.advisories = advisories
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let advisoryCell = tableView.dequeueReusableCell(withIdentifier: "AdvisoryCell", for: indexPath) as? AdvisoryCell {
            advisoryCell.loadViewData(advisory: advisories[indexPath.row])
            return advisoryCell
        }
        return UITableViewCell()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return advisories.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightForAdvisoryCell(text: advisories[indexPath.row].description.cdData) + CGFloat(50)
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Advisory"
        default: return ""
        }
    }

    func heightForAdvisoryCell(text: String) -> CGFloat {
        let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 40, height: .greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.text = text
        label.sizeToFit()
        return label.frame.height
    }
}
