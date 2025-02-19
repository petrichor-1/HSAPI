struct LowLevelVariable {
	var name: String?
	var id: String?
	var type: Double?
	/// Only on local variables
	var description: String?

	/// Extra data. Will be overwritten by values in full regular properties when jsonified, if applicable
	var extraData = [String: JSONType]()
}

extension LowLevelVariable: Codable {
	enum CodingKeys: String, CodingKey {
		case name
		case id = "objectIdString"
		case type
		case description
	}
	
	init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ArbitraryStringCodingKeys.self)
        for key in container.allKeys {
            if let knownKey = CodingKeys(stringValue: key.stringValue) { 
                switch knownKey {
				case .name:
					if let name = try? container.decode(String.self, forKey: key) {
						self.name = name
					} else {
						extraData[key.stringValue] = try container.decode(JSONType.self, forKey: key)
					}
				case .id:
					if let id = try? container.decode(String.self, forKey: key) {
						self.id = id
					} else {
						extraData[key.stringValue] = try container.decode(JSONType.self, forKey: key)
					}
				case .type:
					if let type = try? container.decode(Double.self, forKey: key) {
						self.type = type
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

	func encode(to encoder: Encoder) throws {
		var extraDataContainer = encoder.container(keyedBy: ArbitraryStringCodingKeys.self)
		for (key, value) in extraData {
			try extraDataContainer.encode(value, forKey: ArbitraryStringCodingKeys(stringValue: key))
		}
		var mainContainer = encoder.container(keyedBy: CodingKeys.self)
		if let name {
			try mainContainer.encodeIfPresent(name, forKey: .name)
		}
		if let id {
			try mainContainer.encodeIfPresent(id, forKey: .id)
		}
		if let type {
			try mainContainer.encodeIfPresent(type, forKey: .type)
		}
		if let description {
			try mainContainer.encodeIfPresent(description, forKey: .description)
		}
	}
}