<template>
    <div class="row">
        <h4 class="categoryName">{{ CategoryName }}</h4>
        <section class="categorySection" :id="this.sectionID" >
            <Poster class="item" v-for="(item, index) in posters" :key="index" :IMG="item" :NAME="names[index]"/>
        </section>
    </div>
</template>

<script>
import Poster from './Poster.vue'
import { getLastPosters } from '../services/PosterService'

import PerfectScrollbar from 'perfect-scrollbar'
import 'perfect-scrollbar/css/perfect-scrollbar.css'

export default {
  name: 'Category',
  props: ['CategoryName'],
  components: {
    Poster
  },
  data() {
      return {
          posters: [],
          names: [],
          sectionID: ""
      }
  },
  methods: {
      generateClearID(categoryName){
          this.sectionID = categoryName.replace(/[ğüşöçİĞÜŞÖÇ\s]/g,'');
      },
      getPosters(){
          getLastPosters(this.CategoryName).then(response => {
              var serieses = response['data']['category'][0]['serieses'];
              var posterExist = serieses.filter(x => x.series.posterURL != null)
              this.names = Array.from(posterExist, x => x.series.name);
              this.posters = Array.from(posterExist, x => x.series.posterURL);
              console.log(this.posters);
          })
      },
    perfectScrollBarInit(){
        new PerfectScrollbar('#' + this.sectionID, {
            wheelSpeed: 2,
            wheelPropagation: true,
            minScrollbarLength: 20
        });
    }
  },
  beforeMount(){
    this.generateClearID(this.CategoryName);
  },
  mounted(){
    this.getPosters();
    this.perfectScrollBarInit();
  }
}
</script>