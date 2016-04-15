import ObjectMapper

class UserEntity: Mappable {
    var id: Int?
    var name: String?
    var email: String?
    var url: String?
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        email <- map["email"]
        url <- map["url"]
    }
}