//
// Created by Hongfei on 2018/8/5.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import UIKit


class StationPickerViewController: UITableViewController {
    // elements
    var safeArea: UILayoutGuide!
    var barTitle: String?

    // data
    var stations: [Station]?

    // inner controls
    var selectedHandler: ((Station) -> Void)?

    override var navigationItem: UINavigationItem {
        let navigationItem = UINavigationItem(title: barTitle!)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(closeStationPicker))
        return navigationItem
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.purple
        self.tableView?.register(StationTableCell.self, forCellReuseIdentifier: "StationCollectionCell")
        if self.stations == nil {
            BartStationService.getAllStations() { stations in
                self.stations = stations
                self.tableView?.reloadData()
            }
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let stationCell = tableView.dequeueReusableCell(withIdentifier: "StationCollectionCell", for: indexPath) as? StationTableCell
        stationCell?.setStation(station: (self.stations?[indexPath.row])!)

        return stationCell!
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.stations {
        case .some(let stns):
            return stns.count
        case .none:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedStation = (self.stations?[indexPath.row])!
        if let handler = self.selectedHandler {
            handler(selectedStation)
        }
        self.selectedHandler = nil
        self.dismiss(animated: true)
    }

    @objc func closeStationPicker() {
        self.selectedHandler = nil
        self.dismiss(animated: true)
    }

    func withBarTitle(of title: String?) -> StationPickerViewController {
        self.barTitle = title
        return self
    }

    func onStationSelected(selectedHandler: @escaping (Station) -> Void) -> StationPickerViewController {
        self.selectedHandler = selectedHandler
        return self
    }
}
