
import 'package:flutter_test/flutter_test.dart';

import 'package:gerenciador_tarefas/app.dart';

void main() {
  testWidgets(
    'Exibe login e permite acessar o cadastro',
    (WidgetTester tester) async {
      // Inicializa o aplicativo.
      await tester.pumpWidget(const MyApp());

      // Verifica se a tela de login aparece.
      expect(find.text('Organize seu dia!'), findsOneWidget);

      // Acessa a tela de cadastro.
      await tester.tap(
        find.text('Não tem uma conta? Cadastre-se'),
      );

      await tester.pumpAndSettle();

      // Verifica se a tela de cadastro foi aberta.
      expect(find.text('Criar conta'), findsOneWidget);
      expect(find.text('Comece a se organizar!'), findsOneWidget);
    },
  );
}
