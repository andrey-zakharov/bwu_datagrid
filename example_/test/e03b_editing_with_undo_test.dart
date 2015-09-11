@TestOn('vm')
library bwu_datagrid_examples.test.e03b_editing_with_undo_test;

import 'dart:async' show Future, Stream;

import 'package:bwu_webdriver/bwu_webdriver.dart';
import 'package:test/test.dart';
import 'package:webdriver/io.dart' show Keyboard;
import 'common.dart';

String pageUrl;

main() async {
  pageUrl =  '${await webServer}/e03b_editing_with_undo.html';
  forEachBrowser(tests);
}

// TODO(zoechi)
// - accept with tab

void tests(WebBrowser browser) {
  group('e03b_editing_with_undo,', () {
    ExtendedWebDriver driver;
    setUp(() async {
      driver = await commonSetUp(pageUrl, browser);
    });

    tearDown(() {
      return driver?.quit();
    });

    test('undo', () async {
      const textEditorSelector = const By.cssSelector('input[type="text"]');
      const dateEditorSelector = const By.cssSelector('input[type="date"]');
      const checkboxEditorSelector =
          const By.cssSelector('input[type="checkbox"]');
      const undoButtonSelector = const By.cssSelector(
          'app-element::shadow .options-panel button', const {
        WebBrowser.firefox: removeShadowDom,
        WebBrowser.ie: replaceShadowWithDeep
      });

      // prepare undo
      final undoButton = await driver.findElement(undoButtonSelector);
      expect(await undoButton.enabled, isFalse,
          reason: 'undo button should be disabled when no call was edited yet');

      // prepare scroll
      WebElement viewPort = await driver.findElement(viewPortSelector);
      expect(viewPort, isNotNull);
      final maxYScroll = int.parse(await viewPort.attributes['scrollHeight']);
      expect(maxYScroll, greaterThan(12000));

      // title
      const titleScrollTop = 0;
      const titleTaskTitle = 'Task 12';
      await selectRowByTask(driver, titleTaskTitle, scrollTop: titleScrollTop);
      WebElement titleCell =
          await driver.findElement(titleCellActiveRowSelector);
      final titleOldValue = await titleCell.text;

      await driver.mouse.moveTo(element: titleCell);
      await driver.mouse.doubleClick();

      final titleEditor = await titleCell.findElement(textEditorSelector);
      await titleEditor.clear();
      final titleNewValue = 'New title';
      await titleEditor.sendKeys('${titleNewValue}${Keyboard.enter}');
      expect(await titleCell.elementExists(textEditorSelector), isFalse);
      await new Future.delayed(const Duration(milliseconds: 10));
      expect(await titleCell.text, titleNewValue);

      expect(await undoButton.enabled, isTrue,
          reason:
              'undo button should be enabled after a cell value was changed');

      // description
      const descriptionScrollTop = 0;
      const descriptionTaskTitle = 'Task 3';
      await selectRowByTask(driver, descriptionTaskTitle,
          scrollTop: descriptionScrollTop);
      WebElement descriptionCell =
          await driver.findElement(descriptionCellActiveRowSelector);
      final descriptionOldValue = await descriptionCell.text;
      const descriptionNewValue =
          'Some other description\nwhich can also be multiline';
      await driver.mouse.moveTo(element: descriptionCell);
      await driver.mouse.doubleClick();
      const descriptionEditorSelector =
          const By.cssSelector('body > div > textarea');
      final descriptionEditor =
          await driver.findElement(descriptionEditorSelector);
      await descriptionEditor.clear();
      await descriptionEditor.sendKeys(
          '${descriptionNewValue}${Keyboard.control}${Keyboard.enter}');
      expect(await driver.elementExists(descriptionEditorSelector), isFalse);
      await new Future.delayed(const Duration(milliseconds: 10));
      expect(await descriptionCell.text,
          descriptionNewValue.replaceAll('\n', ' '));

      // duration'
      const durationScrollTop = 0;
      const durationTaskTitle = 'Task 8';
      await selectRowByTask(driver, durationTaskTitle,
          scrollTop: durationScrollTop);
      WebElement durationCell =
          await driver.findElement(durationCellActiveRowSelector);
      final durationOldValue = await durationCell.text;
      await driver.mouse.moveTo(element: durationCell);
      await driver.mouse.doubleClick();
      final durationEditor = await durationCell.findElement(textEditorSelector);
      await durationEditor.clear();
      const durationNewValue = '25 days';
      await durationEditor.sendKeys('${durationNewValue}${Keyboard.enter}');
      expect(await durationCell.elementExists(textEditorSelector), isFalse);
      await new Future.delayed(const Duration(milliseconds: 10));
      expect(await durationCell.text, durationNewValue);

      //percent complete
      final percentCompleteScrollTop = maxYScroll ~/ 2;
      const percentCompleteTaskTitle = 'Task 250';
      await selectRowByTask(driver, percentCompleteTaskTitle,
          scrollTop: percentCompleteScrollTop);
      WebElement percentCompleteCell =
          await driver.findElement(percentCellActiveRowSelector);
      const percentBarSelector =
          const By.cssSelector('span.percent-complete-bar');
      WebElement bar =
          await percentCompleteCell.findElement(percentBarSelector);
      final percentCompleteOldValue = await bar.attributes['style'];
      await driver.mouse.moveTo(element: percentCompleteCell);
      await driver.mouse.doubleClick();
      final percentCompleteEditor =
          await percentCompleteCell.findElement(textEditorSelector);
      await percentCompleteEditor.clear();
      const percentCompleteNewValue = '66';
      await percentCompleteEditor
          .sendKeys('${percentCompleteNewValue}${Keyboard.enter}');
      expect(
          await percentCompleteCell.elementExists(textEditorSelector), isFalse);
      await new Future.delayed(const Duration(milliseconds: 10));
      bar = await percentCompleteCell.findElement(percentBarSelector);
      expect(await bar.attributes['style'],
          matches('width: ${percentCompleteNewValue}%;'));

      // start
      final startScrollTop = maxYScroll ~/ 2;
      const startTaskTitle = 'Task 260';
      await selectRowByTask(driver, startTaskTitle, scrollTop: startScrollTop);
      WebElement startCell =
          await driver.findElement(startCellActiveRowSelector);
      final startOldValue = await startCell.text;
      await driver.mouse.moveTo(element: startCell);
      await driver.mouse.doubleClick();
      final startNewValue = '2016-08-19';
      final startNewInput = '08192016';
      final startEditor = await startCell.findElement(dateEditorSelector);
      await startEditor.sendKeys('${startNewInput}${Keyboard.enter}');
      expect(await startCell.elementExists(dateEditorSelector), isFalse);
      await new Future.delayed(const Duration(milliseconds: 10));
      expect(await startCell.text, startNewValue);

      // finish
      final finishScrollTop = maxYScroll ~/ 4;
      const finishTaskTitle = 'Task 127';
      await selectRowByTask(driver, finishTaskTitle,
          scrollTop: finishScrollTop);
      WebElement finishCell =
          await driver.findElement(finishCellActiveRowSelector);
      final finishOldValue = await finishCell.text;
      await driver.mouse.moveTo(element: finishCell);
      await driver.mouse.doubleClick();
      final finishNewValue = '2016-09-02';
      final finishNewInput = '09022016';
      final finishEditor = await finishCell.findElement(dateEditorSelector);
      await finishEditor.sendKeys('${finishNewInput}${Keyboard.enter}');
      expect(await finishCell.elementExists(dateEditorSelector), isFalse);
      await new Future.delayed(const Duration(milliseconds: 10));
      expect(await finishCell.text, finishNewValue);

      // effort-driven
      const effortDrivenScrollTop = 0;
      const effortDrivenTaskTitle = 'Task 132';
      await selectRowByTask(driver, effortDrivenTaskTitle,
          scrollTop: effortDrivenScrollTop);
      WebElement effortDrivenCell =
          await driver.findElement(effortDrivenCellActiveRowSelector);
      final effortDrivenOldValue = await effortDrivenCell
          .elementExists(effortDrivenCheckedImageSelector);
      await driver.mouse.moveTo(element: effortDrivenCell);
      await driver.mouse.doubleClick();
      final effortDrivenEditor =
          await effortDrivenCell.findElement(checkboxEditorSelector);
      await effortDrivenEditor.click();
      await effortDrivenEditor.sendKeys(Keyboard.enter);
      expect(await effortDrivenCell.elementExists(checkboxEditorSelector),
          isFalse);
      await new Future.delayed(const Duration(milliseconds: 10));
      expect(
          await effortDrivenCell
              .elementExists(effortDrivenCheckedImageSelector),
          !effortDrivenOldValue);

      // exercise
      int undoCount = 0;
      while (await undoButton.enabled) {
        await undoButton.click();
        undoCount++;
      }
      expect(undoCount, 7,
          reason: '7 cells were changed, 7 should have been undone');

      await selectRowByTask(driver, titleTaskTitle, scrollTop: titleScrollTop);
      titleCell = await driver.findElement(titleCellActiveRowSelector);
      expect(await titleCell.text, titleOldValue);

      await selectRowByTask(driver, descriptionTaskTitle,
          scrollTop: descriptionScrollTop);
      descriptionCell =
          await driver.findElement(descriptionCellActiveRowSelector);
      expect(await descriptionCell.text, descriptionOldValue);

      await selectRowByTask(driver, durationTaskTitle,
          scrollTop: durationScrollTop);
      durationCell = await driver.findElement(durationCellActiveRowSelector);
      expect(await durationCell.text, durationOldValue);

      await selectRowByTask(driver, percentCompleteTaskTitle,
          scrollTop: percentCompleteScrollTop);
      percentCompleteCell =
          await driver.findElement(percentCellActiveRowSelector);
      bar = await percentCompleteCell.findElement(percentBarSelector);
      expect(await bar.attributes['style'], percentCompleteOldValue);

      await selectRowByTask(driver, startTaskTitle, scrollTop: startScrollTop);
      startCell = await driver.findElement(startCellActiveRowSelector);
      expect(await startCell.text, startOldValue);

      await selectRowByTask(driver, finishTaskTitle,
          scrollTop: finishScrollTop);
      finishCell = await driver.findElement(finishCellActiveRowSelector);
      expect(await finishCell.text, finishOldValue);

      await selectRowByTask(driver, effortDrivenTaskTitle,
          scrollTop: effortDrivenScrollTop);
      effortDrivenCell =
          await driver.findElement(effortDrivenCellActiveRowSelector);
      expect(
          await effortDrivenCell
              .elementExists(effortDrivenCheckedImageSelector),
          effortDrivenOldValue);
    } /*, skip: 'temporary'*/);
  }, timeout: const Timeout(const Duration(seconds: 180)));
}

Future selectRowByTask(ExtendedWebDriver driver, String taskTitle,
    {scrollTop}) async {
  if (scrollTop != null) {
    WebElement viewPort = await driver.findElement(viewPortSelector);
    await driver.scrollElementAbsolute(viewPort, y: scrollTop);
    await new Future.delayed(const Duration(milliseconds: 100));
  }

  final cells = await (await driver
          .findElements(firstColumnSelector)
          .asyncMap((e) async => {'element': e, 'text': await e.text})
          .where((item) => item['text'] == taskTitle))
      .map((item) => item['element'])
      .toList();
  if (cells.length == 0) {
    throw 'No row with title "${taskTitle}" found.';
  } else if (cells.length > 1) {
    throw '${cells.length} rows with title "${taskTitle}" found.';
  }
  await cells.first.click();
}
