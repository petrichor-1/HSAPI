///A reference to a variable, used in parameter datums
struct LowLevelVariableReference {
	///The id of the variable being referenced
	var variable: String?
	///The type of the variable being referenced
	///If this doesn't match the expected type of the variable, the iOS app's editor will change it, but the player will understand it just fine.
	var type: Double?
	var description: String?
	var object: String?

	/// Extra data. Will be overwritten by values in full regular properties when jsonified, if applicable
	var extraData = [String: JSONType]()
}

extension LowLevelVariableReference: Codable {
	enum CodingKeys: String, CodingKey {
		case variable
		case type
		case description
		case object
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
				case .description:
					if let description = try? container.decode(String.self, forKey: key) {
						self.description = description
					} else {
						extraData[key.stringValue] = try container.decode(JSONType.self, forKey: key)
					}
				case .object:
					if let object = try? container.decode(String.self, forKey: key) {
						self.object = object
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
		if let variable {
			try mainContainer.encodeIfPresent(variable, forKey: .variable)
		}
		if let type {
			try mainContainer.encodeIfPresent(type, forKey: .type)
		}
		if let description {
			try mainContainer.encodeIfPresent(description, forKey: .description)
		}
		if let object {
			try mainContainer.encodeIfPresent(object, forKey: .object)
		}
	}
}