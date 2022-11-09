import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:slidemix/colors.dart';
import 'package:slidemix/creation/creation_bloc.dart';
import 'package:slidemix/creation/widget/creation_source_dialog.dart';
import 'package:slidemix/creation/data/media.dart';
import 'package:slidemix/creation/widget/creation_list.dart';
import 'package:slidemix/logger.dart';
import 'package:slidemix/navigation.dart';
import 'package:slidemix/welcome/welcome.dart';
import 'package:slidemix/widget/button.dart';
import 'package:slidemix/widget/toolbar.dart';

class CreationScreen extends StatefulWidget {
  static Route<void> route() => ScreenRoute(const CreationScreen());

  const CreationScreen({super.key});

  @override
  CreationScreenState createState() => CreationScreenState();
}

class CreationScreenState extends State<CreationScreen> {
  bool _openPickerAtStartup = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_openPickerAtStartup) {
        setState(() => _openPickerAtStartup = false);
        _pickMedia();
      }
    });
  }

  Future _pickMedia() async {
    List<Media> media = [];

    switch (await PickMediaSourceDialog.show(context)) {
      case CreationMediaSource.camera:
        final image = await ImagePicker().pickImage(source: ImageSource.camera);
        if (!mounted || image == null) return;
        media.add(Media(image.path));
        break;

      case CreationMediaSource.gallery:
        final images = await ImagePicker().pickMultiImage();
        if (!mounted || images.isEmpty) return;
        media.addAll(images.map((image) => Media(image.path)));
        break;

      default:
        return;
    }

    if (!mounted) return;
    BlocProvider.of<CreationBloc>(context).pickMedia(media);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // TODO: ask if user wants to leave
        BlocProvider.of<CreationBloc>(context).reset();
        return true;
      },
      child: BlocBuilder<CreationBloc, CreationState>(
        builder: (context, state) {
          return Scaffold(
            appBar: Toolbar(
              leftIcon: Image.asset("assets/images/ic_back.png"),
              onLeftIconTapped: () => Navigator.of(context).maybePop(),
            ),
            body: Stack(
              children: <Widget>[
                CreationList(
                  state.media,
                  onAddMedia: () => _pickMedia(),
                  onDeleteMedia: (media) {
                    BlocProvider.of<CreationBloc>(context).deleteMedia(media);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: FractionallySizedBox(
                      widthFactor: 0.5,
                      child: PrimaryButton(
                        "create",
                        onPressed: () async {
                          await BlocProvider.of<CreationBloc>(context).createMovie();
                          if (!mounted) return;
                          Navigator.of(context)
                              .pushAndRemoveUntil(WelcomeScreen.route(), (_) => false);
                        },
                        isEnabled: state.isCreationAllowed,
                        onPressedButDisabled: () {
                          Logger.d('"create" pressed, but not enough media');
                          final snackBar = SnackBar(
                              content: Text(
                            'Add ${state.minMediaCountToProceed} or more media to create your movie',
                          ));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        },
                        backgroundColor: AppColors.background,
                      ),
                    ),
                  ),
                ),
                if (state.isLoading)
                  Container(
                    color: AppColors.overlay,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
