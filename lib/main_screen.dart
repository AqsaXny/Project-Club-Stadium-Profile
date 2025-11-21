import 'package:dicoding_projek/detail_screen.dart';
import 'package:dicoding_projek/model/tourism_place.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> leagues = tourismPlaceList
        .map((place) => place.league)
        .toSet()
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Club Stadium by League')),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: leagues.length,
        itemBuilder: (context, index) {
          final leagueName = leagues[index];

          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(
                  "assets/league_logo/${leagueName.toLowerCase().replaceAll(" ", "_")}.png",
                ),
                radius: 25,
              ),
              title: Text(
                leagueName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        LeagueStadiumScreen(league: leagueName),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class LeagueStadiumScreen extends StatefulWidget {
  final String league;

  const LeagueStadiumScreen({super.key, required this.league});

  @override
  State<LeagueStadiumScreen> createState() => _LeagueStadiumScreenState();
}

class _LeagueStadiumScreenState extends State<LeagueStadiumScreen> {
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    List<TourismPlace> filtered = tourismPlaceList
        .where((p) => p.league == widget.league)
        .toList();

    List<TourismPlace> searched = filtered
        .where((p) => p.name.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    List<TourismPlace> featured = filtered
        .where((p) => p.featured == true)
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text("Stadiums - ${widget.league}")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Cari stadion / club...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) => setState(() => searchQuery = value),
            ),
          ),
          if (featured.isNotEmpty)
            SizedBox(
              height: 180,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: featured.length,
                itemBuilder: (context, index) {
                  final place = featured[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(place: place),
                        ),
                      );
                    },
                    child: Container(
                      width: 250,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              place.imageAsset,
                              fit: BoxFit.cover,
                              width: 250,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Colors.black.withOpacity(0.7),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 10,
                            left: 10,
                            child: Text(
                              place.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    color: Colors.black,
                                    blurRadius: 5,
                                    offset: Offset(1, 1),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth <= 600) {
                  return StadiumListView(searched);
                } else {
                  return StadiumGridView(
                    places: searched,
                    gridCount: constraints.maxWidth <= 1200 ? 4 : 6,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class StadiumListView extends StatelessWidget {
  final List<TourismPlace> places;
  const StadiumListView(this.places, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: places.length,
      itemBuilder: (context, index) {
        final place = places[index];

        return Card(
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return DetailScreen(place: place);
                  },
                ),
              );
            },
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Image.asset(place.imageAsset, fit: BoxFit.cover),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          place.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(place.location),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class StadiumGridView extends StatelessWidget {
  final List<TourismPlace> places;
  final int gridCount;

  const StadiumGridView({
    super.key,
    required this.places,
    required this.gridCount,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: const EdgeInsets.all(16),
      crossAxisCount: gridCount,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: places.map((place) {
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return DetailScreen(place: place);
                },
              ),
            );
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: Image.asset(place.imageAsset, fit: BoxFit.cover),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    place.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, bottom: 8),
                  child: Text(place.location),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
