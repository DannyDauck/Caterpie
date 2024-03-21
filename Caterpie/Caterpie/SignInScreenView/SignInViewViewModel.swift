//
//  SignInViewViewModel.swift
//  Caterpie
//
//  Created by Danny Dauck on 18.03.24.
//

import Foundation

class SignInViewViewModel: ObservableObject{
    
    let repo = RemoteRepository.shared
    
    @Published var email: String = ""
    @Published var password : String = ""
    @Published var repeatPassword: String = ""
    @Published var passwordCheckText: String = ""
    @Published var register: Bool = true
    @Published var screenIndex: Int = 0
    
    
    @MainActor
    func signInWithEmail(success: @escaping (Bool, String?)->()){
        if register{
            if passwordSecureTest(){
                Task{
                    do{
                        let id = try await repo.createUserWithEmail(email: email, password: password)
                        passwordCheckText = ""
                        success(true, id)
                        createEmptyFbUser(id)
                    }catch{
                        passwordCheckText = "tt_something_went_wrong_while_sign_in"
                        success(false, nil)
                    }
                }
            }else {
                success(false, nil)
            }
        }else{
            Task{
                do{
                    let id = try await repo.getUser(email: email, password: password)
                    passwordCheckText = ""
                    success(true, id)
                }catch{
                    print("Error occured while login to firebase: \(error)")
                    passwordCheckText = "tt_something_went_wrong_while_sign_in"
                    success(false, nil)
                }
            }
        }
    }
    
    func passwordSecureTest()-> Bool{
        if password == repeatPassword{
            if password.count > 7{
                if password.lowercased() != password && password.uppercased() != password{
                    return true
                }else{
                    passwordCheckText = "tt_the_password_musst_contains_small_and_capital_letters"
                    return false
                }
            }else{
                passwordCheckText = "tt_password_ is_to_short"
                return false
            }
        }else{
            passwordCheckText = "tt_passwords_not_matching"
            return false
        }
    }
    
    
    func createEmptyFbUser(_ id: String){
        let user = User(id: id, firstName: "", lastName: "", adresse: Adresse(street: "", postalCode: "", city: ""), companyName: "", stores: [])
        Task{
            RemoteRepository.shared.upsertUser(user)
        }
    }
    
}
