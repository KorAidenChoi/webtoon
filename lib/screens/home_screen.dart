import 'package:flutter/material.dart';
import 'package:webtoon/models/webtoon_model.dart';
import 'package:webtoon/services/api_service.dart';
import 'dart:async';
import 'package:webtoon/widgets/webtoon_widget.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final Future<List<WebtoonModel>> webtoons = ApiService.getTodaysToons();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "오늘의 웹툰",
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 1,
        foregroundColor: Colors.green,
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder(
        future: webtoons,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Expanded(
                  child: makeList(snapshot),
                ),
              ],
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  ListView makeList(AsyncSnapshot<List<WebtoonModel>> snapshot) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: snapshot.data!.length,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      itemBuilder: (context, index) {
        var webtoon = snapshot.data![index];
        Image thumb = Image.network(
          webtoon.thumb,
          errorBuilder: (context, error, stackTrace) {
            return const Text("An error has occured with this image.");
          },
        );
        thumb.image
            .resolve(ImageConfiguration.empty)
            .addListener(ImageStreamListener((_, __) {
          onError:
          (_, __) {
            imageCache.evict(thumb.image);
          };
        }));
        WidgetsFlutterBinding.ensureInitialized();
        FlutterError.onError = (details) {
          if (details.exception is! NetworkImageLoadException) {
            throw details.exception;
          }
        };
        Future(() => print('future 1'));
        Future(() => print('future 2'));
        // Microtasks will be executed before futures.
        Future.microtask(() => print('microtask 1'));
        Future.microtask(() => print('microtask 2'));
        return Webtoon(
          title: webtoon.title,
          thumb: webtoon.thumb,
          id: webtoon.id,
        );
      },
      separatorBuilder: (context, index) => const SizedBox(
        width: 40,
      ),
    );
  }
}
