import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:creator_hub/camera_screen.dart';
import 'package:flutter/material.dart';
import 'package:creator_hub/Models/colors.dart';
import 'package:creator_hub/Models/textstyles.dart';
import 'package:creator_hub/Views/channel_avatar.dart';
import 'package:creator_hub/Views/video_card.dart';
import 'package:youtube_video_info/youtube.dart';
import 'Models/channel.dart';
import 'Models/video.dart';

ThemeData darkTheme = ThemeData.dark().copyWith(
  colorScheme: const ColorScheme.dark(
    primary: Colors.blue,
    secondary: Colors.orange,
  ),
);

Future<String> fetchSummary({
  required String youtubeLink,
  required String serverLink,
}) async {
  String apiUrl = "$serverLink/api/summarize?youtube_url=$youtubeLink";

  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final summaryList = jsonResponse as Map<String, dynamic>;

      if (summaryList.isNotEmpty) {
        final summary = summaryList['summary'] as String;
        return summary;
      } else {
        return 'Summary not found';
      }
    } else {
      return 'Failed to fetch summary. Error code: ${response.statusCode}';
    }
  } catch (e) {
    return 'Failed to fetch summary: $e';
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: darkTheme,
      home: const MyHomePage(),
    ),
  );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  static const String hintText_2 = "Youtube URL...";
  static const String hintText_1 = "Ngrok server link(.app)...";
  static String? summary;
  static YoutubeDataModel? videoData;
  late final TextEditingController link;
  late final TextEditingController server;

  void _fetchMetadata({required String link, required String server}) async {
    videoData = await YoutubeData.getData(link: link);
    summary = await fetchSummary(youtubeLink: link, serverLink: server);
    setState(() {});
  }

  @override
  void initState() {
    link = TextEditingController();
    server = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    link.dispose();
    super.dispose();
  }

  Widget _boldText(boldText, normalText) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 14.0,
          // color: Colors.black,
        ),
        children: <TextSpan>[
          TextSpan(
              text: boldText,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: normalText),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: const Row(
            children: <Widget>[
              SizedBox(
                width: 40,
                child: Image(
                  image: AssetImage("assets/youtube_logo.png"),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 10),
              ),
              // SingleChildScrollView(
              //   child: Text(
              //     "Creator Hub",
              //     style: youtube,
              //   ),
              // ),
            ],
          ),
          actions: <Widget>[
            SizedBox(
              width: 180,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment:
                    CrossAxisAlignment.center, // Adjust this to your preference
                children: <Widget>[
                  SizedBox(
                    width: 20,
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.cast),
                      iconSize: 20,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CameraScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.video_call),
                      iconSize: 20,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.search),
                      iconSize: 20,
                    ),
                  ),
                  SizedBox(
                    width: 50,
                    child: CircleAvatar(
                      radius: 15, // Adjust the radius to control the size
                      backgroundImage: channel.profilePicture,
                    ),
                  )
                ],
              ),
            ),
          ],
          backgroundColor: tabBarColor,
        ),
        body: TabBarView(
          children: [
            // Home Page
            Container(
              color: backgroundColor,
              child: ListView(
                children: getVideos(false),
              ),
            ),
            //explore page
            Container(
              color: Colors.orange,
            ),
            // Subscription Page
            Container(
              color: backgroundColor,
              child: ListView(
                children: getVideos(true),
              ),
            ),
            // Summary
            SingleChildScrollView(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TextField(
                    controller: server,
                    decoration: const InputDecoration(hintText: hintText_1),
                  ),
                  TextField(
                    controller: link,
                    decoration: const InputDecoration(hintText: hintText_2),
                  ),
                  TextButton(
                    onPressed: () => _fetchMetadata(
                      link: link.text,
                      server: server.text,
                    ),
                    child: const Text('Summary'),
                  ),
                  const SizedBox(height: 50),
                  videoData == null
                      ? Container()
                      : Column(
                          children: [
                            _boldText('Summary: ', summary),
                            const Divider(),
                            // _boldText('Summary: ', summary),
                            Image.network(videoData!.thumbnailUrl ?? ''),
                            const Divider(),
                            _boldText('videoId: ', videoData!.videoId),
                            const Divider(),
                            _boldText('Title: ', videoData!.title),
                            const Divider(),
                            _boldText('Channel Name: ', videoData!.authorName),
                            const Divider(),
                            _boldText('Channel URL: ', videoData!.authorUrl),
                            const Divider(),
                            _boldText('Duration: ',
                                '${videoData!.durationSeconds} seconds'),
                            const Divider(),
                            Text('Keywords: ${videoData!.keywords}'),
                            const Divider(),
                            _boldText('Average Rating: ',
                                videoData!.averageRating.toString()),
                            const Divider(),
                            _boldText('View Count: ',
                                '${videoData!.viewCount} views'),
                            const Divider(),
                            _boldText('Full Description: \r\n\r\n',
                                videoData!.fullDescription),
                            const Divider(),
                          ],
                        ),
                ],
              ),
            ),
            // Library
            Container(
              color: Colors.blue,
            ),
          ],
        ),
        bottomNavigationBar: TabBar(
          labelStyle: tabTextStyle,
          tabs: tabList,
          labelColor: tabBarSelectedIconsColor,
          unselectedLabelColor: tabBarUnselectedIconsColor,
          indicatorColor: Colors.transparent,
        ),
        backgroundColor: tabBarColor,
      ),
    );
  }

  List<Widget> getVideos(bool isSubscriptionPage) {
    List<Video> videos = makeVideos();
    List<Widget> cards = [];
    if (isSubscriptionPage) {
      cards.add(Container(
        color: backgroundColor,
        height: 140,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Row(children: <Widget>[
              ChannelAvatar(channel: channel),
            ]),
            Divider(
              color: tabBarUnselectedIconsColor,
            ),
          ],
        ),
      ));
    }
    // to be implemented : On Scroll Down Add Video Cards
    for (Video video in videos) {
      cards.add(VideoCard(
        video: video,
      ));
    }
    return cards;
  }

  List<String> videoTitles = [
    "YouTube Clone With FLutter!",
    "Youtube Transcript",
    "Youtube Video Summarizer",
    "Youtube Metadata",
    "Video Summarization model",
  ];

  Channel channel =
      Channel("Shubham Tripathi", const AssetImage("assets/profilepics/5.jpg"));

  List<Video> makeVideos() {
    List<Video> vids = [];
    for (int i = 0; i < 5; i++) {
      vids.add(Video(
        channel: channel,
        thumbnail: AssetImage("assets/thumbnails/$i.jpg"),
        viewCount: 120000,
        uploadDate: DateTime.now().subtract(const Duration(days: 400)),
        videoTitle: videoTitles[i],
      ));
    }
    return vids;
  }

  List<Widget> tabList = [
    const Tab(
      icon: Icon(Icons.home),
      text: "Home",
    ),
    const Tab(
      icon: Icon(Icons.explore),
      text: "Explore",
    ),
    const Tab(
      icon: Icon(Icons.subscriptions),
      text: "Subscriptions",
    ),
    const Tab(
      icon: Icon(Icons.summarize),
      text: "Summarize",
    ),
    const Tab(
      icon: Icon(Icons.video_library),
      text: "Library",
    )
  ];
}
