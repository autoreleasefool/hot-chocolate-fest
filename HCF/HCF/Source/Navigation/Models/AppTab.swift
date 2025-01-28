enum AppTab: Hashable, Identifiable {
	case flavours
	case map
	case vendors

	var id: Self { self }
}
