import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'StatusList.dart';
import 'data/Gifs.dart';
import 'data/Images.dart';
import 'data/Messages.dart';
import 'data/Quotes.dart';
import 'data/Shayari.dart';
import 'data/Status.dart';
import 'widgets/CustomFeatureCard.dart';
import 'widgets/CustomFullCard.dart';
import 'package:url_launcher/url_launcher.dart';
import 'QuotesList.dart';
import 'utils/SizeConfig.dart';
import 'AboutUs.dart';
import 'GifsImages.dart';
import 'ImagesList.dart';
import 'MemeGenerator.dart';
import 'MessagesList.dart';
import 'MyDrawer.dart';
import 'NativeAdContainer.dart';
import 'ShayariList.dart';
import 'widgets/CustomBannerWidget.dart';
import 'widgets/CustomTextReadMoreWidget.dart';

// Height = 8.96
// Width = 4.14

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

const String testDevice = 'c835aea0489176f272e2d174b8d921ca';
// const String testDevice = 'testDeviceId';

class _HomePageState extends State<HomePage> {
  static final facebookAppEvents = FacebookAppEvents();
  String interstitialTag = "";

// Native Ad Open
  static String _adUnitID = NativeAd.testAdUnitId;

  final _nativeAdController = NativeAdmobController();
  double _height = 0;

