///Post-webplayer 2.0.0, custom rule instances are used to refer to custom rules. In earlier projects, the custom rules were directly referred to.
struct LowLevelCustomRuleInstance {
	///The id of the custom rule that is referenced
	var customRuleId: String?
	///The unique id of this custom rule instance
	var id: String?
	///The parameters passed to the custom rule in this instance
	var parameters: [LowLevelParameter]?

	/// Extra data. Will be overwritten by values in full regular properties when jsonified, if applicable
	var extraData = [String: JSONType]()
}

extension LowLevelCustomRuleInstance: Codable {
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

	func encode(to encoder: Encoder) throws {
		var extraDataContainer = encoder.container(keyedBy: ArbitraryStringCodingKeys.self)
		for (key, value) in extraData {
			try extraDataContainer.encode(value, forKey: ArbitraryStringCodingKeys(stringValue: key))
		}
		var mainContainer = encoder.container(keyedBy: CodingKeys.self)
		if let customRuleId {
			try mainContainer.encodeIfPresent(customRuleId, forKey: .customRuleId)
		}
		if let id {
			try mainContainer.encodeIfPresent(id, forKey: .id)
		}
		if let parameters {
			try mainContainer.encodeIfPresent(parameters, forKey: .parameters)
		}
	}
}