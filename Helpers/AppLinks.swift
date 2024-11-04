import Foundation

struct AppLinks {
    static let appShareURL: URL = {
        guard let url = URL(string: "https://apps.apple.com/us/app/slackline-balance-tracker/id6737515728") else {
            fatalError("Invalid URL for appShareURL")
        }
        return url
    }()

    static let appStoreReviewURL: URL = {
        guard let url = URL(string: "https://apps.apple.com/us/app/slackline-balance-tracker/id6737515728") else {
            fatalError("Invalid URL for appStoreReviewURL")
        }
        return url
    }()

    static let usagePolicyURL: URL = {
        guard let url = URL(string: "https://www.termsfeed.com/live/58686533-9f92-4ed9-876f-dbd7a5094b53") else {
            fatalError("Invalid URL for usagePolicyURL")
        }
        return url
    }()
}
