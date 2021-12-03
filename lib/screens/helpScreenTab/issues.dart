
import 'package:flutter/material.dart';
import 'package:rada_egerton/entities/ComplaintDto.dart';
import 'package:rada_egerton/services/Issues/main.dart';
import 'package:rada_egerton/widgets/RadaButton.dart';

class Issues extends StatefulWidget {
  @override
  _IssuesState createState() => _IssuesState();
}

class _IssuesState extends State<Issues> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int? _selectedIssueCategory = 0;
  TextEditingController _messageController = TextEditingController();
  List<IssueCategory> _issueCategories = [];
  IssueServiceProvider _issueService = new IssueServiceProvider();
  Future<void> init() async {
    final result = await _issueService.getIssueCategories();
    result.fold(
        (issueCategories) => setState(() {
              _issueCategories = issueCategories;
            }),
        (error) => {
              //TODO: handle error
              print(error)
            });
  }

  void createIssue() async {
    if (_formKey.currentState!.validate()) {
      final result = await _issueService.createNewIssue({
        "issueCategory": _selectedIssueCategory,
        "issue": _messageController.text
      });
    }
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  String? valid(String? value) {
    if (value!.isEmpty) {
      return "Requried";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _dropDown(),
            SizedBox(
              height: 30,
            ),
            TextFormField(
              maxLines: 15,
              controller: _messageController,
              minLines: 10,
              validator: valid,
              decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    borderSide:
                        const BorderSide(color: Color(0X55CED0D2), width: 0.0),
                  ),
                  hintText: "Write your issue here"),
            ),
            SizedBox(
              height: 30,
            ),
            RadaButton(
              title: 'Submit',
              handleClick: createIssue,
              fill: true,
            ),
          ],
        ),
      ),
    ));
  }

  Widget _dropDown() {
    return FormField<String>(
      builder: (FormFieldState<String> state) {
        return InputDecorator(
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              borderSide:
                  const BorderSide(color: Color(0X55CED0D2), width: 0.0),
            ),
            // hintText: 'Select issue category',
          ),
          isEmpty: _selectedIssueCategory == 0,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: _selectedIssueCategory,
              isDense: true,
              items: [
                DropdownMenuItem(
                  value: 0,
                  child: Text("Select issue category"),
                ),
                ..._issueCategories.map(
                    (e) => DropdownMenuItem(value: e.id, child: Text(e.name)))
              ],
              onChanged: (i) {
                setState(() {
                  _selectedIssueCategory = i;
                });
              },
            ),
          ),
        );
      },
    );
  }
}
