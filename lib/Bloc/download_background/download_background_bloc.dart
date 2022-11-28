import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wall_par_flutter/Bloc/download_background/download_background_event.dart';
import 'package:wall_par_flutter/Bloc/download_background/download_background_state.dart';
import 'package:wall_par_flutter/download_service.dart';

class DownloadBackgroundBloc
    extends Bloc<DownloadBackgroundEvent, DownloadBackgroundState> {
  final DownloadService downloadService;

  DownloadBackgroundBloc(
    this.downloadService,
  ) : super(DownloadBackgroundInitial());

  @override
  Stream<DownloadBackgroundState> mapEventToState(
      DownloadBackgroundEvent event) async* {
    if (event is DownloadStarted) {
      yield DownloadLoadInProgress(url: event.url);
      downloadService
          .downloadFile(
        url: event.url,
        whenComplete: event.whenComplete,
        onReceiveProgress: (count, total) async {
          add(DownloadWallpaperChanged(
            (count / total * 100),
            event.url,
          ));

          print(count);
        },
      )
          .catchError((e) {
        add(DownloadError());
      });
    } else if (event is DownloadWallpaperChanged) {
      yield event.downPer == 100
          ? DownloadSuccess()
          : DownloadLoadInProgress(downPer: event.downPer, url: event.url);
    } else if (event is DownloadError) {
      yield DownloadFailure();
    }
  }
}
