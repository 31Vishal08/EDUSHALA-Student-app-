import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:student/GetStarted/GetStarted.dart';
import 'package:student/GetStarted/UserType.dart';
import 'package:student/Homes/HomeScreen.dart';
import 'package:student/Usefull/Functions.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';


String oneSignalID = "6ee67cf5-d03f-41e3-8ea6-d7f17831b1f6";

String getGradesUrl = baseUrl + "getAllGrades";

String baseUrl = "https://serve.edushalaacademy.com/";

//Edushala
String mapApiKey = "AIzaSyCx1nU57MRJ1pJFup8akSpq7uDoZlS1FIU";
//My Van
// String mapApiKey = "AIzaSyA6rsQ3vAB_NxVVcfWv3X0KdZLCHJJvdks";



String createUserUrl = baseUrl + "createUser";
String checkUserUrl = baseUrl + "getUserBycode";
String updateUserUrl = baseUrl + "updateUser";
String getUserByid = baseUrl + "getUserByid";




String createChildrenUrl = baseUrl + "createChildren";
String updateChildrenUrl = baseUrl + "updateChildren";
String getChildrenUrl = baseUrl + "getChildrenByParentid";

String createIntervieUrl = baseUrl + "createInterview";
String updateIntervieUrl = baseUrl + "updateInterview";

String getInterviewbyidUrl = baseUrl + "getInterviewByid";
String getInterviewbytutorUrl = baseUrl + "getInterviewByTutor";

String createOfferUrl = baseUrl + "createOffer";
String updateOfferUrl = baseUrl + "updateOffer";

String getOfferbyidUrl = baseUrl + "getOfferByid";
String getOfferbytutorUrl = baseUrl + "getOfferByTutor";

String getSubjectsUrl = baseUrl + "getSubjects";

String uploadImageUrl = "https://node.edushalaacademy.com/upload/file";

String getTutorUrl = baseUrl + "getTutorByid";

// String updateUserUrl = baseUrl + "updateUser";

String submitInquireUrl = baseUrl + "createEnquiry";
String updateInquireUrl = baseUrl + "updateEnquiry";
String getInquirebyParentUrl = baseUrl + "getEnquiryByParentid";
String getInquirebyChildUrl = baseUrl + "getEnquiryByChildId";

String completeEnquiry = baseUrl + "completeEnquiry";

String getClassParentUrl = baseUrl + "getClassesByParentid";
String getClassTutorUrl = baseUrl + "getClassesByTutorid";
String getClassChildUrl = baseUrl + "getClassesByChildid";

String getAttendacneByParent = baseUrl + "getAttendanceByParentid";
String getAttendacneByTutor = baseUrl + "getAttendanceByTutorid";
String getAttendacneByChild = baseUrl + "getAttendanceByChildid";
String getAttendacneByAssignId = baseUrl + "getAttendanceByAssignedid";

String getAllTest = baseUrl + "tutortest/getAllTest";
String getTestById = baseUrl + "tutortest/getTestByid";
String getTestByTutorId = baseUrl + "tutortest/getTestByTutorid";
String createTestUrl = baseUrl + "tutortest/createTest";
String updateTestUrl = baseUrl + "tutortest/updateTest";

String getallAssignedTest = baseUrl + "assignedtest/getAllTest";
String getAssigendTestById = baseUrl + "assignedtest/getTestByid";
String getAssigendTestByTutorId = baseUrl + "assignedtest/getTestByTutorid";
String getAssigendTestByAssignedId = baseUrl + "assignedtest/getTestByAssignid";
String getAssignedTestByParentId = baseUrl + "assignedtest/getTestByParentid";
String getAssignedTestByChildId = baseUrl + "assignedtest/getTestByChildid";
String createAssignedTestUrl = baseUrl + "assignedtest/createTest";
String updateAssignedTestUrl  = baseUrl + "assignedtest/updateTest";


String getAllSubmission = baseUrl + "testsubmission/getAllSubmission";
String getSubmissionById = baseUrl + "testsubmission/getSubmissionByid";
String getSubmissionByTutorId = baseUrl + "testsubmission/getSubmissionByTutorid";
String getSubmissionByAssignId = baseUrl + "testsubmission/getSubmissionByAssignid";
String getSubmissionByParentId = baseUrl + "testsubmission/getSubmissionByParentid";
String getSubmissionByAssignTestId = baseUrl + "testsubmission/getSubmissionByAssignedTestid";
String getSubmissionByChildId = baseUrl + "testsubmission/getSubmissionByChildid";
String createSubmissionUrl = baseUrl + "testsubmission/createSubmission";
String updateSubmissionUrl = baseUrl + "testsubmission/updateSubmission";

