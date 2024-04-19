import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_list/core/router/name_routes_notifier.dart';
import 'package:todo_list/features/auth/domain/entities/entities.dart';
import 'package:todo_list/features/auth/view/pages/home_page.dart';
import 'package:todo_list/features/auth/view/pages/login_page.dart';
import 'package:todo_list/features/auth/view/providers/auth_providers.dart';
import 'package:todo_list/features/tarefa/presentation/pages/tarefa_page.dart';

import 'named_routes.dart';

export 'named_routes.dart';

final goRouterProvider = Provider(
  (ref) {
    final statusUsuarioNotifier = ref.read(statusUsuarioProvider);
    return GoRouter(
      initialLocation: "/",
      refreshListenable: statusUsuarioNotifier,
      redirect: (ctx, state) async {
        final loginRepo = await ref.read(loginRepoProvider);
        final statusLogin = loginRepo.autoLogin();

        if (statusUsuarioNotifier.statusUsuario != statusLogin) {
          statusUsuarioNotifier.statusUsuario = statusLogin;
        }

        final indoParaLogin = state.fullPath == '/';
        if (indoParaLogin) {
          switch (statusUsuarioNotifier.statusUsuario) {
            case StatusUsuario.deslogado:
              return null;
            case StatusUsuario.logado:
              return "/tarefas";
          }
        }
        return null;
      },
      routes: [
        GoRoute(
          path: NamedRoutes.home.routePath,
          name: NamedRoutes.home.routeName,
          pageBuilder: (ctx, state) {
            return const MaterialPage(child: HomePage());
          },
        ),
        GoRoute(
          path: NamedRoutes.login.routePath,
          name: NamedRoutes.login.routeName,
          pageBuilder: (ctx, state) => const MaterialPage(child: LoginPage()),
        ),
        GoRoute(
          path: NamedRoutes.tarefas.routePath,
          name: NamedRoutes.tarefas.routeName,
          pageBuilder: (ctx, state) => const MaterialPage(child: TarefaPage()),
        ),
      ],
    );
  },
);