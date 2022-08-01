import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maptest/constants/colors.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../business_logic/cubit/phone_auth/phone_auth_cubit.dart';
import '../../constants/string.dart';

class MyDrawer extends StatelessWidget {
  MyDrawer({Key? key}) : super(key: key);

  PhoneAuthCubit phoneAuthCubit = PhoneAuthCubit();

  Widget buildDrawerHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.blue[100],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            height: MediaQuery.of(context).padding.top,
          ),
          Container(
            padding: const EdgeInsetsDirectional.fromSTEB(70, 10, 70, 10),
            child: Image.asset(
              'assets/images/profil.jpeg',
              fit: BoxFit.cover,
            ),
          ),
          const Text(
            'Otmane Benlaldj',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          BlocProvider<PhoneAuthCubit>(
            create: (context) => phoneAuthCubit,
            child: Text(
              '${generateCountryFlag()} +213 ${phoneAuthCubit.getLoggedInUser().phoneNumber}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
        ],
      ),
    );
  }

  Widget buildDrawerListItem({
    required IconData leadingIcon,
    required String title,
    Widget? trailing,
    Function()? onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(
        leadingIcon,
        color: color ?? MyColors.blue,
      ),
      title: Text(title),
      trailing: trailing ??
          const Icon(
            Icons.arrow_right,
            color: MyColors.blue,
          ),
      onTap: onTap,
    );
  }

  Widget buildDrawerListItemDivider() {
    return const Divider(
      height: 0,
      thickness: 1,
      indent: 18,
      endIndent: 24,
    );
  }

  String generateCountryFlag() {
    String countryCode = 'dz';
    return countryCode.toUpperCase().replaceAllMapped(
          RegExp(r'[A-Z]'),
          (match) =>
              String.fromCharCode(match.group(0)!.codeUnitAt(0) + 127397),
        );
  }

  void _launcherUrk(String url) async {
    await canLaunchUrl(Uri.parse(url))
        ? throw 'Could not launch $url'
        : await launchUrl(Uri.parse(url));
  }

  Widget buildIconSocialMedia(String url, IconData icon) {
    return InkWell(
      onTap: () => _launcherUrk(url),
      child: Icon(
        icon,
        color: MyColors.blue,
        size: 35,
      ),
    );
  }

  Widget buildSocialMediaIcons() {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildIconSocialMedia('https://www.facebook.com/b.otmane.rock.boy/',
              FontAwesomeIcons.facebook),
          const SizedBox(
            width: 20,
          ),
          buildIconSocialMedia(
              'https://www.linkedin.com/in/otmane-benlaldj-a28621159/',
              FontAwesomeIcons.linkedin),
          const SizedBox(
            width: 20,
          ),
          buildIconSocialMedia('https://www.facebook.com/b.otmane.rock.boy/',
              FontAwesomeIcons.telegram),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          buildDrawerHeader(context),
          buildDrawerListItem(leadingIcon: Icons.person, title: 'My Profile'),
          buildDrawerListItemDivider(),
          buildDrawerListItem(
            leadingIcon: Icons.history,
            title: 'Places History',
            onTap: () {},
          ),
          buildDrawerListItemDivider(),
          buildDrawerListItem(leadingIcon: Icons.settings, title: 'Settings'),
          buildDrawerListItemDivider(),
          buildDrawerListItem(leadingIcon: Icons.help, title: 'Help'),
          buildDrawerListItemDivider(),
          BlocProvider<PhoneAuthCubit>(
            create: (context) => phoneAuthCubit,
            child: buildDrawerListItem(
              leadingIcon: Icons.logout,
              title: 'LogOut',
              color: Colors.red,
              trailing: SizedBox(),
              onTap: () async {
                await phoneAuthCubit.logOut();
                Navigator.pushReplacementNamed(context, loginScreen);
              },
            ),
          ),
          buildDrawerListItemDivider(),
          const SizedBox(
            height: 150,
          ),
          ListTile(
            leading: Text(
              'Follow us',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          Align(
              alignment: Alignment.bottomCenter, child: buildSocialMediaIcons())
        ],
      ),
    );
  }
}
/*Container(
      child: BlocProvider<PhoneAuthCubit>(
        create: (context) => phoneAuthCubit,
        child: ElevatedButton(
          onPressed: () async {
            await phoneAuthCubit.logOut();
            Navigator.pushReplacementNamed(context, loginScreen);
          },
          style: ElevatedButton.styleFrom(
              minimumSize: Size(110, 50),
              primary: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              )),
          child: const Text(
            'Log out',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
 */