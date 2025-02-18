/// Represents the raw json of a block
struct LowLevelBlock {
	var blockClass: String?
	var description: String?
	var keyboardName: String?
	var type: Double?
	/// Note that this MAY in some cases decode differently to Hopscotch. Do not rely on this
	/// decoded value for anything important unless you confirm that `extraData` does not have
	/// anything with the key "params" or "parameters" that contradicts this decoded value
	var parameters: [LowLevelParameter]?
	var controlScript: LowLevelControlScript?
	var controlFalseScript: LowLevelControlScript?
	
	var parameterKey: ParameterKey?

	var extraData = [String: JSONType]()

	enum ParameterKey {
		case parameters
		case params
	}
}

extension LowLevelBlock: Decodable {
	enum CodingKeys: String, CodingKey {
		case blockClass = "block_class"
		case description = "description"
		case keyboardName
		case type

		case parameters = "parameters"
		case params = "params"

		case controlScript
		case controlFalseScript
	}
	
	init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ArbitraryStringCodingKeys.self)
        for key in container.allKeys {
            if let knownKey = CodingKeys(stringValue: key.stringValue) { 
                switch knownKey {
				case .blockClass: 
					if let blockClass = try? container.decode(String.self, forKey: key) {
						self.blockClass = blockClass
					} else {
						extraData[key.stringValue] = try container.decode(JSONType.self, forKey: key)
					}
				case .description: 
					if let description = try? container.decode(String.self, forKey: key) {
						self.description = description
					} else {
						extraData[key.stringValue] = try container.decode(JSONType.self, forKey: key)
					}
				case .keyboardName: 
					if let keyboardName = try? container.decode(String.self, forKey: key) {
						self.keyboardName = keyboardName
					} else {
						extraData[key.stringValue] = try container.decode(JSONType.self, forKey: key)
					}
				case .type: 
					if let type = try? container.decode(Double.self, forKey: key) {
						self.type = type
					} else {
						extraData[key.stringValue] = try container.decode(JSONType.self, forKey: key)
					}
				case .controlScript: 
					if let controlScript = try? container.decode(LowLevelControlScript.self, forKey: key) {
						self.controlScript = controlScript
					} else {
						extraData[key.stringValue] = try container.decode(JSONType.self, forKey: key)
					}
				case .controlFalseScript: 
					if let controlFalseScript = try? container.decode(LowLevelControlScript.self, forKey: key) {
						self.controlFalseScript = controlFalseScript
					} else {
						extraData[key.stringValue] = try container.decode(JSONType.self, forKey: key)
					}
				case .parameters:
					// Note that whichever is decoded first will be what is in the hsapi value, which may be different from
					//      what other decoders use
					let parameters = try? container.decode([LowLevelParameter].self, forKey: key)
					if self.parameters == nil && parameters != nil {
						self.parameters = parameters
						self.parameterKey = .parameters
					} else {
						extraData[key.stringValue] = try container.decode(JSONType.self, forKey: key)
					}
				case .params:
					// Note that whichever is decoded first will be what is in the hsapi value, which may be different from
					//      what other decoders use
					let params = try? container.decode([LowLevelParameter].self, forKey: key)
					if self.parameters == nil && params != nil {
						self.parameters = params
						self.parameterKey = .params
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
}