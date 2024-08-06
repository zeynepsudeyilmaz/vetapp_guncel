import 'package:flutter/material.dart';
import 'package:veteriner_uygulamasi/components/my_button.dart';
import '../../../services/appointment/appointment.dart';
import '../../../widgets/build_appointment_hour.dart';
import '../../../widgets/calender.dart';

// Randevu alma ekranı
class TakeAppointment extends StatefulWidget {
  final String vetId;

  const TakeAppointment({super.key, required this.vetId});

  @override
  State<TakeAppointment> createState() => _TakeAppointmentState();
}

class _TakeAppointmentState extends State<TakeAppointment> {
  DateTime selectedDate = DateTime.now();
  String? selectedHour;

  // Saat listesi
  final List<String> hours = [
    "09:00",
    "10:00",
    "11:00",
    "12:00",
    "13:00",
    "14:00",
    "15:00",
    "16:00",
    "17:00",
    "18:00",
    "19:00",
    "20:00",
  ];

  // Randevu ekleme fonksiyonu
  void bookAppointment() async {
    if (selectedHour != null) {
      final appointment = Appointment();
      await appointment.addAppointment(
        vetId: widget.vetId,
        date: selectedDate,
        hour: selectedHour!,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Randevu başarıyla alındı!')),
      );

      setState(() {
        selectedHour = null;
        selectedDate = DateTime.now();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen bir saat seçin!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3E5FA),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Takvim bileşeni
            CalendarWidget(
              focusedDay: selectedDate,
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  selectedDate = selectedDay;
                });
              },
            ),
            const SizedBox(height: 30.0),
            Wrap(
              spacing: 15,
              runSpacing: 20,
              children: hours.map((hour) {
                return HourBox(
                  hour: hour,
                  isSelected: selectedHour == hour,
                  onSelected: (selectedHour) => setState(() {
                    this.selectedHour = selectedHour;
                  }),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            MyButton(
              onPressed: bookAppointment,
              text: "Randevu Al",
            ),
          ],
        ),
      ),
    );
  }
}
