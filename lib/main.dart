import 'package:nodeflow/application.dart';

void main() async {
  // // check if platform is html
  // if (kIsWeb) {
  //   // set the title of the page
  //   document.title = 'Nodeflow';
  //   window.document.onContextMenu.listen((event) => event.preventDefault());
  // }
  await initializeApplication();
}
