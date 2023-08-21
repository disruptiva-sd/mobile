import 'package:dw_barbershop/src/core/ui/constants.dart';
import 'package:dw_barbershop/src/features/auth/login/login_page.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  //criar 2 var de estados
  var _scale = 10.0;
  var _animationOpacityLogo = 0.0;
  //troca de 0 para 1 para ele aparecer, apos a tela ter sido construída

  // para controle de tamanho em escala do logo
  double get _logoAnimationWidth => 100 * _scale;
  double get _logoAnimationHeight => 120 * _scale;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _animationOpacityLogo = 1.0;
        _scale =
            1.0; // depois q construiu a tela, troca a escala para um para diminuir a img do logo
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              ImageConstants.backgroundChair,
            ),
            fit: BoxFit.cover,
            opacity: 0.5,
          ),
        ),
        child: Center(
          //envolver o logo para animacao: selecionar Image e wrap to widget
          child: AnimatedOpacity(
            duration: const Duration(seconds: 3),
            curve: Curves.easeIn,
            opacity: _animationOpacityLogo,
            //ao final da animacao, qdo terminar fazer o redirect
            //metodo q diz qdo a animacao terminou
            onEnd: () {
              //carregar a nova tela e remover todas as outras
              Navigator.of(context).pushAndRemoveUntil(
                PageRouteBuilder(
                  settings: const RouteSettings(name: '/auth/login'),
                  pageBuilder: (
                    context,
                    animation,
                    secondaryAnimation,
                  ) {
                    //terminou a animacao, redireciona para page login
                    return const LoginPage();
                  },
                  //como ele fara a transicao de uma tela para outra baseado no fade
                  transitionsBuilder: (_, animation, __, child) {
                    return FadeTransition(
                      opacity: animation,
                      child: child, //pag q estamos querendo navegar
                    );
                  },
                ),
                (route) => false,
              );
            },
            //selecionar Image e wrap to widget
            child: AnimatedContainer(
              width: _logoAnimationWidth,
              height: _logoAnimationHeight,
              duration: const Duration(seconds: 3),
              curve: Curves.linearToEaseOut,
              // precisa manter o tamanho  que o container esta da img - fit
              child: Image.asset(
                ImageConstants.imageLogo,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
