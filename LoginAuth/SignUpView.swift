//
//  SignUpView.swift
//  LoginAuth
//
//  Created by Mark on 2/1/23.
//

import SwiftUI
import FirebaseAuth
import Combine

struct SignUpView: View {
    @EnvironmentObject var user: User
    @State var email: String = ""
    @State var password: String = ""
    @Binding var isLoading: Bool
    @Binding var error: String
    @State private var cancellables = Set<AnyCancellable>()
    @Environment (\.dismiss) var dismiss
    var signUpPublisher: AnyPublisher<Void, Error> {
        return Future { promise in
            self.user.auth.createUser(withEmail: self.email, password: self.password) { (result, error) in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.black
                .ignoresSafeArea()
            VStack {
                Image("singup")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 350)
                    .offset(y: -25)
                
                Text("Sign up")
                    .font(.system(size: 40))
                    .fontWeight(.semibold)
                    .foregroundColor(Color.white)
                
                    .offset(x: -113)
                    .offset(y: -40)
                
                TextField("Email", text: $email)
                    .padding()
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                
                    .frame(maxWidth: .infinity)
                    .frame(height: 45)
                    .background(Color.white)
                    .cornerRadius(10)
                    .offset(y: -50)
                
                SecureField("Password", text: $password)
                    .padding()
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                
                    .frame(maxWidth: .infinity)
                    .frame(height: 45)
                    .background(Color.white)
                    .cornerRadius(10)
                    .offset(y: -45)
                
                
                if isLoading {
                    ProgressView()
                        .tint(Color.white)
                } else {
                    
                    Button {
                        self.isLoading = true
                        self.signUpPublisher
                            .receive(on: DispatchQueue.main)
                            .sink(receiveCompletion: { (completion) in
                                switch completion {
                                case .failure(let error):
                                    self.error = error.localizedDescription
                                case .finished:
                                    break
                                }
                                self.isLoading = false
                            }, receiveValue: { _ in
                                // Sign up successful
                                self.user.isLoggedIn = true
                                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                            })
                            .store(in: &self.cancellables)
                        
                        
                    } label: {
                        Text("Create account")
                            .font(.system(size: 20))
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .frame(height: 45)
                            .background(Color.pink)
                            .foregroundColor(Color.white)
                            .cornerRadius(10)
                        
                    }
                    .offset(y: -40)
                    Spacer()
                }
                Text(error)
                    .foregroundColor(.red)
                    .offset(y: -65)
                
                
            }.padding()
            
            Image(systemName: "xmark")
                .fontWeight(.semibold)
                .frame(width: 30, height: 30)
                .foregroundColor(Color.white)
                .onTapGesture {
                    withAnimation {
                        dismiss()
                    }
                }
        }
    }
}


struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(isLoading: .constant(false), error: .constant(""))
    }
}
