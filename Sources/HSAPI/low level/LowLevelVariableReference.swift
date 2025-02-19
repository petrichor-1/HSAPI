struct LowLevelVariableReference {
	var variable: String?
	var type: Double?

	var extraData = [String: JSONType]()
}

extension LowLevelVariableReference: Codable {
	enum CodingKeys: String, CodingKey {
		case variable
		case type
	}
	
	init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ArbitraryStringCodingKeys.self)
        for key in container.allKeys {
            if let knownKey = CodingKeys(stringValue: key.stringValue) { 
                switch knownKey {
				case .variable:
					if let variable = try? container.decode(String.self, forKey: key) {
						self.variable = variable
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
		try mainContainer.encodeIfPresent(variable, forKey: .variable)
		try mainContainer.encodeIfPresent(type, forKey: .type)
	}
}