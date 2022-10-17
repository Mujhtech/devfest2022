import 'package:devfest/data/models/notes_model.dart';
import 'package:devfest/note/note.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NoteCard extends StatelessWidget {
  final NotesModel note;
  const NoteCard({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            OpenNoteTransition(NewNotePage(
              note: note,
            )));
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Theme.of(context).iconTheme.color!.withOpacity(0.2),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
                width: 2,
                color: Theme.of(context).iconTheme.color!.withOpacity(0.5))),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  note.note,
                  maxLines: 6,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              Center(
                child: Text(
                  DateFormat('dd MMMM yyyy').format(note.updatedAt),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              )
            ]),
      ),
    );
  }
}
