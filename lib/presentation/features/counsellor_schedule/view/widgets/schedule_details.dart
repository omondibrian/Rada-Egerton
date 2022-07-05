import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rada_egerton/data/status.dart';
import 'package:rada_egerton/presentation/features/counsellor_schedule/bloc/bloc.dart';
import 'package:rada_egerton/presentation/widgets/button.dart';

class ScheduleDetails extends StatelessWidget {
  const ScheduleDetails({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    add() {
      showModalBottomSheet(
        context: context,
        builder: (_) => _edit(context),
      );
    }

    return Card(
      child: Container(
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.all(15),
        child: BlocBuilder<CounsellorScheduleCubit, ScheduleState>(
          builder: (context, state) {
            if (state.status == ServiceStatus.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Column(
              children: <Widget>[
                if (state.counsellor?.schedule != null)
                  ...state.counsellor!.schedule.map(
                    (c) => ListTile(
                      leading: const Icon(Icons.calendar_today),
                      title: Text(c.day),
                      subtitle: Text("${c.activeFrom} - ${c.activeTo}"),
                      trailing: state.canEdit
                          ? IconButton(
                              onPressed: () => context
                                  .read<CounsellorScheduleCubit>()
                                  .delete(c),
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            )
                          : null,
                    ),
                  ),
                if (state.canEdit)
                  RadaButton(
                    fill: true,
                    handleClick: add,
                    title: "Add",
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

Future<TimeOfDay?> pickDate(BuildContext context) async {
  final time = await showTimePicker(
    context: context,
    initialTime: const TimeOfDay(hour: 8, minute: 30),
  );
  return time;
}

Widget _edit(BuildContext context) {
  final TextEditingController to = TextEditingController();
  final TextEditingController from = TextEditingController();
  String? day = "monday";
  return SizedBox(
    height: MediaQuery.of(context).size.height * .5,
    child: Column(
      children: [
        const SizedBox(height: 40),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * .4,
              child: _DaySelect(
                valueSelect: (value) => {day = value},
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * .2,
              child: TextFormField(
                decoration: const InputDecoration(
                  hintText: "From:",
                ),
                readOnly: true,
                controller: from,
                textAlign: TextAlign.center,
                onTap: () async {
                  final time = await pickDate(context);
                  // ignore: use_build_context_synchronously
                  from.text = time?.format(context) ?? "";
                },
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * .2,
              child: TextFormField(
                decoration: const InputDecoration(
                  hintText: "To:",
                ),
                readOnly: true,
                controller: to,
                textAlign: TextAlign.center,
                onTap: () async {
                  final time = await pickDate(context);
                  // ignore: use_build_context_synchronously
                  to.text = time?.format(context) ?? "";
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * .4,
              child: RadaButton(
                handleClick: () {
                  if (day != null &&
                      from.text.isNotEmpty &&
                      to.text.isNotEmpty) {
                    context.read<CounsellorScheduleCubit>().updateSchedule(
                          from: from.text,
                          to: to.text,
                          day: day!,
                        );
                    Navigator.of(context).pop();
                  }
                },
                title: "Submit",
                fill: true,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * .4,
              child: RadaButton(
                fill: false,
                handleClick: () => Navigator.of(context).pop(),
                title: "Cancel",
              ),
            )
          ],
        ),
      ],
    ),
  );
}

class _DaySelect extends StatefulWidget {
  final Function(String?) valueSelect;
  const _DaySelect({Key? key, required this.valueSelect}) : super(key: key);

  @override
  State<_DaySelect> createState() => __DaySelectState();
}

class __DaySelectState extends State<_DaySelect> {
  String? day = "monday";
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      items: [
        "monday",
        "tuesday",
        "wednesday",
        "thursday",
        "friday",
        "saturday",
        "sunday",
      ]
          .map(
            (day) => DropdownMenuItem(
              value: day,
              child: Text(day),
            ),
          )
          .toList(),
      value: day,
      onChanged: (value) {
        setState(() {
          day = value;
        });
        widget.valueSelect(day);
      },
    );
  }
}
