import 'package:biskit_app/common/const/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({super.key});

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  DateTime today = DateTime.now();
  final DateTime _now = DateTime.now();

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableCalendar(
          locale: context.locale.toString(),
          rowHeight: 53,
          daysOfWeekHeight: 40,
          daysOfWeekStyle: const DaysOfWeekStyle(
              weekdayStyle: TextStyle(
                color: kColorContentWeaker,
                fontSize: 16,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w400,
                height: 0.09,
              ),
              weekendStyle: TextStyle(
                color: kColorContentWeaker,
                fontSize: 16,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w400,
                height: 0.09,
              )),
          headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              headerPadding: EdgeInsets.symmetric(vertical: 8),
              titleTextStyle: TextStyle(
                color: kColorContentDefault,
                fontSize: 18,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w700,
                height: 0.08,
              )),
          focusedDay: today,
          firstDay: DateTime(_now.year, _now.month, _now.day),
          lastDay: DateTime(2040, 10, 24),
          selectedDayPredicate: (day) => isSameDay(day, today),
          onDaySelected: _onDaySelected,
          calendarStyle: CalendarStyle(
            selectedDecoration: const BoxDecoration(
              color: kColorBgSecondary,
              shape: BoxShape.circle,
            ),
            tablePadding: const EdgeInsets.all(10),
            todayTextStyle: const TextStyle(
                color: kColorContentSecondary,
                fontSize: 16,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w600,
                height: 0.09),
            selectedTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w600,
              height: 0.09,
            ),
            defaultTextStyle: const TextStyle(
              color: kColorContentDefault,
              fontSize: 16,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w400,
              height: 0.09,
            ),
            todayDecoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: kColorContentSecondary, width: 1)),
          ),
        )
      ],
    );
  }
}
