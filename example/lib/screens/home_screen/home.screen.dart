import 'package:bluetooth_classic_example/screens/home_screen/home_screen.provider.dart';
import 'package:bluetooth_classic_example/widgets/SelectedBottleCard.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        return HomeScreenProvider();
      },

      child: Consumer<HomeScreenProvider>(
        builder: (context, state, _) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                buildCurrentAndGoal(state),
                buildWaterTracker(state),
              ],
            );
          }
      ),
    );
  }

  Widget buildWaterTracker(HomeScreenProvider state) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildBottleSize(state),
          const SizedBox(width: 20,),
          buildWaterFiller(state),
        ],
      ),
    );
  }

  Widget buildCurrentAndGoal(HomeScreenProvider state) {
    return Padding(
      padding: EdgeInsets.only(top: 80, bottom: 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Current",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15,),

              Text(
                "${(state.waterPercentage * 1000).round()}ml",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo
                ),
              ),
            ]
          ),

          const SizedBox(width: 50,),

          const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Goal",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                  ),
                ),

                SizedBox(height: 15,),

                Text(
                  "2000ml",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo
                  ),
                ),
              ]
          )
        ],
      ),
    );
  }

  Widget buildBottleSize(HomeScreenProvider state) {
    return Column(
      children: [
        // SelectedBottleSize(Icons.water_drop, 1000, state),

        SelectedBottleSize(state),


        const SizedBox(height: 10,),

        const Text("or choose another"),

        const SizedBox(height: 10,),

        Row(
          children: [
            CustomBottleSizeCard(Icons.recycling, 500, state),
            CustomBottleSizeCard(Icons.ac_unit, 330, state),
            CreateNewBottleSizeCard(state)
          ],
        )
      ],
    );
  }

  Widget SelectedBottleSizeCard(IconData icon, int millis, HomeScreenProvider state) {
    return GestureDetector(
      onTap: () {
        state.onSelectedBottlePressed();
        HapticFeedback.vibrate();
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          width: 100,
          height: 120,
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(10),
          ),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: Colors.white
              ),

              const SizedBox(height: 10,),

              Text(
                "${state.selectedBottleMillis}ml",
                style: const TextStyle(
                    color: Colors.white54,
                    fontWeight: FontWeight.bold
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget CustomBottleSizeCard(IconData icon, int millis, HomeScreenProvider state) {
    return GestureDetector(
      onTap: () {
          state.onChangeSelectedBottle(millis);
          HapticFeedback.heavyImpact();
        },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        child: Container(
          width: 55,
          height: 55,
          decoration: BoxDecoration(
            // color: Colors.black54,
            borderRadius: BorderRadius.circular(10),
          ),
          
          child: Center(
            child: Text(
              "${millis}ml",
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,

              ),
            ),
          )
        ),
      ),
    );
  }

  Widget CreateNewBottleSizeCard(HomeScreenProvider state) {
    return GestureDetector(
      onTap: () => state.onWaterPercentageChange(state.waterPercentage / 1000),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        child: Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade100,
              borderRadius: BorderRadius.circular(100),
            ),

            child: const Center(
              child: Icon(
                Icons.add,
                size: 36,
              ),
            )
        ),
      ),
    );
  }

  Widget buildWaterFiller(HomeScreenProvider state) {
    return CircularPercentIndicator(
        animation: true,
        animationDuration: 1000,
        radius: 85,
        lineWidth: 15,
        percent: state.waterPercentage,
        progressColor: Colors.green.shade700,
        backgroundColor: Colors.green.shade100,
        circularStrokeCap: CircularStrokeCap.round,
        center: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${(state.waterPercentage * 100).round()}%",
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade700
              ),
            ),

            Text(
              "to daily goal",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal
              ),
            ),
          ],
        ),

    );
  }
}