  StreamSubscription _subscription;

//Native Ad Close
  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    testDevices: testDevice != null ? <String>[testDevice] : null,
    //keywords: Keywords.adsKeywords,
    //contentUrl: 'http://foo.com/bar.html',
    childDirected: false,
    nonPersonalizedAds: true,
  );

  InterstitialAd _interstitialAd;

  bool _isInterstitialAdReady = false;

  InterstitialAd createInterstitialAd() {
    return InterstitialAd(
      adUnitId: InterstitialAd.testAdUnitId,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("InterstitialAd event $event");
        if (event == MobileAdEvent.closed) {
          _isInterstitialAdReady = false;
          _interstitialAd = createInterstitialAd()..load();

          if (interstitialTag != null) {
            switch (interstitialTag) {
              case "message":
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) => MessagesList(type: "1")));
                break;
              case "english_message":
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) =>
                        MessagesList(type: "3")));
                break;

              case "hindi_message":
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) =>
                        MessagesList(type: "2")));
                break;

              case "marathi_message":
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) =>
                        MessagesList(type: "1")));
                break;

              case "gif":
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) => GifsImages()));
                break;

              case "image":
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) => ImagesList()));
                break;

              case "shayari":
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) => ShayariList()));
                break;

              case "meme":
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) => MemeGenerator()));
                break;

              case "about":
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) => AboutUs()));
                break;

              case "status":
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) => StatusList()));
                break;

              case "quotes":
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) => QuotesList()));
                break;
              default:
            }
          }
        } else if (event == MobileAdEvent.opened || event == MobileAdEvent.failedToLoad) {
          _isInterstitialAdReady = false;
          if (interstitialTag != null) {
            switch (interstitialTag) {
              case "message":
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) => MessagesList()));
                break;

              case "english_message":
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) =>
                        MessagesList(type: "3")));
                break;

              case "hindi_message":
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) =>
                        MessagesList(type: "2")));
                break;

              case "marathi_message":
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) =>
                        MessagesList(type: "1")));
                break;

              case "gif":
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) => GifsImages()));
                break;

              case "image":
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) => ImagesList()));
                break;

              case "shayari":
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) => ShayariList()));
                break;

              case "meme":
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) => MemeGenerator()));
                break;

              case "about":
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) => AboutUs()));
                break;

              case "status":
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) => StatusList()));
                break;

              case "quotes":
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) => QuotesList()));
                break;
              default:
            }
          }
        } 

        else if (event == MobileAdEvent.loaded){
          _isInterstitialAdReady = true;
        }
        else {
          print(event.toString());
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    FirebaseAdMob.instance.initialize(appId: FirebaseAdMob.testAppId);

    _interstitialAd?.dispose();
    _interstitialAd = createInterstitialAd()..load();

    //Native Ad
    _subscription = _nativeAdController.stateChanged.listen(_onStateChanged);
    //
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    //Native Ad
    _subscription.cancel();
    _nativeAdController.dispose();
    super.dispose();
  }

  void _onStateChanged(AdLoadState state) {
    switch (state) {
      case AdLoadState.loading:
        setState(() {
          _height = 0;
        });
        break;

      case AdLoadState.loadCompleted:
        setState(() {
          _height = 36.83 * SizeConfig.heightMultiplier;
        });
        break;

      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Home",
          style: Theme.of(context).appBarTheme.textTheme.headline1,
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            /*TriColorBackground(
                size: size, color: Colors.orangeAccent, isLeft: true),
            TriColorBackground(
                size: size, color: Colors.orangeAccent, isLeft: false),
            TopNBottomBackground(
                size: size, color: Colors.lightBlue, isTop: true),
            TopNBottomBackground(size: size, color: Colors.brown, isTop: false),*/
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(SizeConfig.width(8)),
                    child: Center(
                      child: Text("HaPpY HaLlOwEeN!!!",
                          style: Theme.of(context).textTheme.headline1),
                    ),
                  ),

                  Divider(),

                  //Gifs Start
                  DesignerContainer(
                    isLeft: true,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(SizeConfig.width(8)),
                          child: Text("Halloween Gifs",
                              style: Theme.of(context).textTheme.headline1),
                        ),
                        Padding(
                          padding: EdgeInsets.all(SizeConfig.width(8)),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: InkWell(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  CustomFeatureCard(
                                      size: size,
                                      imageUrl: Gifs.gifs_path[3],
                                      ontap: null),
                                  CustomFeatureCard(
                                      size: size,
                                      imageUrl: Gifs.gifs_path[1],
                                      ontap: null),
                                  CustomFeatureCard(
                                      size: size,
                                      imageUrl: Gifs.gifs_path[2],
                                      ontap: null),
                                  CustomFeatureCard(
                                      size: size,
                                      imageUrl: Gifs.gifs_path[4],
                                      ontap: null),
                                  CustomFeatureCard(
                                      size: size,
                                      imageUrl: Gifs.gifs_path[6],
                                      ontap: null),
                                ],
                              ),
                              onTap: () {
                                print("Gifs Clicked");
                                interstitialTag = "gif";
                                facebookAppEvents.logEvent(
                                  name: "GIF List",
                                  parameters: {
                                    'button_id': 'gif_button',
                                  },
                                );
                                _isInterstitialAdReady == true
                                    ? _interstitialAd?.show()
                                    : Navigator.of(context).push(
                                        new MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                GifsImages()));
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Gifs End

                  Divider(),

                  //Image Start
                  Column(
                    children: [
                      DesignerContainer(
                        isLeft: false,
                        child: Padding(
                          padding: EdgeInsets.all(SizeConfig.width(8)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Halloween Wishes Images",
                                  style: Theme.of(context).textTheme.headline1),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(SizeConfig.width(8)),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: InkWell(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                CustomFeatureCard(
                                    size: size,
                                    imageUrl: Images.images_path[0],
                                    ontap: null),
                                CustomFeatureCard(
                                    size: size,
                                    imageUrl: Images.images_path[2],
                                    ontap: null),
                                CustomFeatureCard(
                                    size: size,
                                    imageUrl: Images.images_path[4],
                                    ontap: null),
                                CustomFeatureCard(
                                    size: size,
                                    imageUrl: Images.images_path[5],
                                    ontap: null),
                              ],
                            ),
                            onTap: () {
                              print("Images Clicked");
                              interstitialTag = "image";
                              facebookAppEvents.logEvent(
                                name: "Image List",
                                parameters: {
                                  'button_id': 'Image_button',
                                },
                              );

                              _isInterstitialAdReady == true
                                  ? _interstitialAd?.show()
                                  : Navigator.of(context).push(
                                      new MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              ImagesList()));
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Image End
                  Divider(),
                  //Native Ad
                  DesignerContainer(
                    isLeft: false,
                    child: NativeAdContainer(
                        height: _height,
                        adUnitID: _adUnitID,
                        nativeAdController: _nativeAdController),
                  ),

                  Divider(),

                  // Messages Start
                  Column(
                    children: [
                      DesignerContainer(
                        isLeft: true,
                        child: Padding(
                          padding: EdgeInsets.all(SizeConfig.width(8)),
                          child: Center(
                            child: Text("Halloween Wishes & Messages",
                                style: Theme.of(context).textTheme.headline1),
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Padding(
                          padding: EdgeInsets.all(SizeConfig.width(8.0)),
                          child: Row(
                            children: [
                              CustomGradientImageTextWidget(
                                size: size,
                                title: "Wishes",
                                bodyText: Messages.english_data[3],
                                bottomText: "Tap For More",
                                color1: Colors.pinkAccent,
                                color2: Colors.pink,
                                isleft: true,
                                imageUrl:
                                    "https://www.freepnglogos.com/uploads/pumpkin-png/halloween-pumpkin-png-clipart-image-gallery-yopriceville-28.png",
                                ontap: () {
                                  print("English Message Clicked");
                                  interstitialTag = "message";
                                  facebookAppEvents.logEvent(
                                    name: "Message List",
                                    parameters: {
                                      'button_id': 'english_message_button',
                                    },
                                  );

                                  _isInterstitialAdReady == true
                                      ? _interstitialAd?.show()
                                      : Navigator.of(context).push(
                                          new MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  MessagesList(type: "1")));
                                },
                              ),
                              CustomGradientImageTextWidget(
                                size: size,
                                title: "Funny Wishes",
                                bodyText: Messages.funny_data[2],
                                bottomText: "Tap For More",
                                color1: Colors.indigoAccent,
                                color2: Colors.indigo,
                                isleft: true,
                                imageUrl:
                                    "https://www.freepnglogos.com/uploads/ghost-png/ghost-halloween-graphics-9.png",
                                ontap: () {
                                  print("Funny Message Clicked");
                                  interstitialTag = "hindi_message";
                                  facebookAppEvents.logEvent(
                                    name: "Message List",
                                    parameters: {
                                      'button_id': 'funny_message_button',
                                    },
                                  );
                                  _isInterstitialAdReady == true
                                      ? _interstitialAd?.show()
                                      : Navigator.of(context).push(
                                          new MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  MessagesList(type: "2")));
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Messages End
                  Divider(),

                  // Quotes Start
                  DesignerContainer(
                    isLeft: false,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(SizeConfig.width(8)),
                          child: Text("Halloween Quotes",
                              style: Theme.of(context).textTheme.headline1),
                        ),
                        Padding(
                          padding: EdgeInsets.all(SizeConfig.width(8)),
                          child: QuotesDesign1(
                            size: size,
                            color: Colors.yellow,
                            bodyText: Quotes.quotes_data[5],
                            footerText: "Tap here to Read Quotes",
                            ontap: () {
                              print("Quotes Clicked");
                              interstitialTag = "quotes";
                              facebookAppEvents.logEvent(
                                name: "Quotes List",
                                parameters: {
                                  'button_id': 'Quotes_button',
                                },
                              );
                             _isInterstitialAdReady == true
                                  ? _interstitialAd?.show()
                                  : Navigator.of(context).push(
                                      new MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              QuotesList()));
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Quotes End

                  Divider(),

                  //Native Ad
                  NativeAdContainer(
                      height: _height,
                      adUnitID: _adUnitID,
                      nativeAdController: _nativeAdController),

                  Divider(),

                  // Shayari start
                  Column(
                    children: [
                      DesignerContainer(
                        isLeft: true,
                        child: Padding(
                          padding: EdgeInsets.all(SizeConfig.width(8)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Perfect Captions For Selfies",
                                  style: Theme.of(context).textTheme.headline1),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(SizeConfig.width(8)),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: InkWell(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                CustomTextReadMoreWidget(
                                  size: size,
                                  color: Colors.brown[400],
                                  text: Messages.captions[5],
                                ),
                                SizedBox(width: SizeConfig.width(8)),
                                CustomTextReadMoreWidget(
                                  size: size,
                                  color: Colors.lightBlue,
                                  text: Messages.captions[4],
                                ),
                                SizedBox(width: SizeConfig.width(8)),
                                CustomTextReadMoreWidget(
                                  size: size,
                                  color: Colors.cyanAccent,
                                  text: Messages.captions[3],
                                ),
                              ],
                            ),
                            onTap: () {
                              print("English Message Clicked");
                              interstitialTag = "english_message";
                              facebookAppEvents.logEvent(
                                name: "Message List",
                                parameters: {
                                  'button_id': 'english_message_button',
                                },
                              );
                              _isInterstitialAdReady == true
                                  ? _interstitialAd?.show()
                                  : Navigator.of(context).push(
                                      new MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              MessagesList(type: "3")));
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Shayari end

                  Divider(),

                  // Shayari Start
                  DesignerContainer(
                    isLeft: true,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(SizeConfig.width(8)),
                          child: Text("Halloween Poems & Rhymes",
                              style: Theme.of(context).textTheme.headline1),
                        ),
                        Padding(
                          padding: EdgeInsets.all(SizeConfig.width(8)),
                          child: QuotesDesign1(
                            size: size,
                            color: Colors.grey,
                            bodyText: Shayari.shayari_data[3],
                            footerText: "Tap here to Read Poems",
                            ontap: () {
                              print("Shayari Clicked");
                              interstitialTag = "shayari";
                              facebookAppEvents.logEvent(
                                name: "Shayari List",
                                parameters: {
                                  'button_id': 'Shayari_button',
                                },
                              );
                              _isInterstitialAdReady == true
                                  ? _interstitialAd?.show()
                                  : Navigator.of(context).push(
                                      new MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              ShayariList()));
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Shayari End

                  Divider(),
                  //Native Ad
                  DesignerContainer(
                    isLeft: true,
                    child: NativeAdContainer(
                        height: _height,
                        adUnitID: _adUnitID,
                        nativeAdController: _nativeAdController),
                  ),

                  Divider(),

                  // Wish Creator Start
                  Column(
                    children: [
                      DesignerContainer(
                        isLeft: false,
                        child: Padding(
                          padding: EdgeInsets.all(SizeConfig.width(8)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Create Greeting Card & Meme",
                                  style: Theme.of(context).textTheme.headline1),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(SizeConfig.width(8)),
                        child: CustomBannerWidget(
                          size: MediaQuery.of(context).size,
                          imagePath: Gifs.gifs_path[1],
                          buttonText: "Create it",
                          topText: "Greetings & Memes for",
                          middleText: "Halloween",
                          bottomText: "Share it With Your Friends",
                          ontap: () {
                            print("Meme Clicked");
                            interstitialTag = "meme";
                            facebookAppEvents.logEvent(
                              name: "Meme Generator",
                              parameters: {
                                'button_id': 'meme_button',
                              },
                            );
                            _isInterstitialAdReady == true
                                ? _interstitialAd?.show()
                                : Navigator.of(context).push(
                                    new MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            MemeGenerator()));
                          },
                        ),
                      ),
                    ],
                  ),
                  // Wish Creator End

                  Divider(),

                  // Status Start

                  DesignerContainer(
                    isLeft: true,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(SizeConfig.width(8)),
                          child: Text("Best Status for Social Media",
                              style: Theme.of(context).textTheme.headline1),
                        ),
                        Padding(
                          padding: EdgeInsets.all(SizeConfig.width(8)),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: InkWell(
                              child: Row(
                                children: [
                                  CustomGradientImageTextWidget(
                                    size: size,
                                    title: "Status for WhatsApp",
                                    bodyText: Status.status_data[16],
                                    bottomText: "Read",
                                    color1: Colors.pinkAccent,
                                    color2: Colors.pink,
                                    isleft: false,
                                    imageUrl:
                                        "https://www.freepnglogos.com/uploads/candle-png/candle-halloween-graphics-20.png",
                                    ontap: null,
                                  ),
                                  CustomGradientImageTextWidget(
                                    size: size,
                                    title: "Status for FB",
                                    bodyText: Status.status_data[10],
                                    bottomText: "Read",
                                    color1: Colors.indigoAccent,
                                    color2: Colors.indigo,
                                    isleft: false,
                                    imageUrl:
                                        "https://www.freepnglogos.com/uploads/pumpkin-png/halloween-pumpkin-icon-1.png",
                                    ontap: null,
                                  ),
                                  CustomGradientImageTextWidget(
                                    size: size,
                                    title: "Funny Status",
                                    bodyText: Status.status_data[5],
                                    bottomText: "Read",
                                    color1: Colors.deepPurple,
                                    color2: Colors.deepPurpleAccent,
                                    isleft: false,
                                    imageUrl:
                                        "https://www.freepnglogos.com/uploads/ghost-png/ghost-halloween-graphics-4.png",
                                    ontap: null,
                                  ),
                                ],
                              ),
                              onTap: () {
                                print("Status Clicked");
                                interstitialTag = "status";
                                facebookAppEvents.logEvent(
                                  name: "Status List",
                                  parameters: {
                                    'button_id': 'Status_button',
                                  },
                                );
                                _isInterstitialAdReady == true
                                    ? _interstitialAd?.show()
                                    : Navigator.of(context).push(
                                        new MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                StatusList()));
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  //Status End

                  Divider(),
                  //Native Ad
                  NativeAdContainer(
                      height: _height,
                      adUnitID: _adUnitID,
                      nativeAdController: _nativeAdController),

                  Divider(),

                  DesignerContainer(
                    isLeft: false,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(SizeConfig.width(8)),
                          child: Text("Play Game \"Sell Rakhi\"",
                              style: Theme.of(context).textTheme.headline1),
                        ),
                        CustomFullCard(
                          size: MediaQuery.of(context).size,
                          imageUrl: "assets/rakhi_game.jpeg",
                          ontap: () {
                            if (Platform.isAndroid) {
                              // Android-specific code
                              print("More Button Clicked");
                              launch(
                                  "https://play.google.com/store/apps/developer?id=Festival+Messages+SMS");
                            } else if (Platform.isIOS) {
                              // iOS-specific code
                              print("More Button Clicked");
                              launch(
                                  "https://apps.apple.com/us/app/-/id1434054710");

                              facebookAppEvents.logEvent(
                                name: "Play Rakshabandhan Game",
                                parameters: {
                                  'clicked_on_play_rakshabandhan_game': 'Yes',
                                },
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),

                  Divider(),

                  Padding(
                    padding: EdgeInsets.all(SizeConfig.width(8)),
                    child: Text("Apps From Developer",
                        style: Theme.of(context).textTheme.headline1),
                  ),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: EdgeInsets.all(SizeConfig.width(8)),
                      child: Row(
                        children: <Widget>[
                          //Column1
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              AppStoreAppsItemWidget1(
                                  imageUrl:
                                      "https://is1-ssl.mzstatic.com/image/thumb/Purple117/v4/8f/e7/b5/8fe7b5bc-03eb-808c-2b9e-fc2c12112a45/mzl.jivuavtz.png/292x0w.jpg",
                                  appTitle: "Good Morning Images & Messages",
                                  appUrl:
                                      "https://apps.apple.com/us/app/good-morning-images-messages-to-wish-greet-gm/id1232993917"),
                              Divider(),
                              AppStoreAppsItemWidget1(
                                  imageUrl:
                                      "https://is4-ssl.mzstatic.com/image/thumb/Purple114/v4/44/e0/fd/44e0fdb5-667b-5468-7b2f-53638cba539e/AppIcon-1x_U007emarketing-0-7-0-0-85-220.png/292x0w.jpg",
                                  appTitle: "Birthday Status Wishes Quotes",
                                  appUrl:
                                      "https://apps.apple.com/us/app/birthday-status-wishes-quotes/id1522542709"),
                              Divider(),
                              AppStoreAppsItemWidget1(
                                  imageUrl:
                                      "https://is4-ssl.mzstatic.com/image/thumb/Purple114/v4/1a/58/a4/1a58a480-a0ae-1940-2cf3-38524430f66b/AppIcon-0-1x_U007emarketing-0-0-GLES2_U002c0-512MB-sRGB-0-0-0-85-220-0-0-0-7.png/292x0w.jpg",
                                  appTitle: "Astrology Horoscope Lal Kitab",
                                  appUrl:
                                      "https://apps.apple.com/us/app/astrology-horoscope-lal-kitab/id1448343526"),
                            ],
                          ),
                          SizedBox(width: SizeConfig.width(3)),
                          //Column2
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              AppStoreAppsItemWidget1(
                                  imageUrl:
                                      "https://is2-ssl.mzstatic.com/image/thumb/Purple124/v4/e9/96/64/e99664d3-1083-5fac-6a0c-61718ee209fd/AppIcon-0-1x_U007emarketing-0-0-GLES2_U002c0-512MB-sRGB-0-0-0-85-220-0-0-0-7.png/292x0w.jpg",
                                  appTitle: "Weight Loss My Diet Coach Tips",
                                  appUrl:
                                      "https://apps.apple.com/us/app/weight-loss-my-diet-coach-tips/id1448343218"),
                              Divider(),
                              AppStoreAppsItemWidget1(
                                  imageUrl:
                                      "https://is2-ssl.mzstatic.com/image/thumb/Purple127/v4/5f/7c/45/5f7c45c7-fb75-ea39-feaa-a698b0e4b09e/pr_source.jpg/292x0w.jpg",
                                  appTitle: "English Speaking Course Grammar",
                                  appUrl:
                                      "https://apps.apple.com/us/app/english-speaking-course-learn-grammar-vocabulary/id1233093288"),
                              Divider(),
                              AppStoreAppsItemWidget1(
                                  imageUrl:
                                      "https://is4-ssl.mzstatic.com/image/thumb/Purple128/v4/50/ad/82/50ad82d9-0d82-5007-fcdd-cc47c439bfd0/AppIcon-0-1x_U007emarketing-0-85-220-10.png/292x0w.jpg",
                                  appTitle: "English Hindi Language Diction",
                                  appUrl:
                                      "https://apps.apple.com/us/app/english-hindi-language-diction/id1441243874"),
                            ],
                          ),
                          SizedBox(width: SizeConfig.width(3)),
                          //Column3

                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              AppStoreAppsItemWidget1(
                                  imageUrl:
                                      "https://is3-ssl.mzstatic.com/image/thumb/Purple118/v4/17/f5/0c/17f50c4d-431b-72c6-b9f4-d1706da59394/AppIcon-0-1x_U007emarketing-0-0-85-220-7.png/292x0w.jpg",
                                  appTitle: "Celebrate Happy New Year 2019",
                                  appUrl:
                                      "https://apps.apple.com/us/app/celebrate-happy-new-year-2019/id1447735210"),
                              Divider(),
                              AppStoreAppsItemWidget1(
                                  imageUrl:
                                      "https://is1-ssl.mzstatic.com/image/thumb/Purple118/v4/79/1e/61/791e61de-500c-6c97-3947-8abbc6b887e3/AppIcon-0-1x_U007emarketing-0-0-GLES2_U002c0-512MB-sRGB-0-0-0-85-220-0-0-0-7.png/292x0w.jpg",
                                  appTitle: "Bangladesh Passport Visa Biman",
                                  appUrl:
                                      "https://apps.apple.com/us/app/bangladesh-passport-visa-biman/id1443074171"),
                              Divider(),
                              AppStoreAppsItemWidget1(
                                  imageUrl:
                                      "https://is1-ssl.mzstatic.com/image/thumb/Purple126/v4/dd/34/c3/dd34c3e8-5c9f-51aa-a3eb-3a203f5fd49b/AppIcon-0-1x_U007emarketing-0-0-GLES2_U002c0-512MB-sRGB-0-0-0-85-220-0-0-0-10.png/292x0w.jpg",
                                  appTitle: "Complete Spoken English Course",
                                  appUrl:
                                      "https://apps.apple.com/us/app/complete-spoken-english-course/id1440118617"),
                            ],
                          ),
                          SizedBox(width: SizeConfig.width(3)),

                          //Column4
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              AppStoreAppsItemWidget1(
                                  imageUrl:
                                      "https://is4-ssl.mzstatic.com/image/thumb/Purple128/v4/bd/00/ee/bd00ee3b-43af-6b07-62a6-28c68373a8b5/AppIcon-1x_U007emarketing-85-220-0-9.png/292x0w.jpg",
                                  appTitle: "Happy Anniversary Greeting SMS",
                                  appUrl:
                                      "https://apps.apple.com/us/app/happy-anniversary-greeting-sms/id1435157874"),
                              Divider(),
                              AppStoreAppsItemWidget1(
                                  imageUrl:
                                      "https://is4-ssl.mzstatic.com/image/thumb/Purple91/v4/f0/84/d7/f084d764-79a8-f6d1-3778-1cb27fabb8bd/pr_source.png/292x0w.jpg",
                                  appTitle: "Egg Recipes 100+ Recipes",
                                  appUrl:
                                      "https://apps.apple.com/us/app/egg-recipes-100-recipes-collection-for-eggetarian/id1232736881"),
                              Divider(),
                              AppStoreAppsItemWidget1(
                                  imageUrl:
                                      "https://is1-ssl.mzstatic.com/image/thumb/Purple114/v4/0f/d6/f4/0fd6f410-9664-94a5-123f-38d787bf28c6/AppIcon-1x_U007emarketing-0-7-0-0-85-220.png/292x0w.jpg",
                                  appTitle: "Rakshabandhan Images Greetings",
                                  appUrl:
                                      "https://apps.apple.com/us/app/rakshabandhan-images-greetings/id1523619788"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      drawer: MyDrawer(),
    );
  }
}

class QuotesDesign1 extends StatelessWidget {
  const QuotesDesign1({
    Key key,
    @required this.size,
    @required this.color,
    @required this.bodyText,
    @required this.footerText,
    this.ontap,
  }) : super(key: key);

  final Color color;
  final String bodyText, footerText;
  final Size size;
  final Function ontap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: Container(
          width: size.width - SizeConfig.width(16),
          height: size.width / 2,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(SizeConfig.height(20)),
              topRight: Radius.circular(SizeConfig.height(20)),
            ),
            boxShadow: [
              BoxShadow(
                  offset: Offset(0, 0), blurRadius: 4, color: Colors.grey),
            ],
          ),
          child: Stack(
            children: [
              Icon(Icons.format_quote,
                  color: Theme.of(context).primaryIconTheme.color),
              Positioned(
                top: 20,
                width: size.width - SizeConfig.width(16),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(SizeConfig.width(8)),
                    child: Text(
                      bodyText,
                      style: Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                bottom: 0,
                right: 0,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(SizeConfig.width(8)),
                    child: Text(
                      footerText,
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                            color: Theme.of(context).primaryIconTheme.color,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        onTap: ontap);
  }
}

class CustomGradientImageTextWidget extends StatelessWidget {
  const CustomGradientImageTextWidget({
    Key key,
    @required this.size,
    @required this.isleft,
    @required this.color1,
    @required this.color2,
    @required this.imageUrl,
    @required this.title,
    @required this.bodyText,
    @required this.bottomText,
    this.ontap,
  }) : super(key: key);

  final Size size;
  final Color color1, color2;
  final String imageUrl, title, bodyText, bottomText;
  final Function ontap;
  final bool isleft;
  //"https://pngimg.com/uploads/ganesha/ganesha_PNG40.png"

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              top: SizeConfig.width(30.0),
              left: SizeConfig.width(8.0),
              right: SizeConfig.width(8.0),
              bottom: SizeConfig.width(8.0),
            ),
            child: Container(
                height: size.height * 0.32,
                width: size.width * 0.49,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    colors: [
                      color1,
                      color2,
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: isleft
                        ? Radius.circular(SizeConfig.height(40))
                        : Radius.circular(SizeConfig.height(8)),
                    topRight: isleft
                        ? Radius.circular(SizeConfig.height(8))
                        : Radius.circular(SizeConfig.height(40)),
                    bottomLeft: Radius.circular(SizeConfig.height(8)),
                    bottomRight: Radius.circular(SizeConfig.height(8)),
                  ),
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(0, 0),
                        blurRadius: 4,
                        color: Colors.grey),
                  ],
                )),
          ),
          isleft
              ? Positioned(
                  top: -1,
                  left: 0,
                  child: Padding(
                    padding: EdgeInsets.only(left: SizeConfig.width(8.0)),
                    child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                        fadeOutDuration: const Duration(seconds: 1),
                        fadeInDuration: const Duration(seconds: 3),
                        height: SizeConfig.height(60),
                        width: SizeConfig.width(60),
                        fit: BoxFit.fill),
                  ),
                )
              : Positioned(
                  top: -1,
                  right: 0,
                  child: Padding(
                    padding: EdgeInsets.only(left: SizeConfig.width(8.0)),
                    child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                        fadeOutDuration: const Duration(seconds: 1),
                        fadeInDuration: const Duration(seconds: 3),
                        height: SizeConfig.height(60),
                        width: SizeConfig.width(60),
                        fit: BoxFit.fill),
                  ),
                ),
          Positioned(
            top: 65,
            child: Padding(
              padding: EdgeInsets.only(
                  left: SizeConfig.width(15.0), right: SizeConfig.width(15.0)),
              child: Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                maxLines: 2,
              ),
            ),
          ),
          Positioned(
            top: 100,
            child: Padding(
              padding: EdgeInsets.only(left: SizeConfig.width(15.0)),
              child: Text(
                bodyText,
                style: Theme.of(context)
                    .textTheme
                    .subtitle2
                    .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Positioned(
            bottom: 15,
            child: Padding(
              padding: EdgeInsets.only(left: SizeConfig.width(15.0)),
              child: Text(
                bottomText,
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      onTap: ontap,
    );
  }
}

class DesignerContainer extends StatelessWidget {
  const DesignerContainer({
    Key key,
    @required this.child,
    @required this.isLeft,
  }) : super(key: key);

  final Widget child;
  final bool isLeft;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: isLeft
          ? BoxDecoration(
              color: Theme.of(context).colorScheme.primaryVariant,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(SizeConfig.height(20)),
              ),
              boxShadow: [
                BoxShadow(
                    offset: Offset(0, 0), blurRadius: 4, color: Colors.grey),
              ],
            )
          : BoxDecoration(
              color: Theme.of(context).colorScheme.primaryVariant,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(SizeConfig.height(20)),
              ),
              boxShadow: [
                BoxShadow(
                    offset: Offset(0, 0), blurRadius: 4, color: Colors.grey),
              ],
            ),
      child: child,
    );
  }
}

class TriColorBackground extends StatelessWidget {
  const TriColorBackground({
    Key key,
    @required this.size,
    this.color,
    this.isLeft,
  }) : super(key: key);

  final Size size;
  final Color color;
  final bool isLeft;
  @override
  Widget build(BuildContext context) {
    return isLeft
        ? Positioned(
            left: 0,
            width: size.width * 0.33,
            top: 0,
            height: size.height,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(SizeConfig.width(100)),
                bottomRight: Radius.circular(SizeConfig.width(100)),
              ),
              child: ColoredBox(color: color),
            ))
        : Positioned(
            right: 0,
            width: size.width * 0.33,
            top: 0,
            height: size.height,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(SizeConfig.width(100)),
                bottomLeft: Radius.circular(SizeConfig.width(100)),
              ),
              child: ColoredBox(color: color),
            ));
  }
}

class TopNBottomBackground extends StatelessWidget {
  const TopNBottomBackground({
    Key key,
    @required this.size,
    this.color,
    this.isTop,
  }) : super(key: key);

  final Size size;
  final Color color;
  final bool isTop;
  @override
  Widget build(BuildContext context) {
    return isTop
        ? Positioned(
            top: 0,
            left: 0,
            width: size.width,
            height: size.height * 0.15,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                bottomRight:
                    Radius.circular(SizeConfig.height(size.height / 2)),
                bottomLeft: Radius.circular(SizeConfig.height(size.height / 2)),
              ),
              child: ColoredBox(color: color),
            ))
        : Positioned(
            left: 0,
            bottom: 0,
            width: size.width,
            height: size.height * 0.15,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(SizeConfig.height(size.height / 2)),
                topLeft: Radius.circular(SizeConfig.height(size.height / 2)),
              ),
              child: ColoredBox(color: color),
            ));
  }
}

class CustomHeader1 extends StatelessWidget {
  const CustomHeader1({
    Key key,
    this.headerText,
    this.imagePath,
    this.descriptionText,
  }) : super(key: key);

  final String headerText, imagePath, descriptionText;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 3 * SizeConfig.widthMultiplier,
        bottom: 10 * SizeConfig.widthMultiplier,
        left: 10 * SizeConfig.widthMultiplier,
        right: 10 * SizeConfig.widthMultiplier,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryVariant,
        borderRadius: BorderRadius.only(
          //30
          bottomRight: Radius.circular(MediaQuery.of(context).size.width),
        ),
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    headerText,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(color: Colors.white),
                  ),
                  SizedBox(
                    width: 1.93 * SizeConfig.widthMultiplier,
                  ),
                  CircleAvatar(
                    backgroundImage: NetworkImage(imagePath),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 2 * SizeConfig.heightMultiplier,
          ),
          Text(
            descriptionText,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .subtitle1
                .copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class AppStoreAppsItemWidget1 extends StatelessWidget {
  const AppStoreAppsItemWidget1({
    Key key,
    this.imageUrl,
    this.appUrl,
    this.appTitle,
  }) : super(key: key);

  final String imageUrl, appUrl, appTitle;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          ClipRRect(
            borderRadius:
                BorderRadius.all(Radius.circular(SizeConfig.width(16))),
            child: Padding(
              padding: EdgeInsets.only(right: SizeConfig.width(3)),
              child: CachedNetworkImage(
                height: SizeConfig.height(80),
                width: SizeConfig.width(80),
                imageUrl: imageUrl,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                fadeOutDuration: const Duration(seconds: 1),
                fadeInDuration: const Duration(seconds: 3),
              ),
            ),
          ),
          Text(
            appTitle,
            style: Theme.of(context)
                .textTheme
                .bodyText1
                .copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      onTap: () {
        launch(appUrl);
      },
    );
  }
}
