import Foundation
import Alamofire

struct GetFeaturingsRequest: Request {
    typealias ReturnType = Array<Featuring>
    var path: String = "featurings"
    var method: Alamofire.HTTPMethod = .get
    var body: [String: Any]?
    var headers: [String: String]?

    init() {
        self.headers = [
            "Content-Type": "application/json"
        ]
    }
}
