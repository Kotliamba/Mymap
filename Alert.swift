import UIKit

extension UIViewController {
    
    func alertAddAdress(to title: String, placeholder: String, completionHandler: @escaping (String) -> Void) {
        
        let alertConrtoller = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
        let alertActionOk = UIAlertAction(title: "Ok", style: .default) { action in
            
            let fieldText = alertConrtoller.textFields?.first
            guard let text = fieldText?.text else {return}
            completionHandler(text)
            
        }
        
        alertConrtoller.addTextField() { textField in
            textField.placeholder = placeholder
            
        }
        
        
        let alertActionCancel = UIAlertAction(title: "Отменить", style: .cancel) { action in
            print(action)
        }
        
        alertConrtoller.addAction(alertActionOk)
        alertConrtoller.addAction(alertActionCancel)
        
        present(alertConrtoller, animated: true)
    }
    
    func alertError(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionOk = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alertController.addAction(actionOk)
        
        present(alertController, animated: true)
    }
    
}
