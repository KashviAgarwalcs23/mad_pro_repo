import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/components/my_drawer.dart';
import 'package:untitled/models/playlist_provider.dart';
import 'package:untitled/models/song.dart';
import 'package:untitled/pages/song_page.dart';
import 'package:untitled/auth/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService _authService = AuthService();
  late PlaylistProvider playlistProvider;

  @override
  void initState() {
    super.initState();
    // Accessing provider in initState requires a workaround using addPostFrameCallback
    WidgetsBinding.instance.addPostFrameCallback((_) {
      playlistProvider = Provider.of<PlaylistProvider>(context, listen: false);
    });
  }

  void _logout() async {
    await _authService.signOut();
    // StreamBuilder in main.dart handles redirection
  }

  void goToSong(int songIndex) {
    playlistProvider.currentSongIndex = songIndex;

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SongPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text("P L A Y L I S T"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      drawer: const MyDrawer(),
      body: Consumer<PlaylistProvider>(
        builder: (context, value, child) {
          final List<Song> playlist = value.playlist;

          return ListView.builder(
            itemCount: playlist.length,
            itemBuilder: (context, index) {
              final Song song = playlist[index];

              return ListTile(
                title: Text(song.songName),
                subtitle: Text(song.artistName),
                leading: Image.asset(song.albumArtImagePath),
                onTap: () => goToSong(index),
              );
            },
          );
        },
      ),
    );
  }
}
