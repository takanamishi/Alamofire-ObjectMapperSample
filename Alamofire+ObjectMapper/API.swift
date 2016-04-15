import Alamofire

/*
 使用例
 API.call(Endpoint.User.Find(id: 1)) { response in
    switch response {
    case .Success(let result):
        print("success \(result)")
    case .Failure(let error):
        print("failure \(error)")
    }
 }
 */

class API {
    class func call<T: RequestProtocol, V where T.ResponseType == V>(request: T, completion: (Result<V, NSError>) -> Void) {
        Alamofire.request(request)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                switch response.result {
                case .Success(let json):
                    completion(request.fromJson(json))
                case .Failure(let error):
                    completion(.Failure(error))
                }
        }
    }
}
