import 'package:esma3ny/core/constants.dart';
import 'package:esma3ny/data/models/public/fees.dart';
import 'package:esma3ny/ui/provider/therapist/fees_state.dart';
import 'package:esma3ny/ui/provider/therapist/profile_state.dart';
import 'package:esma3ny/ui/widgets/textFields/TextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

class EditSessionFees extends StatefulWidget {
  @override
  _EditSessionFeesState createState() => _EditSessionFeesState();
}

class _EditSessionFeesState extends State<EditSessionFees> {
  final key = GlobalKey<FormBuilderState>();
  TextEditingController _fullVideoUsd = TextEditingController();
  TextEditingController _halfVideoUsd = TextEditingController();
  TextEditingController _fullVideoEgp = TextEditingController();
  TextEditingController _halfVideoEgp = TextEditingController();
  TextEditingController _fullAudioUsd = TextEditingController();
  TextEditingController _halfAudioUsd = TextEditingController();
  TextEditingController _fullAudioEgp = TextEditingController();
  TextEditingController _halfAudioEgp = TextEditingController();
  TextEditingController _fullChatUsd = TextEditingController();
  TextEditingController _halfChatUsd = TextEditingController();
  TextEditingController _fullChatEgp = TextEditingController();
  TextEditingController _halfChatEgp = TextEditingController();
  TherapistProfileState _therapistProfileState;

