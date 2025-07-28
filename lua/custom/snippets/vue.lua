-- Vue 代码片段 - 精简版本（常用片段）
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

-- 获取当前文件名（不带扩展名）
local get_filename = function()
  local filename = vim.fn.expand("%:t")
  return filename:match("(.+)%..+") or "Component"
end

-- Vue 常用代码片段集合（精简版）
return {
  -- Vue 3 组合式 API 组件
  s("vcomp", fmt(
    [[<template>
  <div class="{}">
    {}
  </div>
</template>

<script setup lang="ts">
import {{ ref, reactive, computed, onMounted }} from 'vue'

// Props
interface Props {{
  {}
}}

const props = defineProps<Props>()

// Emits
const emit = defineEmits<{{
  {}
}}>()

// State
const {} = ref({})

// Computed
const {} = computed(() => {{
  {}
}})

// Methods
const {} = () => {{
  {}
}}

// Lifecycle
onMounted(() => {{
  {}
}})
</script>

<style scoped>
.{} {{
  {}
}}
</style>]], 
    { 
      f(function(args) return args[1][1]:lower():gsub("(%l)(%w*)", "%1%2") end, {f(get_filename, {})}),
      i(1, "<!-- 模板内容 -->"),
      i(2, "// Props 定义"),
      i(3, "// Emits 定义"),
      i(4, "data"), i(5, "null"),
      i(6, "computedValue"), i(7, "return data"),
      i(8, "handleClick"), i(9, "// 方法实现"),
      i(10, "// 组件挂载后的逻辑"),
      f(function(args) return args[1][1]:lower():gsub("(%l)(%w*)", "%1%2") end, {f(get_filename, {})}),
      i(11, "/* 样式 */")
    }
  )),

  -- Vue 3 ref
  s("vref", fmt(
    [[const {} = ref<{}>({})]], 
    { i(1, "data"), i(2, "any"), i(3, "null") }
  )),

  -- Vue 3 reactive
  s("vreactive", fmt(
    [[const {} = reactive<{}>({{
  {}
}})]], 
    { i(1, "state"), i(2, "any"), i(3, "// 状态属性") }
  )),

  -- Vue 3 computed
  s("vcomputed", fmt(
    [[const {} = computed(() => {{
  {}
}})]], 
    { i(1, "computedValue"), i(2, "return value") }
  )),

  -- Vue 3 watch
  s("vwatch", fmt(
    [[watch({}, (newVal, oldVal) => {{
  {}
}})]], 
    { i(1, "source"), i(2, "// 监听逻辑") }
  )),

  -- Vue 3 watchEffect
  s("vwatcheffect", fmt(
    [[watchEffect(() => {{
  {}
}})]], 
    { i(1, "// 副作用逻辑") }
  )),

  -- Vue 3 onMounted
  s("vmounted", fmt(
    [[onMounted(() => {{
  {}
}})]], 
    { i(1, "// 挂载后逻辑") }
  )),

  -- Vue 3 onUnmounted
  s("vunmounted", fmt(
    [[onUnmounted(() => {{
  {}
}})]], 
    { i(1, "// 卸载前逻辑") }
  )),

  -- Vue 3 defineProps
  s("vprops", fmt(
    [[interface Props {{
  {}
}}

const props = defineProps<Props>()]], 
    { i(1, "// Props 定义") }
  )),

  -- Vue 3 defineEmits
  s("vemits", fmt(
    [[const emit = defineEmits<{{
  {}
}}>()]], 
    { i(1, "// Emits 定义") }
  )),

  -- Vue 3 defineExpose
  s("vexpose", fmt(
    [[defineExpose({{
  {}
}})]], 
    { i(1, "// 暴露的方法或属性") }
  )),

  -- Vue 模板指令 v-if
  s("vif", fmt(
    [[v-if="{}"]], 
    { i(1, "condition") }
  )),

  -- Vue 模板指令 v-for
  s("vfor", fmt(
    [[v-for="{} in {}" :key="{}"]], 
    { i(1, "item"), i(2, "items"), i(3, "item.id") }
  )),

  -- Vue 模板指令 v-model
  s("vmodel", fmt(
    [[v-model="{}"]], 
    { i(1, "value") }
  )),

  -- Vue 模板指令 @click
  s("vclick", fmt(
    [[@click="{}"]], 
    { i(1, "handleClick") }
  )),

  -- Vue 插槽
  s("vslot", fmt(
    [[<slot name="{}">{}</slot>]], 
    { i(1, "default"), i(2, "<!-- 默认内容 -->") }
  )),

  -- Vue 具名插槽
  s("vslotnamed", fmt(
    [[<template #{}>
  {}
</template>]], 
    { i(1, "slotName"), i(2, "<!-- 插槽内容 -->") }
  )),

  -- Vue 作用域插槽
  s("vslotscoped", fmt(
    [[<template #{}="{}">
  {}
</template>]], 
    { i(1, "slotName"), i(2, "slotProps"), i(3, "<!-- 插槽内容 -->") }
  )),

  -- Vue 组件导入
  s("vimport", fmt(
    [[import {} from './{}.vue']], 
    { i(1, "Component"), i(2, "Component") }
  )),

  -- Vue 路由跳转
  s("vrouter", fmt(
    [[router.push('{}')]], 
    { i(1, "/path") }
  )),

  -- Vue 路由参数
  s("vroute", fmt(
    [[route.params.{}]], 
    { i(1, "id") }
  )),

  -- Vue Pinia store
  s("vstore", fmt(
    [[const {} = use{}Store()]], 
    { i(1, "store"), i(2, "Main") }
  )),
}