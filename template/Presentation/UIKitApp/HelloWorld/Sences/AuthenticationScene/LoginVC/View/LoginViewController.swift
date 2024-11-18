import UIKit


class LoginViewController: ViewController<LoginViewModel> {
    static func create(with viewModel: LoginViewModel) -> LoginViewController {
        return LoginViewController(vm: viewModel)
    }
    
    
    
    @IBAction func onLoginClick(_ sender: Any) {
        //        vm.submit()
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true)
        
    }
    
    @IBAction func onRegisterClick(_ sender: Any) {
        vm.showRegisterScreen()
    }
}


extension LoginViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //        guard let image = info[.originalImage] as? UIImage else {
        //            return
        //        }
        //        let destination: DownloadRequest.Destination = {temporaryURL, response in
        //            let (downloadedFileURL, _) = DownloadRequest.suggestedDownloadDestination()(temporaryURL, response)
        //
        //            return (downloadedFileURL, [.removePreviousFile, .createIntermediateDirectories])
        //        }
        //        Task {
        //
        //            let downloadRequest =  AF.download(Router.download, to: destination).validate()
        //            downloadRequest.downloadProgress { progress in
        //                print("Progress: \(progress.fractionCompleted)")
        //            }
        //            await downloadRequest.serializingData().response
        //
        //            await AF.request(Router.upload(["sampleFile": image.pngData()!]))
        //                .validate()
        //                .serializingData(automaticallyCancelling: true)
        //                .response
        //        }
        self.dismiss(animated: true)
    }
}
