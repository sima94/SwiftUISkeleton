//
//  Register.swift
//  SwiftUISkeletron
//
//  Created by Stefan Simic on 8.5.25..
//

import SwiftUI

struct RegisterView: View {

	var viewModel: RegisterViewModel

	var body: some View {
		Text("Hello, RegisterView!")
	}
}

#Preview {
	RegisterView(viewModel: RegisterViewModel())
}
