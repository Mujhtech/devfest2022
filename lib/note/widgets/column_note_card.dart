import 'package:devfest/common/common.dart';
import 'package:devfest/data/models/notes_model.dart';
import 'package:devfest/note/note.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ColumnNoteCard extends StatelessWidget {
  final NotesModel note;
  const ColumnNoteCard({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return InkWell(
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
            color: Theme.of(context).iconTheme.color!.withOpacity(0.05),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
                width: 2,
                color: Theme.of(context).iconTheme.color!.withOpacity(0.1))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
              text: TextSpan(
                style: Theme.of(context).textTheme.headline4!.copyWith(
                      fontSize: 12,
                    ),
                text: '${DateFormat('dd MMMM yyyy').format(note.updatedAt)}: ',
                children: [
                  TextSpan(
                    text: note.note,
                    style: const TextStyle(fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
            const Height10(),
            Row(
              children: [
                Icon(
                  Icons.note,
                  size: 20,
                  color: Theme.of(context).iconTheme.color,
                ),
                const Width10(),
                Text(
                  'Note',
                  style: Theme.of(context).textTheme.headline4,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
