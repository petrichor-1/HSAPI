///A trait. Used in parameter datums and the top level of a project
struct LowLevelTrait {
	///A string description of the type of the trait. Not used by anything
	var description: String?
	///The unique id of this trait.
	/// TODO: What does this do?
	var traitID: String?
	///The ID of the object that this trait references
	/// (i.e.) if this trait is the x position of object "Jeff", `objectID` will be the objectID of object "Jeff"
	var objectID: String?
	///TODO: Figure out what the heck this even means
	/// In the player, it is only used to check if it “uses original object”. 
	///    It is considered to do so if either `type` is `HSBlockType.OriginalObject` or if `objectParameterType` is `HSBlockType.OriginalObject`
	var objectParameterType: Double?
	///The type of the trait
	var type: Double?

	/// Extra data. Will be overwritten by values in full regular properties when jsonified, if applicable
	var extraData = [String: JSONType]()
}

extension LowLevelTrait: Codable {
	enum CodingKeys: String, CodingKey {
		case description
		case traitID = "HSTraitIDKey"
		case objectID = "HSTraitObjectIDKey"
		case objectParameterType = "HSTraitObjectParameterTypeKey"
		case type = "HSTraitTypeKey"
	}
	
	init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ArbitraryStringCodingKeys.self)
        for key in container.allKeys {
            if let knownKey = CodingKeys(stringValue: key.stringValue) { 
                switch knownKey {
				case .description:
					if let description = try? container.decode(String.self, forKey: key) {
						self.description = description
					} else {
						extraData[key.stringValue] = try container.decode(JSONType.self, forKey: key)
					}
				case .traitID:
					if let traitID = try? container.decode(String.self, forKey: key) {
						self.traitID = traitID
					} else {
						extraData[key.stringValue] = try container.decode(JSONType.self, forKey: key)
					}
				case .objectID:
					if let objectID = try? container.decode(String.self, forKey: key) {
						self.objectID = objectID
					} else {
						extraData[key.stringValue] = try container.decode(JSONType.self, forKey: key)
					}
				case .objectParameterType:
					if let objectParameterType = try? container.decode(Double.self, forKey: key) {
						self.objectParameterType = objectParameterType
					} else {
						extraData[key.stringValue] = try container.decode(JSONType.self, forKey: key)
					}
				case .type:
					if let type = try? container.decode(Double.self, forKey: key) {
						self.type = type
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
		if let description {
			try mainContainer.encodeIfPresent(description, forKey: .description)
		}
		if let traitID {
			try mainContainer.encodeIfPresent(traitID, forKey: .traitID)
		}
		if let objectID {
			try mainContainer.encodeIfPresent(objectID, forKey: .objectID)
		}
		if let objectParameterType {
			try mainContainer.encodeIfPresent(objectParameterType, forKey: .objectParameterType)
		}
		if let type {
			try mainContainer.encodeIfPresent(type, forKey: .type)
		}
	}
}