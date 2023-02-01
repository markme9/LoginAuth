//
//  ContentView.swift
//  LoginAuth
//
//  Created by Mark on 2/1/23.
//

import SwiftUI
import FirebaseAuth
import Combine

class User: ObservableObject {
    @Published var isLoggedIn: Bool = false
    
    let auth = FirebaseAuth.Auth.auth()
    func signOut() {
        do {
            try auth.signOut()
            self.isLoggedIn = false
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct ContentView: View {
    @State private var cancellables = Set<AnyCancellable>()
    @EnvironmentObject var user: User
    @State var email: String = ""
    @State var password: String = ""
    @State var isLoading: Bool = false
    @State var error: String = ""
    @State var showSignUp = false
    
    var signInPublisher: AnyPublisher<Void, Error> {
        return Future { promise in
            self.user.auth.signIn(withEmail: self.email, password: self.password) { (result, error) in
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
        NavigationView {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                if !user.isLoggedIn {
                    VStack {
                        Image("login")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 350)
                            .offset(y: -50)
                        
                        Text("Log in")
                            .font(.system(size: 40))
                            .fontWeight(.semibold)
                            .foregroundColor(Color.white)
                            .offset(y: -55)
                            .offset(x: -125)
                        
                        TextField("Email", text: $email)
                            .padding()
                            .textInputAutocapitalization(.never)
                            .disableAutocorrection(true)
                            .frame(maxWidth: .infinity)
                            .frame(height: 45)
                            .background(Color.white)
                            .cornerRadius(10)
                            .offset(y: -70)
                        
                        SecureField("Password", text: $password)
                            .padding()
                            .textInputAutocapitalization(.never)
                            .disableAutocorrection(true)
                        
                            .frame(maxWidth: .infinity)
                            .frame(height: 45)
                            .background(Color.white)
                            .cornerRadius(10)
                            .offset(y: -65)
                        
                        
                        if isLoading {
                            ProgressView()
                                .tint(Color.white)
                            
                        } else {
                            Button(action: {
                                self.isLoading = true
                                self.signInPublisher
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
                                        // Sign in successful
                                        user.isLoggedIn = true
                                        UserDefaults.standard.set(true, forKey: "isLoggedIn")
                                    })
                                    .store(in: &self.cancellables)
                            }) {
                                Text("Log in")
                                    .font(.system(size: 20))
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 45)
                                    .background(Color.pink)
                                    .foregroundColor(Color.white)
                                    .cornerRadius(10)
                                
                            }
                            .offset(y: -60)
                            Text(error)
                                .foregroundColor(.red)
                                .offset(y: -50)
                            
                            HStack {
                                Text("Don't have an account yet?")
                                    .font(.headline)
                                    .foregroundColor(Color.white)
                                Button {
                                    self.showSignUp.toggle()
                                } label: {
                                    Text("Create one")
                                        .font(.headline)
                                        .foregroundColor(Color.yellow)
                                    
                                }
                            }
                            
                        }
                        
                    }
                    .padding([.leading, .trailing])
                    
                } else {
                    HomeView().environmentObject(user)
                }
            }
            .fullScreenCover(isPresented: $showSignUp, content: {
                SignUpView(isLoading: $isLoading, error: $error)
            })
            
            .onAppear {
                self.user.isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(User())
        
    }
}
