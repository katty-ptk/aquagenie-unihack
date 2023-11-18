import 'dart:ui';

import 'package:bluetooth_classic_example/providers/user.provider.dart';
import 'package:bluetooth_classic_example/screens/profile_screen/profile_screen.provider.dart';
import 'package:bluetooth_classic_example/utils/get_it.util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        return ProfileScreenProvider(
          getIt<UserProvider>()
        );
      },

      child: Consumer<ProfileScreenProvider>(
        builder: (context, state, _) {
          return Scaffold(
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: state.loading  // if provider is fetching data, show loading. else, show data based on user status
                  ? [const CircularProgressIndicator()]
                  : state.userExists
                    ? [Center(child: buildProfilePage(state))]
                    : !state.showEnterProfileInfo
                    ? [Center(child: buildAskToCreateProfile(state))]
                    : [Center(child: buildEnterProfileData(state))]
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildAskToCreateProfile(ProfileScreenProvider state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("It seems you do not have a profile created."),
        TextButton(
            onPressed: () {
              state.setShowEnterProfileInfo(true);
            },
            child: const Text("create one now")
        )
      ],
    );
  }

  Widget buildEnterProfileData(ProfileScreenProvider state) {
    TextEditingController dateController = TextEditingController();
    dateController.text = "";

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
            "Hi, ${state.userEmail}! ☺️",
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold
            ),
        ),

        const SizedBox(height: 20,),

        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 50),
          child: Form(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person),
                    border: const UnderlineInputBorder(
                    ),
                    label: const Text("Username"),
                    hintText: "ex: ${(state.userEmail).substring(0, (state.userEmail).indexOf('@'))}"
                  ),
                  onChanged: (value) => state.onUsernameChanged(value),
                ),  // username

                const SizedBox(height: 20,),

                Row(
                  children: [
                    const Text("When were you born?"),

                    const Spacer(),

                    Text(state.dateOfBirth.year != 2023 ? state.dateOfBirth.toString() : ""),
                    IconButton(
                      onPressed: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(), //get today's date
                            firstDate: DateTime(1950), //DateTime.now() - not to allow to choose before today.
                            lastDate: DateTime.now()
                        );

                        if ( pickedDate != null ) {
                          state.onDateOfBirthChanged(pickedDate);
                        }
                      },

                      icon: const Icon(Icons.date_range),
                    )
                  ],
                ),  // date of birth

                const SizedBox(height: 20,),

                Row(
                  children: [
                    const Text("What is your weight?"),
                    const Spacer(),

                    SizedBox(
                      width: 30,
                      child: TextFormField(
                        onChanged: (value) => state.onWeightChanged(value),
                        decoration: const InputDecoration(
                          hintText: "0",
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        textAlign: TextAlign.right,
                      ),
                    ),

                    const SizedBox(width: 10,),

                    const Text(" kg")
                  ],
                ),  // weight

                const SizedBox(height: 20,),

                Row(
                  children: [
                    const Text("What is your height?"),
                    const Spacer(),

                   SizedBox(
                     width: 30,
                     child: TextFormField(
                       onChanged: (value) => state.onHeightChanged(value),
                       decoration: const InputDecoration(
                         hintText: "0",
                       ),
                       inputFormatters: [
                         FilteringTextInputFormatter.digitsOnly
                       ],
                       textAlign: TextAlign.right,
                     ),
                   ),

                    const SizedBox(width: 10,),

                    const Text(" cm")
                  ],
                ),  // height

                const SizedBox(height: 20,),

                Row(
                  children: [
                    const Text("How active are you?"),
                    const Spacer(),

                    SizedBox(
                      width: 100,
                      child: DropdownButton(
                        isExpanded: true,
                        style: Theme.of(context).textTheme.headline6,
                        value: state.activity_level,
                        items: ["not active", "active", "extremely active"]
                            .map<DropdownMenuItem>(
                                (item) => DropdownMenuItem(
                              value: item,
                              child: Center(
                                  child: Text(
                                      item,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal
                                      ),
                                  )
                              ),
                            ))
                            .toList(),
                        onChanged: (value) => state.onActivityLevelChanged(value)
                      ),
                    ),
                  ],
                ),  // height

                TextButton(
                  onPressed: () async {
                    await state.createProfileForUser(
                        state.userEmail,
                        state.username,
                        "F",
                        state.age,
                        state.weight,
                        state.height,
                        state.activity_level,
                    );
                  },

                  child: const Text("save"),
                ) // save
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget buildProfilePage(ProfileScreenProvider state) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          buildUpperContainer(state),
          SingleChildScrollView(child: buildBottomContainer(state))
        ],
      ),
    );
  }

  Widget buildUpperContainer(ProfileScreenProvider state) {
    return Container(
      height: 300,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30)
        )
      ),
      child: Center(
        child: Text(
            "${state.userProfileData!.username}, ${state.userProfileData!.gender}",
            style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              color: Colors.white
            ),
          ),
      ),
    );
  }

  Widget buildBottomContainer(ProfileScreenProvider state) {
    return Container(
      height: 500,
      child: ListView(
            children: [
              InfoCard("Age", state.userProfileData!.age.toString()),
              InfoCard("Weight", state.userProfileData!.weight.toString()),
              InfoCard("Height", state.userProfileData!.height.toString()),
              InfoCard("Activity Level", state.userProfileData!.activity_level.toString()),
              InfoCard("Required Water Intake", state.userProfileData!.required_water_intake.toString()),
            ],
      ),
    );
  }

  Widget InfoCard(String key, String value){
    return Container(
      height: 90,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Card(
            elevation: 20,
            shadowColor: Colors.black87,
            // color: Colors.pink.shade100,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              //set border radius more than 50% of height and width to make circle
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        key,
                      style: TextStyle(
                        fontSize: 16,
                        // fontWeight: FontWeight.bold,
                        color: Colors.indigo.shade300
                      ),
                    ),

                    Divider(
                      thickness: 3,
                      color: Colors.grey.shade200,
                    ),

                    Text(
                        value,
                      style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        color: Colors.indigo
                      ),
                    ),
                  ],
                ),
            ),
        ),
    );
  }
}
