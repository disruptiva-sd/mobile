import 'package:dw_barbershop/src/core/ui/constants.dart';
import 'package:dw_barbershop/src/core/ui/helpers/form_helper.dart';
import 'package:dw_barbershop/src/core/ui/helpers/messages.dart';
import 'package:dw_barbershop/src/features/auth/login/login_state.dart';
import 'package:dw_barbershop/src/features/auth/login/login_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:validatorless/validatorless.dart';

//converter para Statefulwidget
//class LoginPage extends StatefulWidget {
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  //State<LoginPage> createState() => _LoginPageState();
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

//class _LoginPageState extends State<LoginPage> {
class _LoginPageState extends ConsumerState<LoginPage> {
//fu-form-key
  final formKey = GlobalKey<FormState>();
  //fu-text-edit-controller
  final emailEC = TextEditingController();
  final passwordEC = TextEditingController();

  @override
  void dispose() {
    emailEC.dispose();
    passwordEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /*o river obriga a usar o state dele
    estrategia de buscar os dados,estado ou a vm, dentro do build
    ele disponibiliza as referencias para buscar dentro do provider
    */
    //late final WidgetRef ref = context as WidgetRef;
    //acesso a view model, ele busca a instancia do provider notifier e nao do estado
    //destruction LoginVm e extrair a funcao login
    final LoginVm(:login) = ref.watch(loginVmProvider.notifier);
    //ficar escutando alteracoes do estado(provedor)
    ref.listen(loginVmProvider, (_, state) {
      switch (state) {
        case LoginState(status: LoginStateStatus.initial):
          break;
        case LoginState(status: LoginStateStatus.error, :final errorMessage?):
          Messages.showError(errorMessage, context);
        case LoginState(status: LoginStateStatus.error):
          Messages.showError('Erro ao realizar login', context);
        case LoginState(status: LoginStateStatus.admLogin):
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/home/adm', (route) => false);
          break;
        case LoginState(status: LoginStateStatus.employeeLogin):
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/home/employee', (route) => false);
          break;
      }
    }); //loginVmProvider =estado

    return Scaffold(
      backgroundColor: Colors.black,

      //  body: DecoratedBox -> wrap widget form
      body: Form(
        key: formKey, //add form key
        child: DecoratedBox(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                ImageConstants.backgroundChair,
              ),
              fit: BoxFit.cover,
              opacity: 0.5,
            ),
          ),
          //customizar para ter uma rolagem na tela na feature criar conta
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  //ocupa a tela como um todo
                  hasScrollBody: false,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      //construindo form
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(ImageConstants.imageLogo),
                          //para dar o distanciamento entre o logo  einput do form
                          const SizedBox(
                            height: 24,
                          ),
                          TextFormField(
                            //invocar o helper onfocus para controlar o fechamento do teclado qdo clica fora do input
                            onTapOutside: (_) => context.unfocus(),
                            validator: Validatorless.multiple([
                              Validatorless.required('E-mail obrigatório'),
                              Validatorless.email('E-mail inválido'),
                            ]),
                            controller: emailEC, //inserindo o controller email
                            decoration: const InputDecoration(
                              label: Text('Email'),
                              hintText: 'E-mail',
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              labelStyle: TextStyle(color: Colors.black),
                              hintStyle: TextStyle(color: Colors.black),
                            ),
                          ),

                          const SizedBox(
                            height: 24,
                          ),
                          TextFormField(
                            onTapOutside: (_) => context.unfocus(),
                            validator: Validatorless.multiple([
                              Validatorless.required('Senha obrigatória'),
                              Validatorless.min(6,
                                  'Senha deve conter pelo menos 6 caracteres'),
                            ]),
                            obscureText:
                                true, //para nao aparecer nada enquanto o user digita
                            controller: passwordEC,
                            decoration: const InputDecoration(
                              label: Text('Senha'),
                              hintText: 'Senha',
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              labelStyle: TextStyle(color: Colors.black),
                              hintStyle: TextStyle(color: Colors.black),
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Esqueceu a senha?',
                              style: TextStyle(
                                fontSize: 12,
                                color: ColorsConstants.brow,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(56),
                            ),
                            onPressed: () {
                              //validar o form
                              switch (formKey.currentState?.validate()) {
                                case (false || null): //se for falso ou nulo
                                  //mostrar msn de erro...campos invalidos
                                  Messages.showError(
                                      'Campos inválidos', context);
                                  break;
                                case true: //chama login q recebe email e pw
                                  login(emailEC.text, passwordEC.text);
                              }
                            },
                            child: const Text(
                              'ACESSAR',
                            ),
                          ),
                        ],
                      ),
                      Align(
                        //envolver text com widget Align
                        alignment: Alignment.bottomCenter,
                        //envolver Text com widget InkWeel nao tem estilo
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed('/auth/register/user');
                          },
                          child: const Text(
                            // envolver o Text com Align(wrap widget)
                            'Criar conta',
                            style: TextStyle(
                              //ver figma
                              color: Colors.white,
                              fontWeight: FontWeight.w500, //w500 medium
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
