struct LowLevelParameter {
	var defaultValue: String?
	var value: String?
	var key: String?
	var type: Double?
	var variable: String?
	var datum: LowLevelParameterDatum?

	var extraData = [String: JSONType]()
}

extension LowLevelParameter: Codable {
	enum CodingKeys: String, CodingKey {
		case defaultValue
		case value
		case key
		case type
		case variable
		case datum
	}
	
	init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ArbitraryStringCodingKeys.self)
        for key in container.allKeys {
            if let knownKey = CodingKeys(stringValue: key.stringValue) { 
                switch knownKey {
				case .defaultValue:
					if let defaultValue = try? container.decode(String.self, forKey: key) {
						self.defaultValue = defaultValue
					} else {
						extraData[key.stringValue] = try container.decode(JSONType.self, forKey: key)
					}
				case .value:
					if let value = try? container.decode(String.self, forKey: key) {
						self.value = value
					} else {
						extraData[key.stringValue] = try container.decode(JSONType.self, forKey: key)
					}
				case .key:
					if let key = try? container.decode(String.self, forKey: key) {
						self.key = key
					} else {
						extraData[key.stringValue] = try container.decode(JSONType.self, forKey: key)
					}
				case .type:
					if let type = try? container.decode(Double.self, forKey: key) {
						self.type = type
					} else {
						extraData[key.stringValue] = try container.decode(JSONType.self, forKey: key)
					}
				case .variable:
					if let variable = try? container.decode(String.self, forKey: key) {
						self.variable = variable
					} else {
						extraData[key.stringValue] = try container.decode(JSONType.self, forKey: key)
					}
				case .datum:
					if let datum = try? container.decode(LowLevelParameterDatum.self, forKey: key) {
						self.datum = datum
					} else {
						extraData[key.stringValue] = try container.decode(JSONType.self, forKey: key)
					}
				}
                continue
            }

            let value = try container.decode(JSONType.self, forKey: key)
            extraData[key.stringValue] = value
        }
		if self.type == 54 /*HSParameterType.Object*/ && self.datum != nil {
			// Need to redo datum as set image block
			let setImageDatum = try container.decode(LowLevelSetImageDatum.self, forKey: ArbitraryStringCodingKeys(stringValue: "datum"))
			self.datum = .setImage(setImageDatum)
		}
    }

	func encode(to encoder: Encoder) throws {
		var extraDataContainer = encoder.container(keyedBy: ArbitraryStringCodingKeys.self)
		for (key, value) in extraData {
			try extraDataContainer.encode(value, forKey: ArbitraryStringCodingKeys(stringValue: key))
		}
		var mainContainer = encoder.container(keyedBy: CodingKeys.self)
		if let defaultValue {
			try mainContainer.encodeIfPresent(defaultValue, forKey: .defaultValue)
		}
		if let value {
			try mainContainer.encodeIfPresent(value, forKey: .value)
		}
		if let key {
			try mainContainer.encodeIfPresent(key, forKey: .key)
		}
		if let type {
			try mainContainer.encodeIfPresent(type, forKey: .type)
		}
		if let variable {
			try mainContainer.encodeIfPresent(variable, forKey: .variable)
		}
		if let datum {
			try mainContainer.encodeIfPresent(datum, forKey: .datum)
		}
	}
}