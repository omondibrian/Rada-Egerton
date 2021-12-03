class UserDTO {
  String email = "";
  String userName = "";
  String phone = "";
  String profilePic = "";
  String dob = "";
  String id = "";
  String gender = "";

  UserDTO({email, userName, phone, profilePic, dob, id, gender}) {
    this.id = id;
    this.email = email;
    this.userName = userName;
    this.phone = phone;
    this.profilePic = profilePic;
    this.dob = dob;
    this.gender = gender;
  }
  factory UserDTO.defaultDTO() {
    return UserDTO(
      email: '',
      dob: '',
      id: '',
      userName: '',
      phone: '',
      profilePic: '',
      gender: '',
    );
  }
}
