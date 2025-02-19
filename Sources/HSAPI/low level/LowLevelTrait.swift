struct LowLevelTrait {
	var description: String?
	var traitID: String?
	var objectID: String?
	var objectParameterType: Double?
	var type: Double?

	var extraData = [String: JSONType]()
}

extension LowLevelTrait: Codable {
	enum CodingKeys: String, CodingKey {
		case description
		case traitID = "HSTraitIDKey"
		case objectID = "HSTraitObjectIDKey"
		case objectParameterType = "HSTraitObjectParameterTypeKey"
		case type = "HSTraitTypeKey"
	}
	
	init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ArbitraryStringCodingKeys.self)
        for key in container.allKeys {
            if let knownKey = CodingKeys(stringValue: key.stringValue) { 
                switch knownKey {
				case .description:
					if let description = try? container.decode(String.self, forKey: key) {
						self.description = description
					} else {
						extraData[key.stringValue] = try container.decode(JSONType.self, forKey: key)
					}
				case .traitID:
					if let traitID = try? container.decode(String.self, forKey: key) {
						self.traitID = traitID
					} else {
						extraData[key.stringValue] = try container.decode(JSONType.self, forKey: key)
					}
				case .objectID:
					if let objectID = try? container.decode(String.self, forKey: key) {
						self.objectID = objectID
					} else {
						extraData[key.stringValue] = try container.decode(JSONType.self, forKey: key)
					}
				case .objectParameterType:
					if let objectParameterType = try? container.decode(Double.self, forKey: key) {
						self.objectParameterType = objectParameterType
					} else {
						extraData[key.stringValue] = try container.decode(JSONType.self, forKey: key)
					}
				case .type:
					if let type = try? container.decode(Double.self, forKey: key) {
						self.type = type
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
		if let description {
			try mainContainer.encodeIfPresent(description, forKey: .description)
		}
		if let traitID {
			try mainContainer.encodeIfPresent(traitID, forKey: .traitID)
		}
		if let objectID {
			try mainContainer.encodeIfPresent(objectID, forKey: .objectID)
		}
		if let objectParameterType {
			try mainContainer.encodeIfPresent(objectParameterType, forKey: .objectParameterType)
		}
		if let type {
			try mainContainer.encodeIfPresent(type, forKey: .type)
		}
	}
}