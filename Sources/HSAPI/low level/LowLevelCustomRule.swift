struct LowLevelCustomRule {
	var id: String?
	var abilityID: String?
	var name: String?
	var parameters: [LowLevelParameter]?
	var rules: [String]?

	var extraData = [String: JSONType]()
}

extension LowLevelCustomRule: Codable {
	enum CodingKeys: String, CodingKey {
		case id
		case abilityID
		case name
		case parameters
		case rules
	}

	init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ArbitraryStringCodingKeys.self)
        for key in container.allKeys {
            if let knownKey = CodingKeys(stringValue: key.stringValue) { 
                switch knownKey {
				case .id:
					if let id = try? container.decode(String.self, forKey: key) {
						self.id = id
					} else {
						extraData[key.stringValue] = try container.decode(JSONType.self, forKey: key)
					}
				case .abilityID:
					if let abilityID = try? container.decode(String.self, forKey: key) {
						self.abilityID = abilityID
					} else {
						extraData[key.stringValue] = try container.decode(JSONType.self, forKey: key)
					}
				case .name:
					if let name = try? container.decode(String.self, forKey: key) {
						self.name = name
					} else {
						extraData[key.stringValue] = try container.decode(JSONType.self, forKey: key)
					}
				case .parameters:
					if let parameters = try? container.decode([LowLevelParameter].self, forKey: key) {
						self.parameters = parameters
					} else {
						extraData[key.stringValue] = try container.decode(JSONType.self, forKey: key)
					}
				case .rules:
					if let rules = try? container.decode([String].self, forKey: key) {
						self.rules = rules
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
		if let abilityID {
			try mainContainer.encode(abilityID, forKey: .abilityID)
		}
		if let id {
			try mainContainer.encode(id, forKey: .id)
		}
		if let abilityID {
			try mainContainer.encode(abilityID, forKey: .abilityID)
		}
		if let name {
			try mainContainer.encode(name, forKey: .name)
		}
		if let parameters {
			try mainContainer.encode(parameters, forKey: .parameters)
		}
		if let rules {
			try mainContainer.encode(rules, forKey: .rules)
		}
	}
}