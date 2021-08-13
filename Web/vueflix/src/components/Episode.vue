<template>
  <div class="card">
    <div class="card-header">
      <h5 class="mb-0">
        <button class="btn" v-on:click="goToPlayer()">
          {{ this.episodeOrder }}. Bölüm ({{ this.name }})
        </button>
      </h5>
    </div>
  </div>
</template>

<script>

export default {
  name: 'Season',
  props: ['seriesName', 'seasonOrder', 'episodeOrder', 'name', 'resource', 'streamLink'],
  components: {
    
  },
  data() {
    return {
      show: false,
    }
  },
  methods: {
    goToPlayer() {
      location.href = location.origin + "/Dizi/"+this.seriesName.replaceAll(' ','-')+"/"+this.seasonOrder+"-sezon-"+this.episodeOrder+"-bolum-izle"
    },
  },
  beforeMount(){
   
  },
  mounted(){

  }
}
</script>