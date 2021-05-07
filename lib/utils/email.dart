import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

class SendEmail{
  sendEmail(String nombres, String correo, String aPaterno, String aMaterno) async{

    String username = 'carsharingupc.tp2@gmail.com';
    String password = 'UPCTP2021';

    final smtpServer = gmail(username, password);

    // Create our email message.
    final message = Message()
      ..from = Address(username)
      ..recipients.add('easydrive.pe@gmail.com')
      ..subject = '[IT-Driver] 🚘 Un nuevo usuario se ha registrado  🚘 -  ${DateTime.now()}'
      ..text = 'Hola Agente,\n\nSe ha registrado un nuevo usuario a EasyDrive, por favor validar\n\nNombre: '
          '$nombres\nApellido: $aPaterno $aMaterno\nCorreo: $correo\n\n'
          'Recuerde que tiene 2 horas para poder atender esta solicitud\n\n Saludos,\n Equipo EasyDrive'
      ..html = '<p><span style="color: #003366;">Hola Agente,</span></p> '
          '<p><span style="color: #003366;">Se ha registrado un nuevo usuario a EasyDrive, por favor evaluar su acceso. Los datos del usuario son los siguientes:</span></p> '
          '<p><span style="color: #003366;">Nombre: $nombres</span></p> <p><span style="color: #003366;">Apellidos: $aPaterno $aMaterno</span></p> '
          '<p><span style="color: #003366;">Correo: $correo</span></p> <p>&nbsp;</p> <p><span style="color: #003366;">Recuerde que tiene 2 horas para poder atender esta solicitud.</span></p> '
          '<p>&nbsp;</p> <p><span style="color: #003366;">Saludos cordiales,</span></p> <p><img src="https://lh3.googleusercontent.com/D-5C82HpJaM5qjNIhqemRi034njkpGAzEaj9baHywQprB7uldVGnsykh1LNHN3wjEiZ7a5AAQRu7cayxKC60YFqem-ah4TajwhylY9-uXYYOhD0JMPHyU-Kry6e2OvWCREHBxGgTp9-HTztyk9KMlozeiLu1yp11j-98_cIOeS7sjWam0vYUpfhQ-JUXlXKoGgO97kyrCTev385XAZmhZe6Ve1jAW941sLFaBplIQ3ddRppUct7MZWeGc3B74HLDR28PUbdtahF7BRzgZkzQHKT8hFiMoqJek3-u4O_wZ_BSCNPjVYRsa3v2Ooo5Uj0JhoF_rSBwxYNHOdbykMxyWWqm8VlpOf8bEqf9TgiWOfIgGkFmtoT4XB1siLYjfIy-8I26FeyIkJs4aoBDvBu1TJq1sccc9oZtXsc9NoVrRwFfA-6-e0MltBKc1I4JoPoY1UCs0I-e9W7XYb_P98EBWWjbqY1z3uf8IDl9Nf8I50xUnZGt_1cByVrlu0gkPlCj_jwLTJep2rfp1GhaUDnazAcI3-KLc7o_JLgPPJLuJx7jcWE2WRMQU08yMSMUenCF6CSHKSqjJsrb3VLLoQ-BTDtJhCzRhLgQcFU7-i282SeXKIGgr3IkvqbInvZiH-YFIPzAH4eaWtpq_dkMx5ef26gO32j99tQsBG_daztcx1cyLko2u_nLloXuFdCnqVR3htlCfay8SRXnFeT_hcWdlA=s625-no?authuser=0" alt="Logo corpo" width="50" height="50" /></p> '
          '<p><span style="color: #003366;"><strong>Equipo EasyDrive</strong></span></p>';

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent. \n'+ e.toString());
    }
  }
}