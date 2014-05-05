library bwu_dart.bwu_datagrid.plugin;

import 'dart:html' as dom;
import 'dart:async' as async;
import 'package:bwu_datagrid/bwu_datagrid.dart';

abstract class Plugin {
  Datagrid _grid;

  void destroy();
  void Plugin(this._grid);
}

class SelectionModel extends Plugin {

  @override
  void init() {

  }

  @override
  void destroy() {
    // TODO: implement destroy
  }

  void setSelectedRanges(List<int> ranges) {

  }

  /**
   * on selected-ranges-changed
   */
  static const ON_SELECTED_RANGES_CHANGED = 'selected-ranges-changed';
  async.StreamController<dom.CustomEvent> _onSelectedRangesChanged = new async.StreamController<dom.CustomEvent>();
  async.Stream<dom.CustomEvent> get onSelectedRangesChanged =>
//      BwuDatagrid._onSelectedRangesChanged.forTarget(this);
      _onSelectedRangesChanged.stream; //.forTarget(this);

  static const dom.EventStreamProvider<dom.CustomEvent> _onSelectedRangesChanged =
      const dom.EventStreamProvider<dom.CustomEvent>(ON_SELECTED_RANGES_CHANGED);

//  var controller = new StreamController.broadcast();
//         var stream = controller.stream.asyncMap((e) => e);
//         controller.add(1);
}