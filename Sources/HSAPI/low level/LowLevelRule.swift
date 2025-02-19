///The definition of a rule
struct LowLevelRule {
	///The id of the ability this rule contains
	var abilityID: String?
	///The unique id of the ability
	/// Must also not be the same as any custom rule instances
	var id: String?
	/// TODO: Figure out what this does
	/// Often empty string
	var objectID: String?
	///TODO: Figure out what this does
	/// often empty string
	/// Unused in webplayer
	/// Can be absent without issue
	var name: String?
	///The parameters for this rule
	/// TODO: Elaborate more
	var parameters: [LowLevelParameter]?
	///The type of the block in this rule
	/// TODO: Change the name of this in HSAPI?
	var ruleBlockType: Double?

	/// Extra data. Will be overwritten by values in full regular properties when jsonified, if applicable
	var extraData = [String: JSONType]()
}

extension LowLevelRule: Codable {
	enum CodingKeys: String, CodingKey {
		case abilityID
		case id
		case objectID
		case name
		case parameters
		case ruleBlockType
	}
	
	init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ArbitraryStringCodingKeys.self)
        for key in container.allKeys {
            if let knownKey = CodingKeys(stringValue: key.stringValue) { 
                switch knownKey {
				case .abilityID:
					if let abilityID = try? container.decode(String.self, forKey: key) {
						self.abilityID = abilityID
					} else {
						extraData[key.stringValue] = try container.decode(JSONType.self, forKey: key)
					}
				case .id:
					if let id = try? container.decode(String.self, forKey: key) {
						self.id = id
					} else {
						extraData[key.stringValue] = try container.decode(JSONType.self, forKey: key)
					}
				case .objectID:
					if let objectID = try? container.decode(String.self, forKey: key) {
						self.objectID = objectID
					} else {
						extraData[key.stringValue] = try container.decode(JSONType.self, forKey: key)
					}
				case .name:
					if let name = try? container.decode(String.self, forKey: key) {
						self.name = name
					} else {
						extraData[key.stringValue] = try container.decode(JSONType.self, forKey: key)
					}
				case .parameters:
					if let parameters = try? container.decode([LowLevelParameter].self, forKey: key) {
						self.parameters = parameters
					} else {
						extraData[key.stringValue] = try container.decode(JSONType.self, forKey: key)
					}
				case .ruleBlockType:
					if let ruleBlockType = try? container.decode(Double.self, forKey: key) {
						self.ruleBlockType = ruleBlockType
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
		if let abilityID {
			try mainContainer.encodeIfPresent(abilityID, forKey: .abilityID)
		}
		if let id {
			try mainContainer.encodeIfPresent(id, forKey: .id)
		}
		if let objectID {
			try mainContainer.encodeIfPresent(objectID, forKey: .objectID)
		}
		if let name {
			try mainContainer.encodeIfPresent(name, forKey: .name)
		}
		if let parameters {
			try mainContainer.encodeIfPresent(parameters, forKey: .parameters)
		}
		if let ruleBlockType {
			try mainContainer.encodeIfPresent(ruleBlockType, forKey: .ruleBlockType)
		}
	}
}