import SwiftUI

struct Badge: View {
	let text: String
	let foreground: Color
	let background: Color

	var body: some View {
		Text(text)
			.font(.subheadline)
			.padding(6)
			.foregroundStyle(foreground)
			.background {
				Capsule()
					.fill(background)
					.stroke(foreground)
			}
	}
}