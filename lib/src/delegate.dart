part of flutter_offline;

abstract class OfflineBuilderDelegate {
  Duration get delay => const Duration(milliseconds: 350);

  Widget waitBuilder(BuildContext context) {
    return Center(child: CircularProgressIndicator());
  }

  Widget offlineBuilder(BuildContext context, bool state) {
    return null;
  }

  Widget builder(BuildContext context, bool state);
}
