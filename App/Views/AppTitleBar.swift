//
//  AppTitleBar.swift
//  Arbitrage
//
//  Created by Randy Hill on 4/18/21.
//

import SwiftUI

struct AppTitleBar: View {
    @EnvironmentObject var db: Database
    @Binding var isShowingDetailView: Bool
    @Binding var title: String
    @State private var animationOn = false

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text($title.wrappedValue)
                    .font(.title)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer(minLength: 80.0)
                Button(action: {
                    isShowingDetailView = true
                }, label: {
                    Image(systemName: "pencil.circle.fill")
                            .font(.largeTitle)
                })
                .frame(alignment: .trailing)
                Spacer(minLength: 20.0)
                Button(action: {
#if DEV
                Test.addDataToQuotes = true
#endif
                    withAnimation {
                        animationOn = true
                        db.refreshAllSymbols {
                            animationOn = false 
                        }
                    }
                 }, label: {
                    Image(systemName: "arrow.clockwise.circle.fill")
                        .font(.largeTitle)
                        .animation(.easeInOut)
                        .rotationEffect(animationOn ? .degrees(90) : .degrees(0))
                        .scaleEffect(animationOn ? 2.0 : 1.0)
               })
                .frame(alignment: .trailing)
            }
        }
    }
}

struct AppTitleBar_Previews: PreviewProvider {
    static var previews: some View {
        AppTitleBar(isShowingDetailView: .constant(false), title: .constant("Positions"))
    }
}