  @override
  initState() {
    _therapistProfileState =
        Provider.of<TherapistProfileState>(context, listen: false);
    _fullVideoUsd.text = _therapistProfileState
        .therapistProfileResponse.fees.video.usd.full
        .toString();
    _halfVideoUsd.text = _therapistProfileState
        .therapistProfileResponse.fees.video.usd.half
        .toString();
    _fullVideoEgp.text = _therapistProfileState
        .therapistProfileResponse.fees.video.egp.full
        .toString();
    _halfVideoEgp.text = _therapistProfileState
        .therapistProfileResponse.fees.video.egp.half
        .toString();
    _fullAudioUsd.text = _therapistProfileState
        .therapistProfileResponse.fees.audio.usd.full
        .toString();
    _halfAudioUsd.text = _therapistProfileState
        .therapistProfileResponse.fees.audio.usd.half
        .toString();
    _fullAudioEgp.text = _therapistProfileState
        .therapistProfileResponse.fees.audio.egp.full
        .toString();
    _halfAudioEgp.text = _therapistProfileState
        .therapistProfileResponse.fees.audio.egp.half
        .toString();
    _fullChatUsd.text = _therapistProfileState
        .therapistProfileResponse.fees.chat.usd.full
        .toString();
    _halfChatUsd.text = _therapistProfileState
        .therapistProfileResponse.fees.chat.usd.half
        .toString();
    _fullChatEgp.text = _therapistProfileState
        .therapistProfileResponse.fees.chat.egp.full
        .toString();
    _halfChatEgp.text = _therapistProfileState
        .therapistProfileResponse.fees.chat.egp.half
        .toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Fees',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      ),
      body: body(),
    );
  }

  body() => Consumer<FeesState>(
        builder: (context, state, child) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: FormBuilder(
            key: key,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FormBuilderDropdown(
                    items: [
                      DropdownMenuItem(
                        child: Text('Local Fees'),
                        value: LOCAL,
                      ),
                      DropdownMenuItem(
                        child: Text('Foreign Fees'),
                        value: FOREIGN,
                      ),
                    ],
                    validator: FormBuilderValidators.required(context),
                    onChanged: (value) {
                      state.setAccountValue(value);
                    },
                    name: 'account type',
                    decoration: InputDecoration(labelText: 'Account Type'),
                  ),
                  Text(
                    'Video Fees',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, height: 2.5, fontSize: 20),
                  ),
                  TextFieldForm(
                    hint: 'Price for 60 Minute [USD]',
                    validate: FormBuilderValidators.required(context),
                    prefixIcon: Icons.monetization_on,
                    controller: _fullVideoUsd,
                  ),
                  TextFieldForm(
                    hint: 'Price for 30 Minute [USD]',
                    validate: FormBuilderValidators.required(context),
                    prefixIcon: Icons.monetization_on,
                    controller: _halfVideoUsd,
                  ),
                  TextFieldForm(
                    hint: 'Price for 60 Minute [EGP]',
                    validate: FormBuilderValidators.required(context),
                    prefixIcon: Icons.monetization_on,
                    controller: _fullVideoEgp,
                  ),
                  TextFieldForm(
                    hint: 'Price for 30 Minute [EGP]',
                    validate: FormBuilderValidators.required(context),
                    prefixIcon: Icons.monetization_on,
                    controller: _halfVideoEgp,
                  ),
                  Text(
                    'Audio Fees',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, height: 2.5, fontSize: 20),
                  ),
                  TextFieldForm(
                    hint: 'Price for 60 Minute [USD]',
                    validate: FormBuilderValidators.required(context),
                    prefixIcon: Icons.monetization_on,
                    controller: _fullAudioUsd,
                  ),
                  TextFieldForm(
                    hint: 'Price for 30 Minute [USD]',
                    validate: FormBuilderValidators.required(context),
                    prefixIcon: Icons.monetization_on,
                    controller: _halfAudioUsd,
                  ),
                  TextFieldForm(
                    hint: 'Price for 60 Minute [EGP]',
                    validate: FormBuilderValidators.required(context),
                    prefixIcon: Icons.monetization_on,
                    controller: _fullAudioEgp,
                  ),
                  TextFieldForm(
                    hint: 'Price for 30 Minute [EGP]',
                    validate: FormBuilderValidators.required(context),
                    prefixIcon: Icons.monetization_on,
                    controller: _halfAudioEgp,
                  ),
                  Text(
                    'Chat Fees',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, height: 2.5, fontSize: 20),
                  ),
                  TextFieldForm(
                    hint: 'Price for 60 Minute [USD]',
                    validate: FormBuilderValidators.required(context),
                    prefixIcon: Icons.monetization_on,
                    controller: _fullChatUsd,
                  ),
                  TextFieldForm(
                    hint: 'Price for 30 Minute [USD]',
                    validate: FormBuilderValidators.required(context),
                    prefixIcon: Icons.monetization_on,
                    controller: _halfChatUsd,
                  ),
                  TextFieldForm(
                    hint: 'Price for 60 Minute [EGP]',
                    validate: FormBuilderValidators.required(context),
                    prefixIcon: Icons.monetization_on,
                    controller: _fullChatEgp,
                  ),
                  TextFieldForm(
                    hint: 'Price for 30 Minute [EGP]',
                    validate: FormBuilderValidators.required(context),
                    prefixIcon: Icons.monetization_on,
                    controller: _halfChatEgp,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        if (mounted) {
                          if (key.currentState.validate()) {
                            await state.edit(fees());
                            await _therapistProfileState.updateProfile();
                            if (state.isUpdated) Navigator.pop(context);
                          }
                        }
                      },
                      child: Text('edit'))
                ],
              ),
            ),
          ),
        ),
      );

  fees() => Fees(
        video: FeesUnit(
            egp: FeesAmount(full: _fullVideoEgp.text, half: _halfVideoEgp.text),
            usd:
                FeesAmount(full: _fullVideoUsd.text, half: _halfVideoUsd.text)),
        audio: FeesUnit(
            egp: FeesAmount(full: _fullAudioEgp.text, half: _halfAudioEgp.text),
            usd:
                FeesAmount(full: _fullAudioUsd.text, half: _halfAudioUsd.text)),
        chat: FeesUnit(
          egp: FeesAmount(full: _fullChatEgp.text, half: _halfChatEgp.text),
          usd: FeesAmount(full: _fullChatUsd.text, half: _halfChatUsd.text),
        ),
      );
}