String getAllreview = baseUrl + "ratingreview/getAllReview";
String getReviewById = baseUrl + "ratingreview/getReviewByid";
String getReviewByTutorId = baseUrl + "ratingreview/getReviewByTutorid";
String getReivewByParent = baseUrl + "ratingreview/getReviewByParentid";
String getReviewByChild = baseUrl + "ratingreview/getReviewByChildid";
String getReviewByAssignedid = baseUrl + "ratingreview/getReviewByAssignedid";
String createReviewUrl = baseUrl + "ratingreview/createReview";
String updateReviewUrl = baseUrl + "ratingreview/updateReview";

String getAllChats = baseUrl + "chats/getAllChat";
String getChatsById = baseUrl + "chats/getChatByid";
String getChatByChatId = baseUrl  + "chats/getChatByChatid";
String createChatUrl = baseUrl + "chats/createChat";
String updateChatUrl = baseUrl + "chats/updateChat";

String getAllMacrosUrl = baseUrl + "getAllMacros";
String getMacroById = baseUrl + "getMacroById";
String createMacroById = baseUrl + "createMacro";
String updateMacro = baseUrl + "updateMacro";

String getAllPTM = baseUrl + "ptms/getAllPTM";
String getPTMbyid = baseUrl + "ptms/getPTMByid";
String getPTMbyMTPid = baseUrl + "ptms/getPTMByPTMid";
String createPTMurl = baseUrl + "ptms/createPTM";
String updatePTMurl = baseUrl + "ptms/updatePTM";

String getAllHoliday = baseUrl + "holidays/getAllHoliday";
String getHolidayByid = baseUrl + "holidays/getHolidayByid";
String getHolidaybyTutorid = baseUrl + "holidays/getHolidayByTutorid";
String getHolidayByParentid = baseUrl + "holidays/getHolidayByParentid";
String getHolidaybyChildid = baseUrl + "holidays/getHolidayByChildid";
String getHolidaybyAssignid = baseUrl + "holidays/getHolidayByAssignid";
String createHolidayUrl = baseUrl + "holidays/createHoliday";
String updateHolidayUrl = baseUrl + "holidays/updateHoliday";

String getAllSwot = baseUrl + "swot/getAllSwot";
String getSwotbyId = baseUrl + "swot/getSwotByid";
String getSwotbyTutorId = baseUrl + "swot/getSwotByTutorid";
String getSwotbyParentId = baseUrl + "swot/getSwotByParentid";
String getSwotbyChildId = baseUrl + "swot/getSwotByChildid";
String createSwotUrl = baseUrl + "swot/createSwot";
String updateSwotUrl = baseUrl + "swot/updateSwot";

String editAssignedUrl = baseUrl + "updateAssigned";





checker(String uid,BuildContext c) async{
  User? auth = FirebaseAuth.instance.currentUser;
  http.Response response = await http.post(Uri.parse(checkUserUrl),
    headers: <String,String>{
      'Content-Type': 'application/json; charset=UTF-8'
    },
    body: jsonEncode(<String, String>{
      'user_code': uid,
    }),
  );
  print(response.statusCode);
  print(response.body);

  if(response.statusCode == 201){
    print('success');
    navScreen(userType(), c, true);
  }
  else if(response.statusCode == 200){
    print(response.body);
    Map mainData = jsonDecode(response.body);
    print(mainData);
    Map data = mainData['user'];
    print(data);
    getSubjectData(data,c);
  }
}


getSubjectData(Map data,BuildContext c)async{
  Map subjectMap = {};
  http.Response response = await http.post(Uri.parse(getSubjectsUrl),
    headers: <String,String>{
      'Content-Type': 'application/json; charset=UTF-8'
    },
    body: jsonEncode(<String, String>{

    }),
  );
  print(response.statusCode);
  print(response.body);
  if(response.statusCode == 200) {
    Map S = jsonDecode(response.body);
    List listOfSubjects = S['subjects'];
    print(listOfSubjects);
    for (var i in listOfSubjects) {
      Map mm = i as Map;
      subjectMap[mm['id']] = {
        'id':mm['id'],
        'title':mm['title'],
        'icon':mm['icon'],
        'grade':mm['grade'],
      };
      if(listOfSubjects.last == i){
        getGrades(data, subjectMap, c);
      }
    }
  }
}

