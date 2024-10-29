import UIKit
import RxCocoa
import RxSwift


class HomeViewController: ViewController<HomeViewModel> {

    @IBOutlet weak var usersTableView: UITableView!
    private let refreshControl = UIRefreshControl()

    static func create(with viewModel: HomeViewModel) -> HomeViewController {
        let vc =  HomeViewController(vm: viewModel)
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        vm.getUserList()
    }
    
    override func setup() {
        usersTableView.dataSource = self
        usersTableView.delegate = self
        usersTableView.register(cell: UserTableViewCell.self)
        self.usersTableView.addSubview(refreshControl)
        self.refreshControl.addTarget(self, action: #selector(updateData), for: .valueChanged)
    }
    
    override func setupRx() {
        vm.data.skip(1).subscribe(with: self) { vc, users in
            DispatchQueue.main.async {
                vc.usersTableView.reloadData()
                vc.refreshControl.endRefreshing()
            }
            
        }.disposed(by: disposeBag)
    }
    
    @IBAction func onLogoutButtonPressed(_ sender: Any) {
        vm.logout()
    }
}

extension HomeViewController {
    @objc func updateData() {
        vm.getUserList()
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        vm.data.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.identifier, for: indexPath) as? UserTableViewCell else {
            return .init()
        }
        cell.setData(user: vm.data.value[indexPath.row])
        if indexPath.row == vm.data.value.count - 1 {
            vm.loadMoreUser()
        }
        return cell
    }
}
