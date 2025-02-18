struct LowLevelCustomRuleInstance {
	var customRuleId: String?
	var id: String?
	var parameters: [LowLevelParameter]?

	var extraData = [String: JSONType]()
}

extension LowLevelCustomRuleInstance: Decodable {
	enum CodingKeys: String, CodingKey {
		case customRuleId = "customRuleID"
		case id
		case parameters
	}
	
	init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ArbitraryStringCodingKeys.self)
        for key in container.allKeys {
            if let knownKey = CodingKeys(stringValue: key.stringValue) { 
                switch knownKey {
				case .customRuleId:
					if let customRuleId = try? container.decode(String.self, forKey: key) {
						self.customRuleId = customRuleId
					} else {
						extraData[key.stringValue] = try container.decode(JSONType.self, forKey: key)
					}
				case .id:
					if let id = try? container.decode(String.self, forKey: key) {
						self.id = id
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
}