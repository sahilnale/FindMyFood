import SwiftUI

struct FriendListView: View {
    @Environment(\.presentationMode) var presentationMode

    var friends = ["Nikhil Kichili", "Krishna Dua", "Dhruv Patak"]

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.blue)
                        .padding()
                }
                Spacer()
            }
            .padding()

            ScrollView {
                VStack(spacing: 20) {
                    ForEach(friends, id: \.self) { friend in
                        VStack {
                            Text(friend)
                                .font(.headline)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 2)
                        .padding([.leading, .trailing], 10)
                    }
                }
            }
        }
    }
}

struct FriendListView_Previews: PreviewProvider {
    static var previews: some View {
        FriendListView()
    }
}
