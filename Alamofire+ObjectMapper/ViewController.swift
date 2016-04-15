import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        API.call(Endpoint.User.Get) { response in
            switch response {
            case .Success(let result):
                print("success \(result)")
                print(result.url)
            case .Failure(let error):
                print("failure \(error)")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

