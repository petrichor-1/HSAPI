struct LowLevelEventParameter {
	var blockType: Double?
	var description: String?
	var id: String?
	var objectID: String?

	var extraData = [String: JSONType]()
}

extension LowLevelEventParameter: Codable {
	enum CodingKeys: String, CodingKey {
		case blockType
		case description
		case id
		case objectID
	}
	
	init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ArbitraryStringCodingKeys.self)
        for key in container.allKeys {
            if let knownKey = CodingKeys(stringValue: key.stringValue) { 
                switch knownKey {
				case .blockType:
					if let blockType = try? container.decode(Double.self, forKey: key) {
						self.blockType = blockType
					} else {
						extraData[key.stringValue] = try container.decode(JSONType.self, forKey: key)
					}
				case .description:
					if let description = try? container.decode(String.self, forKey: key) {
						self.description = description
					} else {
						extraData[key.stringValue] = try container.decode(JSONType.self, forKey: key)
					}
				case .id:
					if let id = try? container.decode(String.self, forKey: key) {
						self.id = id
					} else {
						extraData[key.stringValue] = try container.decode(JSONType.self, forKey: key)
					}
				case .objectID:
					if let objectID = try? container.decode(String.self, forKey: key) {
						self.objectID = objectID
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

	func encode(to encoder: Encoder) throws {
		var extraDataContainer = encoder.container(keyedBy: ArbitraryStringCodingKeys.self)
		for (key, value) in extraData {
			try extraDataContainer.encode(value, forKey: ArbitraryStringCodingKeys(stringValue: key))
		}
		var mainContainer = encoder.container(keyedBy: CodingKeys.self)
		try mainContainer.encodeIfPresent(blockType, forKey: .blockType)
		try mainContainer.encodeIfPresent(description, forKey: .description)
		try mainContainer.encodeIfPresent(id, forKey: .id)
		try mainContainer.encodeIfPresent(objectID, forKey: .objectID)
	}
}