//
//  ContentView.swift
//  CCTV Viewer
//
//  Created by Hing Tat Tsang on 13/7/2022.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {

    var url: URL

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

struct CameraView: View {
    var streamlink: String
    @State private var showingPopoverfull = false
    var name: String
    @State var zoom = Double(0)
    @State var streamQuality = Double(50)
    @State var exposure = Double(30)
    @State var torch: Bool
    @State var info = Bool(true)
    @State var photo = Bool(false)
    @State var night = Bool(false)
    @State private var rec = "1"
    var body: some View {
        ZStack {
            WebView(url: URL(string: "\(streamlink)/ptz?zoom=\(zoom)")!)
            let streamQualityint = Int(streamQuality)
            WebView(url: URL(string: "\(streamlink)/settings/quality?set=\(streamQualityint)")!)
            let exposureint = Int(exposure)-30
            WebView(url: URL(string: "\(streamlink)/settings/exposure?set=\(exposureint)")!)
            if torch == true {
                WebView(url: URL(string: "\(streamlink)/enabletorch")!)
            } else {
                WebView(url: URL(string: "\(streamlink)/disabletorch")!)
            }
            if info == true {
                WebView(url: URL(string: "\(streamlink)/settings/overlay?set=on")!)
            } else {
                WebView(url: URL(string: "\(streamlink)/settings/overlay?set=off")!)
            }
            if rec == "1" {
                
            } else if rec == "2" {
                WebView(url: URL(string: "\(streamlink)/startvideo?force=1&tag=rec")!)
            } else if rec == "3" {
                WebView(url: URL(string: "\(streamlink)/stopvideo?force=1")!)
            } else {
                
            }
            if photo == true {
                WebView(url: URL(string: "\(streamlink)/settings/ffc?set=on")!)
            } else {
                WebView(url: URL(string: "\(streamlink)/settings/ffc?set=off")!)
            }
            if night == true {
                WebView(url: URL(string: "\(streamlink)/settings/night_vision?set=on")!)
            } else {
                WebView(url: URL(string: "\(streamlink)/settings/night_vision?set=off")!)
            }
            
            
            
            VStack {
               
//
//                WebView(url: URL(string: "\(streamlink)/settings_window.html")!)
//
                List {
                    Section {
                        WebView(url: URL(string: "\(streamlink)/video")!)
                        .allowsHitTesting(false)
                        .aspectRatio(100/60, contentMode: .fit)
                        .onTapGesture {
                            showingPopoverfull = true
                        }
                    }
                    Section {
                        HStack {
                            Text("縮放")
                            Slider(value: $zoom, in: 0...30)
                            
                        }
                        HStack {
                            Text("質量")
                            Slider(value: $streamQuality, in: 1...100)
                        }
                        HStack {
                            Text("曝光")
                            Slider(value: $exposure, in: 1...60)
                        }
                        HStack {
                            Toggle("照明", isOn: $torch)
                        }
                        HStack {
                            Toggle("顯示資訊", isOn: $info)
                        }
                        HStack {
                            Toggle("切換前後鏡頭", isOn: $photo)
                        }
                        HStack {
                            Toggle("打開夜視功能", isOn: $night)
                        }
                        if rec == "1" {
                            HStack {
                                Text("錄製")
                                Spacer()
                                Button("開始") {
                                    rec = "2"
                                }
                                .padding(.horizontal)
                                
                            }
                        } else if rec == "2" {
                            HStack {
                                Text("錄製")
                                Spacer()
                                Button("結束") {
                                    rec = "3"
                                }
                                .padding(.horizontal)
                                
                            }
                        } else if rec == "3" {
                            HStack {
                                Text("錄製")
                                Spacer()
                                Button("開始") {
                                    rec = "2"
                                }
                                .padding(.horizontal)
                                
                            }
                        } else {
                            HStack {
                                Text("錄製")
                                Spacer()
                                Button("開始") {
                                    rec = "2"
                                }
                                .padding(.horizontal)
                                
                            }
                        }
                        HStack {
                            Button("打開鏡頭管理頁面") {
                                showingPopoverfull = true
                            }
                            
                        }
                    }
                }
            }
            
        }
        .fullScreenCover(isPresented: $showingPopoverfull) {
            VStack {
                ZStack {
                    HStack {
                        Spacer()
                        Button("退出") {
                            showingPopoverfull = false
                        }
                        .padding()
                    }
                    HStack {
                        Text("鏡頭管理頁面")
                            .padding()
                    }
                }
                WebView(url: URL(string: "\(streamlink)/videomgr.html")!)
            }
        }
    }

}

struct ContentView: View {
    @State private var showingPopover = false
    @State var ip = String("")
    @State var username = String("")
    @State var password = String("")
    @State var port = String("")
    @State private var logout = "1"
    @State var torch = Bool(false)
    var body: some View {
        ZStack {
            if logout == "1" {
                
            } else if logout == "2" {
    //            logined
                
            } else if logout == "3" {
    //            logout
                WebView(url: URL(string: "\("http://\(username):\(password)@\(ip):\(port)")/stopvideo?force=1")!)
                WebView(url: URL(string: "\("http://\(username):\(password)@\(ip):\(port)")/disabletorch")!)
                WebView(url: URL(string: "\("http://\(username):\(password)@\(ip):\(port)")/settings/night_vision?set=off")!)
            } else {
                
            }
            NavigationView {
                List {
                    Section {
                        HStack {
                            Text("IP地址:")
                            Spacer()
                            TextField("192.168.1.1", text: $ip)
                                .foregroundColor(.gray)
                        }
                        HStack {
                            Text("端口:")
                            Spacer()
                            TextField("80", text: $port)
                                .foregroundColor(.gray)
                        }
                        HStack {
                            Text("用戶名稱:")
                            Spacer()
                            TextField("Username", text: $username)
                                .foregroundColor(.gray)
                        }
                        HStack {
                            Text("密碼:")
                            Spacer()
                            SecureField("Password", text: $password)
                                .foregroundColor(.gray)
                        }
//                        HStack {
//                            Toggle("照明", isOn: $torch)
//                        }
                    }
                    Section {
                        Button("登入") {
                            showingPopover = true
                            logout = "2"
                        }
                    }
                    NavigationLink(destination: about()) {
                        Text("關於這個應用")
                    }
                }
                .navigationTitle("登入你的IP Camera")
                .fullScreenCover(isPresented: $showingPopover) {
                    VStack {
                        ZStack {
                            HStack {
                                Spacer()
                                Button("退出") {
                                    showingPopover = false
                                }
                                .padding()
                            }
                            HStack {
                                Text(ip)
                                    .padding()
                            }
                        }
                        CameraView(streamlink: "http://\(username):\(password)@\(ip):\(port)", name: ip, torch: torch)
                    }
                    .onDisappear {
                        logout = "3"
                    }
                    
                }
                
            }
            .navigationViewStyle(StackNavigationViewStyle())
            
        }
        
        
    }
    

}

struct about: View {
    var body: some View {
        List {
            Section {
                Text("這個應用是為(IP摄像头 by Pavel Khlebovich)設計")
                Text("https://play.google.com/store/apps/details?id=com.pas.webcam")
            }
            Section {
                Text("iP Camera Viewer 1.0.0")
                Text("© 2020-2022 AlwaysBoringStudio. 保留一切權利")
                Text("https://alwaysboringstudio.site")
            }
        }
        .navigationTitle("關於")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
