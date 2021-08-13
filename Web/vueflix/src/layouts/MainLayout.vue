<template>
    <div>
        <Header />
        <router-view />
        <!-- <slot></slot> -->
        <Footer />
    </div>
</template>
<script>
import 'bootstrap/dist/css/bootstrap.css'
import 'bootstrap-vue/dist/bootstrap-vue.css'

import Header from '../components/Header.vue'
import Footer from '../components/Footer.vue'

export default {
    name: "MainLayout",
    components: {
        Header,
        Footer
    }
}
</script>

<style>
body {
  overflow-x: hidden;
}

#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  color: #2c3e50;
}

nav {
  margin-bottom: 40px;
  padding: 0 25px;
}

h4.categoryName {
  text-align: left;
  padding: 0 25px;
}

section {
 width: 100%;
 margin: 20px 0;
 width: 100%;
 position: relative;
 display: flex;
}
section .item {
 padding: 0 2px;
 transition: 250ms all;
 display: inline-block;
}
/* section .item:hover {
 margin: 0 40px;
 transform: scale(1.2);
} */
section a {
 position: absolute;
 color: #fff;
 text-decoration: none;
 font-size: 6em;
 width: 80px;
 padding: 20px;
 text-align: center;
 z-index: 1;
}
@media only screen and (max-width: 600px) {
 a.arrow__btn {
 display: none;
 }
}
.item img {
  height: 250px;
}


</style>