getGrades(Map data, Map subjectData,BuildContext c) async{

  Map gradesMap = {};
  http.Response response = await http.post(Uri.parse(getGradesUrl),
    headers: <String,String>{
      'Content-Type': 'application/json; charset=UTF-8'
    },
    body: jsonEncode(<String, String>{

    }),
  );
  print(response.statusCode);
  print(response.body);
  if(response.statusCode == 200) {
    Map S = jsonDecode(response.body);
    List listOfGrades = S['grades'];
    print(listOfGrades);
    for (var i in listOfGrades) {
      Map mm = i as Map;
      gradesMap[mm['id']] = {
        'title': mm['grade'],
        'id':mm['id'],
        'board':mm['board']
      };
      if(listOfGrades.last == i){
        getParentChildren(subjectData, gradesMap, data, c);
      }
    }
  }
}


getParentChildren(Map sub, Map grades,Map d, BuildContext c) async{
  Map superChild = {};
  http.Response response = await http.post(Uri.parse(getChildrenUrl),
    headers: <String,String>{
      'Content-Type': 'application/json; charset=UTF-8'
    },
    body: jsonEncode(<String, dynamic>{
      'parent': d['user_id'],
    }),
  );
  print(response.statusCode);
  print(response.body);
  if(response.statusCode == 200){
      Map data = jsonDecode(response.body);
      List allChild = data['children'];
      superChild = makeSuperMap(allChild);
      Map macroMap = await getMacros();
      Navigator.of(c).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) =>
              homeScreen(data:d,subjectData: sub,gradesData: grades,childData: superChild,)), (Route<dynamic> route) => false);

}
  else{
    Navigator.of(c).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) =>
            homeScreen(data:d,subjectData: sub,gradesData: grades,childData:{},)), (Route<dynamic> route) => false);


  }
}

Future<Map>getMacros() async{
  Map macrosMap = {};
  http.Response response = await http.post(Uri.parse(getAllMacrosUrl),
    headers: <String,String>{
      'Content-Type': 'application/json; charset=UTF-8'
    },
    body: jsonEncode(<String, String>{

    }),
  );
  print("macros${response.statusCode}");
  print(response.body);
  if(response.statusCode == 200) {
    Map S = jsonDecode(response.body);
    List listOfMacros = S['macros'];
    print(listOfMacros);
    for (var i in listOfMacros) {
      Map mm = i as Map;
      macrosMap[mm['id']] = {
        'title': mm['title'],
        'id':mm['id'],
        'icon':mm['icon'],
        'desc':mm['desc']
      };
    }
  }
  return macrosMap;
}

Future<Map> returnSubjectData(BuildContext c)async{
  Map subjectMap = {};
  http.Response response = await http.post(Uri.parse(getSubjectsUrl),
    headers: <String,String>{
      'Content-Type': 'application/json; charset=UTF-8'
    },
    body: jsonEncode(<String, String>{

    }),
  );
  print(response.statusCode);
  print(response.body);
  if(response.statusCode == 200) {
    Map S = jsonDecode(response.body);
    List listOfSubjects = S['subjects'];
    print(listOfSubjects);
    for (var i in listOfSubjects) {
      Map mm = i as Map;
      subjectMap[mm['id']] = {
        'id':mm['id'],
        'title':mm['title'],
        'icon':mm['icon'],
        'grade':mm['grade'],
      };
    }
  }
  return subjectMap;
}

Future<Map> returnGrades(BuildContext c) async{

  Map gradesMap = {};
  http.Response response = await http.post(Uri.parse(getGradesUrl),
    headers: <String,String>{
      'Content-Type': 'application/json; charset=UTF-8'
    },
    body: jsonEncode(<String, String>{

    }),
  );
  print(response.statusCode);
  print(response.body);
  if(response.statusCode == 200) {
    Map S = jsonDecode(response.body);
    List listOfGrades = S['grades'];
    print(listOfGrades);
    for (var i in listOfGrades) {
      Map mm = i as Map;
      gradesMap[mm['id']] = {
        'title': mm['grade'],
        'id':mm['id'],
        'board':mm['board']
      };
    }
  }
  return gradesMap;
}



