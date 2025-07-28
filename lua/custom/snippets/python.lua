-- Python 代码片段
local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local l = require("luasnip.extras").lambda
local rep = require("luasnip.extras").rep
local p = require("luasnip.extras").partial
local m = require("luasnip.extras").match
local n = require("luasnip.extras").nonempty
local dl = require("luasnip.extras").dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local types = require("luasnip.util.types")
local conds = require("luasnip.extras.conditions")
local conds_expand = require("luasnip.extras.conditions.expand")

-- 获取当前文件名（不带扩展名）
local get_filename = function()
  local filename = vim.fn.expand("%:t")
  return filename:match("(.+)%..+")
end

-- 获取当前日期
local get_date = function()
  return os.date("%Y-%m-%d")
end

-- 获取当前时间
local get_time = function()
  return os.date("%H:%M:%S")
end

-- 获取当前用户名
local get_username = function()
  return vim.fn.expand("$USER")
end

-- Python 代码片段集合
return {
  -- 函数定义
  s(
    "def",
    fmt(
      [[def {}({}):
    """{}"""
    {}
    return {}]],
      {
        i(1, "function_name"),
        i(2, "args"),
        i(3, "函数描述"),
        i(4, "# function body"),
        i(5, "None"),
      }
    )
  ),

  -- 类定义
  s(
    "class",
    fmt(
      [[class {}({}):
    """{}"""
    
    def __init__(self, {}):
        {}
        
    {}]],
      {
        i(1, "ClassName"),
        i(2, "object"),
        i(3, "类描述"),
        i(4, "args"),
        i(5, "# init body"),
        i(6, "# class body"),
      }
    )
  ),

  -- 主函数
  s(
    "main",
    fmt(
      [[def main():
    {}

if __name__ == "__main__":
    main()]],
      {
        i(1, "# main function body"),
      }
    )
  ),

  -- 导入模块
  s(
    "imp",
    fmt(
      [[import {}]],
      {
        i(1, "module"),
      }
    )
  ),

  -- 从模块导入
  s(
    "from",
    fmt(
      [[from {} import {}]],
      {
        i(1, "module"),
        i(2, "name"),
      }
    )
  ),

  -- 条件语句
  s(
    "if",
    fmt(
      [[if {}:
    {}]],
      {
        i(1, "condition"),
        i(2, "# body"),
      }
    )
  ),

  -- if-else 语句
  s(
    "ife",
    fmt(
      [[if {}:
    {}
else:
    {}]],
      {
        i(1, "condition"),
        i(2, "# if body"),
        i(3, "# else body"),
      }
    )
  ),

  -- if-elif-else 语句
  s(
    "ifee",
    fmt(
      [[if {}:
    {}
elif {}:
    {}
else:
    {}]],
      {
        i(1, "condition1"),
        i(2, "# if body"),
        i(3, "condition2"),
        i(4, "# elif body"),
        i(5, "# else body"),
      }
    )
  ),

  -- for 循环
  s(
    "for",
    fmt(
      [[for {} in {}:
    {}]],
      {
        i(1, "item"),
        i(2, "iterable"),
        i(3, "# body"),
      }
    )
  ),

  -- for 循环（带索引）
  s(
    "fore",
    fmt(
      [[for {}, {} in enumerate({}):
    {}]],
      {
        i(1, "i"),
        i(2, "item"),
        i(3, "iterable"),
        i(4, "# body"),
      }
    )
  ),

  -- for 循环（带范围）
  s(
    "forr",
    fmt(
      [[for {} in range({}):
    {}]],
      {
        i(1, "i"),
        i(2, "10"),
        i(3, "# body"),
      }
    )
  ),

  -- while 循环
  s(
    "while",
    fmt(
      [[while {}:
    {}]],
      {
        i(1, "condition"),
        i(2, "# body"),
      }
    )
  ),

  -- try-except 语句
  s(
    "try",
    fmt(
      [[try:
    {}
except {}:
    {}]],
      {
        i(1, "# try body"),
        i(2, "Exception as e"),
        i(3, "# except body"),
      }
    )
  ),

  -- try-except-finally 语句
  s(
    "tryf",
    fmt(
      [[try:
    {}
except {}:
    {}
finally:
    {}]],
      {
        i(1, "# try body"),
        i(2, "Exception as e"),
        i(3, "# except body"),
        i(4, "# finally body"),
      }
    )
  ),

  -- with 语句
  s(
    "with",
    fmt(
      [[with {} as {}:
    {}]],
      {
        i(1, "expression"),
        i(2, "target"),
        i(3, "# body"),
      }
    )
  ),

  -- 列表推导式
  s(
    "lc",
    fmt(
      [[{} = [{} for {} in {}{}]],
      {
        i(1, "result"),
        i(2, "expression"),
        i(3, "item"),
        i(4, "iterable"),
        i(5, " if condition"),
      }
    )
  ),

  -- 字典推导式
  s(
    "dc",
    fmt(
      [[{} = {{{}: {} for {} in {}{}}}]],
      {
        i(1, "result"),
        i(2, "key"),
        i(3, "value"),
        i(4, "item"),
        i(5, "iterable"),
        i(6, " if condition"),
      }
    )
  ),

  -- 集合推导式
  s(
    "sc",
    fmt(
      [[{} = {{{} for {} in {}{}}}]],
      {
        i(1, "result"),
        i(2, "expression"),
        i(3, "item"),
        i(4, "iterable"),
        i(5, " if condition"),
      }
    )
  ),

  -- 生成器表达式
  s(
    "ge",
    fmt(
      [[{} = ({} for {} in {}{})]],
      {
        i(1, "result"),
        i(2, "expression"),
        i(3, "item"),
        i(4, "iterable"),
        i(5, " if condition"),
      }
    )
  ),

  -- lambda 表达式
  s(
    "lambda",
    fmt(
      [[{} = lambda {}: {}]],
      {
        i(1, "func"),
        i(2, "args"),
        i(3, "expression"),
      }
    )
  ),

  -- 打印
  s(
    "print",
    fmt(
      [[print({})]],
      {
        i(1, "message"),
      }
    )
  ),

  -- 格式化打印
  s(
    "printf",
    fmt(
      [[print(f"{}"{})]],
      {
        i(1, "message"),
        i(2, ""),
      }
    )
  ),

  -- 调试打印
  s(
    "debug",
    fmt(
      [[print(f"DEBUG: {} = {{{}}}")]],
      {
        i(1, "variable"),
        rep(1),
      }
    )
  ),

  -- 断言
  s(
    "assert",
    fmt(
      [[assert {}, "{}"]],
      {
        i(1, "condition"),
        i(2, "error message"),
      }
    )
  ),

  -- 装饰器
  s(
    "dec",
    fmt(
      [[def {}({}):
    """{}"""
    def wrapper(*args, **kwargs):
        {}
        result = func(*args, **kwargs)
        {}
        return result
    return wrapper]],
      {
        i(1, "decorator_name"),
        i(2, "func"),
        i(3, "装饰器描述"),
        i(4, "# before function call"),
        i(5, "# after function call"),
      }
    )
  ),

  -- 属性装饰器
  s(
    "prop",
    fmt(
      [[    @property
    def {}(self):
        """{}"""
        return self._{}
        
    @{}.setter
    def {}(self, value):
        self._{} = value]],
      {
        i(1, "property_name"),
        i(2, "属性描述"),
        rep(1),
        rep(1),
        rep(1),
        rep(1),
      }
    )
  ),

  -- 静态方法
  s(
    "static",
    fmt(
      [[    @staticmethod
    def {}({}):
        """{}"""
        {}
        return {}]],
      {
        i(1, "method_name"),
        i(2, "args"),
        i(3, "方法描述"),
        i(4, "# method body"),
        i(5, "None"),
      }
    )
  ),

  -- 类方法
  s(
    "class",
    fmt(
      [[    @classmethod
    def {}(cls, {}):
        """{}"""
        {}
        return {}]],
      {
        i(1, "method_name"),
        i(2, "args"),
        i(3, "方法描述"),
        i(4, "# method body"),
        i(5, "None"),
      }
    )
  ),

  -- 抽象方法
  s(
    "abstract",
    fmt(
      [[    @abstractmethod
    def {}(self, {}):
        """{}"""
        pass]],
      {
        i(1, "method_name"),
        i(2, "args"),
        i(3, "方法描述"),
      }
    )
  ),

  -- 文件读取
  s(
    "read",
    fmt(
      [[with open({}, "{}") as {}:
    {} = {}.{}()]],
      {
        i(1, "'file.txt'"),
        i(2, "r"),
        i(3, "f"),
        i(4, "content"),
        rep(3),
        c(5, { t("read"), t("readlines") }),
      }
    )
  ),

  -- 文件写入
  s(
    "write",
    fmt(
      [[with open({}, "{}") as {}:
    {}.write({})]],
      {
        i(1, "'file.txt'"),
        i(2, "w"),
        i(3, "f"),
        rep(3),
        i(4, "content"),
      }
    )
  ),

  -- 文件头注释
  s(
    "header",
    fmt(
      [[#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
@file: {}
@description: {}
@author: {}
@date: {}
@time: {}
"""

{}]],
      {
        f(function() return vim.fn.expand("%:t") end),
        i(1, "文件描述"),
        f(get_username),
        f(get_date),
        f(get_time),
        i(0),
      }
    )
  ),

  -- 函数注释
  s(
    "doc",
    fmt(
      [["""{}

Args:
    {}: {}

Returns:
    {}: {}
"""]],
      {
        i(1, "函数描述"),
        i(2, "param_name"),
        i(3, "param_description"),
        i(4, "return_type"),
        i(5, "return_description"),
      }
    )
  ),

  -- 类型注解函数
  s(
    "tdef",
    fmt(
      [[def {}({}) -> {}:
    """{}"""
    {}
    return {}]],
      {
        i(1, "function_name"),
        i(2, "args: type"),
        i(3, "return_type"),
        i(4, "函数描述"),
        i(5, "# function body"),
        i(6, "result"),
      }
    )
  ),

  -- 测试函数
  s(
    "test",
    fmt(
      [[def test_{}():
    """{}"""
    # Arrange
    {}
    
    # Act
    {}
    
    # Assert
    {}]],
      {
        i(1, "function_name"),
        i(2, "测试描述"),
        i(3, "# setup code"),
        i(4, "# function call"),
        i(5, "# assertions"),
      }
    )
  ),

  -- pytest 测试函数
  s(
    "pytest",
    fmt(
      [[def test_{}():
    """{}"""
    # Arrange
    {}
    
    # Act
    {}
    
    # Assert
    assert {}, "{}"]],
      {
        i(1, "function_name"),
        i(2, "测试描述"),
        i(3, "# setup code"),
        i(4, "# function call"),
        i(5, "condition"),
        i(6, "assertion message"),
      }
    )
  ),

  -- pytest 夹具
  s(
    "fixture",
    fmt(
      [[import pytest

@pytest.fixture
def {}():
    """{}"""
    # Setup
    {} = {}
    
    yield {}
    
    # Teardown
    {}]],
      {
        i(1, "fixture_name"),
        i(2, "夹具描述"),
        i(3, "resource"),
        i(4, "setup_code"),
        rep(3),
        i(5, "# teardown code"),
      }
    )
  ),

  -- 异常处理
  s(
    "raise",
    fmt(
      [[raise {}("{}")]],
      {
        i(1, "Exception"),
        i(2, "error message"),
      }
    )
  ),

  -- 自定义异常
  s(
    "exception",
    fmt(
      [[class {}(Exception):
    """{}"""
    def __init__(self, {}):
        self.message = {}
        super().__init__(self.message)]],
      {
        i(1, "CustomException"),
        i(2, "异常描述"),
        i(3, "message='Error occurred'"),
        i(4, "message"),
      }
    )
  ),

  -- 日志记录
  s(
    "logger",
    fmt(
      [[import logging

logger = logging.getLogger({})
logger.setLevel(logging.{})

# 创建处理器
handler = logging.StreamHandler()
handler.setLevel(logging.{})

# 创建格式化器
formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
handler.setFormatter(formatter)

# 添加处理器到日志记录器
logger.addHandler(handler)]],
      {
        i(1, "__name__"),
        i(2, "INFO"),
        rep(2),
      }
    )
  ),

  -- 日志记录（简化版）
  s(
    "log",
    fmt(
      [[import logging

logging.basicConfig(
    level=logging.{},
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger({})]],
      {
        i(1, "INFO"),
        i(2, "__name__"),
      }
    )
  ),

  -- 日志消息
  s(
    "logmsg",
    fmt(
      [[logger.{}("{}")]],
      {
        c(1, { t("info"), t("debug"), t("warning"), t("error"), t("critical") }),
        i(2, "log message"),
      }
    )
  ),

  -- 参数解析
  s(
    "argparse",
    fmt(
      [[import argparse

def parse_args():
    """{}"""
    parser = argparse.ArgumentParser(description="{}")
    parser.add_argument("{}", {}, help="{}")
    return parser.parse_args()

def main():
    args = parse_args()
    {}

if __name__ == "__main__":
    main()]],
      {
        i(1, "解析命令行参数"),
        i(2, "程序描述"),
        i(3, "-f"),
        i(4, "type=str, required=True"),
        i(5, "参数帮助信息"),
        i(6, "# main function body"),
      }
    )
  ),

  -- 配置文件解析
  s(
    "config",
    fmt(
      [[import configparser

def load_config({}):
    """{}"""
    config = configparser.ConfigParser()
    config.read({})
    return config

config = load_config({})]],
      {
        i(1, "config_file='config.ini'"),
        i(2, "加载配置文件"),
        i(3, "config_file"),
        i(4, "'config.ini'"),
      }
    )
  ),

  -- 数据类
  s(
    "dataclass",
    fmt(
      [[from dataclasses import dataclass

@dataclass
class {}:
    """{}"""
    {}: {}
    {}: {}
    
    def {}(self):
        {}
        return {}]],
      {
        i(1, "ClassName"),
        i(2, "类描述"),
        i(3, "field1"),
        i(4, "str"),
        i(5, "field2"),
        i(6, "int"),
        i(7, "method_name"),
        i(8, "# method body"),
        i(9, "result"),
      }
    )
  ),

  -- 枚举类
  s(
    "enum",
    fmt(
      [[from enum import Enum

class {}(Enum):
    """{}"""
    {} = {}
    {} = {}
    {} = {}]],
      {
        i(1, "EnumName"),
        i(2, "枚举描述"),
        i(3, "FIRST"),
        i(4, "1"),
        i(5, "SECOND"),
        i(6, "2"),
        i(7, "THIRD"),
        i(8, "3"),
      }
    )
  ),

  -- 上下文管理器
  s(
    "context",
    fmt(
      [[class {}:
    """{}"""
    def __init__(self, {}):
        self.{} = {}
        
    def __enter__(self):
        {}
        return self
        
    def __exit__(self, exc_type, exc_val, exc_tb):
        {}
        return {}]],
      {
        i(1, "ContextManager"),
        i(2, "上下文管理器描述"),
        i(3, "resource"),
        i(4, "resource"),
        rep(3),
        i(5, "# setup code"),
        i(6, "# cleanup code"),
        i(7, "False"),
      }
    )
  ),

  -- 单例模式
  s(
    "singleton",
    fmt(
      [[class {}:
    _instance = None
    
    def __new__(cls, *args, **kwargs):
        if cls._instance is None:
            cls._instance = super().__new__(cls)
        return cls._instance
        
    def __init__(self, {}):
        # 只在第一次创建实例时初始化
        if not hasattr(self, 'initialized'):
            self.{} = {}
            self.initialized = True]],
      {
        i(1, "Singleton"),
        i(2, "param=None"),
        i(3, "param"),
        rep(2),
      }
    )
  ),

  -- 工厂模式
  s(
    "factory",
    fmt(
      [[class {}:
    @staticmethod
    def create({}):
        """{}"""
        if {} == {}:
            return {}()
        elif {} == {}:
            return {}()
        else:
            raise ValueError(f"Unknown type: {{}}".format({}))]],
      {
        i(1, "Factory"),
        i(2, "type_name"),
        i(3, "创建对象的工厂方法"),
        rep(2),
        i(4, "'type1'"),
        i(5, "Type1"),
        rep(2),
        i(6, "'type2'"),
        i(7, "Type2"),
        rep(2),
      }
    )
  ),

  -- 观察者模式
  s(
    "observer",
    fmt(
      [[class {}:
    """{}"""
    def __init__(self):
        self._observers = []
        
    def attach(self, observer):
        if observer not in self._observers:
            self._observers.append(observer)
            
    def detach(self, observer):
        try:
            self._observers.remove(observer)
        except ValueError:
            pass
            
    def notify(self, *args, **kwargs):
        for observer in self._observers:
            observer.update(self, *args, **kwargs)
            

class {}:
    """{}"""
    def update(self, subject, *args, **kwargs):
        print(f"{{self.__class__.__name__}} received update from {{subject.__class__.__name__}}")
        {}]],
      {
        i(1, "Subject"),
        i(2, "被观察者"),
        i(3, "Observer"),
        i(4, "观察者"),
        i(5, "# handle update"),
      }
    )
  ),
}