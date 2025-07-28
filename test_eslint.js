// 测试 ESLint 格式化功能的 JavaScript 文件
// 这个文件包含一些格式问题，用于测试 eslint_d 是否能正常工作

const test = function () {
  let a = 1;
  let b = 2;
  console.log(a + b);
};

function badFormatting() {
  return "hello world";
}

const obj = { a: 1, b: 2, c: 3 };

if (true) {
  console.log("test");
}

export default test;
