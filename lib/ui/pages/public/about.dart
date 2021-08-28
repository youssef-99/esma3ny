import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class AboutUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('flutter_html Example'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Html(
          data: """
          <p><strong>Therapist View</strong></p><p><strong>// Appointments page صفحة المواعيد &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</strong></p><p><strong>“Appointments”: “”, &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; المواعيد</strong></p><p><strong>\" Today \": \"\", اليوم</strong></p><p><strong>\" Upcoming\": \"\", القادمة</strong></p><p><strong>t\" Session hasn’t started yet \": \"الجلسة لم تبدء</strong></p><p><strong>Join ; انضم</strong></p><p><strong>\" Start \": \"\"إبدء</strong></p><p><strong>“Not started”: “”, لم تبدء&nbsp;</strong></p><p><strong>“Started”: “”, بدأت</strong></p><p><strong>// Calendar التقويم</strong></p><p>&nbsp;</p><figure class=\"table\"><table><tbody><tr><td>title</td><td>name</td><td>age</td><td>email</td><td>action</td></tr><tr><td>jojo</td><td>william</td><td>12</td><td>jojo@test.com</td><td>&nbsp;</td></tr></tbody></table></figure>""",
        ),
      ),
    );
  }
}
