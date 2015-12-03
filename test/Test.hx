import utest.UTest;
import routely.*;

class Test {
  static function main() {
    UTest.run([
      new TestNodeJs(),
      #if (js && html)
      new TestHtml()
      #end
    ]);
  }
}
