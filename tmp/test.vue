<template>
  <div class="hello">
    <h1>{{ message }}</h1>
    <button @click="handleClick">Click me</button>
  </div>
</template>

<script setup>
import { ref } from "vue";

const message = ref("Hello Vue!");
const count = ref(0);

function handleClick() {
  count.value++;
  message.value = `Clicked ${count.value} times`;
}
</script>

<style scoped>
.hello {
  text-align: center;
  margin-top: 50px;
}
</style>

