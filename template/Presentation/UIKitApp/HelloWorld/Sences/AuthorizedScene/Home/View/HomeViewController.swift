import UIKit
import RxCocoa

struct ImageThumbHash {
    let url: String
    let thumbHash: String
}


class HomeViewController: ViewController<HomeViewModel> {

    let data: [ImageThumbHash] = [
        .init(url: "https://picsum.photos/id/102/300/400", thumbHash: "6kkONQiJiH+Il3iYd3O4WXh/c3cH"),
        .init(url: "https://picsum.photos/id/103/300/400", thumbHash: "H/gJPQhJl3+JJoeHd4SHuGdwgwY4"),
        .init(url: "https://picsum.photos/id/104/300/400", thumbHash: "NAkGDQCBpnBaV5umdomGVpVQ2Agg"),
        .init(url: "https://picsum.photos/id/106/300/400", thumbHash: "Z+cJFQSBaX+aqGuWRoh4d4p30HcG"),
        .init(url: "https://picsum.photos/id/107/300/400", thumbHash: "o/gVFQJ3h3+Il3iXh4d4d2h0cPeX"),
        .init(url: "https://picsum.photos/id/108/300/400", thumbHash: "OAgGDQLekHxpeDe6h3Spl1WQKwOo"),
        .init(url: "https://picsum.photos/id/109/300/400", thumbHash: "pjkOFQJueL+HN3l3h3l4iGViIAUm"),
        .init(url: "https://picsum.photos/id/110/300/400", thumbHash: "XEoGFQRWdl+HWHdZiJOoqDpgkfgY"),
        .init(url: "https://picsum.photos/id/111/300/400", thumbHash: "WhgSFQJ4eJ+Il5eIiJd4d2ePCYQW"),
        .init(url: "https://picsum.photos/id/112/300/400", thumbHash: "HxkOLQiHiJmIyHn3eHt3d4aAeAh4"),
        .init(url: "https://picsum.photos/id/113/300/400", thumbHash: "ZOcRFQKZiX+ImHeXd3doh7RfCcu4"),
        .init(url: "https://picsum.photos/id/114/300/400", thumbHash: "YvgNHQR1d3CIZ3eIiIdoh3VwVQdX"),
        .init(url: "https://picsum.photos/id/115/300/400", thumbHash: "IAgSDQJkd593l4iYeHiIiHaPive3"),
        .init(url: "https://picsum.photos/id/116/300/400", thumbHash: "VQgKNQhnVYCaClZoiXKZlneAhgdo"),
        .init(url: "https://picsum.photos/id/117/300/400", thumbHash: "zygOFQIoaHd6aJb4R3SJhylvlfJm"),
        .init(url: "https://picsum.photos/id/118/300/400", thumbHash: "3xgOJQJpiH93h4eIh3dod4ZwRRoH"),
        .init(url: "https://picsum.photos/id/119/300/400", thumbHash: "NggGBQB3h4+HN5Z3eXlYpwAAAAAA"),
        .init(url: "https://picsum.photos/id/120/300/400", thumbHash: "iPgFFQJ2iJB3V4eIh3aId3aQhzj2"),
        .init(url: "https://picsum.photos/id/121/300/400", thumbHash: "JAgeBQBmeJ+Hh4iHhnd3hwAAAAAA"),
        .init(url: "https://picsum.photos/id/122/300/400", thumbHash: "i8cFDQKcM2iYCWdoZ3ioiJp2oHkH"),
        .init(url: "https://picsum.photos/id/123/300/400", thumbHash: "l/cJDQB5d4B4GIhHh3VodoZ/ffbo"),
        .init(url: "https://picsum.photos/id/124/300/400", thumbHash: "GpcFFQZGd4+ICHeXh4d4Z5dwigrX"),
        .init(url: "https://picsum.photos/id/125/300/400", thumbHash: "ZSgOFQR4h3+Ip4iHd4dnaHeAZwd3"),
        .init(url: "https://picsum.photos/id/126/300/400", thumbHash: "3fcJBQBah493iIeYiIdoeQLdDEOt"),
        .init(url: "https://picsum.photos/id/127/300/400", thumbHash: "mgoKHQJ4h5OH94m3d3eYiFeanxf4"),
        .init(url: "https://picsum.photos/id/128/300/400", thumbHash: "WvgVFQJ4d393d4iHh4l4aHpgvJb1"),
        .init(url: "https://picsum.photos/id/129/300/400", thumbHash: "pTkKHQR7d2+Il4hIhpWoeHdwYwdI"),
        .init(url: "https://picsum.photos/id/130/300/400", thumbHash: "NAgGBQB3iI93CIiXeIOXeAAAAAAA"),
        .init(url: "https://picsum.photos/id/131/300/400", thumbHash: "sQkGBQR6h1+IR3q3hpWXdmlvdAiY"),
        .init(url: "https://picsum.photos/id/132/300/400", thumbHash: "nCgSFQJ2iJ+Ht4ind2l3Z49++8jV"),
        .init(url: "https://picsum.photos/id/133/300/400", thumbHash: "IwkOLQJHpo93qIhYh46JV4V/B9mI"),
        .init(url: "https://picsum.photos/id/134/300/400", thumbHash: "mQgKDQKVlymIl3T5d2iXeKMENwgU"),
        .init(url: "https://picsum.photos/id/135/300/400", thumbHash: "W/cRDQJ4eH+IZ4d3eIh4h2iHbwin"),
        .init(url: "https://picsum.photos/id/136/300/400", thumbHash: "1RgODQJ4ea+GqHqoeYmHeJB0Amk6"),
        .init(url: "https://picsum.photos/id/137/300/400", thumbHash: "FzkOFQJJiI2HB6dYh4mHeHmPkvc4"),
        .init(url: "https://picsum.photos/id/139/300/400", thumbHash: "WDkOHQRnh2J4CIioh4SHeHZlcEcG"),
        .init(url: "https://picsum.photos/id/140/300/400", thumbHash: "afgJDQB3Z4+HJ3d4h4pnh6Z/OSEK"),
        .init(url: "https://picsum.photos/id/141/300/400", thumbHash: "nfcFLQZ6eJiICHanmHhHpnaAXAf4"),
        .init(url: "https://picsum.photos/id/142/300/400", thumbHash: "YggGHQQHVoN313hISaNqWFdwdwOo"),
        .init(url: "https://picsum.photos/id/143/300/400", thumbHash: "YhgGBQBJdoR4N3f4dnWXZ0qPjAnk"),
        .init(url: "https://picsum.photos/id/144/300/400", thumbHash: "IAgWBQCLeI+Hd3aIeHWoiAAAAAAA"),
        .init(url: "https://picsum.photos/id/145/300/400", thumbHash: "1AgGDQDbind2SruZdXP2ZtqMgPsq"),
        .init(url: "https://picsum.photos/id/146/300/400", thumbHash: "IhgKDQB/lcNYSGenhmWISW7QJyUL"),
        .init(url: "https://picsum.photos/id/147/300/400", thumbHash: "YOcNDQJpeI+Hh3h3eIdoaF2Vz3f4"),
        .init(url: "https://picsum.photos/id/149/300/400", thumbHash: "SNcFDQKMhmWHKIb3elC3uXlQjAfG"),
        .init(url: "https://picsum.photos/id/151/300/400", thumbHash: "HQgaBQB2eH93V3hHiHiYeAAAAAAA"),
        .init(url: "https://picsum.photos/id/152/300/400", thumbHash: "mhcOHQZ6l4aHCJZ3eFeXt3h3n4cI"),
        .init(url: "https://picsum.photos/id/153/300/400", thumbHash: "XikKFQIBuIhq2JRmd7Z3eAW6/MWv"),
        .init(url: "https://picsum.photos/id/154/300/400", thumbHash: "JxgSFQJ5eH93V4eIeHeIiIiPBDgO"),
        .init(url: "https://picsum.photos/id/155/300/400", thumbHash: "6BcSHQiIh3+Hd4d3iId3h4xwlAd4"),
        .init(url: "https://picsum.photos/id/156/300/400", thumbHash: "pygGBQDJW59nt1g2p4vWOPaYfm/6"),
        .init(url: "https://picsum.photos/id/157/300/400", thumbHash: "8fcFFQL1QlNni4RdlXqlyTuvu/TK"),
        .init(url: "https://picsum.photos/id/158/300/400", thumbHash: "5wcSDQKKeH93CIjIeXWHiDFlX6b3"),
        .init(url: "https://picsum.photos/id/159/300/400", thumbHash: "HrgFDQKmWl6al3j4jIlnhgyoAkun"),
        .init(url: "https://picsum.photos/id/160/300/400", thumbHash: "nfcRDQJcdXp193fId2ZolzbzWAZL"),
        .init(url: "https://picsum.photos/id/161/300/400", thumbHash: "2SgSDQSIeH+Hl4aHiIeIeIBubgi5"),
        .init(url: "https://picsum.photos/id/162/300/400", thumbHash: "3+cVLQh4eI94V4h3d3mHeHaPZfd4"),
        .init(url: "https://picsum.photos/id/163/300/400", thumbHash: "XQgOHQKLZ5qIB5iIh4d4uJqPkAr2"),
        .init(url: "https://picsum.photos/id/164/300/400", thumbHash: "5/gFJQaXhn93CGiXd4rGZ4uIwCgI"),
        .init(url: "https://picsum.photos/id/165/300/400", thumbHash: "pLcJhRRXd4CHCIdXh3mYV3eAiAeH"),
        .init(url: "https://picsum.photos/id/166/300/400", thumbHash: "GfgVBQB4iH93p4h4h4RoiGaAmvjm"),
        .init(url: "https://picsum.photos/id/167/300/400", thumbHash: "WVoGLQRziI9pSZjJWYd4gUOZMJIK"),
        .init(url: "https://picsum.photos/id/168/300/400", thumbHash: "YfgVHQR5d4+HmHdIiIeXiJlwiIYJ"),
        .init(url: "https://picsum.photos/id/169/300/400", thumbHash: "mcgJFQpmeIR4p2j4d3ZXmDiogPU5"),
        .init(url: "https://picsum.photos/id/170/300/400", thumbHash: "GykSDQCFdn93p3iIeIWIl6d4f5r3"),
        .init(url: "https://picsum.photos/id/171/300/400", thumbHash: "GPgVFQJniI+Hl4dod4aHiFVgUwVH"),
        .init(url: "https://picsum.photos/id/172/300/400", thumbHash: "3vcNDQCIeI93Z3d3iIh3d1eAfAXI"),
        .init(url: "https://picsum.photos/id/173/300/400", thumbHash: "KSkWHQJ3eH94OHiYh4h4iIqdsAka"),
        .init(url: "https://picsum.photos/id/174/300/400", thumbHash: "XgkaFQSHd4+Il3eId4Z4h3Svkfh3"),
        .init(url: "https://picsum.photos/id/175/300/400", thumbHash: "HwgOBQAri3iJCIh1hnV5dwAAAAAA"),
        .init(url: "https://picsum.photos/id/176/300/400", thumbHash: "IfgVHQp3d4+IaId3eIaYd3eQcweI"),
        .init(url: "https://picsum.photos/id/177/300/400", thumbHash: "5hgaFQJ2d3+IiHh4h4h4d2aQYQWI"),
        .init(url: "https://picsum.photos/id/178/300/400", thumbHash: "YwgaDQCIh393d3iIiHh4h8pwclwI"),
        .init(url: "https://picsum.photos/id/179/300/400", thumbHash: "LggKDQJGlmuH95fIm6FXZnmOn/jY"),
        .init(url: "https://picsum.photos/id/180/300/400", thumbHash: "nhgGHQTLdf1nSF+HhBFoVoMwKwqy"),
        .init(url: "https://picsum.photos/id/181/300/400", thumbHash: "FvgRFQKIZoh4B4hYd3l2h2d5YLQF"),
        .init(url: "https://picsum.photos/id/182/300/400", thumbHash: "48YNNQiYh3mHB3h3h3l3aIdwhQh4"),
        .init(url: "https://picsum.photos/id/183/300/400", thumbHash: "5PcNDQCHiI93l3hXeIdYiKl/e9n4"),
        .init(url: "https://picsum.photos/id/184/300/400", thumbHash: "jUgKLQZ3eIV4CIiYd4hoeHeAdwdX"),
        .init(url: "https://picsum.photos/id/185/300/400", thumbHash: "50kWHQZ3d3+IeIhod4eId4dwdQhX"),
        .init(url: "https://picsum.photos/id/186/300/400", thumbHash: "aQgKFQI4eICVZ4a4l4dnh3iAef13"),
        .init(url: "https://picsum.photos/id/187/300/400", thumbHash: "UwgSFQKHeH+Il4dYh3aYd3d/even"),
        .init(url: "https://picsum.photos/id/188/300/400", thumbHash: "Y+cZDQJ4d3+IiIeXd4aHiGaOX5j4"),
        .init(url: "https://picsum.photos/id/189/300/400", thumbHash: "makFDQJIl291OYenqHiHaFpYD+iE"),
        .init(url: "https://picsum.photos/id/190/300/400", thumbHash: "UhgGDQA1l4CHSJi3eHZml0aA9TaI"),
        .init(url: "https://picsum.photos/id/191/300/400", thumbHash: "5fcNFQKEeG93p4k5eVaYh5SAgQl1"),
        .init(url: "https://picsum.photos/id/192/300/400", thumbHash: "HAgSBQA3eIl5BogYl3iXeAAAAAAA"),
        .init(url: "https://picsum.photos/id/193/300/400", thumbHash: "HugRHQaIeI+Id3d3d3d3h3hygKcH"),
        .init(url: "https://picsum.photos/id/194/300/400", thumbHash: "aOcRFQJ4iH94V4d3eHl4h4eAfgfI"),
        .init(url: "https://picsum.photos/id/195/300/400", thumbHash: "DBgGDQI0xoN7B4lYWHuGVzWQYgEJ"),
        .init(url: "https://picsum.photos/id/196/300/400", thumbHash: "aQgGDQCGd3h414f4dnh3mYmAkxgI"),
        .init(url: "https://picsum.photos/id/197/300/400", thumbHash: "ZQgaFQZ4iI93p4d4h3V3mKigggha"),
        .init(url: "https://picsum.photos/id/198/300/400", thumbHash: "ZvgZDQJ5eH+HWIZ3iYiHdyMQQgZ2"),
        .init(url: "https://picsum.photos/id/199/300/400", thumbHash: "5/cNHQJ3iH+IV3iIh3Wnd4dwegmn"),
        .init(url: "https://picsum.photos/id/200/300/400", thumbHash: "7ygKFQJ2iI94p4g3doaoh3mAwwgW"),
        .init(url: "https://picsum.photos/id/201/300/400", thumbHash: "qigSPQiYd393iHl4dodomHeAeAeY"),
        .init(url: "https://picsum.photos/id/202/300/400", thumbHash: "mNcRHQIIl3x1eIaIiHZ4hwp9pIBl"),
        .init(url: "https://picsum.photos/id/203/300/400", thumbHash: "3/cZHQaKiI+HZ3dYiIiId4qQpgh4"),
        .init(url: "https://picsum.photos/id/204/300/400", thumbHash: "G/gZJQaIiJ+Hl3dnh4V3iHaQcgdJ"),
        .init(url: "https://picsum.photos/id/206/300/400", thumbHash: "JRkaPQh4d394V4doeHd3h3iAgAcI")
        ]
    
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    static func create(with viewModel: HomeViewModel) -> HomeViewController {
        let vc =  HomeViewController(vm: viewModel)
        return vc
    }
    
    override func setup() {
        imagesCollectionView.delegate = self
        imagesCollectionView.dataSource = self
        imagesCollectionView.register(ImageCollectionViewCell.self)
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5

        imagesCollectionView.collectionViewLayout = layout
    }
    
    @IBAction func onLogoutButtonPressed(_ sender: Any) {
        vm.logout()
    }
}


extension HomeViewController: UICollectionViewDelegate,
                                UICollectionViewDataSource,
                                UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         let padding: CGFloat = 5
         let collectionViewSize = collectionView.frame.size.width - (padding * 2)
         let itemSize = collectionViewSize / 3 - 1
         return CGSize(width: itemSize, height: itemSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(ImageCollectionViewCell.self, indexPath: indexPath)
        let imageThumb = data[indexPath.row]
        cell.setImageUrl(url: imageThumb.url, thumbHash: imageThumb.thumbHash)
        return cell
    }
}
