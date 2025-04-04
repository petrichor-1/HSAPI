///The contents of the `datum` field of a parameter in a set image block.
///This will only be parsed by the webplayer if it is in the proper parameter type.
struct LowLevelSetImageDatum {
	//TODO: More documentation
	var customObject: String?
	/// Will have higher priority than `type` in webplayer parsing
	var text: String?
	var type: Double?
	/// Usually empty string
	var name: String?
	/// Usually empty string
	var description: String?

	/// Extra data. Will be overwritten by values in full regular properties when jsonified, if applicable
	var extraData = [String: JSONType]()
}

extension LowLevelSetImageDatum: Codable {
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

	func encode(to encoder: Encoder) throws {
		var extraDataContainer = encoder.container(keyedBy: ArbitraryStringCodingKeys.self)
		for (key, value) in extraData {
			try extraDataContainer.encode(value, forKey: ArbitraryStringCodingKeys(stringValue: key))
		}
		var mainContainer = encoder.container(keyedBy: CodingKeys.self)
		if let customObject {
			try mainContainer.encodeIfPresent(customObject, forKey: .customObject)
		}
		if let text {
			try mainContainer.encodeIfPresent(text, forKey: .text)
		}
		if let type {
			try mainContainer.encodeIfPresent(type, forKey: .type)
		}
		if let name {
			try mainContainer.encodeIfPresent(name, forKey: .name)
		}
		if let description {
			try mainContainer.encodeIfPresent(description, forKey: .description)
		}
	}
}