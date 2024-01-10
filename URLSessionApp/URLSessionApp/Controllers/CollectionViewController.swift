//
//  CollectionViewController.swift
//  URLSessionApp
//
//  Created by Eugene on 08/01/2024.
//

import UIKit
import UserNotifications

class CollectionViewController: UICollectionViewController {
    
    let actions = Actions.allCases
    private let reuseIdentifier = "cell"
    private let url = "https://jsonplaceholder.typicode.com/posts"
    private let urlUploadImage = "https://api.imgur.com/3/image"
    private var alert: UIAlertController!
    private var dataProvider = DataProvider()
    private var filePath: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerForNotification()
        dataProvider.fileLocation = { location in
            
            self.filePath = location.absoluteString
            self.alert.dismiss(animated: false)
            self.postNotification()
        }
    }
    
    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return actions.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell
        cell.labelInfo.text = actions[indexPath.row].rawValue
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let action = actions[indexPath.row]
        
        switch action {
        case .downloadImage:
            performSegue(withIdentifier: "showImage", sender: self)
        case .get:
            NetworkManager.getRequest(url: url)
        case .post:
            NetworkManager.postRequest(url: url)
        case .ourCourses:
            performSegue(withIdentifier: "showCourses", sender: self)
        case .uploadImage:
            NetworkManager.uploadImage(url: urlUploadImage)
        case .downloadFile:
            showAlert()
            dataProvider.startDownload()
        case .ourCoursesWithAlamofire:
            performSegue(withIdentifier: "showWithAlamofire", sender: self)
        case .responseData:
            performSegue(withIdentifier: "showResponse", sender: self)
            AlamofireNetwork.responseData(url: "https://swiftbook.ru//wp-content/uploads/api/api_courses")
        }
    }
    
    private func showAlert() {
        
        alert = UIAlertController(title: "Downloading...", message: "0", preferredStyle: .alert)
        let hieght = NSLayoutConstraint(item: alert.view!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: 170)
        alert.view.addConstraint(hieght)
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { action in
            self.dataProvider.stopDownload()
        }
        alert.addAction(cancelAction)
        present(alert, animated: true) {
            
            let size = CGSize(width: 40, height: 40)
            let point = CGPoint(x: self.alert.view.frame.width / 2 - size.width / 2, y: self.alert.view.frame.height / 2 - size.height / 2)
            let activityIndicator = UIActivityIndicatorView(frame: CGRect(origin: point, size: size))
            activityIndicator.color = .gray
            activityIndicator.startAnimating()
            
            let progressView = UIProgressView(frame: CGRect(x: 0, y: self.alert.view.frame.height - 44, width: self.alert.view.frame.width, height: 2))
            progressView.tintColor = .blue
            self.dataProvider.onProgress = { progress in
                progressView.progress = Float(progress)
                self.alert.message = String(Int(progress * 100)) + "%"
            }
            
            self.alert.view.addSubview(activityIndicator)
            self.alert.view.addSubview(progressView)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let coursesVC = segue.destination as? TableViewController
        let imageVC = segue.destination as? ImageViewController
        
        
        switch segue.identifier {
        case "showCourses":
            coursesVC?.fetchData()
        case "showWithAlamofire":
            coursesVC?.fetchDataWithAlamofire()
        case "showResponse":
            imageVC?.fetchDataWithAlamofire()
        case "showImage":
            imageVC?.fetchImage()
        default: break
        }
    }

}

extension CollectionViewController {
    
    private func registerForNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) {_,_ in }
    }
    
    private func postNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Download Complete!"
        content.body = "Your background transfer completed. Path: \(filePath!)"
        
        let triger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        let request = UNNotificationRequest(identifier: "Complete", content: content, trigger: triger)
        UNUserNotificationCenter.current().add(request)
    }
}
