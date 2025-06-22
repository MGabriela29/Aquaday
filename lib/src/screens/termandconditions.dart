import 'package:flutter/material.dart';

class TermsAndConditionsContent extends StatelessWidget {
  const TermsAndConditionsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Términos y Condiciones de AquaDay',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF04246C), // Color principal de tu app
            ),
          ),
          SizedBox(height: 15),
          Text(
            'Bienvenido a AquaDay, tu aplicación de recordatorios para la ingesta de agua. Al usar nuestra aplicación, aceptas los siguientes términos y condiciones. Por favor, léelos cuidadosamente.',
            style: TextStyle(fontSize: 14),
          ),
          SizedBox(height: 20),
          Text(
            '1. Objeto de la Aplicación',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF04246C),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'AquaDay está diseñada para ayudarte a mantenerte hidratado proporcionando recordatorios personalizados y un seguimiento de tu ingesta de agua diaria. No es una aplicación médica y no debe usarse para diagnosticar, tratar, curar o prevenir ninguna enfermedad.',
            style: TextStyle(fontSize: 14),
          ),
          SizedBox(height: 20),
          Text(
            '2. Exención de Responsabilidad Médica',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF04246C),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'La información y las funciones proporcionadas por AquaDay son solo para fines informativos y de seguimiento general. Siempre consulta a un profesional de la salud antes de tomar cualquier decisión relacionada con tu salud o dieta, especialmente si tienes condiciones médicas preexistentes o estás embarazada.',
            style: TextStyle(fontSize: 14),
          ),
          SizedBox(height: 20),
          Text(
            '3. Privacidad de los Datos',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF04246C),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Nos comprometemos a proteger tu privacidad. Recopilamos datos sobre tu ingesta de agua para ofrecerte un seguimiento personalizado. Estos datos se almacenan de forma segura y no se comparten con terceros sin tu consentimiento explícito. Consulta nuestra Política de Privacidad completa para obtener más detalles.',
            style: TextStyle(fontSize: 14),
          ),
          SizedBox(height: 20),
          Text(
            '4. Precisión de los Recordatorios',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF04246C),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Aunque nos esforzamos por la precisión, AquaDay no garantiza que los recordatorios sean exactos al segundo debido a las variaciones del sistema operativo y las configuraciones del dispositivo. La responsabilidad de la ingesta de agua recae en el usuario.',
            style: TextStyle(fontSize: 14),
          ),
          SizedBox(height: 20),
          Text(
            '5. Uso Apropiado',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF04246C),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Aceptas usar AquaDay solo para fines legales y de acuerdo con estos términos. No debes usar la aplicación de ninguna manera que pueda dañar, deshabilitar, sobrecargar o deteriorar la aplicación o interferir con el uso y disfrute de la aplicación por parte de terceros.',
            style: TextStyle(fontSize: 14),
          ),
          SizedBox(height: 20),
          Text(
            '6. Modificaciones de los Términos',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF04246C),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Nos reservamos el derecho de modificar estos términos y condiciones en cualquier momento. Te notificaremos sobre cualquier cambio importante a través de la aplicación o por otros medios. Tu uso continuado de la aplicación después de dichas modificaciones constituirá tu aceptación de los nuevos términos.',
            style: TextStyle(fontSize: 14),
          ),
          SizedBox(height: 20),
          Text(
            '7. Contacto',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF04246C),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Si tienes alguna pregunta sobre estos Términos y Condiciones, por favor contáctanos a través de la sección de soporte de la aplicación.',
            style: TextStyle(fontSize: 14),
          ),
          SizedBox(height: 20),
          Text(
            'Al hacer clic en "Aceptar" o al continuar usando AquaDay, confirmas que has leído, entendido y aceptado estar sujeto a estos Términos y Condiciones.',
            style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }
}
