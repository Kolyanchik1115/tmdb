import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmdb/ui/Theme/app_button_style.dart';
import 'package:tmdb/ui/widgets/auth/auth_model.dart';

class AuthWidget extends StatelessWidget {
  const AuthWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Войти в свою учетную запись'),
        centerTitle: true,
      ),
      body: ListView(
        children: const [
          _HeaderWidget(),
        ],
      ),
    );
  }
}

class _HeaderWidget extends StatelessWidget {
  const _HeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(fontSize: 16, color: Colors.black);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 25,
          ),
          const Text(
              'Чтобы пользоваться правкой и возможностями рейтинга TMDB, а также получить персональные рекомендации, необходимо войти в свою учётную запись. Если у вас нет учётной записи, её регистрация является бесплатной и простой. Нажмите здесь, чтобы начать ',
              style: textStyle),
          TextButton(
              style: AppButtonStyle.linkButton,
              onPressed: () {},
              child: const Text('Регистрация')),
          const SizedBox(
            height: 25,
          ),
          const Text(
              'Если Вы зарегистрировались, но не получили письмо для подтверждения, нажмите здесь, чтобы получить письмо повторно.',
              style: textStyle),
          TextButton(
              style: AppButtonStyle.linkButton,
              onPressed: () {},
              child: const Text('Подтверждение почты')),
          const SizedBox(
            height: 40,
          ),
          _FormWidget(),
        ],
      ),
    );
  }
}

class _FormWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(fontSize: 16, color: Colors.black);
    const textFiledDecorator = InputDecoration(
      border: OutlineInputBorder(),
      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      isCollapsed: true,
    );
    final model = context.read<AuthViewModel>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _ErrorMessageText(),
        const Text(
          'Имя пользователя',
          style: textStyle,
        ),
        TextField(
          decoration: textFiledDecorator,
          controller: model.loginTextController,
        ),
        const SizedBox(
          height: 20,
        ),
        const Text('Пароль', style: textStyle),
        TextField(
          obscureText: true,
          decoration: textFiledDecorator,
          controller: model.passwordTextController,
        ),
        const SizedBox(
          height: 30,
        ),
        Row(
          children: [
            _AuthButtonWidget(model: model),
            const SizedBox(
              width: 30,
            ),
            TextButton(
              onPressed: () {},
              style: AppButtonStyle.linkButton,
              child: const Text(
                'Сбросить пароль',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _AuthButtonWidget extends StatelessWidget {
  const _AuthButtonWidget({
    Key? key,
    required this.model,
  }) : super(key: key);

  final AuthViewModel? model;

  @override
  Widget build(BuildContext context) {
    final model = context.watch<AuthViewModel>();
    final onPressed =
        model.canStartAuth == true ? () => model.auth(context) : null;
    final child = model.isAuthProgress
        ? const SizedBox(
            width: 15,
            height: 15,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : const Text('Войти');
    return ElevatedButton(onPressed: onPressed, child: child);
  }
}

class _ErrorMessageText extends StatelessWidget {
  const _ErrorMessageText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final errorMassage = context.select((AuthViewModel m) => m.errorMessage);
    if (errorMassage == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Text(
        errorMassage,
        style: const TextStyle(
          fontSize: 17,
          color: Colors.red,
        ),
      ),
    );
  }
}
