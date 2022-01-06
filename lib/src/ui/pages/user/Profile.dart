import 'dart:io';


import 'package:flutter/material.dart';
import 'package:hiltonSample/src/bloc/utility/AppConfig.dart';
import 'package:hiltonSample/src/bloc/utility/SharedPrefrence.dart';
import 'package:hiltonSample/src/bloc/utility/Validations.dart';
import 'package:hiltonSample/src/model/User.dart';
import 'package:hiltonSample/src/resource/networkConstant.dart';
import 'package:hiltonSample/src/ui/ui_constants/ImageAssetsResolver.dart';
import 'package:hiltonSample/src/ui/ui_constants/theme/AppColors.dart';
import 'package:hiltonSample/src/ui/ui_constants/theme/string.dart';
import 'package:hiltonSample/src/ui/ui_constants/theme/style.dart';
import 'package:hiltonSample/src/ui/widgets/CustomButton.dart';
import 'package:hiltonSample/src/ui/widgets/CustomLoader.dart';
import 'package:hiltonSample/src/ui/widgets/CustomTextField.dart';
import 'package:hiltonSample/src/bloc/AuthenticationBloc.dart';
import 'package:image_picker/image_picker.dart';

// import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';
import '../../../../AppLocalizations.dart';
import 'package:hiltonSample/src/bloc/ThemeBloc.dart';
import '../../../../route_generator.dart';
import 'package:hiltonSample/src/ui/widgets/CustomBackButton.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController emailController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  AuthenticationBloc authenticationBloc = AuthenticationBloc();
  bool _isVisible = false,
      isToShowLoginDialog = false,
      isPasswordHidden = true,
      isKeyBoardOpen = false,
      isLoading = true;
  ThemeBloc themeBloc;
  bool darkThemeSelected;
  final _formKey = GlobalKey<FormState>();
  String genderId;
  List<String> gender = [
    "Male",
    "Female",
  ];
  DateTime _dateTime;
  File _image;
  User user;
  final picker = ImagePicker();

  setVisiblity(bool visiblity) {
    setState(() {
      _isVisible = visiblity;
    });
  }

  setPasswordStatus() {
    setState(() {
      isPasswordHidden = !isPasswordHidden;
    });
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  void initState() {
    themeBloc = ThemeBloc.getInstance();
    darkThemeSelected = themeBloc.isDarkThemeSelected;
    themeBloc.darkThemeIsEnabled.listen((value) {
      setState(() {
        darkThemeSelected = value;
      });
    });
    getUser();
    authenticationBloc.userAuthStream.listen((user) {
      saveUser(user: user);
    }, onError: (exception) {
      Toast.show(exception.toString(), context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    });
    authenticationBloc.imageStream.listen((user) {
      authenticationBloc.userAuth(
          user: User(
              fullname: nameController.text,
              email: emailController.text,
              picture: user.picture,
              contact: contactController.text,
              gender: genderId,
              dob: dateController.text),
          url: NetworkConstants.PROFILE_UPDATE_URL);
    }, onError: (exception) {
      Toast.show(exception.toString(), context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    });

    super.initState();
  }

  void getUser() async {
    user = await SharedPref.createInstance().getCurrentUser();
    if (user != null) {
      emailController.text = user.email;
      nameController.text = user.fullname;
      contactController.text = user.contact;
      dateController.text = user.dob;
      if (genderId == user.email)
        genderId = "";
      else
        genderId = user.gender;
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: loginWithEmailWidget(context),
      ),
    );
  }

  Widget loginWithEmailWidget(BuildContext context) {
    final app = AppConfig(context);
    if (!isLoading) {
      return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Colors.red, Colors.red[300]])),
        child: Stack(
          children: <Widget>[
            Center(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(),
                  child: Container(
                    margin: EdgeInsets.all(AppConfig.of(context).appWidth(5)),
                    decoration: BoxDecoration(
                      color:
                          darkThemeSelected ? Color(0xFF353434) : Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Stack(
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height: app.appWidth(2)),
                            Align(
                                alignment: Alignment.topCenter,
                                child: SizedBox(
                                  child: CircleAvatar(
                                    radius: AppConfig.of(context).appWidth(13),
                                    backgroundColor: Colors.white,
                                    child: GestureDetector(
                                      onTap: () {
                                        print("tapped");
                                        getImage();
                                      },
                                      child: Container(
                                        child: CircleAvatar(
                                          child: Align(
                                            alignment: Alignment.bottomRight,
                                            child: CircleAvatar(
                                              backgroundColor: Colors.white,
                                              radius: AppConfig.of(context)
                                                  .appWidth(4),
                                              child: Icon(
                                                Icons.camera_alt,
                                                size: AppConfig.of(context)
                                                    .appWidth(5),
                                                color: Color(0xFF404040),
                                              ),
                                            ),
                                          ),
                                          radius: AppConfig.of(context)
                                              .appWidth(12),
                                          backgroundImage: (_image == null &&
                                                  user.picture == null)
                                              ? AssetImage(ImageAssetsResolver
                                                  .ITGN_IMAGE)
                                              : _image != null
                                                  ? Image.file(
                                                      _image,
                                                      fit: BoxFit.cover,
                                                    ).image
                                                  : NetworkImage(user.picture),
                                        ),
                                      ),
                                    ),
                                  ),
                                )),
                            SizedBox(height: app.appWidth(5)),
                            Form(
                              key: _formKey,
                              child: Container(
                                margin: EdgeInsets.only(
                                    left: AppConfig.of(context).appWidth(5),
                                    right: AppConfig.of(context).appWidth(5)),
                                child: Column(
                                  children: <Widget>[
                                    CustomTextField(
                                        AppLocalizations.of(context)
                                            .translate(Strings.FULL_NAME),
                                        TextInputType.text,
                                        VALIDATION_TYPE.TEXT,
                                        Icons.account_circle,
                                        nameController,
                                        false,
                                        () {}),
                                    SizedBox(height: app.appWidth(3)),
                                    CustomTextField(
                                        AppLocalizations.of(context)
                                            .translate(Strings.USERNAME),
                                        TextInputType.text,
                                        VALIDATION_TYPE.TEXT,
                                        Icons.alternate_email,
                                        emailController,
                                        false,
                                        () {}),
                                    SizedBox(height: app.appWidth(3)),
                                    CustomTextField(
                                        AppLocalizations.of(context)
                                            .translate(Strings.CONTACT),
                                        TextInputType.number,
                                        VALIDATION_TYPE.TEXT,
                                        Icons.contact_phone_outlined,
                                        contactController,
                                        false,
                                        () {}),
                                    SizedBox(height: app.appWidth(3)),
                                    // DropDownField(
                                    //   onValueChanged: (dynamic value) {
                                    //     genderId = value;
                                    //   },
                                    //   value: genderId == user.email
                                    //       ? ""
                                    //       : genderId,
                                    //   required: false,
                                    //   hintText: AppLocalizations.of(context)
                                    //       .translate(Strings.SELECT_GENDER),
                                    //   labelText: AppLocalizations.of(context)
                                    //       .translate(Strings.GENDER),
                                    //   items: gender,
                                    // ),
                                    SizedBox(height: app.appWidth(3)),
                                    InkWell(
                                      onTap: () {
                                        showDatePicker(
                                                context: context,
                                                initialDate: _dateTime == null
                                                    ? DateTime.now()
                                                    : _dateTime,
                                                firstDate: DateTime(2001),
                                                lastDate: DateTime(2022))
                                            .then((date) {
                                          setState(() {
                                            dateController.text =
                                                DateFormat('yyyy/MM/dd')
                                                    .format(date);
                                            _dateTime = date;
                                          });
                                        });
                                      },
                                      child: IgnorePointer(
                                        child: CustomTextField(
                                            AppLocalizations.of(context)
                                                .translate(Strings.DOB),
                                            TextInputType.text,
                                            VALIDATION_TYPE.TEXT,
                                            Icons.date_range,
                                            dateController,
                                            false,
                                            () {}),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: app.appHeight(3)),
                            Container(
                              margin: EdgeInsets.only(
                                  left: AppConfig.of(context).appWidth(5),
                                  right: AppConfig.of(context).appWidth(5)),
                              child: CustomButton(
                                onPressed: () async {
                                  if (_formKey.currentState.validate()) {
                                    if (_image != null) {
                                      authenticationBloc.uploadImageToServer(
                                          image: _image,
                                          url: NetworkConstants
                                              .IMAGE_UPLOAD_URL);
                                    } else {
                                      authenticationBloc.userAuth(
                                          user: User(
                                              fullname: nameController.text,
                                              email: emailController.text,
                                              picture: user.picture != null
                                                  ? user.picture
                                                  : null,
                                              contact: contactController.text,
                                              gender: genderId,
                                              dob: dateController.text),
                                          url: NetworkConstants
                                              .PROFILE_UPDATE_URL);
                                    }
                                  }
                                },
                                radius: 10,
                                text: AppLocalizations.of(context)
                                    .translate(Strings.SAVE),
                                textColor: darkThemeSelected
                                    ? Color(0xFF353434)
                                    : Colors.white,
                                backgorundColor:
                                    AppColors.of(context).mainColor(1),
                                width: AppConfig.of(context).appWidth(84),
                                isToShowEndingIcon: false,
                              ),
                            ),
                            SizedBox(height: app.appHeight(3)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            CustomBackButton(darkThemeSelected: darkThemeSelected),
            Positioned(
//          top: AppConfig.of(context).appHeight(50),
//          right: AppConfig.of(context).appHeight(28),
              child: Visibility(
                  visible: _isVisible,
                  child: Center(child: CircularProgressIndicator())),
            ),
          ],
        ),
      );
    } else
      return CustomLoader();
  }

  Future<void> saveUser({User user}) async {
    await SharedPref.createInstance().setCurrentUser(user);
    Toast.show("Profile updated successfully", context,
        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
  }
}
