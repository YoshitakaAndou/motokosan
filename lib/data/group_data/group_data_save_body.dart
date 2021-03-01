import 'package:motokosan/data/data_save_body.dart';

import 'group_data.dart';

class GroupDataSaveBody {
  static final GroupDataSaveBody instance = GroupDataSaveBody();

  Future<void> save(GroupData _groupData) async {
    await DataSave.saveString("_groupName", _groupData.name);
    await DataSave.saveString("_groupPassword", _groupData.password);
    await DataSave.saveString("_groupCode", _groupData.groupCode);
    await DataSave.saveString("_groupEmail", _groupData.email);
  }

  Future<GroupData> loadGroupData() async {
    final GroupData _groupData = GroupData();
    _groupData.name = await DataSave.getString("_groupName");
    _groupData.password = await DataSave.getString("_groupPassword");
    _groupData.groupCode = await DataSave.getString("_groupCode");
    _groupData.email = await DataSave.getString("_groupEmail");
    return _groupData;
  }
}
