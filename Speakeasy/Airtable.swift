import Moya

enum Airtable {
  case questions
}

extension Airtable: TargetType {
  var baseURL: URL { return URL(string: "https://api.airtable.com/v0/appwnaqHUPq8eCISY")! }
  var path: String {
    switch self {
    case .questions:
      return "/Questions"
    }
  }
  var method: Moya.Method {
    switch self {
    case .questions:
      return .get
    }
  }
  var task: Task {
    switch self {
    case .questions:
      return .requestParameters(parameters: ["maxRecords": 500], encoding: URLEncoding.queryString)
    }
  }
  var sampleData: Data {
    switch self {
    case .questions:
      guard let url = Bundle.main.url(forResource: "questions", withExtension: "json"),
        let data = try? Data(contentsOf: url) else {
          return Data()
      }
      return data
    }
  }
  var headers: [String: String]? {
    return ["Content-type": "application/json",
            "Authorization": "Bearer keyJyQeXgQnXYLSOH"]
  }
}

struct AirtableResponse: Codable {
  let records: [AirtableRecord]
}

struct AirtableRecord: Codable {
  let fields: Card
}

struct Card: Codable {
  let question: String
  let subtext: String?
  let category: String?
  let color: String?

  var colorPalette: ColorPalette? {
    return .from(string: color)
  }
}
