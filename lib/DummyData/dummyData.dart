

Map<String,String> getComments(String msg,String r,String date){
  Map<String,String> a = {
    'message':msg,
    'date':date,
    'rating':r,
  };
  return a;
}

List allCommentsData = [
  getComments("hello you are relally awesome and I love your work", "5", "2021-12-09"),
  getComments("Oh Mout good u so aweome", "2", "2021-12-09"),
  getComments("hello you are relally awesome and I love your work", "1", "2022-04-09"),
  getComments("hello you are relally awesome and I love your work", "4", "2021-05-09"),
];