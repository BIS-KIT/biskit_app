import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:table_calendar/table_calendar.dart';

class CalendarWidget extends StatefulWidget {
  final DateTime? selectedDay;
  final Function(DateTime)? onDaySelected;
  const CalendarWidget({Key? key, this.onDaySelected, this.selectedDay})
      : super(key: key);

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  DateTime selectedDay = DateTime.now();
  DateTime now = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.selectedDay != null) {
      setState(() {
        selectedDay = widget.selectedDay!;
      });
    }
  }

  void onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      selectedDay = day;
    });

    if (widget.onDaySelected != null) {
      widget.onDaySelected!(day);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableCalendar(
          locale: context.locale.toString(),
          rowHeight: 53,
          daysOfWeekHeight: 40,
          sixWeekMonthsEnforced: true,
          daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle: kTsKrBody16Rg.copyWith(color: kColorContentWeaker),
            weekendStyle: kTsKrBody16Rg.copyWith(color: kColorContentWeaker),
          ),
          headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              headerPadding: const EdgeInsets.symmetric(vertical: 8),
              titleTextStyle:
                  kTsKrHeading18Bd.copyWith(color: kColorContentDefault)),
          focusedDay: selectedDay,
          firstDay: DateTime(now.year, now.month, now.day),
          lastDay: DateTime(2040, 10, 24),
          selectedDayPredicate: (day) => isSameDay(day, selectedDay),
          onDaySelected: (selectedDay, focusedDay) =>
              onDaySelected(selectedDay, focusedDay),
          calendarStyle: CalendarStyle(
            selectedDecoration: const BoxDecoration(
              color: kColorBgSecondary,
              shape: BoxShape.circle,
            ),
            tablePadding: const EdgeInsets.all(10),
            outsideTextStyle:
                kTsKrBody16Rg.copyWith(color: kColorContentDisabled),
            disabledTextStyle:
                kTsKrBody16Rg.copyWith(color: kColorContentDisabled),
            todayTextStyle:
                kTsKrBody16Sb.copyWith(color: kColorContentSecondary),
            selectedTextStyle:
                kTsKrBody16Sb.copyWith(color: kColorContentInverse),
            defaultTextStyle:
                kTsKrBody16Rg.copyWith(color: kColorContentDefault),
            weekendTextStyle:
                kTsKrBody16Rg.copyWith(color: kColorContentDefault),
            todayDecoration: BoxDecoration(
                color: kColorContentInverse,
                shape: BoxShape.circle,
                border: Border.all(color: kColorContentSecondary, width: 1)),
          ),
        )
      ],
    );
  }
}
