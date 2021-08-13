<template>
<div>
  <div class="container">
    <div class="row mb-2">
      <div class="col-md-4 text-center">
        <Poster :IMG="this.posterURL" />
      </div>
      <div id="SeriesDetailText" class="col-md-8" style="height: 100px; overflow: auto; position: relative;">
        <h1> {{ this.seriesName }} </h1>
        {{ this.about }}
      </div> 
    </div>

    <div class="row">
        <div id="accordion">
          <season :seriesName="this.seriesName" v-for="(item, index) in seasons" :key="index" :order="item.order" :episodes="item.episodes"></season>
        </div>
    </div>
  </div>

</div>
</template>

<script>
import Poster from '../components/Poster.vue'
import Season from '../components/Season.vue'

import { getSeriesDetail } from '../services/SeriesService'

import PerfectScrollbar from 'perfect-scrollbar'
import 'perfect-scrollbar/css/perfect-scrollbar.css'

export default {
  name: 'SeriesDetail',
  props: ["name"],
  components: {
    Poster,
    Season
  },
  data() {
      return {
          seriesName: "",
          posterURL: "",
          about: "",
          seasons: [],
      }
  },
  methods: {
    getDetail(){
        getSeriesDetail(this.URLtoSTR(this.name)).then(response => {
            console.log(response);
            this.posterURL = response['data']['series'][0].posterURL;
            this.seriesName = response['data']['series'][0].name;
            this.about = response['data']['series'][0].about;//Array.from(categories, x => x.name);
            this.seasons = response['data']['series'][0]['seasons'];
        })
    },
    URLtoSTR(url){
      return url.replaceAll('-', ' ');
    },
    perfectScrollBarInit(){
      new PerfectScrollbar('#SeriesDetailText', {
          wheelSpeed: 2,
          wheelPropagation: true,
          minScrollbarLength: 20
      });
    }
  },
  mounted () {
    this.getDetail();
    this.perfectScrollBarInit();
  }
}
</script>