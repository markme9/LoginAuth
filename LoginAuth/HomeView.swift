//
//  HomeView.swift
//  LoginAuth
//
//  Created by Mark on 2/1/23.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var user: User
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            VStack {
                VStack(alignment: .leading) {
                    Text("Welcome \nto the home Screen !")
                        .font(.system(size: 50))
                        .fontWeight(.semibold)
                        .foregroundColor(.green)
                }
                Button {
                    self.user.signOut()
                } label: {
                    Text("Sign out")
                        .fontWeight(.semibold)
                        .padding(.all, 5)
                    
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
                .tint(Color.red)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(User())
    }
}
