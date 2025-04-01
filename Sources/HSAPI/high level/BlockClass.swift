enum BlockClass {
	case unknown(String)
}

extension BlockClass {
	init(stringValue: String) {
		self = .unknown(stringValue)
	}
}