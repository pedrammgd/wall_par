abstract class DownloadBackgroundState {}

class DownloadBackgroundInitial extends DownloadBackgroundState {}

class DownloadLoadInProgress extends DownloadBackgroundState {
  final String? url;
  final double downPer;

  DownloadLoadInProgress({this.url, this.downPer = 0});
}

class DownloadSuccess extends DownloadBackgroundState {}

class DownloadFailure extends DownloadBackgroundState {}
