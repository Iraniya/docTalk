//
//  ViewController.swift
//  learnRxSwift
//
//  Created by Shilpy Samaddar on 07/01/18.
//  Copyright © 2018 iraniya. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SDWebImage

class ViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    private let bag = DisposeBag()
    private let users = Variable<[User]>([])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindUI()
    }
    
    func bindUI() {
        // observe text, form request, bind table view to result
        searchBar.rx.text
            .orEmpty
            .debounce(0.5, scheduler: MainScheduler.instance)
            .map { query in
                let apiUrl = URLComponents(string: "https://api.github.com/search/users?q=\(query)&sort=followers")!
                return URLRequest(url: apiUrl.url!)
            }
            .flatMapLatest { request in
                return URLSession.shared.rx.json(request: request)
                    .catchErrorJustReturn([])
            }
            .map { json -> [User] in
                guard let json = json as? [String: Any],
                let items = json["items"] as? [[String:Any]]  else {
                        return []
                }
                return items.flatMap(User.init)
            }
            .bind(to: tableView.rx.items) { tableView, row, user in
                let cell:customCell = self.tableView.dequeueReusableCell(withIdentifier: "Cell") as! customCell
                cell.id.text = user.login
                cell.name.text = user.url
                let userImageURL = URL(string: user.avatar_url)!
                cell.photo.sd_setImage(with: userImageURL);
                return cell
            }
            .disposed(by: bag)
    }

}
