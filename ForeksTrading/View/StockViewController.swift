//
//  ViewController.swift
//  ForeksTrading
//
//  Created by x on 13.01.2023.
//

import UIKit

class StockViewController: UIViewController, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    var dataSource: UITableViewDiffableDataSource<Section, StockModel>!
    var indexPathsToHighlight: [IndexPath] = []
    
    private var stockListViewModel: StockListViewModel = StockListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark  
        
        //TableView Delegation
        self.tableView.delegate = self
        
        //Notification observing for updating data
        NotificationCenter.default.addObserver(self, selector: #selector(dataUpdated), name: .dataUpdated, object: nil)
        
        //Trigger initial request for getting Stock data
        stockListViewModel.getStockInitialData()
        
        //DiffableDataSource setup & Cell configuration
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { [self]
            tableView, indexPath, model -> UITableViewCell? in
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "StockCell", for: indexPath) as! StockTableViewCell
            let stockViewModel = self.stockListViewModel.stockAtIndex(indexPath.row)
            
            cell.name?.text = stockViewModel.stock.tke
            cell.lastUpdateTime?.text = stockViewModel.detail["clo"] as? String
            
            
            cell.columnOne?.text = (stockViewModel.detail[(stockListViewModel.firstSelection?.key)!] as? Double)?.description ?? "-"
            if stockListViewModel.firstSelection?.key == "pdd" {
                cell.columnOne.textColor = ((stockViewModel.detail["pdd"] as? Double)?.isLess(than: 0))! ? UIColor.red : UIColor.green
                cell.columnOne.text!.insert("%", at: cell.columnOne.text!.startIndex)
            } else {
                cell.columnOne.textColor = UIColor.white
            }
            
            
            cell.columnTwo?.text = (stockViewModel.detail[(stockListViewModel.secondSelection?.key)!] as? Double)?.description ?? "-"
            if stockListViewModel.secondSelection?.key == "pdd" {
                cell.columnTwo.textColor = ((stockViewModel.detail["pdd"] as? Double)?.isLess(than: 0))! ? UIColor.red : UIColor.green
                cell.columnTwo.text!.insert("%", at: cell.columnTwo.text!.startIndex)
            } else {
                cell.columnTwo.textColor = UIColor.white
            }
            
            cell.arrowImage.image = stockViewModel.detail["lasChanges"] as? Bool == true ? UIImage(systemName: "arrow.down") : UIImage(systemName: "arrow.up")
            cell.arrowImage.tintColor = stockViewModel.detail["lasChanges"] as? Bool == true ? UIColor.red : UIColor.green
      
            updateCell(at: indexPath)
            
            return cell
        })
    }
    
    //DiffableDataSource snopshot management
    func updateDataSource(){
        var snapshot = NSDiffableDataSourceSnapshot<Section, StockModel>()
        snapshot.appendSections([.stocksTBSection])
        snapshot.appendItems(stockListViewModel.stockList)
        dataSource.apply(snapshot, animatingDifferences: false, completion: nil)
        
        DispatchQueue.main.async {
            for indexPath in self.indexPathsToHighlight {
                if let cell = self.tableView.cellForRow(at: indexPath) {
                    cell.setSelected(true, animated: true)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        if let cell = self.tableView.cellForRow(at: indexPath) {
                            cell.setSelected(false, animated: true)
                        }
                    }
                }
            }
            self.indexPathsToHighlight.removeAll()
        }
    }
    
    func updateCell(at indexPath: IndexPath) {
        self.indexPathsToHighlight.append(indexPath)
    }
    
    @objc func dataUpdated() {
        self.updateDataSource()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // Create the header view
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
        headerView.backgroundColor = .black
        
        // Create the title label
        let titleLabel = UILabel()
        titleLabel.text = "Symbols"
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textAlignment = .left
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(titleLabel)
        
        var menuActionsLeft: [UIAction] = []
        var menuActionsRight: [UIAction] = []
        if let options = stockListViewModel.selectOptions {
            for option in options {
                menuActionsLeft.append(UIAction(title: option.name ?? "", handler: {_ in
                    self.stockListViewModel.firstSelection = Mypage(name: option.name, key: option.key)
                    self.tableView.reloadData()
                }))
                menuActionsRight.append(UIAction(title: option.name ?? "", handler: {_ in
                    self.stockListViewModel.secondSelection = Mypage(name: option.name, key: option.key)
                    self.tableView.reloadData()
                }))
            }
        }
        
        let rightButton = UIButton(configuration: UIButton.Configuration.gray(), primaryAction: nil)
        rightButton.menu = UIMenu(children:menuActionsRight.enumerated().map { (index, action) -> UIAction in
            if action.title == stockListViewModel.secondSelection?.name {
                action.state = .on
            }
            return action
        })
        rightButton.showsMenuAsPrimaryAction = true
        rightButton.changesSelectionAsPrimaryAction = true
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(rightButton)
        
        let leftButton = UIButton(configuration: UIButton.Configuration.gray(), primaryAction: nil)
        leftButton.menu = UIMenu(children:menuActionsLeft.enumerated().map { (index, action) -> UIAction in
            if action.title == stockListViewModel.firstSelection?.name {
                action.state = .on
            }
            return action
        })
        leftButton.showsMenuAsPrimaryAction = true
        leftButton.changesSelectionAsPrimaryAction = true
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(leftButton)
        
        // Add constraints to position the title label and pulldown buttons
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            titleLabel.widthAnchor.constraint(equalTo: headerView.widthAnchor, multiplier: 0.5),
            
            rightButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            rightButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            rightButton.widthAnchor.constraint(equalTo: headerView.widthAnchor, multiplier: 0.25),
            
            leftButton.trailingAnchor.constraint(equalTo: rightButton.leadingAnchor, constant: -8),
            leftButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            leftButton.widthAnchor.constraint(equalTo: headerView.widthAnchor, multiplier: 0.25),
        ])
        
        return headerView
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    enum Section {
        case stocksTBSection
    }
}
