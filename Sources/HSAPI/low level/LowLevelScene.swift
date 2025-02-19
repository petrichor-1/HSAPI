///The structure used to define a scene.
struct LowLevelScene {
	///The filename of the thumbnail for the scene in the scene selector
	var filename: String?
	///The name of the scene
	var name: String?
	///The unique id of the scene
	var id: String?
	///A list of object ids referencing the objects in the scene
	var objects: [String]?

	/// Extra data. Will be overwritten by values in full regular properties when jsonified, if applicable
	var extraData = [String: JSONType]()
}

extension LowLevelScene: Codable {
	enum CodingKeys: String, CodingKey {
		case filename
		case name
		case id
		case objects
	}
	
	init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ArbitraryStringCodingKeys.self)
        for key in container.allKeys {
            if let knownKey = CodingKeys(stringValue: key.stringValue) { 
                switch knownKey {
				case .filename:
					if let filename = try? container.decode(String.self, forKey: key) {
						self.filename = filename
					} else {
						extraData[key.stringValue] = try container.decode(JSONType.self, forKey: key)
					}
				case .name:
					if let name = try? container.decode(String.self, forKey: key) {
						self.name = name
					} else {
						extraData[key.stringValue] = try container.decode(JSONType.self, forKey: key)
					}
				case .id:
					if let id = try? container.decode(String.self, forKey: key) {
						self.id = id
					} else {
						extraData[key.stringValue] = try container.decode(JSONType.self, forKey: key)
					}
				case .objects:
					if let objects = try? container.decode([String].self, forKey: key) {
						self.objects = objects
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
		if let filename {
			try mainContainer.encodeIfPresent(filename, forKey: .filename)
		}
		if let name {
			try mainContainer.encodeIfPresent(name, forKey: .name)
		}
		if let id {
			try mainContainer.encodeIfPresent(id, forKey: .id)
		}
		if let objects {
			try mainContainer.encodeIfPresent(objects, forKey: .objects)
		}
	}
}