import 'package:file_picker/file_picker.dart';
import 'package:sketcher/eventStreams/save_event.dart';
import 'package:sketcher/eventStreams/save_file_event.dart';

class SaveController {
  static void instance = SaveController._privateController();

  SaveController._privateController() {
    SaveEvent.instance.stream.listen((_) => _handleEvent());
  }

  void _handleEvent() async {
    String? outputFile = await FilePicker.platform.saveFile(
      dialogTitle: 'Please select an output file:',
      fileName: 'output.sk',
    );

    if (outputFile == null) {
      return;
    }

    SaveFileEvent.instance.addEvent(outputFile);
  }
}
