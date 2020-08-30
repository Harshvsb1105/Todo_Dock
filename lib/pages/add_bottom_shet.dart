

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:todo_dock/NotificationPlugin.dart';

import '../bloc/todo.dart';
import '../models/todo_models.dart';
import '../style.dart';
import '../widgets/text_field.dart';

class AddItemBottomShet extends StatefulWidget {
  final TodoCategory category;
  final NotificationPlugin notificationPlugin;

  AddItemBottomShet({Key key, @required this.category, this.notificationPlugin}) : super(key: key);

  @override
  _AddItemBottomShetState createState() => _AddItemBottomShetState();
}

class _AddItemBottomShetState extends State<AddItemBottomShet> {
  String title = '';
  String description = '';
  bool enableDescription = false;
  TimeOfDay pickedTime;
  String time;
  int hr;
  int min;




  @override
  void initState() {
    super.initState();
    notificationPlugin.setListenerForLowerVersions(onNotificationInLowerVersions);
    notificationPlugin.setOnNotificationClick(onNotificationClick);
  }

  void itemTitleChanget(String title) {
    setState(() {
      this.title = title;
    });
  }

  void itemDescriptionChanget(String description) {
    setState(() {
      this.description = description;
    });
  }

  void chaneEnableDescription() {
    setState(() {
      enableDescription = !enableDescription;
      description = '';
    });
  }

  Future<void> selectTime(NotificationPlugin notificationPlugin) async {
    print('time of the day');
       await showTimePicker(context: context, initialTime: TimeOfDay.now())
        .then((value) async {
          print('hello whats the time : ${value.hour} & ${value.minute}');
          hr = value.hour;
          min = value.minute;
          notificationPlugin.showDailyAtTime(hr, min);
          setState(() {
            this.time = '$hr:$min';
          });
    });

  }

  bool get _saveEnable {
    if (title.isEmpty) {
      return false;
    }
    if (enableDescription && description.isEmpty) {
      return false;
    }

    return true;
  }

  Future saveItem() async {
    if (_saveEnable) {
      await context.read<Todo>().addItem(TodoItem(
          category: widget.category.id,
          title: title,
          description: description,
          time: time,
      ));

      //go back
      Navigator.of(context).pop();
    }
  }

  onNotificationInLowerVersions(ReceivedNotification receivedNotification){}

  onNotificationClick(String payload){
    print('Payload $payload');
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      padding:
      EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      duration: const Duration(milliseconds: 300),
      curve: Curves.decelerate,
      child: Container(
        height: enableDescription ? 244 : 190,
        child: Neumorphic(
            padding: const EdgeInsets.all(Style.mainPadding),
            style: NeumorphicStyle(
                boxShape: NeumorphicBoxShape.roundRect(const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16))),
                oppositeShadowLightSource: true),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                NeumorphicTextField(
                    hint: 'add_task.title_hint'.tr(),
                    onChanged: itemTitleChanget,
                    autofocus: true),
                const SizedBox(height: Style.mainPadding),
                if (enableDescription)
                  NeumorphicTextField(
                    hint: 'add_task.description_hint'.tr(),
                    onChanged: itemDescriptionChanget,
                  ),
                const SizedBox(height: Style.mainPadding),
                Row(
                  children: <Widget>[
                    NeumorphicButton(
                      padding: const EdgeInsets.all(16),
                      style: const NeumorphicStyle(
                        boxShape: NeumorphicBoxShape.circle(),shape: NeumorphicShape.convex,
                      ),
                      child: FaIcon(FontAwesomeIcons.bars,
                          size: 18,
                          color: NeumorphicTheme.defaultTextColor(context)),
                      onPressed: chaneEnableDescription,
                    ),
                    SizedBox(width: 10,),
                    NeumorphicButton(
                      padding: const EdgeInsets.all(16),
                      style: const NeumorphicStyle(
                        boxShape: NeumorphicBoxShape.circle(),shape: NeumorphicShape.convex,
                      ),
                      child: FaIcon(FontAwesomeIcons.clock,
                          size: 18,
                          color: NeumorphicTheme.defaultTextColor(context)),
                      onPressed: () async {
                       await selectTime(notificationPlugin);
                      },
                    ),
                    const Spacer(),
                    NeumorphicButton(
                      padding: const EdgeInsets.all(16),
                      style: NeumorphicStyle(
                          boxShape: NeumorphicBoxShape.roundRect(
                              Style.mainBorderRadius),shape: NeumorphicShape.convex,),
                      child: Text('add',
                          style: TextStyle(
                              color: _saveEnable
                                  ? NeumorphicTheme.accentColor(context)
                                  : NeumorphicTheme.defaultTextColor(
                                  context)))
                          .tr(),
                      onPressed: saveItem,
                    ),
                  ],
                )
              ],
            )),
      ),
    );
  }
}

void modalBottomSheet(BuildContext context, TodoCategory category) {
  showModalBottomSheet<Widget>(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (_) {
        return AddItemBottomShet(category: category);
      });
}



