struct LowLevelSceneReference {
	var id: String?
	var blockType: Double?
	var description: String?
	var scene: String?

	var extraData = [String: JSONType]()
}

extension LowLevelSceneReference: Codable {
	enum CodingKeys: String, CodingKey {
		case id
		case blockType
		case description
		case scene
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
				case .blockType:
					if let blockType = try? container.decode(Double.self, forKey: key) {
						self.blockType = blockType
					} else {
						extraData[key.stringValue] = try container.decode(JSONType.self, forKey: key)
					}
				case .description:
					if let description = try? container.decode(String.self, forKey: key) {
						self.description = description
					} else {
						extraData[key.stringValue] = try container.decode(JSONType.self, forKey: key)
					}
				case .scene:
					if let scene = try? container.decode(String.self, forKey: key) {
						self.scene = scene
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
		if let id {
			try mainContainer.encodeIfPresent(id, forKey: .id)
		}
		if let blockType {
			try mainContainer.encodeIfPresent(blockType, forKey: .blockType)
		}
		if let description {
			try mainContainer.encodeIfPresent(description, forKey: .description)
		}
		if let scene {
			try mainContainer.encodeIfPresent(scene, forKey: .scene)
		}
	}
}