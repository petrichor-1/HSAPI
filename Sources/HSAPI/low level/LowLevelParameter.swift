struct LowLevelParameter {
	var defaultValue: String?
	var value: String?
	var key: String?
	var type: Double?
	var variable: String?
	var datum: LowLevelParameterDatum?

	var extraData = [String: JSONType]()
}

extension LowLevelParameter: Decodable {
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
}