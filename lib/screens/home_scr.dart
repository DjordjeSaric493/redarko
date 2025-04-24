import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/firebase_serv.dart';
import '../models/user_m.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? selectedShift;
  List<String> shiftOptions = [];
  List<UserModel> usersInShift = [];
  List<UserModel> myShifts = [];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final firebaseService = Provider.of<FirebaseService>(
      context,
      listen: false,
    );
    final email = firebaseService.user?.email ?? '';

    final allShifts = await firebaseService.getAllShiftTimes();
    final shifts = await firebaseService.getShiftsForUser(email);

    setState(() {
      shiftOptions = allShifts;
      selectedShift = allShifts.isNotEmpty ? allShifts.first : null;
      myShifts =
          shifts; //A value of type 'List<Map<String, dynamic>>' can't be assigned to a variable of type 'List<UserModel>'.
    });

    await _loadUsersInSelectedShift();
  }

  Future<void> _loadUsersInSelectedShift() async {
    if (selectedShift == null) return;

    final firebaseService = Provider.of<FirebaseService>(
      context,
      listen: false,
    );
    final users = await firebaseService.getUsersForShift(
      '',
      selectedShift!,
    ); // ako ne koristiš day, ostavi prazno
    setState(() {
      usersInShift = users;
    });
  }

  @override
  Widget build(BuildContext context) {
    final firebaseService = Provider.of<FirebaseService>(context);
    final userEmail = firebaseService.user?.email ?? 'Nepoznat';

    return Scaffold(
      appBar: AppBar(
        title: Text('Redarko'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await firebaseService.logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            shiftOptions.isEmpty
                ? Center(child: CircularProgressIndicator())
                : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: Icon(Icons.person),
                        title: Text('Prijavljeni ste kao:'),
                        subtitle: Text(userEmail),
                      ),
                    ),
                    SizedBox(height: 16),
                    Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Izaberite smenu:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            DropdownButton<String>(
                              value: selectedShift,
                              isExpanded: true,
                              items:
                                  shiftOptions.map((shift) {
                                    return DropdownMenuItem(
                                      value: shift,
                                      child: Text(shift),
                                    );
                                  }).toList(),
                              onChanged: (newValue) async {
                                setState(() {
                                  selectedShift = newValue;
                                });
                                await _loadUsersInSelectedShift();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Vaše prijavljene smene:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            ...myShifts.map((s) => Text('• ${s.shiftTime}')),
                            if (myShifts.isEmpty)
                              Text('Niste još prijavljeni ni za jednu smenu.'),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Prijavljeni u smenu $selectedShift:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            ...usersInShift.map((u) => Text('• ${u.name}')),
                            if (usersInShift.isEmpty)
                              Text('Nema još prijavljenih.'),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Zameni sa linkom do  forme
                          const googleFormUrl =
                              'https://docs.google.com/forms/d/e/1FAIpQLScnY9X.../viewform';
                          launchUrl(Uri.parse(googleFormUrl));
                        },
                        icon: Icon(Icons.edit_calendar),
                        label: Text('Popuni Google Formu za smenu'),
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}
