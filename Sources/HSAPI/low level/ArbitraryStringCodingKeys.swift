struct ArbitraryStringCodingKeys: CodingKey {
	let stringValue: String
	var intValue: Int? { nil }

	init(stringValue: String) {
		self.stringValue = stringValue
	}

	init(intValue: Int) {
		fatalError("intValue is not supported for ArbitraryStringCodingKeys")
	}
}