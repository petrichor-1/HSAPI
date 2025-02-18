struct LowLevelSetImageDatum {
	var customObject: String?
	/// Will have higher priority than `type` in webplayer parsing
	var text: String?
	var type: Double?
	/// Usually empty string
	var name: String?
	/// Usually empty string
	var description: String?

	var extraData = [String: JSONType]()
}

extension LowLevelSetImageDatum: Decodable {
	enum CodingKeys: String, CodingKey {
		case customObject
		case text
		case type
		case name
		case description
	}
	
	init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ArbitraryStringCodingKeys.self)
        for key in container.allKeys {
            if let knownKey = CodingKeys(stringValue: key.stringValue) { 
                switch knownKey {
				case .customObject:
					if let customObject = try? container.decode(String.self, forKey: key) {
						self.customObject = customObject
					} else {
						extraData[key.stringValue] = try container.decode(JSONType.self, forKey: key)
					}
				case .text:
					if let text = try? container.decode(String.self, forKey: key) {
						self.text = text
					} else {
						extraData[key.stringValue] = try container.decode(JSONType.self, forKey: key)
					}
				case .type:
					if let type = try? container.decode(Double.self, forKey: key) {
						self.type = type
					} else {
						extraData[key.stringValue] = try container.decode(JSONType.self, forKey: key)
					}
				case .name:
					if let name = try? container.decode(String.self, forKey: key) {
						self.name = name
					} else {
						extraData[key.stringValue] = try container.decode(JSONType.self, forKey: key)
					}
				case .description:
					if let description = try? container.decode(String.self, forKey: key) {
						self.description = description
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