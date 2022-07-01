import 'package:flutter/material.dart';
import 'package:rada_egerton/data/entities/complaint_dto.dart';
import 'package:rada_egerton/data/services/issues.dart';
import 'package:rada_egerton/presentation/widgets/button.dart';

class Issues extends StatefulWidget {
  const Issues({Key? key}) : super(key: key);

  @override
  State<Issues> createState() => _IssuesState();
}

class _IssuesState extends State<Issues> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int? _selectedIssueCategory = 0;
  final TextEditingController _messageController = TextEditingController();
  List<IssueCategory> _issueCategories = [];
  final IssueServiceProvider _issueService = IssueServiceProvider();

  Future<void> init() async {
    final result = await _issueService.getIssueCategories();
    result.fold(
      (issueCategories) => setState(() {
        _issueCategories = issueCategories;
      }),
      (error) => {
        ScaffoldMessenger.of(context).showMaterialBanner(
          MaterialBanner(
            content: Text(error.message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  init();
                },
                child: const Text("Retry"),
              )
            ],
          ),
        )
      },
    );
  }

  void createIssue() async {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Submiting your issue, please wait...",
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          duration: const Duration(seconds: 10),
        ),
      );
      final result = await _issueService.createNewIssue(
        {
          "issueCategoryID": _selectedIssueCategory.toString(),
          "issue": _messageController.text,
          "status": "3"
        },
      );

      result.fold(
        (l) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Issue created successfuly",
                style: TextStyle(color: Theme.of(context).primaryColor)),
            duration: const Duration(seconds: 10),
          ),
        ),
        (r) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(r.message,
                style: TextStyle(color: Theme.of(context).errorColor)),
            duration: const Duration(seconds: 10),
            action: SnackBarAction(label: "RETRY", onPressed: createIssue),
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    init();
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
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                maxLines: 15,
                controller: _messageController,
                minLines: 10,
                validator: valid,
                decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      borderSide:
                          BorderSide(color: Color(0X55CED0D2), width: 0.0),
                    ),
                    hintText: "Write your issue here"),
              ),
              const SizedBox(
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
      ),
    );
  }

  Widget _dropDown() {
    return FormField<String>(
      builder: (FormFieldState<String> state) {
        return InputDecorator(
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.all(10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              borderSide: BorderSide(color: Color(0X55CED0D2), width: 0.0),
            ),
            // hintText: 'Select issue category',
          ),
          isEmpty: _selectedIssueCategory == 0,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: _selectedIssueCategory,
              isDense: true,
              items: [
                const DropdownMenuItem(
                  value: 0,
                  child: Text("Select issue category"),
                ),
                ..._issueCategories.map(
                    (e) => DropdownMenuItem(value: e.id, child: Text(e.name)))
              ],
              onChanged: (i) {
                setState(
                  () {
                    _selectedIssueCategory = i;
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}

String? valid(String? value) {
  if (value!.isEmpty) {
    return "Requried";
  }
  return null;
}
