enum BlockType {
	case unknown(Double)
}

extension BlockType {
	init(doubleValue: Double) {
		self = .unknown(doubleValue)
	}

	///The expected `description` for this type, or `nil` if one is not known
	var description: String? {
		get {
			switch self {
			case .unknown:
				return nil
			}
		}
	}
}