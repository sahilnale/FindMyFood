import SwiftUI

struct LoginView: View {
    @Binding var isLoggedIn: Bool
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showCreateAccount = false
    @StateObject private var viewModel = AuthViewModel.shared

    var body: some View {
        VStack {
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

            Button(action: {
                Task {
                    do {
                        try await viewModel.signIn(withEmail: email, password: password)
                        isLoggedIn = true
                    } catch {
                        print("Failed to sign in: \(error.localizedDescription)")
                    }
                }
            }) {
                Text("Login")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .padding()

            Button(action: {
                showCreateAccount = true
            }) {
                Text("Create Account")
                    .foregroundColor(.blue)
            }
            .padding()
            .sheet(isPresented: $showCreateAccount) {
                CreateAccountView()
            }
        }
        .padding()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(isLoggedIn: .constant(false))
    }
}
