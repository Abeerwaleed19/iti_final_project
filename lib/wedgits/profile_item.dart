import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
class ProfileItem extends StatelessWidget {
  final String textValue;
  final String icon;

  const ProfileItem({
    super.key,
    required this.textValue,
    required this.icon
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 48,
      decoration: BoxDecoration(
        color: Color(0xFFF8F7F7),
        borderRadius: BorderRadius.circular(8),


      ),

      child:
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            SvgPicture.asset(icon,),
            SizedBox(width: 10,),
            Text(textValue,style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black.withValues(alpha: 0.84),
                fontFamily: "Poppins"
            ),),

            Spacer(),

            Icon(Icons.arrow_forward_ios,size: 18,)

          ],
        ),
      )
      ,
    );
  }
}
