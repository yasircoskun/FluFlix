<template>
  <div>
    <Category v-for="(item, index) in categories" :key="index" :CategoryName="item" />
  </div>
</template>

<script>
import Category from './Category.vue'

import { getCategorySlider } from '../services/CategoryService'

export default {
  name: 'CategorySlider',
  components: {
    Category
  },
  data() {
      return {
          categories: []
      }
  },
  methods: {
    getCategories(){
        getCategorySlider().then(response => {
            console.log(response);
            var categories = response['data']['category'];
            this.categories = Array.from(categories, x => x.name);
            console.log(this.categories);
        })
    },
  },
  mounted () {
    this.getCategories();
  }
}
</script>