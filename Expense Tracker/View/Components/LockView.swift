//
//  LockView.swift
//  Expense Tracker
//
//  Created by Manuchim Oliver on 16/12/2023.
//

import SwiftUI
import LocalAuthentication

struct LockView<Content: View>: View {
    var lockType: LockType
    var lockPin: String
    var isEnabled: Bool
    var lockWhenAppGoesBackground: Bool = true
    @ViewBuilder var content: Content
    
    // View properties
    @State private var pin: String = ""
    var forgotPin: () -> () = {  }
    @State private var animateField: Bool = false
    @State private var isUnlocked: Bool = false
    @State private var noBiometricAccess: Bool = false
    
    // Lock context
    let context = LAContext()
    
    // scene phase
    @Environment(\.scenePhase) private var phase
    
    var body: some View {
        GeometryReader  {
            let size = $0.size
            
            content
                .frame(width: size.width, height: size.height)
            
            if isEnabled && !isUnlocked {
                ZStack{
                    Rectangle()
                        .fill(.black)
                        .ignoresSafeArea()
                    if (lockType == .both && !noBiometricAccess) || lockType == .biometric {
                        Group{
                            if noBiometricAccess {
                                Text("Please enable biometric access in settings to unlock with FaceID/Fingerprint")
                                    .font(.callout)
                                    .multilineTextAlignment(.center)
                                    .padding(50)
                            } else {
                                // biometric unlock
                                VStack(spacing: 12){
                                    VStack(spacing: 6){
                                        Image(systemName: "lock")
                                            .font(.largeTitle)
                                        
                                        Text("Tap to unlock")
                                            .font(.caption2)
                                            .foregroundStyle(.gray)
                                    }
                                    .frame(width: 100, height: 100)
                                    .background(.ultraThinMaterial, in: .rect(cornerRadius: 10))
                                    .contentShape(.rect)
                                    .onTapGesture {
                                        unlockView()
                                    }
                                    
                                    if lockType == .both {
                                        Text("Enter pin")
                                            .frame(width: 100, height: 40)
                                            .background(.ultraThinMaterial, in: .rect(cornerRadius: 10))
                                            .contentShape(.rect)
                                            .onTapGesture {
                                                noBiometricAccess = true
                                            }
                                    }
                                }
                            }
                        }
                    } else {
                        // custom number pad to type Vew Lock pin
                        NumberPadView()
                    }
                }
                .environment(\.colorScheme, .dark)
                .transition(.offset(y: size.height + 100))
                
            }
        }
        .onChange(of: isEnabled, initial: true) { oldValue, newValue in
            if newValue {
                unlockView()
            }
        }
        .onChange(of: phase) { oldValue, newValue in
            if newValue != .active && lockWhenAppGoesBackground {
                isUnlocked = false
                pin = ""
            }
            
            if newValue == .active && !isUnlocked && isEnabled {
                unlockView()
            }
        }
    }
    
    private func unlockView() {
        Task{
            if isBiometricAvailable && lockType != .number {
                // requesting  biometric unlock
                if let result = try? await context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Unlock the View"), result {
                    print("Unlocked")
                    withAnimation(.snappy, completionCriteria: .logicallyComplete){
                        isUnlocked = true
                    } completion: {
                        pin = ""
                    }
                }
            }
            
            // No biometric permission, therefore set lockc type to keypad and update biometric status
            noBiometricAccess = !isBiometricAvailable
        }
        
    }
    
    private var isBiometricAvailable: Bool {
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }
    
    // custom number pad view
    @ViewBuilder
    private func NumberPadView() -> some View {
        VStack(spacing: 15){
            Text("Enter pin")
                .font(.title.bold())
                .frame(maxWidth: .infinity)
                .overlay(alignment: .leading){
                    // back button to b displayed when locktype is .both
                    if lockType == .both && isBiometricAvailable {
                        Button(action: {
                            pin = ""
                            noBiometricAccess = false
                        }, label: {
                            Image(systemName: "arrow.left")
                                .font(.title3)
                                .contentShape(.rect)
                        })
                        .tint(.white)
                        .padding(.leading)
                    }
                }
            
            // add wiggling animation when pin is wrong
            
            HStack(spacing: 10){
                ForEach(0..<4, id:\.self) { index in
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 50, height: 55)
                    
                    // show pin in boxes using indexes
                        .overlay{
                            if pin.count > index {
                                let index = pin.index(pin.startIndex, offsetBy: index)
                                let string = String(pin[index])
                                
                                Text(string)
                                    .font(.title.bold())
                                    .foregroundStyle(.black)
                            }
                        }
                }
            }
            .keyframeAnimator(initialValue: CGFloat.zero, trigger: animateField, content: {content, value in
                content
                    .offset(x: value)
                
            }, keyframes: { _ in
                KeyframeTrack{
                    CubicKeyframe(30, duration: 0.07)
                    CubicKeyframe(-30, duration: 0.07)
                    CubicKeyframe(20, duration: 0.07)
                    CubicKeyframe(-20, duration: 0.07)
                    CubicKeyframe(0, duration: 0.07)
                }
            })
            .padding(.top, 15)
            .overlay(alignment: .bottomTrailing, content: {
                Button("Forgot pin?", action: forgotPin)
                    .font(.callout)
                    .foregroundStyle(.white)
                    .offset(y: 40)
            })
            .frame(maxHeight: .infinity)
            
            // custom number pad
            GeometryReader{_ in
                LazyVGrid(columns: Array(repeating:  GridItem(), count: 3), content: {
                    ForEach(1...9,  id: \.self)  { number in
                        Button(action: {
                         // adding numbers with max value of 4
                            if pin.count <= 4{
                                pin.append("\(number)")
                            }
                        }, label: {
                            Text("\(number)")
                                .font(.title)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 20)
                                .contentShape(.rect)
                        })
                        .tint(.white)
                    }
                    
                    // 0 and Back button
                    Button(action: {
                        if !pin.isEmpty {
                            pin.removeLast()
                        }
                    }, label: {
                        Image(systemName: "delete.backward")                            .font(.title)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20)
                            .contentShape(.rect)
                    })
                    .tint(.white)
                    Button(action: {
                        if pin.count <= 4{
                            pin.append("0")
                        }
                    }, label: {
                        Text("0")
                            .font(.title)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20)
                            .contentShape(.rect)
                    })
                    .tint(.white)
                })
                .frame(maxHeight: .infinity, alignment: .bottom)
            }
            .onChange(of: pin) { oldValue, newValue in
                // validate entered pin
                if newValue.count == 4{
                    if lockPin == pin{
                        print("Correct Pin!")
                        withAnimation(.snappy, completionCriteria: .logicallyComplete){
                            isUnlocked = true
                        } completion: {
                            pin = ""
                            noBiometricAccess = !isBiometricAvailable
                        }
                    } else {
                        print("Wrong pin entered")
                        pin = ""
                        animateField.toggle()
                    }
                    
                }
            }
        }
        .padding()
        .environment(\.colorScheme, .dark)
    }
    
    enum LockType: String {
        case biometric = "Biometric Auth"
        case number =  "Custom Number Lock"
        case both = "First preference will be biometric, and if it's not available, it will go for number lock"
    }
}

#Preview {
    ContentView()
}
