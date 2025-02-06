import Foundation
import Alamofire

struct GetPostsRequest: Request {
    typealias ReturnType = Array<Post>
    var path: String = "posts"
    var method: Alamofire.HTTPMethod = .get
    var body: [String: Any]?
    var headers: [String: String]?

    init() {
        self.headers = [
            "Content-Type": "application/json"
        ]
    }
}
