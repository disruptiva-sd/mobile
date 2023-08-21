import 'package:dw_barbershop/src/core/ui/helpers/form_helper.dart';
import 'package:dw_barbershop/src/core/ui/helpers/messages.dart';
import 'package:dw_barbershop/src/features/register/user_register_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:validatorless/validatorless.dart';

//converter a class UserRegisterPage (option+enter)para StatefullWidget
//trocar StatefulWidget para
class UserRegisterPage extends ConsumerStatefulWidget {
  const UserRegisterPage({super.key});

  @override
  ConsumerState<UserRegisterPage> createState() => _UserRegisterPageState();
}

class _UserRegisterPageState extends ConsumerState<UserRegisterPage> {
//criar a conexao do form
  final formKey = GlobalKey<FormState>();
  final nameEC = TextEditingController();
  final emailEC = TextEditingController();
  final passwordEC = TextEditingController();

  @override
  void dispose() {
    nameEC.dispose();
    emailEC.dispose();
    passwordEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userRegisterVM = ref.watch(userRegisterVmProvider.notifier);
    //ficar esctuando as alteracoes da tela
    ref.listen(userRegisterVmProvider, (_, state) {
      switch (state) {
        case UserRegisterStateStatus.initial:
        case UserRegisterStateStatus.success:
        case UserRegisterStateStatus.error:
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar Conta'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        //envolvendo padding para em volta da tela ter centralizacao
        child: SingleChildScrollView(
          child: Form(
            key: formKey, //precisa da key para fazer a validacao
            child: Column(
              children: [
                //fu-separator
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  //add controller e validacao
                  onTapOutside: (_)=> context.unfocus(),
                  controller: nameEC,
                  validator: Validatorless.required('Nome obrigatório'),
                  decoration: const InputDecoration(
                    label: Text('Nome'),
                  ),
                ),
                //fu-separator
                const SizedBox(
                  height: 24,
                ),
                TextFormField(
                  onTapOutside: (_)=> context.unfocus(),
                  controller: emailEC,
                  validator: Validatorless.multiple([
                    Validatorless.required('E-mail obrigatório'),
                    Validatorless.email('E-mail inválido'),
                  ]),
                  decoration: const InputDecoration(
                    label: Text('E-mail'),
                  ),
                ),
                //fu-separator
                const SizedBox(
                  height: 24,
                ),
                TextFormField(
                  onTapOutside: (_)=> context.unfocus(),
                  controller: passwordEC,
                  validator: Validatorless.multiple([
                    Validatorless.required('Senha obrigatória'),
                    Validatorless.min(
                        6, 'Senha deve ter no mínimo 6 caracteres'),
                  ]),
                  obscureText: true, //para esconder a senha
                  decoration: const InputDecoration(
                    label: Text('Senha'),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                TextFormField(
                  onTapOutside: (_)=> context.unfocus(),
                  validator: Validatorless.multiple([
                    Validatorless.required('Confirma Senha obrigatória'),
                    Validatorless.compare(passwordEC, 'Senha diferente de confirma a senha'),  
                  ]),
                  obscureText: true,
                  decoration: const InputDecoration(
                    label: Text('Confirma Senha'),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(56)),
                  onPressed: () {
                    //validar form
                    switch(formKey.currentState?.validate()){
                      case null || false:
                      Messages.showError('Formulário inválido',context);
                      case true:
                      userRegisterVM.register(
                        name:nameEC.text,
                        email:emailEC.text,
                        password:passwordEC.text
                        );
                    }
                  },
                  child: const Text('Criar Conta'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