Map makeSuperMap(List cd){
  Map superChildData = {};
  for(var i in cd){
    superChildData[i['id']] = {
      'id': i['id'],
      'name' : i['name'],
      'dob' : i['dob'],
      'gender':i['gender'],
      'school':i['school'],
      'grade':i['grade'],
      'photo':i['photo_url'],
      'photo_url':i['photo_url'],
    };
  }
  return superChildData;

}


Future<String> uploadImage(String f) async{
  File file = File(f);

  Uint8List imagebytes_one = await file.readAsBytes();
  String l_image = base64.encode(imagebytes_one);

  String ukey = generateRandomStringonly(10);

  var aa = {
    'name': ukey+ "." + f.substring(f.length - 8).split(".").last,    // 'name':'hello.jpg',
    // 'file':l_image,
    'ukey':ukey,
  };
  print(aa);

  http.Response response = await http.post(Uri.parse(uploadImageUrl),
    headers: <String,String>{
      'Content-Type': 'application/json; charset=UTF-8'
    },


    body: jsonEncode(<String, String>{
      'name': ukey.toLowerCase()+ "." +f.substring(f.length - 8).split(".").last,
      // 'name':'hey.jpg',
      'file':l_image,
      'ukey':ukey.toLowerCase(),
    }),
  );

  print(response.statusCode);
  print(response.body);
  if(response.statusCode == 202){
    Map imgd = jsonDecode(response.body);
    String imgs = imgd['data'];
    return imgs;
  }
  else{
    return "hello";
  }

}



createInterview() async{
  http.Response response = await http.post(Uri.parse(createIntervieUrl),
    headers: <String,String>{
      'Content-Type': 'application/json; charset=UTF-8'
    },
    body: jsonEncode(<String, String>{
      'date':'20-12-2001',
      'time':'16:50',
      'link':'h',
      'tutor':'2',
      'status':'pending'
    }),
  );
  print("status ${response.statusCode}");
  print(response.body);

  if(response.statusCode == 200){
  }
  else{

  }
}

createOffer() async{
  http.Response response = await http.post(Uri.parse(getOfferbytutorUrl),
    headers: <String,String>{
      'Content-Type': 'application/json; charset=UTF-8'
    },
    body: jsonEncode(<String, String>{
      'tutor':'5',
    }),
  );
  print("status ${response.statusCode}");
  print(response.body);

  if(response.statusCode == 200){
  }
  else{

  }
}


checkUser() async{
  http.Response response = await http.post(Uri.parse(checkUserUrl),
    headers: <String,String>{
      'Content-Type': 'application/json; charset=UTF-8'
    },
    body: jsonEncode(<String, String>{
      'user_code': "helloo",
    }),
  );
  print("status ${response.statusCode}");
  print(response.body);

  if(response.statusCode == 200){
  }
  else{

  }
}

updateUser() async{
  http.Response response = await http.post(Uri.parse(updateUserUrl),
    headers: <String,String>{
      'Content-Type': 'application/json; charset=UTF-8'
    },
    body: jsonEncode(<String, String>{
      'user_code': "hello",
      'name':'Pulli',
    }),
  );
  print("status ${response.statusCode}");
  print(response.body);

  if(response.statusCode == 200){
  }
  else{

  }
}

Future<Map> getAssignedTestData(String testid)async{
  Map rd = {};
  http.Response response = await http.post(Uri.parse(getTestById),
    headers: <String,String>{
      'Content-Type': 'application/json; charset=UTF-8'
    },
    body: jsonEncode(<String, String>{
      'id': testid,
    }),
  );
  print(response.statusCode);
  print(response.body);
  if(response.statusCode == 200){
    Map testData = jsonDecode(response.body);
    rd = testData['test'];
  }
  return rd;
}

Future<Map> getOneUserbyid(String id) async {
  http.Response response = await http.post(Uri.parse(getUserByid),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8'
    },
    body: jsonEncode(<String, String>{
      'user_id': id,
    }),
  );
  print(response.statusCode);
  print(response.body);
  if (response.statusCode == 200) {
    Map td = jsonDecode(response.body);
    Map tdd = td['user'];
    return tdd;
  }
  else {
    return {};
  }
}

postNotification(String id,String content, String heading) async {
  var notification = OSCreateNotification(
    playerIds: [id],
    content: content,
    heading: heading,
    androidSmallIcon: "https://i.ibb.co/SN0HCCp/Frame-14.png",
  );
}

launch_us(String s) async{
  await launchUrl(
      Uri.parse(s),
      mode: LaunchMode.externalApplication
  );

}


