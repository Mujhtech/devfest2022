import 'package:devfest/app/app.dart';
import 'package:devfest/auth/bloc/auth_bloc.dart';
import 'package:devfest/common/common.dart';
import 'package:devfest/extensions/extensions.dart';
import 'package:devfest/note/note.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:math' as math;

class NotePage extends StatelessWidget {
  const NotePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const NoteView();
  }
}

class NoteView extends StatefulWidget {
  const NoteView({super.key});

  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: const Duration(seconds: 2))
        ..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget statusWidget(NoteSyncStatus status) {
    if (status.isSyncing) {
      return AnimatedBuilder(
        animation: _controller,
        builder: (_, child) {
          return Transform.rotate(
            angle: _controller.value * 2 * math.pi,
            child: child,
          );
        },
        child: Icon(
          Icons.cloud_sync,
          size: 16,
          color: Theme.of(context).iconTheme.color,
        ),
      );
    } else if (status.isSuccess) {
      return const Icon(
        Icons.cloud_done,
        size: 16,
        color: AppColor.primary3,
      );
    } else if (status.isFailure) {
      return const Icon(Icons.sync_problem, size: 16, color: AppColor.primary2);
    } else {
      return Icon(
        Icons.sync,
        size: 16,
        color: Theme.of(context).iconTheme.color,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final notes = context.watch<NoteBloc>().state.notes;
    final syncStatus = context.watch<NoteBloc>().state.syncStatus;
    final layout = context.watch<AppDataBloc>().state.layout;
    final user = context.watch<AuthBloc>().state.user;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      floatingActionButton: SecondaryButton(
          icon: const Icon(
            Icons.add,
            size: 20,
            color: AppColor.black,
          ),
          onPressed: () {
            Navigator.push(context, PageTransition(const NewNotePage()));
          },
          label: 'Add new',
          width: 100,
          height: 50),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'My Notes',
                  style: Theme.of(context).textTheme.headline2,
                ),
                Row(
                  children: [
                    if (user != null && user.photo != null) ...[
                      GestureDetector(
                        onTap: () {
                          showAppDialog(
                              context: context,
                              height: 200,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SecondaryButton(
                                      foregroundBorderColor: AppColor.primary2,
                                      backgroundColor: AppColor.primary2,
                                      onPressed: () async {
                                        context
                                            .read<AuthBloc>()
                                            .add(AuthLogoutRequested());
                                        Navigator.pop(context);
                                      },
                                      textColor: AppColor.primary2,
                                      label: 'Logout',
                                      width: 200,
                                      height: 40)
                                ],
                              ));
                        },
                        child: Container(
                          width: 25,
                          height: 25,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              image: DecorationImage(
                                  image: NetworkImage(user.photo!),
                                  fit: BoxFit.cover),
                              border: Border.all(
                                  width: 2,
                                  color: Theme.of(context).iconTheme.color!)),
                        ),
                      ),
                      const Width5()
                    ],
                    GestureDetector(
                      onTap: () {
                        if (user != null && user.email != null) {
                          context.read<NoteBloc>().add(const NoteSync());
                        } else {
                          showAppDialog(
                              context: context,
                              height: 200,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SecondaryButton(
                                      onPressed: () async {
                                        context
                                            .read<AuthBloc>()
                                            .add(AuthSignIn(context));
                                        context
                                            .read<NoteBloc>()
                                            .add(const NoteSync());
                                        Navigator.pop(context);
                                      },
                                      icon: SvgPicture.asset(
                                        AppVector.google,
                                        width: 25,
                                        height: 25,
                                      ),
                                      label: 'Continue with google',
                                      width: 200,
                                      height: 40)
                                ],
                              ));
                        }
                      },
                      child: Container(
                          width: 25,
                          height: 25,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                  width: 2,
                                  color: Theme.of(context).iconTheme.color!)),
                          child: statusWidget(syncStatus)),
                    ),
                    const Width5(),
                    GestureDetector(
                      onTap: () {
                        context.read<AppDataBloc>().add(const NoteLayoutChanged(
                            layout: NoteDispayLayout.grid));
                      },
                      child: Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            border: layout == NoteDispayLayout.grid
                                ? Border.all(
                                    width: 2,
                                    color: Theme.of(context).iconTheme.color!)
                                : null),
                        child: Icon(
                          Icons.grid_view,
                          size: 16,
                          color: Theme.of(context).iconTheme.color,
                        ),
                      ),
                    ),
                    const Width5(),
                    GestureDetector(
                      onTap: () {
                        context.read<AppDataBloc>().add(const NoteLayoutChanged(
                            layout: NoteDispayLayout.column));
                      },
                      child: Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            border: layout == NoteDispayLayout.column
                                ? Border.all(
                                    width: 2,
                                    color: Theme.of(context).iconTheme.color!)
                                : null),
                        child: Icon(
                          Icons.view_list,
                          size: 18,
                          color: Theme.of(context).iconTheme.color,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(
              height: context.screenHeight(0.83),
              child: notes != null && notes.isNotEmpty
                  ? layout == NoteDispayLayout.grid
                      ? GridView.builder(
                          padding: const EdgeInsets.only(
                              top: 10, bottom: 20, left: 20, right: 20),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 100 / 100,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          shrinkWrap: true,
                          //clipBehavior: Clip.none,
                          itemBuilder: (context, index) {
                            final note = notes[index];
                            return NoteCard(
                              note: note,
                              key: Key(note.toString()),
                            );
                          },
                          itemCount: notes.length)
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemBuilder: (_, index) {
                            final note = notes[index];
                            return ColumnNoteCard(
                                key: Key(note.toString()), note: note);
                          },
                          separatorBuilder: (_, index) {
                            return const Height10();
                          },
                          itemCount: notes.length)
                  : Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'No note found, start taking note like a dev you are',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headline2,
                          )
                        ],
                      ),
                    ))
        ],
      ),
    );
  }
}
