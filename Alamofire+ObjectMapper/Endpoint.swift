import Alamofire
import ObjectMapper

class Endpoint {
    enum User: RequestProtocol {
        typealias ResponseType = UserEntity
        
        case Get
        case Find(id: Int)
        case Delete
        
        var method: Alamofire.Method {
            switch self {
            case .Get, .Find:
                return .GET
            case .Delete:
                return .DELETE
            }
        }
        
        var path: String {
            switch self {
            case .Get:
                return "/get"
            case .Find(let id):
                return "/user/\(id)"
            case .Delete:
                return "/user/delete"
            }
        }
    }
}
