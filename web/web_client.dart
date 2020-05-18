/// Copyright 2020 Orion Services
/// Licensed under the Apache License, Version 2.0 (the "License");
/// you may not use this file except in compliance with the License.
/// You may obtain a copy of the License at
///
/// http://www.apache.org/licenses/LICENSE-2.0
///
/// Unless required by applicable law or agreed to in writing, software
/// distributed under the License is distributed on an "AS IS" BASIS,
/// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
/// See the License for the specific language governing permissions and
///  limitations under the License.
import 'dart:html';
import 'dart:convert';
import 'package:orion_user_client/web_service.dart';
import 'package:orion_user_client/web_socket.dart';

/// methos main
void main() {
  WebClientExample();
}

/// Examples of how to use TalkWebService and TalkWebSocket clients in
/// simple Web page
class WebClientExample {
  /// Talk Web Service client
  UserWebService _userWS;

  /// Talk Web Socket client
  UserWebSocket _userSocket;

  WebClientExample() {
    // instantiating the talk web service client
    _userWS = UserWebService(getSecureValue(), getDevelopmentValue());
    _userSocket = UserWebSocket(getSecureValue(), getDevelopmentValue());

    // adding buttons listeners
    // Web Service
    querySelector('#btnCreateUser').onClick.listen(createUserHandler);

   

    // adding checkboxes listeners to change service URL to run with secure
    // connection and dev mode
    querySelector('#secure').onClick.listen(urlHandler);
    querySelector('#development').onClick.listen(urlHandler);
    querySelector('#btnChangeHost').onClick.listen(urlHandler);
  }

  /// Handles the [MouseEvent event] of the button create channel
  void createUserHandler(MouseEvent event) async {
   

    // geting the message from input text
    var name = (querySelector('#name') as InputElement).value;
    var email = (querySelector('#email') as InputElement).value;
    
    String data;
    try {
      // sending the message to a channel in talk Service
      var response = await _userWS.createUser(name, email);
      data = json.decode(response.body)['name'];
      data = json.decode(response.body)['email'];

    } on Exception {
      data = 'connection refused';
    } finally {
      // setting the return message to HTML screen
      appendNode(data);
    }
  }

  


  

  /// Handles the [MouseEvent] of the checkboxes
  void urlHandler(MouseEvent event) {
    // change the url of the service
    _userWS.changeServiceURL(getSecureValue(), getDevelopmentValue(),
        getHostValue(), getPortValue());
    _userSocket.changeServiceURL(getSecureValue(), getDevelopmentValue(),
        getHostValue(), getPortValue());

    appendNode(_userWS.wsURL);
    appendNode(_userSocket.socketURL);
  }

  /// [return] a boolean indicating a secure conection or not
  bool getSecureValue() {
    return (querySelector('#secure') as InputElement).checked;
  }

  /// [return] a boolean indicating if the service will run in dev mode
  bool getDevelopmentValue() {
    return (querySelector('#development') as InputElement).checked;
  }

  /// [return] a string with the host
  String getHostValue() {
    var host = (querySelector('#host') as InputElement).value;
    return (host == '') ? 'localhost' : host;
  }

  /// [return] a string with the port
  String getPortValue() {
    var port = (querySelector('#port') as InputElement).value;
    return (port == '') ? '9081' : port;
  }

  /// append a [String information] in output area in the page
  void appendNode(String information) {
    var node = document.createElement('span');
    var br = document.createElement('br');
    node.innerHtml = information;
    querySelector('#output').append(node);
    querySelector('#output').append(br);
  }
}
