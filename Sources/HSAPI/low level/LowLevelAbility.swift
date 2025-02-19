/// Represents the raw json of an ability
struct LowLevelAbility {
	var abilityID: String?
	var blocks: [LowLevelBlock]?
	var createdAt: Double?
	var name: String?
	var parameters: [LowLevelParameter]?

	var extraData = [String: JSONType]()
}

extension LowLevelAbility: Codable {
	enum CodingKeys: String, CodingKey {
		case abilityID
		case blocks
		case createdAt
		case name
		case parameters
	}
	
	init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ArbitraryStringCodingKeys.self)
        for key in container.allKeys {
            if let knownKey = CodingKeys(stringValue: key.stringValue) { 
                switch knownKey {
				case .abilityID:
					if let abilityID = try? container.decode(String.self, forKey: key) {
						self.abilityID = abilityID
					} else {
						extraData[key.stringValue] = try container.decode(JSONType.self, forKey: key)
					}
				case .blocks:
					if let blocks = try? container.decode([LowLevelBlock].self, forKey: key) {
						self.blocks = blocks
					} else {
						extraData[key.stringValue] = try container.decode(JSONType.self, forKey: key)
					}
				case .createdAt:
					if let createdAt = try? container.decode(Double.self, forKey: key) {
						self.createdAt = createdAt
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
		if let blocks {
			try mainContainer.encode(blocks, forKey: .blocks)
		}
		if let createdAt {
			try mainContainer.encode(createdAt, forKey: .createdAt)
		}
		if let name {
			try mainContainer.encode(name, forKey: .name)
		}
		if let parameters {
			try mainContainer.encode(parameters, forKey: .parameters)
		}
	}
}