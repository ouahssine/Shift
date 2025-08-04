
class login
{
  String username;
  String password;

  login({required this.username,required this.password});

  Map<String, dynamic> toJson()
  {
    return {
      'username' : this.username,
      'password' : this.password, 
    };
  }


}


