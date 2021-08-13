<template>
  <div class="card">
    <div class="card-header">
      <h5 class="mb-0">
        <button class="btn" v-on:click="toggleSeason()">
          {{ this.order }}. Sezon
        </button>
      </h5>
    </div>

    <div class="collapse" v-bind:class="{ show: show }">
      <div class="card-body">
        <Episode v-for="(item, index) in episodes" :key="index" :seriesName="this.seriesName" :seasonOrder="this.order" :episodeOrder="item.order" :name="item.name" :resource="item.resource" :streamLink="item.streamLink"/>
      </div>
    </div>
  </div>
</template>

<script>
import Episode from '../components/Episode.vue'
export default {
  name: 'Season',
  props: ['order', 'episodes', 'seriesName'],
  components: {
    Episode
  },
  setup() {
  },
  data() {
    return {
      show: false
    }
  },
  methods: {
    toggleSeason() {
      this.show = !this.show;
    }
  },
  beforeMount(){
   
  },
  mounted(){

  }
}
</script>