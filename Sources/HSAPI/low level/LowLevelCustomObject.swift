import Foundation

struct LowLevelCustomObject {
	var createdDate: Date?
	var fileName: String?
	var id: String?
	var name: String?
	var size: LowLevelStageSize? //FIXME: What is this *ACTUALLY* supposed to be?
	var updatedDate: Date?

	var extraData = [String: JSONType?]()
}

extension LowLevelCustomObject: Decodable {
	enum CodingKeys: String, CodingKey {
		case createdDate
		case fileName
		case id
		case name
		case size
		case updatedDate
	}
	
	init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ArbitraryStringCodingKeys.self)
        for key in container.allKeys {
            if let knownKey = CodingKeys(stringValue: key.stringValue) { 
                switch knownKey {
				case .createdDate: 
					if let createdDate = try? container.decode(Date.self, forKey: key) {
						self.createdDate = createdDate
					} else if let createdDateString = try? container.decode(String.self, forKey: key), let createdDate = HSDateFormatter.singleton.date(from: createdDateString) { // Silly hack because Hopscotch produces slightly nonstandard dates, for some reason
						self.createdDate = createdDate
					} else {
						extraData[key.stringValue] = try container.decode(JSONType.self, forKey: key)
					}
				case .fileName: 
					if let fileName = try? container.decode(String.self, forKey: key) {
						self.fileName = fileName
					} else {
						extraData[key.stringValue] = try container.decode(JSONType.self, forKey: key)
					}
				case .id: 
					if let id = try? container.decode(String.self, forKey: key) {
						self.id = id
					} else {
						extraData[key.stringValue] = try container.decode(JSONType.self, forKey: key)
					}
				case .name: 
					if let name = try? container.decode(String.self, forKey: key) {
						self.name = name
					} else {
						extraData[key.stringValue] = try container.decode(JSONType.self, forKey: key)
					}
				case .size: 
					if let size = try? container.decode(LowLevelStageSize.self, forKey: key) {
						self.size = size
					} else {
						extraData[key.stringValue] = try container.decode(JSONType.self, forKey: key)
					}
				case .updatedDate: 
					if let updatedDate = try? container.decode(Date.self, forKey: key) {
						self.updatedDate = updatedDate
					} else if let updatedDateString = try? container.decode(String.self, forKey: key), let updatedDate = HSDateFormatter.singleton.date(from: updatedDateString) { // Silly hack because Hopscotch produces slightly nonstandard dates, for some reason
						self.updatedDate = updatedDate
					} else {
						extraData[key.stringValue] = try container.decode(JSONType.self, forKey: key)
					}
				}
                continue
            }

            let value = try container.decode(JSONType.self, forKey: key)
            extraData[key.stringValue] = value
        }
    }
}