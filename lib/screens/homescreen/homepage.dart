import 'package:event_ticketing_mobile_app/models/event_model.dart';
import 'package:event_ticketing_mobile_app/provider/auth.dart';
import 'package:event_ticketing_mobile_app/provider/nav_bar.dart';
import 'package:event_ticketing_mobile_app/screens/homescreen/widgets/category_item.dart';
import 'package:event_ticketing_mobile_app/screens/homescreen/widgets/recommended_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedpage = Provider.of<NavProvider>(context).selectetab;
    return Scaffold(
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(left: 5),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.location_on),
                          SizedBox(width: 8),
                          Text(
                            'Eldoret,Kenya',
                            style: TextStyle(),
                          ),
                        ],
                      ),
                      InkWell(
                          onTap: () {
                            Provider.of<FbAuthProvider>(context, listen: false)
                                .signOut();
                          },
                          child: Container(
                            margin: const EdgeInsets.only(left: 10),
                            child: const Icon(
                              Icons.logout_sharp,
                            ),
                          ))
                    ],
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      label: Text("Search Events"),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Text(
                      'Categories',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const SingleChildScrollView(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        CategoryItem(
                          name: 'Reggae',
                          icon: Icons.music_note,
                        ),
                        CategoryItem(
                          name: 'RnB',
                          icon: Icons.music_note,
                        ),
                        CategoryItem(
                          name: 'Jazz',
                          icon: Icons.music_note,
                        ),
                        CategoryItem(
                          name: 'Comedy',
                          icon: Icons.music_note,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Recommended',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).size.height * .3,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 6,
                          itemBuilder: (ctx, index) {
                            return RecommendedItem(
                              event: EventModel(
                                  section: null,
                                  id: "",
                                  recommended: true,
                                  upcoming: true,
                                  description: "",
                                  title: "Burna Boy's Afro Fest",
                                  imageUrl:
                                      "https://pbs.twimg.com/media/DpkN5pOX4AA5zzt.jpg:large",
                                  venue: "Eldoret,Kenya",
                                  time: "10PM",
                                  date: "20 AUG 2024"),
                            );
                          })),

                  //////////
                  ///
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'UpComing',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).size.height * .3,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 6,
                          itemBuilder: (ctx, index) {
                            return RecommendedItem(
                              event: EventModel(
                                  section: null,
                                  id: "",
                                  description: "",
                                  title: "Burna Boy's Afro Fest",
                                  imageUrl:
                                      "https://pbs.twimg.com/media/DpkN5pOX4AA5zzt.jpg:large",
                                  venue: "Eldoret,Kenya",
                                  time: "10PM",
                                  date: "20 AUG 2024",
                                  recommended: true,
                                  upcoming: true),
                            );
                          })),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: NavigationBarTheme(
          data: NavigationBarThemeData(
            height: 60,
            indicatorShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            indicatorColor: Colors.grey.shade900,
          ),
          child: NavigationBar(
            selectedIndex: selectedpage,
            onDestinationSelected: (value) {
              Provider.of<NavProvider>(context, listen: false).select(value);
            },
            destinations: const [
              NavigationDestination(
                icon: Icon(
                  Icons.home_filled,
                ),
                label: 'Home',
                selectedIcon: Icon(
                  Icons.home_outlined,
                  color: Colors.white,
                ),
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.receipt_long,
                ),
                label: 'Tickets',
                selectedIcon: Icon(
                  Icons.receipt_long,
                  color: Colors.white,
                ),
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.shopping_basket_rounded,
                ),
                label: 'Cart',
                selectedIcon: Icon(
                  Icons.shopping_basket_rounded,
                  color: Colors.white,
                ),
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.person_pin_circle_sharp,
                ),
                label: 'Profile',
                selectedIcon: Icon(
                  Icons.person_pin_circle_sharp,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ));
  }
}
