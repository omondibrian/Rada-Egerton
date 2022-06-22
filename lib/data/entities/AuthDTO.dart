class AuthDTO {
  String _email = "";
  String _password = "";
  String _userName = "";
  String _university = "";

  AuthDTO({email, password, userName, university}) {
    this._email = email;
    this._password = password;
    this._userName = userName;
    this._university = university;
  }

  ///
  ///converts object to json field
  ///

  toJson() {
    return {
      "email": this.getEmail(),
      "password": this.getPassword(),
      "university": this.getUniversity()
    };
  }

  String getEmail() => this._email;
  String getPassword() => this._password;
  String getUsername() => this._userName;
  String getUniversity() => this._university;
}
