import 'package:flutter/material.dart';
import 'package:webtoon/model/webtoon_detail_model.dart';
import 'package:webtoon/model/webtoon_episode_model.dart';
import 'package:webtoon/services/api_service.dart';

class DetailScreen extends StatefulWidget {
  final String title, thumb, id;

  const DetailScreen({
    super.key,
    required this.title,
    required this.thumb,
    required this.id,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Future<WebtoonDetailModel> webtoon;
  late Future<List<WebtoonEpisodeModel>> episodes;

  @override
  void initState() {
    super.initState();
    webtoon = ApiService.getToonById(widget.id);
    episodes = ApiService.getLatestEpisodesById(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        foregroundColor: Colors.green,
        backgroundColor: Colors.white,
        title: Text(widget.title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
            )),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 50,
            right: 50,
            top: 30,
            bottom: 60,
          ),
          child: Column(
            children: [
              // thumb
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Hero! 같은 tag를 갖는 객체에 모핑 효과를 줌
                  Hero(
                    tag: widget.id,
                    child: Container(
                      // image
                      width: 200,
                      clipBehavior: Clip.hardEdge,
                      // 부모-자식 영역 침범 문제 해결->borderRadius 적용됨
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 10,
                              offset: const Offset(10, 10),
                              color: Colors.black.withOpacity(0.5),
                            )
                          ]),
                      child: Image.network(
                        widget.thumb,
                        headers: const {
                          'Referer': 'https://comic.naver.com',
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              // about, genre, age
              FutureBuilder(
                future: webtoon,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // about
                        Text(
                          snapshot.data!.about,
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 12),
                        // genre & age
                        Text(
                          '${snapshot.data!.genre} / ${snapshot.data!.age}',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    );
                  }
                  return Text('...');
                },
              ),
              SizedBox(height: 30),
              // episodes
              FutureBuilder(
                future: episodes,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        for (var episode in snapshot.data!)
                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.green.shade400,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    episode.title,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Icon(
                                    Icons.chevron_right_rounded,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          )
                      ],
                    );
                  }
                  return Container();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
