import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vehicle_management_app/data/models/user/driver.dart';
import 'package:vehicle_management_app/data/models/user/user.dart';
import 'package:vehicle_management_app/presentation/pages/user/profilescreen/cubit/profile_cubit.dart';
import 'package:vehicle_management_app/presentation/widgets/commonappbar.dart';

class ProfileScreenPage extends StatelessWidget {
  const ProfileScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: 'Profile'),
      body: BlocBuilder<ProfileCubit, dynamic>(
        builder: (context, state) {
          return state == null
              ? const Center(child: CircularProgressIndicator())
              : state.role == 'driver'
                  ? _buildDriverProfileScreen(state)
                  : _buildProfileScreen(state);
        },
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon, Color color) {
    return CircleAvatar(
      radius: 25,
      backgroundColor: color,
      child: Icon(icon, color: Colors.white),
    );
  }

  Widget _buildInfoCard(String title, String info, IconData icon) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ListTile(
        leading: Icon(icon, color: Colors.teal),
        title: Text(title),
        subtitle: Text(info),
      ),
    );
  }

  Widget _buildProfileScreen(UserModel? state) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const CircleAvatar(
            radius: 80,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 75,
              backgroundImage: NetworkImage('https://via.placeholder.com/150'),
            ),
          ),
          Text(
            state!.fullName.toString(),
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          Text(
            state.role.toString(),
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          const SizedBox(height: 20),
          _buildInfoCard('Email', state.email.toString(), Icons.email),
          _buildInfoCard('Phone', state.contactNumber.toString(), Icons.phone),
          _buildInfoCard(
              'Employee Id', state.employeeId.toString(), Icons.badge),
          _buildInfoCard(
              'Department', state.department.toString(), Icons.school),
          _buildInfoCard(
              'Designation', state.designation.toString(), Icons.work),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildDriverProfileScreen(DriverModel? state) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const CircleAvatar(
            radius: 80,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 75,
              backgroundImage: NetworkImage('https://via.placeholder.com/150'),
            ),
          ),
          Text(
            state!.name.toString(),
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          Text(
            state.role.toString(),
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          const SizedBox(height: 20),
          _buildInfoCard('Phone', state.contact.toString(), Icons.phone),
          _buildInfoCard(
              'Alternate Phone', state.altContact.toString(), Icons.phone),
          _buildInfoCard('Driver Id', state.driverId.toString(), Icons.badge),
          _buildInfoCard('Date of Birth', state.dateOfBirth.toString(),
              Icons.calendar_today),
          _buildInfoCard(
              'License Number', state.licenseNumber.toString(), Icons.badge),
          _buildInfoCard('License Expiry Date',
              state.licenseExpiryDate1.toString(), Icons.badge),
          _buildInfoCard('Address', state.residence.toString(), Icons.house),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
