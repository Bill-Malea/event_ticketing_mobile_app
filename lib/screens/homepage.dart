import 'package:event_ticketing_mobile_app/models/event_model.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
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
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.location_on),
                        SizedBox(width: 8),
                        Text(
                          'Eldoret,Kenya',
                          style: TextStyle(),
                        ),
                      ],
                    ),
                    Icon(Icons.menu)
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
                        selected: true,
                      ),
                      CategoryItem(
                        name: 'RnB',
                        icon: Icons.music_note,
                        selected: false,
                      ),
                      CategoryItem(
                        name: 'Jazz',
                        icon: Icons.music_note,
                        selected: false,
                      ),
                      CategoryItem(
                        name: 'Comedy',
                        icon: Icons.music_note,
                        selected: false,
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
                    height: MediaQuery.of(context).size.height * .5,
                    child: GridView.builder(
                        itemCount: 6,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 8,
                        ),
                        itemBuilder: (ctx, index) {
                          return RecommendedItem(
                            event: EventModel(
                                title: "Burna Boy's Afro Fest",
                                imageUrl:
                                    "https://pbs.twimg.com/media/DpkN5pOX4AA5zzt.jpg:large",
                                venue: "Eldoret,Kenya",
                                time: "10PM",
                                date: "20 AUG 2024"),
                          );
                        })),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final String name;
  final IconData icon;
  final bool selected;

  const CategoryItem(
      {super.key,
      required this.name,
      required this.icon,
      required this.selected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: Colors.black87,
        ),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 10),
            Icon(
              icon,
              size: 25,
              color: Colors.white,
            ),
            const SizedBox(height: 4),
            Text(
              name,
              style: const TextStyle(color: Colors.white, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}

class RecommendedItem extends StatelessWidget {
  final EventModel event;

  const RecommendedItem({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8.0),
              topRight: Radius.circular(8.0),
            ),
            child: Image.network(
              event.imageUrl,
              fit: BoxFit.cover,
              height: 180.0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  event.venue,
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
