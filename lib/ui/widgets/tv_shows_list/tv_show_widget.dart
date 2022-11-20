import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmdb/domain/api_client/image_downloader.dart';
import 'package:tmdb/ui/widgets/movie_list/movie_list_%20model.dart';
import 'package:tmdb/ui/widgets/tv_shows_list/tv_show_model.dart';

class TVListWidget extends StatefulWidget {
  const TVListWidget({Key? key}) : super(key: key);

  @override
  State<TVListWidget> createState() => _TVListWidgetState();
}

class _TVListWidgetState extends State<TVListWidget> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locale = Localizations.localeOf(context);
    context.read<TVListViewModel>().setupLocale(locale);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: const [
        _TVListWidget(),
        _SearchWidget(),
      ],
    );
  }
}

class _SearchWidget extends StatelessWidget {
  const _SearchWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<TVListViewModel>();

    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextField(
        onChanged: model.searchTV,
        decoration: InputDecoration(
          labelText: 'Поиск',
          filled: true,
          fillColor: Colors.white.withAlpha(235),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}

class _TVListWidget extends StatelessWidget {
  const _TVListWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.watch<TVListViewModel>();

    return ListView.builder(
        padding: const EdgeInsets.only(top: 70),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        itemCount: model.tv.length,
        itemExtent: 163,
        itemBuilder: (BuildContext context, int index) {
          model.showMovieAtIndex(index);
          return _TVListRowWidget(
            index: index,
          );
        });
  }
}

class _TVListRowWidget extends StatelessWidget {
  final int index;

  const _TVListRowWidget({required this.index});

  @override
  Widget build(BuildContext context) {
    final model = context.read<TVListViewModel>();

    final movie = model.tv[index];
    final posterPath = movie.posterPath;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black.withOpacity(0.2)),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ]),
            clipBehavior: Clip.hardEdge,
            child: Row(
              children: [
                if (posterPath != null)
                  Image.network(
                    ImageDownloader.imageUrl(posterPath),
                    width: 95,
                  ),
                const SizedBox(
                  height: 15,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        movie.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        movie.releaseDate,
                        style: const TextStyle(color: Colors.grey),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        movie.overview,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () => model.onMovieTab(context, index),
            ),
          ),
        ],
      ),
    );
    ;
  }
}
