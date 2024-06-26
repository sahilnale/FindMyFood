import SwiftUI

struct CreateAccountView: View {
    @State private var fullname: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @StateObject private var viewModel = AuthViewModel.shared
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            Text("Create Account")
                .font(.largeTitle)
                .padding(.bottom, 20)

            TextField("Name", text: $fullname)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .autocapitalization(.words)
                .padding(.bottom, 20)

            TextField("Email", text: $email)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
                .padding(.bottom, 20)

            SecureField("Password", text: $password)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .padding(.bottom, 20)

            SecureField("Confirm Password", text: $confirmPassword)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .padding(.bottom, 20)

            Button(action: {
                Task {
                    do {
                        try await viewModel.createUser(withEmail: email, password: password, fullname: fullname)
                        presentationMode.wrappedValue.dismiss()
                    } catch {
                        print("Failed to create user: \(error.localizedDescription)")
                    }
                }
            }) {
                Text("Create Account")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .padding()
        }
        .padding()
    }
}

struct CreateAccountView_Previews: PreviewProvider {
    static var previews: some View {
        CreateAccountView()
    }
}
