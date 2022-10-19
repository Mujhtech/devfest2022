import 'package:devfest/app/app.dart';
import 'package:devfest/core/core.dart';
import 'package:devfest/data/models/notes_model.dart';
import 'package:devfest/extensions/extensions.dart';
import 'package:devfest/note/note.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class NewNotePage extends StatelessWidget {
  final NotesModel? note;
  const NewNotePage({super.key, this.note});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) {
          return NoteBloc(
              noteService: context.read<NoteService>(),
              snackBarService: context.read<SnackBarService>());
        },
        child: NewNoteView(
          note: note,
        ));
  }
}

class NewNoteView extends StatefulWidget {
  final NotesModel? note;
  const NewNoteView({super.key, this.note});

  @override
  State<NewNoteView> createState() => _NewNoteViewState();
}

class _NewNoteViewState extends State<NewNoteView> {
  TextEditingController note = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final focusNode = FocusNode();
  String? noteId;
  final debounce = Debounce(delayInMilliseconds: 1000);
  bool hasFocus = false;

  @override
  void initState() {
    super.initState();
    if (widget.note == null) {
      noteId = const Uuid().v4();
    } else {
      noteId = widget.note!.id;
      note = TextEditingController(text: widget.note?.note);
    }
    focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    focusNode.removeListener(_onFocusChange);
    focusNode.dispose();
    super.dispose();
  }

  _onFocusChange() {
    setState(() {
      hasFocus = focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    '${DateFormat('dd MMMM yyyy').format(DateTime.now())} at ${DateFormat('kk:mm').format(DateTime.now())}',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  SizedBox(
                    height: context.screenHeight(hasFocus ? 0.9 : 0.6),
                    child: TextFormField(
                      focusNode: focusNode,
                      controller: note,
                      cursorColor: AppColor.primary1,
                      style: Theme.of(context).textTheme.headline1,
                      expands: true,
                      maxLines: null,
                      minLines: null,
                      onChanged: (value) async {
                        if (value.isNotEmpty) {
                          NotesModel note = NotesModel(
                              id: noteId!,
                              userId: noteId!,
                              note: value,
                              sync: SyncStatus.unpblish,
                              createdAt: DateTime.now(),
                              updatedAt: DateTime.now());

                          debounce.call(() {
                            context
                                .read<NoteBloc>()
                                .add(NoteCreated(note: note));
                          });
                        }
                      },
                      decoration: InputDecoration(
                          hintText: 'Write something...',
                          hintStyle: Theme.of(context)
                              .textTheme
                              .headline1!
                              .copyWith(
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? AppColor.black.withOpacity(.2)
                                      : AppColor.white.withOpacity(.35)),
                          border: InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedBorder: InputBorder.none),
                      keyboardType: TextInputType.multiline,
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
