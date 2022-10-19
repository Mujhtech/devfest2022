import 'package:devfest/app/app.dart';
import 'package:devfest/app/app_color.dart';
import 'package:devfest/common/common.dart';
import 'package:devfest/core/core.dart';
import 'package:devfest/extensions/extensions.dart';
import 'package:devfest/note/note.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotePage extends StatelessWidget {
  const NotePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) {
          return NoteBloc(
            snackBarService: context.read<SnackBarService>(),
            noteService: context.read<NoteService>(),
          )..add(const NoteRefreshed());
        },
        child: const NoteView());
  }
}

class NoteView extends StatelessWidget {
  const NoteView({super.key});

  @override
  Widget build(BuildContext context) {
    final notes = context.watch<NoteBloc>().state.notes;
    final layout = context.watch<AppDataBloc>().state.layout;
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
                          itemBuilder: (_, index) {
                            return Container();
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
