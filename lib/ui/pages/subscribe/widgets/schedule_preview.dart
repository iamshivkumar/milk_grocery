import 'package:flutter/material.dart';
import '../../../../utils/dates.dart';
import '../../../../utils/utils.dart';
import 'package:table_calendar/table_calendar.dart';

class SchedulePreview extends StatelessWidget {
  final List<DateTime> dates;

  const SchedulePreview({Key? key, required this.dates}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final calenderStyle = CalendarStyle();

    final theme = Theme.of(context);
    return TableCalendar(
      calendarStyle: CalendarStyle(
        selectedDecoration: BoxDecoration(
          color: theme.accentColor,
          shape: BoxShape.circle,
        ),
        todayTextStyle: calenderStyle.defaultTextStyle,
        todayDecoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: theme.accentColor, width: 1),
          shape: BoxShape.circle,
        ),
      ),
      selectedDayPredicate: (d) => dates.where((element) => isSameDay(element, d)).isNotEmpty,
      daysOfWeekStyle: DaysOfWeekStyle(
        dowTextFormatter: (d, e) => Utils.weekD(d),
      ),
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
      ),
      availableCalendarFormats: {
        CalendarFormat.month: "Month",
      },
      calendarFormat: CalendarFormat.month,
      focusedDay: DateTime.now(),
      firstDay: Dates.today,
      lastDay: DateTime(2025),
    );
  }
}
