/// Represents the raw json of a block
struct LowLevelBlock {
	///The class of block
	/// TODO: Explain effects of this being incorrect in the iOS editor
	/// Usually "method" for normal blocks, "control" for e.g. repeat, "conditionalControl" for conditional blocks like check once if, "conditionalOperator" for comparison operators like `>`, `<`, `and`, etc., "operator" for other operators
	/// The webplayer ignores this
	var blockClass: String?
	///The name of the block type
	/// Not displayed anywhere
	/// Can be omitted
	var description: String?
	///Added by the new hopscotch.fun web editor.
	/// TODO: Elaborate more
	var keyboardName: String?
	///The block type
	var type: Double?
	/// The parameters for this block
	/// Note that this MAY in some cases decode differently to Hopscotch. Do not rely on this
	/// decoded value for anything important unless you confirm that `extraData` does not have
	/// anything with the key "params" or "parameters" that contradicts this decoded value
	var parameters: [LowLevelParameter]?
	///The controlScript used for any sub-abilities, except for `else` in check if else blocks.
	var controlScript: LowLevelControlScript?
	///The controlScript for the `else` part of `check_if_else` blocks.
	var controlFalseScript: LowLevelControlScript?
	
	///Which key is used for parameters?
	/// The webplayer will understand both in all situations
	/// TODO: Will the editor?
	/// .parameters for method blocks, .params for operator blocks
	var parameterKey: ParameterKey?

	/// Extra data. Will be overwritten by values in full regular properties when jsonified, if applicable
	var extraData = [String: JSONType]()

	enum ParameterKey {
		/// Used for method blocks in abilities
		case parameters
		/// Used for operator blocks in parameters
		case params
	}
}

extension LowLevelBlock: Codable {
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

	func encode(to encoder: Encoder) throws {
		var extraDataContainer = encoder.container(keyedBy: ArbitraryStringCodingKeys.self)
		for (key, value) in extraData {
			try extraDataContainer.encode(value, forKey: ArbitraryStringCodingKeys(stringValue: key))
		}
		var mainContainer = encoder.container(keyedBy: CodingKeys.self)
		if let blockClass {
			try mainContainer.encodeIfPresent(blockClass, forKey: .blockClass)
		}
		if let description {
			try mainContainer.encodeIfPresent(description, forKey: .description)
		}
		if let keyboardName {
			try mainContainer.encodeIfPresent(keyboardName, forKey: .keyboardName)
		}
		if let type {
			try mainContainer.encodeIfPresent(type, forKey: .type)
		}
		if let controlScript {
			try mainContainer.encodeIfPresent(controlScript, forKey: .controlScript)
		}
		if let controlFalseScript {
			try mainContainer.encodeIfPresent(controlFalseScript, forKey: .controlFalseScript)
		}
		if let parameters {
			// Arbitrary choice of default parameter key. There shouldn't really be a situation where one is set without the other caused by HSAPI code,
			//           but if the user directly deals with low level objects that could happen. In that case, assume that they don't mind whatever we pick :)
			switch parameterKey ?? .parameters {
			case .parameters:
				try mainContainer.encode(parameters, forKey: .parameters)
			case .params:
				try mainContainer.encode(parameters, forKey: .params)
			}
		}
	}
}