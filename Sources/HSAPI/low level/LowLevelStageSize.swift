/// Represents the stage size of a project
struct LowLevelStageSize {
	var width: Double?
	var height: Double?

	/// Extra data. Will be overwritten by values in full regular properties when jsonified, if applicable
	var extraData = [String: JSONType]()
}

extension LowLevelStageSize: Codable {
	enum CodingKeys: String, CodingKey {
		case width
		case height
	}
	
	init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ArbitraryStringCodingKeys.self)
        for key in container.allKeys {
            if let knownKey = CodingKeys(stringValue: key.stringValue) { 
                switch knownKey {
				case .width:
					if let width = try? container.decode(Double.self, forKey: key) {
						self.width = width
					} else {
						extraData[key.stringValue] = try container.decode(JSONType.self, forKey: key)
					}
				case .height:
					if let height = try? container.decode(Double.self, forKey: key) {
						self.height = height
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
		if let width {
			try mainContainer.encodeIfPresent(width, forKey: .width)
		}
		if let height {
			try mainContainer.encodeIfPresent(height, forKey: .height)
		}
	}
}