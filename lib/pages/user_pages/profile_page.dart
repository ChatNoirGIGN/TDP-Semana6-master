import 'package:carsharing_app/pages/sign_in_pages/login_page.dart';
import 'package:carsharing_app/pages/user_pages/update_profile_page.dart';
import 'package:carsharing_app/providers/user_provider.dart';
import 'package:carsharing_app/utils/color_palette.dart';
import 'package:carsharing_app/utils/divide.dart';
import 'package:carsharing_app/widgets/input_text.dart';
import 'package:carsharing_app/widgets/user_drawer.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  UserAppDrawer _appDrawer = UserAppDrawer();
  Dividers _dividers = Dividers();
  ColorPalette _colorPalette = ColorPalette();
  UsuarioProvider _usuarioProvider = UsuarioProvider();
  InputText _inputText = InputText();

  TextEditingController _verify = TextEditingController();

  SharedPreferences sharedPreferences;

  String _nombres;
  String _correo;
  int _id;
  
  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if(sharedPreferences.getString("token") == null){
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginPage()), (Route<dynamic> route) => false);
    }
    setState(() {
      _nombres =  sharedPreferences.getString("nombres");
      _correo = sharedPreferences.getString("correo");
      _id = sharedPreferences.getInt("id");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLoginStatus();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mi perfil'),  backgroundColor: _colorPalette.blue_app,),
      body: FutureBuilder(
        future: _usuarioProvider.getUser(_id),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(snapshot.data == null) {
            return Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: 1,
              itemBuilder: (BuildContext context, int i){
                return Container(
                  color: _colorPalette.gray_app,
                  child: Column(
                    children: [
                      _dividers.defDivider(16.0),
                      CircleAvatar(
                        backgroundColor: _colorPalette.blue_app,
                        radius: 100.0,
                        child: Icon(Icons.person, size: 150.0, color: Colors.white),
                      ),
                      _dividers.defDivider(16.0),
                      Padding(child: _createTextDisable(snapshot.data.nombres, 'Nombres'),padding: EdgeInsets.only(left: 30.0, right: 30.0)),
                      _dividers.defDivider(16.0),
                      Padding(child: _createTextDisable(snapshot.data.apellidoPaterno, 'A. Paterno'),padding: EdgeInsets.only(left: 30.0, right: 30.0)),
                      _dividers.defDivider(16.0),
                      Padding(child: _createTextDisable(snapshot.data.apellidoMaterno, 'A. Materno'),padding: EdgeInsets.only(left: 30.0, right: 30.0)),
                      _dividers.defDivider(16.0),
                      Padding(child: _createTextDisable(snapshot.data.celular, 'Celular'),padding: EdgeInsets.only(left: 30.0, right: 30.0)),
                      _dividers.defDivider(16.0),
                      Padding(child: _createTextDisable(snapshot.data.dni, 'DNI'),padding: EdgeInsets.only(left: 30.0, right: 30.0)),
                      _dividers.defDivider(16.0),
                      Padding(child: _createTextDisable(snapshot.data.fechaNac, 'Fecha Nac'),padding: EdgeInsets.only(left: 30.0, right: 30.0)),
                      _dividers.defDivider(16.0),
                      Padding(child: _createTextDisable(snapshot.data.correo, 'Correo'),padding: EdgeInsets.only(left: 30.0, right: 30.0)),
                      _dividers.defDivider(32.0),
                      Padding(child:_updateData(snapshot.data.password.toString()),padding: EdgeInsets.only(left: 30.0, right: 30.0)),
                      _dividers.defDivider(32.0),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
      drawer: _appDrawer.userAppDrawer(context, _nombres, _correo),
    );
  }

  Widget _createTextDisable(String value, String hint){
    return TextFormField(
      decoration: InputDecoration(
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: _colorPalette.green_app
          )
        ),
        labelText: value,
        labelStyle: TextStyle(
            color: _colorPalette.dark_blue_app
        ),
        icon: Text('$hint: ', style: TextStyle(color: _colorPalette.dark_blue_app, fontWeight: FontWeight.w700))
      ),
      enabled: false,
      onChanged: (valor){
        setState(() {
        });
      },
    );
  }
  Widget _updateData(String password) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: _colorPalette.green_app
        ),
        child: Text('Editar Datos', style: TextStyle(color: _colorPalette.dark_blue_app, fontWeight: FontWeight.w700)),
        onPressed: () {
            alertVerify(context, 'Verificacion de Contrase??a', 'Por razones de seguridad antes de editar datos, digita tu contrase??a', password);
          },
      ),
    );
  }
  void alertVerify(BuildContext context, String cabezera, String body, String password) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            title: Text(cabezera, style: TextStyle(color: _colorPalette.dark_blue_app,fontWeight: FontWeight.w700)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(body,style: TextStyle(color: _colorPalette.dark_blue_app)),
                _dividers.defDivider(16.0),
                _inputText.defaultIText(
                    _verify,
                    TextInputType.name,
                    TextCapitalization.none,
                    'Validar contrase??a',
                    Icons.lock,
                    '',
                    true,
                    20
                ),
                _dividers.defDivider(16.0),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'Verificar',
                  style: TextStyle(color: _colorPalette.green_app, fontWeight: FontWeight.w700),
                ),
                onPressed: () {
                  if(_verify.text == password){
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => UpdateProfilePage()), (Route<dynamic> route) => true);
                  }
                },
              ),
            ],
          );
        }
    );
  }
}
