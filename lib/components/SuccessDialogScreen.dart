import 'package:flutter/material.dart';

class SuccessDialogScreen extends StatelessWidget {
  final String? title;
  final String message;
  final String buttonLabel;
  final VoidCallback onPressed;
  final IconData icon;
  final Color iconBackgroundColor;
  final Color iconColor;
  final Color buttonColor;
  final Color buttonTextColor;

  const SuccessDialogScreen({
    Key? key,
    this.title,
    required this.message,
    required this.buttonLabel,
    required this.onPressed,
    this.icon = Icons.check,
    this.iconBackgroundColor = const Color(0xFF3535B5),
    this.iconColor = Colors.white,
    this.buttonColor = const Color(0xFF3535B5),
    this.buttonTextColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, // Fundo branco para toda a tela
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: iconBackgroundColor,
                shape: BoxShape.circle,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 60,
                ),
              ),
            ),
            if (title != null) ...[
              const SizedBox(height: 16),
              Text(
                title!,
                style: const TextStyle(
                  color: Color(0xFF3535B5),
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  fontFamily: 'DoppioOne',
                  decoration: TextDecoration.none, // Remove underline
                ),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(
                color: Color(0xFF3535B5),
                fontWeight: FontWeight.w700,
                fontSize: 20,
                fontFamily: 'DoppioOne',
                decoration: TextDecoration.none, // Remove underline
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: 220,
              height: 44,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 4,
                  shadowColor: Colors.black26,
                ),
                onPressed: onPressed,
                child: Text(
                  buttonLabel,
                  style: TextStyle(
                    color: buttonTextColor,
                    fontFamily: 'DoppioOne',
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    decoration: TextDecoration.none, // Remove underline
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}