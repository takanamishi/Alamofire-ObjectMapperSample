import Alamofire
import ObjectMapper

protocol RequestProtocol: URLRequestConvertible {
    associatedtype ResponseType
    
    var baseURL: String { get }
    var method: Alamofire.Method { get }
    var path: String { get }
    var headers: [String: String]? { get }
    var parameters: [String: AnyObject]? { get }
    var encoding: ParameterEncoding { get }
    
    func fromJson(json: AnyObject) -> Result<ResponseType, NSError>
}

extension RequestProtocol {
    var method: Alamofire.Method {
        return .GET
    }
    
    var baseURL: String {
        return "https://httpbin.org"
    }
    
    var headers: [String: String]? {
        return nil
    }
    
    var parameters: [String: AnyObject]? {
        return nil
    }
    
    var encoding: ParameterEncoding {
        return .URL
    }
    
    var URLRequest: NSMutableURLRequest {
        let url = "\(baseURL)\(path)"
        let encodedUrl = url.stringByAddingPercentEncodingWithAllowedCharacters(
            NSCharacterSet.URLQueryAllowedCharacterSet())
        let mutableURLRequest = NSMutableURLRequest(URL: NSURL(string: encodedUrl!)!)
        mutableURLRequest.HTTPMethod = method.rawValue
        mutableURLRequest.allHTTPHeaderFields = headers
        do {
            if let parameters = parameters {
                mutableURLRequest.HTTPBody = try NSJSONSerialization.dataWithJSONObject(
                    parameters, options: NSJSONWritingOptions())
            }
        } catch {
            // No-op
        }
        mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return mutableURLRequest
    }
    
    /*
     NSError について
     
     1) domain は 識別子。独自で設定する際は com.company.app が通常
     2) code: エラーコード
     3) UserInfoのDictionary: エラーの概要（NSLocalizedDescriptionKey）と復旧方法（NSLocalizedRecoverySuggestionErrorKey）
     */
    // TODO: error の時は http のステータスコードの情報を取得したい
    func fromJson(json: AnyObject) -> Result<ResponseType, NSError> {
        guard let value = json as? ResponseType else {
            let errorInfo = [NSLocalizedDescriptionKey: "Convert object failed" , NSLocalizedRecoverySuggestionErrorKey: "Good luck!"]
            let error = NSError(domain: "com.actindi.app", code: 0, userInfo: errorInfo)
            return .Failure(error)
        }
        return .Success(value)
    }
}

extension RequestProtocol where ResponseType: Mappable {
    func fromJson(json: AnyObject) -> Result<ResponseType, NSError> {
        guard let value = Mapper<ResponseType>().map(json) else {
            let errorInfo = [ NSLocalizedDescriptionKey: "Mapping object failed" , NSLocalizedRecoverySuggestionErrorKey: "Rainy days never stay." ]
            let error = NSError(domain: "com.actindi.app", code: 0, userInfo: errorInfo)
            return .Failure(error)
        }
        return .Success(value)
    }
}