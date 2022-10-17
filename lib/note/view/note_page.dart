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
    final notes = context.select((NoteBloc bloc) => bloc.state.notes);
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
                    Container(
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                              width: 2,
                              color: Theme.of(context).iconTheme.color!)),
                      child: Icon(
                        Icons.grid_view,
                        size: 16,
                        color: Theme.of(context).iconTheme.color,
                      ),
                    ),
                    const Width5(),
                    Container(
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                              width: 2,
                              color: Theme.of(context).iconTheme.color!)),
                      child: Icon(
                        Icons.view_list,
                        size: 18,
                        color: Theme.of(context).iconTheme.color,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(
              height: context.screenHeight(0.83),
              child: notes.isNotEmpty
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
