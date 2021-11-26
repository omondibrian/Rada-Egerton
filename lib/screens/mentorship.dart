import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Mentorship extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mentorship"),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpinKitSpinningLines(color: Theme.of(context).primaryColor),
            Text(
              "Coming soon",
              style: Theme.of(context).textTheme.headline1,
            ),
          ],
        ),
      ),
    );
  }
}
// Future<File> getProfilePicPath() async {
  //   var pickedImage = await _imagePicker.pickImage(source: ImageSource.gallery);
  //   return File(pickedImage!.path); //convert from XFile to File type
  // }

  // Future<Response?> updateProfilePic() async {
  //   try {
  //     String imageFileName = getProfilePicPath().toString().split('/').last;
  //     FormData formData = FormData.fromMap({
  //       "profilePic": await MultipartFile.fromFile(
  //           getProfilePicPath().toString(),
  //           filename: imageFileName),
  //     });
  //     SharedPreferences _preferences = await SharedPreferences.getInstance();
  //     String? authToken = _preferences.getString("TOKEN");
  //     return await _httpConnection.put(
  //       '$BASE_URL/api/v1/admin/user/profile',
  //       data: formData,
  //       options: Options(
  //         headers: {
  //           'Authorization': authToken,
  //           "Content-type": "multipart/form-data",
  //         },
  //       ),
  //     );
  //   } catch (e) {
  //     print(e);
  //   }
  // }