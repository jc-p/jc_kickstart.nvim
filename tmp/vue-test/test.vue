<template>
  <div class="hello">
    <h1>{{ msg }}</h1>
    <p>{{ count }}</p>
    <button @click="increment">Click me</button>
  </div>
</template>

<script setup>
import { ref } from 'vue'

const msg = ref('Hello Vue!')
const count = ref(0)

function increment() {
  count.value++
}
</script>

<style scoped>
.hello {
  text-align: center;
}
</style>