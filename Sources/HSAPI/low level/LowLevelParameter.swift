struct LowLevelParameter {
	///The default value of the parameter
	/// In the iOS editor, it is the grey text that shows up if you remove any actual value from it
	var defaultValue: String?
	///The actual value of the parameter
	/// This will be ignored if there is a `datum`
	var value: String?
	///The label for this parameter
	/// This actually shows up in the editor just to the left of the parameter
	/// (i.e. the "=" in an equals operator, or the "to" in a set variable block, or the "x" and "y" in a set position block)
	var key: String?
	///The parameter type
	var type: Double?
	///A variable id
	/// This is usally absent.
	/// The iOS editor only seems to add it in rules to reference eventParameters
	/// In the webplayer, if `datum` is falsy, and `variable` is not, the player will first search for a variable with this id. If it does not find one, it will then check for a trait. If there is no trait with this id either, then it will search for an eventParameter. Once it finds one, it will use it as the value of the parameter.
	var variable: String?
	///A child block
	/// if this is present, `value` will not be the actual value used, instead the computed value of the contents of `datum`.
	var datum: LowLevelParameterDatum?

	/// Extra data. Will be overwritten by values in full regular properties when jsonified, if applicable
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